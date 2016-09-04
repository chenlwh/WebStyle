//
//  GWBaseProvider.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWBaseProvider.h"
#import "GWProviderDelegate.h"
#import "NSObject+AutoPairKeyValue.h"
#import "GWProviderManager.h"
#import "NSDictionary+FormatString.h"
#import "NSString+MD5Addition.h"
#import "MAZeroingWeakRef.h"
#import "GWLocalCache.h"
#import "GWDownloadCache.h"
#import "Msgdefine.h"
#import "UrlDefine.h"

#import "GWErrorDomain.h"

@interface GWBaseProvider()
{
    MAZeroingWeakRef *_ref;
}

/**
 *  不添加至url里的属性名
 */
@property (nonatomic, strong) NSMutableArray* nonparameterablePropertyNames;
@property (nonatomic, strong) NSMutableDictionary* keyParamNameValueParamValue;
/**
 *  为上传文件url的属性名
 */
@property (nonatomic, retain) NSMutableSet* uploadFileUrlPropertyNames;
@end

@implementation GWBaseProvider

- (void)dealloc
{
    if([_operation respondsToSelector:@selector(cancel)])
        [_operation performSelector:@selector(cancel) withObject:nil];
  
    
    
}

- (id)initWithSender:(id<GWProviderDelegate>)sender
{
    if(self = [self init])
    {
        self.sender = sender;
    }
    
    return self;
}

- (id)init
{
    if(self = [super init])
    {
        self.urlString = KGWHostURL;
        self.cacheUrlString = KGWHostURL;
        self.interfaceName = @"";//@"rest?";
        self.httpMethod = HttpMethodPost;
        _needHttps = NO;
        _responseType = EGWHTTPRequestResponseTypeString;
        _modelReq = NO;
        _cache = nil;
        self.responseHandler = nil;
        self.completeHandler = nil;
        self.operation = nil;
        self.errorblock = nil;
        _needRecord = NO;
        
        _resultPackage = nil;
        
        _sendStatus = EGWProviderStatusIdle;
        
        _resendTimes = 0;
        _resendMaxTimes = 1;
        
        _nonparameterablePropertyNames = [[NSMutableArray alloc] init];
        _keyParamNameValueParamValue = [[NSMutableDictionary alloc] init];
        
        _requestPriority = EGWProviderPriorityNormal;
        
        _timeOutSeconds = 60;
        
        _requestHeaders = [[NSMutableDictionary alloc] init];
        
        _uploadFileUrlPropertyNames = [[NSMutableSet alloc] initWithCapacity:1];
        
        _allowResumeForFileDownloads = YES;
    }
    
    return self;
}


- (void)setSender:(id<GWProviderDelegate>)sender
{
    _sender = sender;
    _ref = nil;
    if(_sender)
        _ref  = [[MAZeroingWeakRef alloc] initWithTarget:_sender];
}

- (BOOL)senderByDealloc
{
    id newSender = nil;
    if(_ref)
        newSender = [_ref target];
    
    return (_sender != newSender);
}

- (BOOL)isIdle
{
    return (EGWProviderStatusIdle == self.sendStatus);
}


- (NSString*)description
{
    
    //test
    //return [NSString stringWithFormat:@"%@--------%p",[self urlEncodeWithCacheUrl:NO],self];
    return [self urlEncodeWithCacheUrl:NO];
}

