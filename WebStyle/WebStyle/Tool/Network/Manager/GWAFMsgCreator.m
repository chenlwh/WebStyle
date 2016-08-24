//
//  GWAFMsgCreator.m
//  GWMovie
//
//  Created by wushengtao on 16/2/2.
//  Copyright © 2016年 gewara. All rights reserved.
//

#import <objc/runtime.h>
#import "GWAFMsgCreator.h"
#import "GWBaseProvider.h"
#import "NSDictionary+FormatString.h"
#import "GWAppDotNetAPIClient.h"

#import "MsgDefine.h"
#import "FBKVOController.h"
//#import "GWCommkit.h"
#import "GWDownSessionManager.h"

#define HTTP_TIMEOUT 60


static char kGWKvoControllerKey;
static char kGWStoreResponseObjectKey;

@interface NSObject(GWStoreResponse)
@property (nonatomic, strong) FBKVOController* kvoController;
@property (nonatomic, strong) NSObject*        responseObject;
@end

@implementation NSObject (GWStoreResponse)

- (FBKVOController*)kvoController
{
    return objc_getAssociatedObject(self, &kGWKvoControllerKey);
}

- (void)setKvoController:(FBKVOController *)kvoController
{
    objc_setAssociatedObject(self, &kGWKvoControllerKey, kvoController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setResponseObject:(NSObject*)responseObject
{
    objc_setAssociatedObject(self, &kGWStoreResponseObjectKey, responseObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject*)responseObject
{
    return objc_getAssociatedObject(self, &kGWStoreResponseObjectKey);
}

@end

@interface GWAFMsgCreator()

@property (nonatomic,strong) GWDownSessionManager             *downManager;
@property (nonatomic,strong) GWAppDotNetAPIClient             *manager;

@end


@implementation GWAFMsgCreator

- (void)dealloc
{
    _responseDelegate = nil;
    _progressDelegate = nil;
}

- (instancetype)init
{
    if(self = [super init])
    {
        
        
        _manager        = [GWAppDotNetAPIClient sharedClient];
        AFHTTPResponseSerializer* serializer  = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer           = serializer;
        _manager.requestSerializer.timeoutInterval = HTTP_TIMEOUT;
        [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost = 4;
        //if need support https should fix here
        _manager.securityPolicy.allowInvalidCertificates = NO;
        _manager.securityPolicy.validatesDomainName      = NO;
        
        _downManager = [[GWDownSessionManager alloc]init];
        
        
        
        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationDidStart:) name:AFNetworkingTaskDidResumeNotification object:nil];

    }
    
    return self;
}

- (void)operationDidStart:(NSNotification*)noti
{
    if (noti.object) {
         [self requestStarted:noti.object];
    }
   
}

#pragma mark config request
- (void)configureRequest:(NSURLSessionTask *)request
            withProvider:(GWBaseProvider*)provider
{
    if(IOS8)
    {
        switch (provider.requestPriority)
        {
            case EGWProviderPriorityVeryHigh:
                {
                    request.priority = 0.9;
                }
                break;
            case EGWProviderPriorityHigh:
                {
                    request.priority = 0.75;
                }
                break;
            case EGWProviderPriorityLow:
                {
                    request.priority =  0.25;
                }
                break;
            case EGWProviderPriorityVeryLow:
                {
                    request.priority =  0.1;
                }
                break;
            case EGWProviderPriorityNormal:
            default:
                {
                    request.priority =  0.5;
                }
                break;
        }

    }
    
    
  
    
    provider.operation = request;
    
   // WeakObjectDef(self);
  
    //request.kvoController = [[FBKVOController alloc] initWithObserver:self];
      /*
    [request.kvoController observe:request
                    keyPath:@"response"
                    options:NSKeyValueObservingOptionNew
                      block:^(id observer, id object, NSDictionary *change) {
                          NSHTTPURLResponse* response = (NSHTTPURLResponse*)((NSURLSessionTask*)object).response;
                          
                          //NSLog(@"response:%@",response);
                          
                          [weakself request:object didReceiveResponseHeaders:[response allHeaderFields]];
                      }];
    */
#ifdef __PRINTF_REQUEST_URL__
    D_Log(@"get b: %@", [provider valueForKey:@"method"]);
#endif
    
}

- (void)downloadTaskCompletionWithProvider:(GWBaseProvider*)provider
                                  task:(NSURLSessionTask *)task
                                  filePath:(NSURL*)filePath
                                     error:(NSError*)error{
    

    if(error)
    {
        [self requestFailed:task withError:error];
        return;
    }
    
    if(![provider.fileDownloadPath isEqualToString:provider.temporaryFileDownloadPath])
    {
            NSError* fileError = nil;
            [[NSFileManager defaultManager] removeItemAtPath:provider.fileDownloadPath
                                                       error:&fileError];
            if(fileError)
            {
                D_Log(@"remove Path error:%@", fileError);
            }
            
            fileError = nil;
            
            [[NSFileManager defaultManager] moveItemAtPath:[filePath absoluteString]
                                                    toPath:provider.fileDownloadPath
                                                     error:&fileError];
            if(fileError)
            {
                D_Log(@"move Path error:%@", fileError);
            }
        
      }
    
    
    [self requestFinished:(id)provider.operation];
    
    
}

#pragma mark RequestMehtods

- (NSURLSessionDataTask*)downLoadWithProvider:(GWBaseProvider*)provider urlString:(NSMutableString*)urlStr{


    WeakObjectDef(self);
    WeakObjectDef(provider);
    
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    

    
    NSURLSessionDataTask *request =  [_downManager gw_downloadTaskWithRequest:mutableRequest progress:^(NSURLSessionTask *task,NSProgress *downloadProgress) {
        
    
        [weakself request:task didReceiveBytes:downloadProgress];
        
    } destination:^NSURL *(NSURL *targetPath, NSURLSessionTask *task) {
        NSURL *downloadURL = [NSURL fileURLWithPath:provider.fileDownloadPath];
        return downloadURL;
    } tempLocation:[NSURL fileURLWithPath:provider.temporaryFileDownloadPath] completionHandler:^(NSURLSessionTask *task, NSURL *filePath, NSError *error) {
        [weakself downloadTaskCompletionWithProvider:weakprovider task:task filePath:filePath error:error];
      //  [weakself downloadTaskCompletionWithProvider:weakprovider task:weakprovider.operation filePath:filePath error:error];
    }];
    
    
    [self configureRequest:request withProvider:provider];
    
    return request;

}

- (NSURLSessionDataTask*)Get:(NSString*)urlStr parameters:(NSDictionary*)params provider:(GWBaseProvider*)provider{

    WeakObjectDef(self);
    WeakObjectDef(provider);
    NSURLSessionDataTask* request = [_manager GET:urlStr
                                      parameters:params
                                        progress:^(NSProgress * _Nonnull downloadProgress) {
                                            
                                            if (weakprovider.operation) {
                                                 [weakself request:(id)weakprovider.operation didReceiveBytes:downloadProgress];
                                            }
                                            
                                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                            task.responseObject = responseObject;
                                            [weakself requestFinished:task];
                                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                            [weakself requestFailed:task withError:error];
                                        }];
    
    [self configureRequest:request withProvider:provider];

    return request;
    
    
}

- (NSURLSessionDataTask*)Post:(NSString*)urlStr formDatas:(NSMutableArray*)fromDatas parameters:(NSDictionary*)params provider:(GWBaseProvider*)provider{
    
    WeakObjectDef(self);
    WeakObjectDef(provider);
    
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithDictionary:params];
    [pars removeObjectsForKeys:fromDatas];
    
    
    NSURLSessionDataTask  *sessionTask = [_manager POST:urlStr
                     parameters:pars
      constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    for(NSString* key in fromDatas)
                    {
                        NSError* error = nil;
                        [formData appendPartWithFileURL:[NSURL fileURLWithPath:[params objectForKey:key]]
                                                   name:key
                                               fileName:[weakprovider fileNameWithFileProperty:key]
                                               mimeType:[weakprovider contentTypeWithFileProperty:key]
                                                  error:&error];
                    }
        }
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           
                           if (weakprovider.operation) {
                                [weakself request:(id)weakprovider.operation didReceiveBytes:uploadProgress];
                           }
                           
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            task.responseObject = responseObject;
                            [weakself requestFinished:task];
                            
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                            [weakself requestFailed:task withError:error];
                            
                        }];
    
    [self configureRequest:sessionTask withProvider:provider];
    
    return sessionTask;
    
}

