//
//  GWDownSessionManager.m
//  AFNetworking Example
//
//  Created by heboyce on 16/5/18.
//
//

#import "GWDownSessionManager.h"

#ifndef NSFoundationVersionNumber_iOS_8_0
#define GW_NSFoundationVersionNumber_With_Fixed_5871104061079552_bug 1140.11
#else
#define GW_NSFoundationVersionNumber_With_Fixed_5871104061079552_bug NSFoundationVersionNumber_iOS_8_0
#endif


#define GW_ShowError(error)  if (error) { NSLog(@"Move File Error:%@",error);}

#define HTTPStausOK 200


static dispatch_queue_t url_session_manager_creation_queue() {
    static dispatch_queue_t af_url_session_manager_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_url_session_manager_creation_queue = dispatch_queue_create("com.gw.alamofire.networking.downsession.manager.creation", DISPATCH_QUEUE_SERIAL);
    });
    
    return af_url_session_manager_creation_queue;
}

static void url_session_manager_create_task_safely(dispatch_block_t block) {
    if (NSFoundationVersionNumber < GW_NSFoundationVersionNumber_With_Fixed_5871104061079552_bug) {
        // Fix of bug
        // Open Radar:http://openradar.appspot.com/radar?id=5871104061079552 (status: Fixed in iOS8)
        // Issue about:https://github.com/AFNetworking/AFNetworking/issues/2093
        dispatch_sync(url_session_manager_creation_queue(), block);
    } else {
        block();
    }
}

static NSString * const GWURLSessionManagerLockName = @"com.alamofire.networking.downsession.manager.lock";

typedef NSURL * (^AFURLSessionDownloadTaskDidFinishDownloadingBlock)(NSURLSessionTask *downloadTask, NSURL *location);
typedef void (^AFURLSessionTaskCompletionHandler)(NSURLSessionTask *task, id responseObject, NSError *error);
typedef void (^AFURLSessionTaskProgressBlock)(NSURLSessionTask *task,NSProgress *);
typedef NSURLSessionAuthChallengeDisposition (^AFURLSessionTaskDidReceiveAuthenticationChallengeBlock)(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential);
typedef void (^AFURLSessionDataTaskDidReceiveDataBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data);
typedef NSURLSessionResponseDisposition (^AFURLSessionDataTaskDidReceiveResponseBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response);
typedef void (^AFURLSessionDataTaskDidBecomeDownloadTaskBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLSessionDownloadTask *downloadTask);
typedef NSCachedURLResponse * (^AFURLSessionDataTaskWillCacheResponseBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSCachedURLResponse *proposedResponse);
typedef void (^AFURLSessionDidFinishEventsForBackgroundURLSessionBlock)(NSURLSession *session);
typedef void (^AFURLSessionTaskDidCompleteBlock)(NSURLSession *session, NSURLSessionTask *task, NSError *error);


@interface GWDownSessionManagerTaskDelegate : NSObject<NSURLSessionDataDelegate,NSURLSessionDelegate>
@property (nonatomic,weak) GWDownSessionManager                                 *manager;
@property (nonatomic, copy) AFURLSessionTaskProgressBlock                       downloadProgressBlock;
@property (nonatomic, copy) AFURLSessionTaskCompletionHandler                   completionHandler;
@property (nonatomic, copy) AFURLSessionDownloadTaskDidFinishDownloadingBlock   downloadTaskDidFinishDownloading;

@property (readwrite,nonatomic,copy) NSURL                                      *tempDownFileUrl;
@property (nonatomic,copy) NSURL                                                *downFileUrl;
@property (nonatomic,strong) NSOutputStream                                     *outStream;
@property (nonatomic,strong) NSProgress                                         *progress;
@end


@implementation GWDownSessionManagerTaskDelegate


- (id)init{
    
    NSString *tmpFileName = [NSString stringWithFormat:@"%@.tmp",@([self hash])];
    NSURL *tmpFilepath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:tmpFileName]];

    return [self initWithTmpFilePath:tmpFilepath];

}