- (NSString*)urlEncodeWithCacheUrl:(BOOL)useCacheUrl
{
    [self providerWillStart];
    NSMutableDictionary* params = [self dictionaryOfPropertyNameAsKeyAndValueAsParameter];
    [params addEntriesFromDictionary:[self dictionaryOfAddedParameterAndValues]];
    
    //签名
    [self signToParams:params];
    
    NSMutableString* urlStr = [NSMutableString stringWithFormat:@"%@%@", useCacheUrl ? self.cacheUrlString : self.urlString, self.interfaceName];
    
    if(self.needHttps)
    {
        NSRange range = [urlStr rangeOfString:@"http://"];
        [urlStr replaceCharactersInRange:range withString:@"https://"];
    }
    
    
    [urlStr setString:[NSString stringWithFormat:@"%@%@", urlStr, [params urlString]]];
    [urlStr setString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return urlStr;
}

- (BOOL)shouldCodeWithPropertyName:(NSString *)propertyName
{
    if([propertyName isEqualToString:@"sender"]
       || [propertyName isEqualToString:@"cache"]
       || [propertyName isEqualToString:@"operation"]
       || [propertyName isEqualToString:@"errorblock"]
       || [propertyName isEqualToString:@"responseHandler"]
       || [propertyName isEqualToString:@"completeHandler"])
    {
        return NO;
    }
    
    return [super shouldCodeWithPropertyName:propertyName];
}

@end

@implementation GWBaseProvider (Cache)
- (void)useCacheInfo:(BOOL)useCache
{
    if(useCache)
    {
        [self useDownloadCache:[GWDownloadCache sharedCache] cacheSecond: 10 * 60];
    }
    else
    {
        _cache = nil;
    }
}

- (void)useDownloadCache:(GWDownloadCache*)downloadCache
             cacheSecond:(NSTimeInterval)cacheSecond
             cachePolicy:(EGWCachePolicy)cachePolicy
{
    if(!_cache)
        _cache = [[GWCacheInfo alloc] init];
    _cache.cachePolicy = cachePolicy;
    _cache.cacheSecond = cacheSecond;
    _cache.downloadCache = downloadCache;
}

- (void)useDownloadCache:(GWDownloadCache*)downloadCache
             cacheSecond:(NSTimeInterval)cacheSecond
{
    [self useDownloadCache:downloadCache
               cacheSecond:cacheSecond
               cachePolicy:EGWCachePolicyCacheFirst];
}

- (void)readLocalCacheWithCompletion:(ReadCacheCompletion)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error = nil;
        id<NSCoding> cacheData = [self readLocalCacheWithError:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion)
            {
                completion(cacheData, error);
            }
        });
    });
}

- (void)saveLocalCache:(id<NSCoding>)cacheObject completion:(SaveCacheCompletion)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [self saveLocalCache:cacheObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion)
            {
                completion(success);;
            }
        });
    });
}

- (id<NSCoding>)readLocalCache
{
    return [self readLocalCacheWithError:nil];
}

- (id<NSCoding>)readLocalCacheWithError:(NSError**)error
{
    if(!_cache)
    {
        return nil;
    }
    
//    if(![self.httpMethod isEqualToString:HttpMethodGet])
//    {
//        return nil;
//    }
    
    if(!self.cache.downloadCache)
    {
        self.cache.downloadCache = [GWDownloadCache sharedCache];
    }
    
    NSString* urlStr = [self urlEncodeWithCacheUrl:YES];
    NSString* keyStr = [self.cache.downloadCache keyForURL:[NSURL URLWithString:urlStr]];
//    MSGLOG(@"readLocalCache:\n\n%@\n\n%@\n\n", keyStr, urlStr);
    GWLocalCache* localCache = [GWLocalCache currentCache];
    
    id<NSCoding> cacheData = [localCache objectForKey:keyStr];
    BOOL expired = [localCache cacheIsExpiredWithKey:keyStr];
    if(expired)
    {
        if(error)
        {
            *error = [NSError errorWithDomain:GWRNormalErrorDomain
                                         code:EGWReadCacheErrorCodeCacheExpired
                                     userInfo:@{NSLocalizedDescriptionKey : @"缓存过期"}];
        }
        
//        if(EGWCachePolicyCacheAlwaysRead != self.cache.cachePolicy)
//        {
//            cacheData = nil;
//        }
    }
    else
    {
        if(!cacheData && error)
        {
            *error = [NSError errorWithDomain:GWRNormalErrorDomain
                                         code:EGWReadCacheErrorCodeCacheEmpty
                                     userInfo:@{NSLocalizedDescriptionKey : @"无缓存"}];
        }
    }
    return cacheData;
}

- (BOOL)saveLocalCache:(id<NSCoding>)cacheObject
{
    if(!_cache)
    {
        return NO;
    }
    
    //该次请求从缓存中读取
//    if(!_operation)
//    {
//        return NO;
//    }
    
//    if(![self.httpMethod isEqualToString:HttpMethodGet])
//    {
//        return NO;
//    }
    
    if(!self.cache.downloadCache)
    {
        self.cache.downloadCache = [GWDownloadCache sharedCache];
    }
    
    
    NSString* urlStr = [self urlEncodeWithCacheUrl:YES];
    NSString* keyStr = [self.cache.downloadCache keyForURL:[NSURL URLWithString:urlStr]];
    
//    MSGLOG(@"saveLocalCache:\n\n%@\n\n%@\n\n", keyStr, urlStr);
    GWLocalCache* localCache = [GWLocalCache currentCache];
    [localCache setObject:cacheObject forKey:keyStr withTimeoutInterval:self.cache.cacheSecond];
    return YES;
}

