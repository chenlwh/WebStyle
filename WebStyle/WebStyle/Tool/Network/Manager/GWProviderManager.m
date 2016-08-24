//
//  GWProviderManager.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWProviderManager.h"
#import "GWProviderDelegate.h"

#import "GWDownloadCache.h"
#import "GWBaseProvider.h"
#import "NSDictionary+FormatString.h"
#import "GWErrorInterceptorHandler.h"
#import "NSError+GWRError.h"
#import "GWProviderResultPackage.h"
#import "MsgDefine.h"
#import "NSDate+SFAddition.h"


#if __has_include(<AFNetworking.h>)
#import "GWAFMsgCreator.h"
#undef  __use_ASIHTTPRequest__
#else
#import "GWASIMsgCreator.h"
#define __use_ASIHTTPRequest__
#endif


NSString *const GWBaseHTTPRequestSeverDate      = @"GWBaseHTTPRequestSeverDate";
NSString *const GWBaseHTTPRequestUserErrorFound = @"GWBaseHTTPRequestUserErrorFound";

NSString *const GWBaseHTTPResponseScore         = @"GWBaseHTTPResponseScore";//返回的积分信息
//通知的时候如果响应在非主线程里，刷新界面会crash
#if defined(__TEST__)
#define MenuKvo(obj, fun) [obj performSelectorOnMainThread:@selector(willChangeValueForKey:) withObject:@"providerArray" waitUntilDone:NO]; \
                          fun; \
                          [obj performSelectorOnMainThread:@selector(didChangeValueForKey:) withObject:@"providerArray" waitUntilDone:NO];
#else
#define MenuKvo(obj, fun) fun;
#endif


static GWProviderManager* providermanager = nil;

@interface GWProviderManager()<GWProviderManagerResponseDelegate, GWProviderManagerProgressDelegate>
@property (nonatomic, readonly) NSMutableDictionary* recordCacheDictionary;
@property (nonatomic, readonly) NSMutableArray* providerArray;
@end

@implementation GWProviderManager
@synthesize msgCreator = _msgCreator;

+ (GWProviderManager*)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!providermanager)
            providermanager = [[GWProviderManager alloc] init];
    });
    
    
    return providermanager;
}


- (id)init
{
    if(self = [super init])
	{
        _providerArray = [[NSMutableArray alloc] init];
        _errorHandler = [[GWErrorInterceptorHandler alloc] init];
        _recordCacheDictionary = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (id<GWProviderManagerRequestDelegate>)msgCreator
{
    @synchronized(self)
    {
        if(!_msgCreator)
        {
            
            
#ifdef __use_ASIHTTPRequest__
//            _msgCreator = [[GWASIMsgCreator alloc] init];
#else
            _msgCreator = [[GWAFMsgCreator alloc] init];
#endif
            _msgCreator.responseDelegate = self;
            _msgCreator.progressDelegate = self;
        }
    }
    
    return _msgCreator;
}

- (void)setMsgCreator:(id<GWProviderManagerRequestDelegate>)msgCreator
{
    @synchronized(self)
    {
        _msgCreator = msgCreator;
        
        _msgCreator.responseDelegate = self;
        _msgCreator.progressDelegate = self;
    }
}

#pragma mark cancel provider
- (void)doCancelAndNotifcation:(GWBaseProvider*)provider
{

     provider.sendStatus = EGWProviderStatusIdle;
    [self.msgCreator cancelRequest:provider.operation];
     provider.operation = nil;
    

    __block typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSError* error = [NSError errorWithDomain:GWHTTPRequestErrorDomain
                                             code:GWRequestCancelledErrorType
                                         userInfo:@{NSLocalizedDescriptionKey : @"cancel provider by user"}];
        GWProviderResultPackage* package = [wself packageWithResult:nil error:error];
        [wself provider:provider responedComplete:package];
    });
    
}