- (id)initWithTmpFilePath:(NSURL*)tmpPath{

    self = [super init];
    
    self.tempDownFileUrl = tmpPath;
     self.outStream = [NSOutputStream outputStreamToFileAtPath:tmpPath.path append:YES];
    [self.outStream open];
    
    return self;

}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(__unused NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSError *moveError = nil;
    

    /*
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        if (httpResponse.statusCode != HTTPStausOK && !error) {
            
           error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                                 code:httpResponse.statusCode
                                             userInfo:@{NSLocalizedDescriptionKey : @"未知错误"}];
            
        }
        
    }
    */
    
    
    
    if (!error) {
        self.downFileUrl = self.downloadTaskDidFinishDownloading(task,self.tempDownFileUrl);
    }
    
    if (self.tempDownFileUrl && self.downFileUrl) {
         [[NSFileManager defaultManager] moveItemAtURL:self.tempDownFileUrl toURL:self.downFileUrl error:&moveError];
          GW_ShowError(error);
    }
    
    if (self.completionHandler) {
        self.completionHandler(task,self.downFileUrl,error);
    }
    
  
}

#pragma mark - NSURLSessionDataTaskDelegate

- (void)URLSession:(__unused NSURLSession *)session
          dataTask:(__unused NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
     unsigned long long  bytesReceived = 0;
    
    
    
    if (!self.progress) {
        self.progress = [[NSProgress alloc]init];
        
        NSFileManager *manager = [NSFileManager defaultManager];
       
        if ([manager fileExistsAtPath:self.tempDownFileUrl.path]) {
        
            bytesReceived = [[manager attributesOfItemAtPath:self.tempDownFileUrl.path error:nil] fileSize];
        }
        
      
        self.progress.totalUnitCount = dataTask.countOfBytesExpectedToReceive + bytesReceived;
        
       
    }
    
    
    
    
    
    self.progress.completedUnitCount = dataTask.countOfBytesReceived + self.progress.totalUnitCount - dataTask.countOfBytesExpectedToReceive;
    
    if (self.downloadProgressBlock) {
       self.downloadProgressBlock(dataTask,_progress);
    }
    

    NSInteger       dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
    
    // 接收到的数据长度
    dataLength = [data length];
    dataBytes  = [data bytes];
    
    bytesWrittenSoFar = 0;
    do {
        bytesWritten = [self.outStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
        assert(bytesWritten != 0);
        if (bytesWritten == -1) {
            break;
        } else {
            bytesWrittenSoFar += bytesWritten;
        }
    } while (bytesWrittenSoFar != dataLength);
    
   
}

@end


@interface GWDownSessionManager()
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;
@property (readonly, nonatomic, copy) NSString *taskDescriptionForSessionTasks;
@property (readwrite, nonatomic, strong) NSLock *lock;

@property (readwrite, nonatomic, copy) AFURLSessionTaskDidCompleteBlock                         taskDidComplete;
@property (readwrite, nonatomic, copy) AFURLSessionTaskDidReceiveAuthenticationChallengeBlock   taskDidReceiveAuthenticationChallenge;
@property (readwrite, nonatomic, copy) AFURLSessionDataTaskDidReceiveResponseBlock              dataTaskDidReceiveResponse;
@property (readwrite, nonatomic, copy) AFURLSessionDataTaskDidReceiveDataBlock                  dataTaskDidReceiveData;
@property (readwrite, nonatomic, copy) AFURLSessionDataTaskDidBecomeDownloadTaskBlock           dataTaskDidBecomeDownloadTask;
@property (readwrite, nonatomic, copy) AFURLSessionDataTaskWillCacheResponseBlock               dataTaskWillCacheResponse;
@property (readwrite, nonatomic, copy) AFURLSessionDidFinishEventsForBackgroundURLSessionBlock  didFinishEventsForBackgroundURLSession;


@end


@implementation GWDownSessionManager

- (instancetype)init {
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    self.sessionConfiguration   = configuration;
    self.operationQueue         = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    self.session                = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
    self.mutableTaskDelegatesKeyedByTaskIdentifier = [[NSMutableDictionary alloc]init];
    self.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
#if !TARGET_OS_WATCH
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
#endif
    
    self.mutableTaskDelegatesKeyedByTaskIdentifier = [[NSMutableDictionary alloc] init];
    
    self.lock = [[NSLock alloc] init];
    self.lock.name = GWURLSessionManagerLockName;
    
    return self;
}

- (NSURLSessionDataTask *)gw_downloadTaskWithRequest:(NSMutableURLRequest *)request
                                             progress:(void (^)(NSURLSessionTask *task,NSProgress *downloadProgress)) downloadProgressBlock
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLSessionTask *task))destination
                                        tempLocation:(NSURL*)tempPath
                                    completionHandler:(void (^)(NSURLSessionTask *task, NSURL *filePath, NSError *error))completionHandler
{
    __block NSURLSessionDataTask *downloadTask = nil;
    
    NSURL *tmpFilepath = nil;
    
    if (tempPath) {
        tmpFilepath = tempPath;
    }else{
        
       NSString *tmpFileName = [NSString stringWithFormat:@"%@.tmp",@([request.URL.lastPathComponent hash])];
       tmpFilepath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:tmpFileName]];
        
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:tmpFilepath.path]) {
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:request.allHTTPHeaderFields];
        
        unsigned long long  bytesReceived = [[manager attributesOfItemAtPath:tmpFilepath.path error:nil] fileSize];
        
        [headers setObject:[NSString stringWithFormat:@"bytes=%llu-",bytesReceived] forKey:@"Range"];
        
        request.allHTTPHeaderFields = headers;
        
    }else{
    
        [manager createFileAtPath:tmpFilepath.path contents:nil attributes:nil];
    }
    
   
    url_session_manager_create_task_safely(^{
        downloadTask = [self.session dataTaskWithRequest:request];
    });
    
   
    
    [self addDelegateForDownloadTask:downloadTask progress:downloadProgressBlock destination:destination tempLocation:tmpFilepath completionHandler:completionHandler];
    
    return downloadTask;
}