- (void)clearLocalCache
{
    if(!_cache)
    {
        return;
    }
    
//    if(![self.httpMethod isEqualToString:HttpMethodGet])
//    {
//        return;
//    }
    
    if(!self.cache.downloadCache)
    {
        self.cache.downloadCache = [GWDownloadCache sharedCache];
    }
    
    NSString* urlStr = [self urlEncodeWithCacheUrl:YES];
    NSString* keyStr = [self.cache.downloadCache keyForURL:[NSURL URLWithString:urlStr]];
    
    GWLocalCache* localCache = [GWLocalCache currentCache];
    [localCache removeCacheForKey:keyStr];
}

- (BOOL)isUsedCachedData
{
    return self.resultPackage.isUseCache;
//    return [self readLocalCacheWithError:nil];
}
@end

@implementation GWBaseProvider (MsgEncode)
- (void)providerWillStart
{
    _isUsedCachedData = NO;
    
    if([_fileDownloadPath length])
    {
        self.httpMethod = HttpMethodGet;
        _responseType = EGWHTTPRequestResponseTypeData;
    }
    
//    [self setPropertyNameAsNonparameterable:@"description"];
//    [self setPropertyNameAsNonparameterable:@"debugDescription"];
}

- (NSMutableDictionary*)dictionaryOfPropertyNameAsKeyAndValueAsParameter
{
    NSMutableDictionary* params = [self dictionaryFromObjectWithclassDecider:^BOOL(Class tmpClass, BOOL *stop) {
        if(tmpClass == [GWBaseProvider class])
        {
            *stop = YES;
            return NO;
        }
        return YES;
    }];
    
    NSString* key;
    NSMutableArray* removesKeys = [[NSMutableArray alloc] init];
    for(key in [params allKeys])
    {
        if([self shouldParameterableWithPropertyName:key])
        {
            NSString *replaceKey = [self replacementForPropertyName:key];
            if(replaceKey.length == 0)
                continue;
            
            NSString *originalValue = [params valueForKey:key];
            [params removeObjectForKey:key];
            originalValue = originalValue ? originalValue : @"";
            NSString *value = [self replacementForPropertyValue:originalValue propertyName:replaceKey];
            if(value == nil){
                value = originalValue;
            }
            if(value != nil){
                [params setObject:value forKey:replaceKey];
            }else{
                MSGLOG(@"%@ key:%@ cannot be nil", NSStringFromClass(self.class), replaceKey);
            }
        }
        else
        {
            [removesKeys addObject:key];
        }
    }
    [params removeObjectsForKeys:removesKeys];

    
    return params ;
}

- (NSString *)replacementForPropertyName:(NSString *)propertyName
{
    return propertyName;
}

- (NSString *)replacementForPropertyValue:(NSString *)value propertyName:(NSString *)propertyName
{
    if(_replacePropertyValue)
    {
        NSDictionary* replacePropertyDic = _replacePropertyValue();
        NSString* replaceValue = replacePropertyDic[propertyName];
        if(replaceValue)
        {
            return replaceValue;
        }
    }
    
    return value;
}

- (BOOL)shouldParameterableWithPropertyName:(NSString *)propertyName
{
    if([_nonparameterablePropertyNames containsObject:propertyName])
        return NO;
    
    return YES;
}

- (void)setPropertyNameAsNonparameterable:(NSString *)propertyName
{
    if(propertyName)
        [_nonparameterablePropertyNames addObject:propertyName];
}

- (void)removePropertyNameAsNonparameterable:(NSString *)propertyName
{
    if(propertyName)
        [_nonparameterablePropertyNames removeObject:propertyName];
}

@end


@implementation GWBaseProvider (MsgDecode)
- (void)responseHeaders:(NSDictionary*)responseHeaders
{
    self.responseHeaders = responseHeaders;
}