- (void)handleCancelModelReq:(id<GWProviderDelegate>)sender
{
    NSMutableArray* removes = [[NSMutableArray alloc] init];
    GWBaseProvider* tmpProvider;
    @synchronized (self)
    {
        for(tmpProvider in _providerArray)
        {
            if(tmpProvider.modelReq)
            {
                [self doCancelAndNotifcation:tmpProvider];
                [removes addObject:tmpProvider];
            }
        }
        if([removes count] > 0)
        {
            MenuKvo(self,
                [_providerArray removeObjectsInArray:removes];
            )
        }
        
       
    }

    [self performSelectorOnMainThread:@selector(removeProgressView) withObject:nil waitUntilDone:YES];
}


- (void)cancelAllProvider
{
    GWBaseProvider* tmpProvider;
    @synchronized (self)
    {
        for(tmpProvider in _providerArray)
        {
            [self doCancelAndNotifcation:tmpProvider];
        }
        
        if([_providerArray count] > 0)
        {

            MenuKvo(self,
                    [_providerArray removeAllObjects];
                    )

        }
    }

    
    [self performSelectorOnMainThread:@selector(removeProgressView) withObject:nil waitUntilDone:YES];
}

- (void)cancelProviderInArray:(NSArray*)providers
{
    @synchronized (self)
    {
        for(GWBaseProvider* tmpProvider in providers)
        {
            [self cancelProvider:tmpProvider];
        }
    }
}

- (void)cancelProvider:(GWBaseProvider*)provider
{
    NSMutableArray* removes = [[NSMutableArray alloc] init];
    GWBaseProvider* tmpProvider;
    BOOL modelReqExist = NO;
    @synchronized (self)
    {
        for(tmpProvider in _providerArray)
        {
            if(tmpProvider == provider)
            {
                [self doCancelAndNotifcation:tmpProvider];
                [removes addObject:tmpProvider];
                            
            }
            else if(tmpProvider.modelReq)
                modelReqExist = YES;
        }
        
        if([removes count] > 0)
        {

            MenuKvo(self,
                    [_providerArray removeObjectsInArray:removes];
                    )

        }

    }

    
    if(modelReqExist)
        [self performSelectorOnMainThread:@selector(removeProgressView) withObject:nil waitUntilDone:YES];
}


- (void)cancelProviderBySender:(id<GWProviderDelegate>)sender
{
    NSMutableArray* removes = [[NSMutableArray alloc] init];
    GWBaseProvider* tmpProvider;
    BOOL modelReqExist = NO;
    @synchronized (self)
    {
        for(tmpProvider in _providerArray)
        {
            if(sender == tmpProvider.sender)
            {
                [self doCancelAndNotifcation:tmpProvider];
                [removes addObject:tmpProvider];
            }
            else if(tmpProvider.modelReq){
                modelReqExist = YES;
            }
        }
        
        if([removes count] > 0)
        {

            MenuKvo(self,
                    [_providerArray removeObjectsInArray:removes];
                    )

        }
    }


    
    if(modelReqExist)
        [self performSelectorOnMainThread:@selector(removeProgressView) withObject:nil waitUntilDone:YES];
}

- (GWProviderResultPackage*)packageWithResult:(id)result error:(NSError*)error
{
    GWProviderResultPackage* package = [[GWProviderResultPackage alloc] init];
    package.providerResult = result;
    package.providerError = error;
    package.isUseCache = NO;
    return package;
}

#pragma mark find providers
/**
 *  所有请求列表
 *
 *  @return <#return value description#>
 */
- (NSArray*)allProviders
{
    @synchronized(self)
    {
        return _providerArray;
    }
}

/**
 *  根据block方法获取相应的provider
 *
 *  @param selectBlock 规则block
 *
 *  @return provider 数组
 */