- (void)addDelegateForDownloadTask:(NSURLSessionDataTask *)downloadTask
                          progress:(void (^)(NSURLSessionTask *task,NSProgress *downloadProgress)) downloadProgressBlock
                       destination:(NSURL * (^)(NSURL *targetPath, NSURLSessionTask *task))destination
                      tempLocation:(NSURL*)tempLocation
                 completionHandler:(void (^)(NSURLSessionTask *task, NSURL *filePath, NSError *error))completionHandler
{
    
    GWDownSessionManagerTaskDelegate *delegate = [[GWDownSessionManagerTaskDelegate alloc]initWithTmpFilePath:tempLocation];
    delegate.manager = self;
    
    if (destination) {
        delegate.downloadTaskDidFinishDownloading = ^NSURL * (NSURLSessionTask *task, NSURL *location) {
            return destination(location, task);
        };
    }
    
    [self setDelegate:delegate forTask:downloadTask];
    
   
    
    delegate.completionHandler = completionHandler;

    delegate.downloadProgressBlock = downloadProgressBlock;
    
}


#pragma mark -

- (GWDownSessionManagerTaskDelegate *)delegateForTask:(NSURLSessionTask *)task {
    NSParameterAssert(task);
    
    GWDownSessionManagerTaskDelegate *delegate = nil;
    [self.lock lock];
    delegate = self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)];
    
    [self.lock unlock];
    
    return delegate;
}

- (void)setDelegate:(GWDownSessionManagerTaskDelegate *)delegate
            forTask:(NSURLSessionTask *)task
{
    NSParameterAssert(task);
    NSParameterAssert(delegate);
    
    [self.lock lock];
    self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate;

    [self.lock unlock];
}

- (void)removeDelegateForTask:(NSURLSessionTask *)task {
    NSParameterAssert(task);
    
    [self.lock lock];
    [self.mutableTaskDelegatesKeyedByTaskIdentifier removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
}

#pragma mark - NSURLSessionTaskDelegate



- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if (self.taskDidReceiveAuthenticationChallenge) {
        disposition = self.taskDidReceiveAuthenticationChallenge(session, task, challenge, &credential);
    } else {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([self.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                disposition = NSURLSessionAuthChallengeUseCredential;
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}


- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    GWDownSessionManagerTaskDelegate *delegate = [self delegateForTask:task];
    
 
    
    if (delegate) {
        [delegate URLSession:session task:task didCompleteWithError:error];
        [self removeDelegateForTask:task];
    }
  
    if (self.taskDidComplete) {
        self.taskDidComplete(session, task, error);
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    
    if (self.dataTaskDidReceiveResponse) {
        disposition = self.dataTaskDidReceiveResponse(session, dataTask, response);
    }
    
    if (completionHandler) {
        completionHandler(disposition);
    }
}



- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
  
    GWDownSessionManagerTaskDelegate *delegate = [self delegateForTask:dataTask];
    
    [delegate URLSession:session dataTask:dataTask didReceiveData:data];


    if (self.dataTaskDidReceiveData) {
        self.dataTaskDidReceiveData(session, dataTask, data);
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
   
    NSCachedURLResponse *cachedResponse = proposedResponse;
    
    if (self.dataTaskWillCacheResponse) {
        cachedResponse = self.dataTaskWillCacheResponse(session, dataTask, proposedResponse);
    }
    
    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
    
    if (self.didFinishEventsForBackgroundURLSession) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.didFinishEventsForBackgroundURLSession(session);
        });
    }
}


@end