- (void)didReceiveBytes:(long long)bytes totalBytes:(long long)totalBytes
{
    if(self.receiveHandler)
    {
        self.receiveHandler(bytes, totalBytes);
    }
}

- (id)parseResponed:(id)respond error:(NSError**)error
{
    if(self.responseHandler)
        return self.responseHandler(respond, error);
    
    return respond;
}

- (void)responedComplete:(GWProviderResultPackage*)package
{
    if(self.completeHandler)
        self.completeHandler(package.providerResult, package.providerError);
}

- (NSError *)searchError:(NSString *)responseString description:(NSString*)description errorHandler:(GWErrorInterceptorHandler*)errorHandler
{
    return nil;
}
@end


@implementation GWBaseProvider (Sign)
- (void)signToParams:(NSMutableDictionary* )params
{
    if([self.fileDownloadPath length])
        return;
    
    NSString* signStr = [params urlString];
    //MSGLOG(@"signStr:%@", signStr);
    NSString* privateKey = [self replacementForPropertyValue:[[[self class] config] privateKey] propertyName:@"privateKey"];
    signStr = [NSString stringWithFormat:@"%@%@", signStr, privateKey];
    [params setObject:[[signStr stringFromMD5] uppercaseString] forKey:@"sign"];
    [params setObject:@"MD5" forKey:@"signmethod"];
}
@end

@implementation GWBaseProvider (SendStatus)

- (BOOL)isRunning
{
    if(EGWProviderStatusIdle == self.sendStatus)
        return NO;
    
    return YES;
}

@end


@implementation GWBaseProvider (Send)

- (void)request
{
    _resendTimes = 0;  //该方法为上层调用，provider manager 不会调用，调用此方法把重试次数重置
    GWProviderManager* providerManager = [GWProviderManager instance];
    [providerManager performSelectorOnMainThread:@selector(sendProvider:) withObject:self waitUntilDone:YES];
}

- (void)requestWithCompletionHandler:(CompleteHandler)completeHandler
{
    self.completeHandler = completeHandler;
    [self request];
}

- (void)requestWithResponseHandler:(ResponseHandler)responseHandler
                 completionHandler:(CompleteHandler)completeHandler
{
    self.responseHandler = responseHandler;
    self.completeHandler = completeHandler;
    [self request];
}
@end

@implementation GWBaseProvider(Cancal)
- (void)cancelProvider
{
  //   self.completeHandler = nil;
   //  self.responseHandler = nil;
    
    [[GWProviderManager instance] cancelProvider:self];
}

@end

@implementation GWBaseProvider(AdditionalParameters)

- (void)setParameterWithKey:(NSString *)key value:(id)value
{
    value ? [_keyParamNameValueParamValue setObject:value forKey:key] : [self removeParameterWithKey:key];
}

- (void)setParametersFromDictionary:(NSDictionary *)dictionary
{
    [_keyParamNameValueParamValue addEntriesFromDictionary:dictionary];
}

- (void)removeParameterWithKey:(NSString *)key
{
    [_keyParamNameValueParamValue removeObjectForKey:key];
}

- (NSDictionary *)dictionaryOfAddedParameterAndValues
{
    return _keyParamNameValueParamValue;
}

- (BOOL)isUploadFileUrlProperty:(NSString*)property
{
    return [_uploadFileUrlPropertyNames containsObject:property];
}

- (void)addUploadFileUrlProperty:(NSString*)property
{
    [_uploadFileUrlPropertyNames addObject:property];
}

- (void)removeUploadFileUrlProperty:(NSString*)property
{
    [_uploadFileUrlPropertyNames removeObject:property];
}

- (NSString*)fileNameWithFileProperty:(NSString*)property
{
    return nil;
}

- (NSString*)contentTypeWithFileProperty:(NSString*)property
{
    return @"";//@"image/jpg";
}
@end

@implementation GWBaseProvider(Additional)
+ (id<GWAppConfigDelegate>)config
{
    return [GWProviderAppConfig instance];
}

- (NSTimeInterval)requestCostTime
{
    return (_responseTime - _sendTime);
}

- (NSString*)thumbDescription
{
    return @"";
}

- (void)logWithError:(NSError*)error
{

}

-(NSString*)requestMethod
{
    return @"";
}
@end