- (NSArray*)getProviderByBlock:(SelectBlock)selectBlock
{
    NSMutableArray* providers = [[NSMutableArray alloc] init];
    @synchronized (self)
    {
        if(selectBlock)
        {
            GWBaseProvider* tmpProvider;
            for(tmpProvider in _providerArray)
            {
                if(selectBlock(tmpProvider))
                {
                    [providers addObject:tmpProvider];
                }
            }
        }
    }

    return providers;
}

/**
 *  根据sender查找当前需要记录的provider
 *
 *  @param sender sender
 *
 *  @return provider 数组
 */
- (NSArray*)getRecordProvidersBySender:(id<GWProviderDelegate>)sender
{
    NSMutableArray* providers = [[NSMutableArray alloc] init];
    GWBaseProvider* tmpProvider;
    @synchronized (self)
    {
        for(tmpProvider in _providerArray)
        {
            if(sender == tmpProvider.sender
               && tmpProvider.needRecord)
            {
                [providers addObject:tmpProvider];
            }
        }
    }
    
    return providers;
}

/**
 *  根据sender查找其所有perovider
 *
 *  @param sender
 *
 *  @return sender的provider数组
 */
- (NSArray*)getProvidersBySender:(id<GWProviderDelegate>)sender
{
    NSMutableArray* providers = [[NSMutableArray alloc] init];
    GWBaseProvider* tmpProvider;
    @synchronized (self)
    {
        for(tmpProvider in _providerArray)
        {
            if(sender == tmpProvider.sender)
            {
                [providers addObject:tmpProvider];
            }
        }
    }

    return providers;
}

/**
 *  根据provider请求类型获取其所有provider
 *
 *  @param class provider class
 *
 *  @return provider 数组
 */
- (NSArray*)getProviersByProviderClass:(Class)providerClass
{
    NSMutableArray* providers = [[NSMutableArray alloc] init];
    GWBaseProvider* tmpProvider;
    @synchronized (self)
    {
        for(tmpProvider in _providerArray)
        {
            if([tmpProvider isKindOfClass:providerClass])
            {
                [providers addObject:tmpProvider];
            }
        }
    }
    
    return providers;
}

/**
 * @description 获取当前模态请求数组
 */
- (NSArray*)getModelProviders
{
    NSMutableArray* model_reqs = [[NSMutableArray alloc] init];
    GWBaseProvider* tmpProvider;
    @synchronized (self)
    {
        for(tmpProvider in _providerArray)
        {
            if(tmpProvider.modelReq)
            {
                [model_reqs addObject:tmpProvider];
            }
        }
    }
    
    return model_reqs;
}

/**
 * @description 获取当前对应opreration操作对应的请求数组
 * @param opration 相应的ASIHttpRequest或者AFNetworking请求
 */
- (NSArray*)findProviderByOperation:(NSObject*)opration
{
    NSMutableArray* model_providers = [[NSMutableArray alloc] init];
    GWBaseProvider* tmpProvider;
    
    @synchronized (self)
    {
        for(tmpProvider in _providerArray)
        {
          
            
          
        
            if(opration == tmpProvider.operation)
            {
                [model_providers addObject:tmpProvider];
            }
        }
    }
    
    return model_providers ;
}

#pragma mark provider priority
- (void)resetPriority:(EGWProviderPriority)priority
          withSenders:(NSSet*)providers
{
    [_providerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GWBaseProvider* provider = obj;
        if(provider.sender && [providers containsObject:provider.sender])
        {
            provider.requestPriority = priority;
        }
        else
        {
            provider.requestPriority = EGWProviderPriorityNormal;
        }
    }];
}