- (NSURLSessionDataTask*)Post:(NSString*)urlStr parameters:(NSDictionary*)params provider:(GWBaseProvider*)provider{
    
    WeakObjectDef(self);
    WeakObjectDef(provider);
    
    NSURLSessionDataTask  *sessionTask = [_manager POST:urlStr
                     parameters:params
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           
                           if (weakprovider.operation) {
                                 [weakself request:(id)weakprovider.operation didReceiveBytes:uploadProgress];
                           }
                          
                           
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            task.responseObject = responseObject;
                            [weakself requestFinished:task];
                            
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                            [weakself requestFailed:task withError:error];
                            
                        }];
    
    [self configureRequest:sessionTask withProvider:provider];
    
    return sessionTask;

}



#pragma mark GWProviderManagerRequestDelegate
- (void)cancelRequest:(NSObject *)request
{
 
    NSURLSessionTask* task = (NSURLSessionTask*)request;
   // [task.kvoController unobserveAll];
    
 //   D_Log(@"cancelRequest:%@",task);
    
    
    [task cancel];
  
    
}

- (NSInteger)responseStatusCodeWithRequest:(NSObject*)request
{
    return ((NSHTTPURLResponse*)((NSURLSessionTask*)request).response).statusCode;
}

- (NSString*)responseStringWithRequest:(NSObject*)request
{
    
    NSString* str = [[NSString alloc] initWithData:(id)((NSURLSessionTask*)request).responseObject encoding:NSUTF8StringEncoding];
    
    return str;
}

