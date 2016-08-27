//
//  GWDownSessionManager.h
//  AFNetworking Example
//
//  Created by heboyce on 16/5/18.
//
//

#import <Foundation/Foundation.h>
#import "AFSecurityPolicy.h"

#if !TARGET_OS_WATCH
#import "AFNetworkReachabilityManager.h"
#endif

@interface GWDownSessionManager : NSObject<NSURLSessionDataDelegate,NSURLSessionDelegate>


/**
 The managed session.
 */
@property (readonly, nonatomic, strong) NSURLSession *session;

/**
 The operation queue on which delegate callbacks are run.
 */
@property (readonly, nonatomic, strong) NSOperationQueue *operationQueue;

///-------------------------------
/// @name Managing Security Policy
///-------------------------------

/**
 The security policy used by created session to evaluate server trust for secure connections. `AFURLSessionManager` uses the `defaultPolicy` unless otherwise specified.
 */
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

#if !TARGET_OS_WATCH
///--------------------------------------
/// @name Monitoring Network Reachability
///--------------------------------------

/**
 The network reachability manager. `AFURLSessionManager` uses the `sharedManager` by default.
 */
@property (readwrite, nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
#endif

- (NSURLSessionDataTask *)gw_downloadTaskWithRequest:(NSMutableURLRequest *)request
                                            progress:(void (^)(NSURLSessionTask *task,NSProgress *downloadProgress)) downloadProgressBlock
                                         destination:(NSURL * (^)(NSURL *targetPath, NSURLSessionTask *task))destination
                                        tempLocation:(NSURL*)tempPath
                                   completionHandler:(void (^)(NSURLSessionTask *task, NSURL *filePath, NSError *error))completionHandler;


@end