#pragma mark provider send
- (void)sendProvider:(GWBaseProvider *)provider
{
//    MSGLOG(@"sendProvider");
    [provider cancelProvider];
    
    [provider providerWillStart];
    
    //检查provider参数
    NSError* error = [self checkProviderParamError:provider];
    if(error)
    {
        __block typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            GWProviderResultPackage* package = [wself packageWithResult:nil error:error];
            [wself provider:provider responedComplete:package];
        });
        return;
    }
    
    provider.sendStatus = EGWProviderStatusWaiting;
    
    /*
     TODO:这里需要优化，这是provider添加到_providerArray中时候，provider的operation还是为nil的
     by hepeilin
     */
    
    @synchronized (self)
    {
        MenuKvo(self,
            [_providerArray addObject:provider];
        )
    }
    

    NSMutableDictionary* params = [provider dictionaryOfPropertyNameAsKeyAndValueAsParameter];
    [params addEntriesFromDictionary:[provider dictionaryOfAddedParameterAndValues]];
    
    //签名
    [provider signToParams:params];
    
    NSMutableString* urlStr = [NSMutableString stringWithFormat:@"%@%@", provider.urlString, provider.interfaceName];
    
    if(provider.needHttps)
    {
        NSRange range = [urlStr rangeOfString:@"http://"];
        [urlStr replaceCharactersInRange:range withString:@"https://"];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"GWProviderSenderNotifaction" object:provider];
    
//    MSGLOG(@"\n==============send start==================");
//    MSGLOG(@"method:%@", provider.httpMethod);
//    MSGLOG(@"%@", [NSString stringWithFormat:@"%@%@", urlStr, [params urlString]]);
//    MSGLOG(@"\n==============send end==================");
    
    id<NSCoding> cacheObject = nil;
    if(provider.cache
       && (EGWCachePolicyCacheFirst == provider.cache.cachePolicy || EGWCachePolicyCacheAlwaysRead == provider.cache.cachePolicy))
    {
        NSError* error = nil;
        cacheObject = [provider readLocalCacheWithError:&error];
        if(error && (EGWCachePolicyCacheFirst == provider.cache.cachePolicy))
        {
            cacheObject = nil;
        }
    }
    
    if(!cacheObject)
    {
        //无缓存，发起http请求
        [self.msgCreator operationWithProvider:provider withUrlStr:urlStr withParams:params];
        
    }
    else
    {
        //有缓存，直接返回
        __block typeof(self) bself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            GWProviderResultPackage* package = [bself packageWithResult:cacheObject error:nil];
            package.isUseCache = YES;
            [bself completeProvider:provider package:package];
        });
    }

    
    if(provider.modelReq && [[self getModelProviders] count] >= 1)
    {
        [self createProgressView];
    }
}

#pragma mark msg handler

- (BOOL)removeCacheProvidersIfEmptyWithSender:(id<GWProviderDelegate>)sender
{
    NSArray* providers = [self getRecordProvidersBySender:sender];
    if([providers count] == 0)
    {
        NSString* key = [NSString stringWithFormat:@"%ld", (long)(sender)];
        @synchronized (self)
        {
            [_recordCacheDictionary removeObjectForKey:key];
        }
        return YES;
    }
    
    return NO;
}

- (void)provider:(GWBaseProvider*)provider responedComplete:(GWProviderResultPackage*)package
{
    if(provider.needRecord && provider.sender)
    {
        NSMutableArray* recordCacheArray = nil;
        @synchronized (self)
        {
            NSString* key = [NSString stringWithFormat:@"%ld", (long)(provider.sender)];
            recordCacheArray = _recordCacheDictionary[key];
            if(!recordCacheArray)
            {
                recordCacheArray = [NSMutableArray array];
                [_recordCacheDictionary setObject:recordCacheArray forKey:key];
            }
            [recordCacheArray addObject:package];
        }
        
        BOOL needRemoveCache = [self removeCacheProvidersIfEmptyWithSender:provider.sender];
        if(needRemoveCache
           && [provider.sender respondsToSelector:@selector(providersDidSendFinish:)])
        {
            [provider.sender providersDidSendFinish:recordCacheArray];
        }
    }
    
    provider.resultPackage = package;
    [provider responedComplete:package];
}