- (NSData*)responseDataWithRequest:(NSObject*)request
{
    return (id)((NSURLSessionTask*)request).responseObject;

}


- (NSObject*)operationWithProvider:(GWBaseProvider*)provider
                        withUrlStr:(NSMutableString*)urlStr
                        withParams:(NSDictionary*)params
{
    
 
    WeakObjectDef(self);
    
   [_manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
       
       if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
              [weakself request:dataTask didReceiveResponseHeaders:[(NSHTTPURLResponse*)dataTask.response allHeaderFields]];
       }
       
       return NSURLSessionResponseAllow;
        
   }];
     
    
    for(NSString* key in provider.requestHeaders)
    {
        [_manager.requestSerializer setValue:provider.requestHeaders[key] forHTTPHeaderField:key];
    }
    
    if([provider.httpMethod isEqualToString:HttpMethodGet])
    {
        if(provider.allowResumeForFileDownloads && [provider.fileDownloadPath length])
        {
           NSURLSessionDataTask *request = [weakself downLoadWithProvider:provider urlString:urlStr];
           [request resume];
           return request;
        }
        else
        {
            NSURLSessionDataTask* request = [self Get:urlStr parameters:params provider:provider];
            [request resume];
            return request;
        }
        
    }
    else
    {
        NSArray* keys = [params allKeys];
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        NSMutableArray* formDatas = [NSMutableArray array];
        for(NSString *key in keys)
        {
            if([provider isUploadFileUrlProperty:key])
            {
                [formDatas addObject:key];
            }
           
            [parameters setValue:[params objectForKey:key] forKey:key];
        }
        
        NSURLSessionDataTask* sessionTask = nil;
        
        if([formDatas count] > 0)
        {
            [weakself Post:urlStr formDatas:formDatas parameters:parameters provider:provider];
        }
        else
        {
            [weakself Post:urlStr parameters:parameters provider:provider];
        }
        

        [sessionTask resume];
        
        return sessionTask;
    }
    
    return nil;
}


#pragma mark -  GWProviderManagerResponseDelegate

- (void)requestStarted:(NSObject *)request
{
    if([_responseDelegate respondsToSelector:@selector(requestStarted:)])
    {
        [_responseDelegate requestStarted:request];
    }
}

- (void)requestFinished:(NSObject *)request
{
    if([_responseDelegate respondsToSelector:@selector(requestFinished:)])
    {
        [_responseDelegate requestFinished:request];
    }
}

- (void)requestFailed:(NSObject *)request withError:(NSError*)error
{

    NSURLSessionTask *task = (NSURLSessionTask*)request;
 
    NSInteger statusCode  = 0;
    
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
       
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        statusCode = response.statusCode;
        
    }
    

    
    if(statusCode > 0 && !error)
    {
        [self requestFinished:request];
        return;
    }
    
    if([_responseDelegate respondsToSelector:@selector(requestFailed:error:)])
    {
        [_responseDelegate requestFailed:request error:error];
    }

}

- (void)request:(NSObject *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
    if([_responseDelegate respondsToSelector:@selector(request:didReceiveResponseHeaders:)])
    {
        [_responseDelegate request:request didReceiveResponseHeaders:responseHeaders];
    }
}

#pragma GWProviderManagerProgressDelegate

- (void)request:(NSObject *)request didReceiveBytes:(NSProgress*)downloadProgress
{
    
    
    if([_progressDelegate respondsToSelector:@selector(request:didReceiveBytes:totalBytes:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_progressDelegate request:request
                       didReceiveBytes:downloadProgress.completedUnitCount
                            totalBytes:downloadProgress.totalUnitCount];
        });
        
    }
}


@end