/**
 *  检查provider参数是否合法
 *
 *  @param provider
 *
 *  @return 相关错误
 */
- (NSError*)checkProviderParamError:(GWBaseProvider*)provider
{
    if([provider.urlString length] == 0)
        return [NSError errorWithLocalizedDescription:@"url不能为空！"];
    
    return nil;
}

/**
 *  判断是否为合法的provider
 *
 *  @param provider 待判断的Provider
 *
 *  @return YES:合法，NO:非法
 */
- (BOOL)providerIsValid:(GWBaseProvider*)provider
{
    if(!provider)
    {
        MSGLOG(@"not found provider");
        return NO;
    }
    
    if(!provider.operation)
    {
        MSGLOG(@"provider's operation is nil");
        return NO;
    }
    
    //malloc_zone_from_ptr
    if([provider senderByDealloc])
    {
        MSGLOG(@"this provider's sender is be dealloc");
        return NO;
    }
    
    return YES;
}

- (BOOL)resendProviderIfNeed:(GWBaseProvider*)provider error:(NSError*)error
{
    if(provider.errorblock
       && provider.errorblock(error)
       && provider.resendTimes < provider.resendMaxTimes)
    {
        provider.resendTimes++;
        MSGLOG(@"resend provider:%@", [provider description]);
        [self sendProvider:provider];
        return YES;
    }
    
    return NO;
}

- (void)completeProvider:(GWBaseProvider*)provider package:(GWProviderResultPackage*)package
{
    if(provider.modelReq && [[self getModelProviders] count] == 1)
    {
        [self performSelectorOnMainThread:@selector(removeProgressView) withObject:nil waitUntilDone:YES];
    }
    
    GWBaseProvider *strongProvier = provider;
    
    
  
    @synchronized (self)
    {

        MenuKvo(self,
            [_providerArray removeObject:strongProvier];
        )

    }
   
    if(package.providerError)
    {
        strongProvier.sendStatus = EGWProviderStatusIdle;
        [self provider:strongProvier responedComplete:package];
    }
    else
    {
        //正常获取保存缓存
#if 0
        if(package.isUseCache)
        {
            strongProvier.sendStatus = EGWProviderStatusIdle;
            [self provider:strongProvier responedComplete:package];
        }
        else
        {
            strongProvier.sendStatus = EGWProviderStatusCacheSaving;
            __block typeof(self) wself = self;
            __block typeof (self) wProvier = strongProvier;
            
            [strongProvier saveLocalCache:package.providerResult
                          completion:^(BOOL success) {
                              
                              //由于异步解析，此时请求可能被取消了，所以再次判断
                              if(strongProvier && ![wProvier senderByDealloc] && EGWProviderStatusCacheSaving == wProvier.sendStatus)
                              {
                                  [wself provider:wProvier responedComplete:package];
                              }
                              else
                              {
                                  //被取消了，不做删除，防止该provider被重用后又被删除
                                  MSGLOG(@"opration be cancel while save cache");
                              }
                              wProvier.sendStatus = EGWProviderStatusIdle;
                          }];
        }
        
#else
        strongProvier.sendStatus = EGWProviderStatusIdle;
        [strongProvier saveLocalCache:package.providerResult];
        [self provider:strongProvier responedComplete:package];
#endif
    }
 
}

/**
 *  成功后处理
 *
 *  @param provider    该条请求的provider
 *  @param responed    返回的数据
 *  @param description description
 */
- (void)handleSuccess:(GWBaseProvider*)provider forResponed:(id)responed description:(NSString*)description
{
    __block typeof(self) wself = self;
    
    void(^failBlock)() = ^{
        MSGLOG(@"handleSuccess:forResponed:description:%@ not a valid provider, sendStatus:%@", NSStringFromClass([provider class]), @(provider.sendStatus));
        provider.sendStatus = EGWProviderStatusIdle;

        MenuKvo(wself,
            [wself.providerArray removeObject:provider];
        )

        
        if(provider.modelReq && [[wself getModelProviders] count] == 1)
        {
            [wself performSelectorOnMainThread:@selector(removeProgressView) withObject:nil waitUntilDone:NO];
        }
    };
    
    if(![self providerIsValid:provider])
    {
        failBlock();
        return;
    }
    
    NSError *error = nil;
    if([responed isKindOfClass:[NSString class]])
    {
         error = [provider searchError:responed
                           description:description
                          errorHandler:_errorHandler];
    }
    
    if(!error)
    {
        __block NSError *outError = nil;
        provider.sendStatus = EGWProviderStatusParse;
        NSObject* opration = provider.operation;
//        D_Log(@"parse response start %@, %@", NSStringFromClass([provider class]), @(provider.sendStatus));
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(![wself providerIsValid:provider])
            {
                failBlock();
            }
            else
            {
//                D_Log(@"parsing response %@, %@", NSStringFromClass([provider class]), @(provider.sendStatus));
                id result = [provider parseResponed:responed error:&outError];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    D_Log(@"parse response end %@, sendStatus:%@, opration:(%ld/%ld)", NSStringFromClass([provider class]), @(provider.sendStatus), (long)opration, (long)provider.operation);

                    //由于异步解析，此时请求可能被取消了，所以再次判断
                    if((opration == provider.operation) && [wself providerIsValid:provider])
                    {
                        GWProviderResultPackage* package = [wself packageWithResult:result error:outError];
                        [wself completeProvider:provider package:package];
                    }
                    else 
                    {
                        //被取消了，不做删除，防止该provider被重用后又被删除
                        MSGLOG(@"opration be cancel while parse");
//                        failBlock();
                    }
                });
            }
        });
    }
    else
    {
        //判断是否需要重发
        if(![self resendProviderIfNeed:provider error:error])
        {
            GWProviderResultPackage* package = [self packageWithResult:nil error:error];
            [self completeProvider:provider package:package];
            
            MSGLOG(@"provider:%@",provider.class);
            //send notification
            [[NSNotificationCenter defaultCenter] postNotificationName:GWBaseHTTPRequestUserErrorFound object:error];
        }
        
    }
}


/**
 *  失败后处理
 *
 *  @param provider  该条请求的provider
 *  @param httpError msgcreator的错误
 */
- (void)handleFail:(GWBaseProvider*)provider withError:(NSError*)httpError
{
    

    
    provider.sendStatus = EGWProviderStatusIdle;
    
    if(provider.modelReq && [[self getModelProviders] count] == 1)
    {
        [self performSelectorOnMainThread:@selector(removeProgressView) withObject:nil waitUntilDone:NO];
    }
    
    if(![self providerIsValid:provider])
    {
        MSGLOG(@"handleFail:withError: not a valid provider: %@", [provider description]);
        @synchronized (self)
        {

            MenuKvo(self,
                    [_providerArray removeObject:provider];
                    )

            
        }
        [self removeCacheProvidersIfEmptyWithSender:provider.sender];
        return;
    }
    
    NSError* error = provider.defaultNetworkError ? [NSError errorWithDomain:httpError.domain code:httpError.code userInfo:provider.defaultNetworkError.userInfo] : httpError;

    GWBaseProvider *strongProvider = provider;
    
    @synchronized (self)
    {

        MenuKvo(self,
                [_providerArray removeObject:provider];
                )
        

    }
    
    //判断是否需要重发
    if(![self resendProviderIfNeed:strongProvider error:error])
    {
        GWProviderResultPackage* package = [self packageWithResult:nil error:error];
        [self provider:strongProvider responedComplete:package];
        
        D_Log(@"provider:%@",provider.class);
        //send notification
        [[NSNotificationCenter defaultCenter] postNotificationName:GWBaseHTTPRequestUserErrorFound object:error];
    }
    

}


#pragma mark - GWProviderManagerResponseDelegate
- (void)requestStarted:(NSObject*)request
{
    
    
    GWBaseProvider* provider = [[self findProviderByOperation:request] firstObject];
    provider.sendStatus = EGWProviderStatusSend;
    provider.sendTime = [NSDate timeIntervalSinceReferenceDate];

}

- (void)requestFinished:(NSObject*)request
{
    
   
    GWBaseProvider* provider = [[self findProviderByOperation:request] firstObject];
    
    if (!provider) {
        return;
    }
    
    
    
    provider.responseTime = [NSDate timeIntervalSinceReferenceDate];

    NSString* urlString = [provider description];
    NSInteger responseStatusCode = [self.msgCreator responseStatusCodeWithRequest:request];
    if(200 == responseStatusCode)
    {
        //MSGLOG(@"\n==============recv start==================");
        if(provider.responseType == EGWHTTPRequestResponseTypeString)
        {
            NSString *responseString = [self.msgCreator responseStringWithRequest:request];
            
          //  D_Log(@"responseString:%@",responseString);
            //MSGLOG(@"%@", responseString);
            [self handleSuccess:provider forResponed:responseString description:urlString];
        }
        else
        {
            //TODO:sheen 大文件情况下需要直接写文件而不是全部下载完成再回调，后期优化（增加downloadDestinationPath设置）
            //MSGLOG(@"it's data format response...");
            [self handleSuccess:provider forResponed:[self.msgCreator responseDataWithRequest:request] description:urlString];
        }
        //MSGLOG(@"\n==============recv end=
        
        [provider logWithError:nil];
    }
    else
    {
        NSError* error = nil;
        //TODO:sheen 206 416等错误处理
        if(responseStatusCode != 206 && responseStatusCode != 416)
        {
            //非http200下载出错，删除文件
            if([provider.fileDownloadPath length])
            {
                [[NSFileManager defaultManager] removeItemAtPath:provider.fileDownloadPath error:&error];
            }
            
            if([provider.temporaryFileDownloadPath length])
            {
                error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:provider.temporaryFileDownloadPath error:&error];
            }
        }
        
        //非http 200的错误  当这里边的urlString 可能是nil 所以要处理，现在查找原因，初步会议室task完成时候回调finish函数时候已经被cancel掉了
        error = [NSError errorWithDomain:GWHTTPRequestErrorDomain
                                    code:responseStatusCode
                                userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"response http code:%@", @(responseStatusCode)], GWErrorRequestURLKey : urlString}];
        [self handleFail:provider withError:error];
        [provider logWithError:nil];
    }
}

- (void)requestFailed:(NSObject*)request error:(NSError*)error
{

    GWBaseProvider* provider = [[self findProviderByOperation:request] firstObject];
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
    NSString* urlStr = [provider description];
    if([urlStr length])
    {
        [userInfo setObject:urlStr forKey:GWErrorRequestURLKey];
    }
    NSError* errorInfo = [NSError errorWithDomain:error.domain
                                             code:error.code
                                         userInfo:userInfo];
    [self handleFail:provider withError:errorInfo];
    
    [provider logWithError:errorInfo];
}

- (void)request:(NSObject*)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSDate *serverDate = [NSDate gw_dateFromRFC1123String:[responseHeaders objectForKey:@"Date"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GWBaseHTTPRequestSeverDate
                                                        object:serverDate];
    
   
    GWBaseProvider* provider = [[self findProviderByOperation:request] firstObject];
    [provider responseHeaders:responseHeaders];
    provider.serverDate = serverDate;
}

#pragma mark GWProviderManagerProgressDelegate
- (void)request:(NSObject*)request didReceiveBytes:(long long)bytes totalBytes:(long long)totalBytes
{
    GWBaseProvider* provider = [[self findProviderByOperation:request] firstObject];
    
    [provider didReceiveBytes:bytes
                   totalBytes:totalBytes];
}

@end
