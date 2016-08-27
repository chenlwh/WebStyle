//
//  GWProviderManagerDelagate.h
//  GewaraCore
//
//  Created by wushengtao on 16/2/2.
//  Copyright © 2016年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GWBaseProvider;


/**
 *  响应delegate，调用方向为msg creator->msg manager
 */
@protocol GWProviderManagerResponseDelegate <NSObject>
@optional
/**
 *  请求开始回调
 *
 *  @param request <#request description#>
 */
- (void)requestStarted:(NSObject *)request;
/**
 *  请求完成回调
 *
 *  @param request <#request description#>
 */
- (void)requestFinished:(NSObject *)request;
/**
 *  请求失败回调
 *
 *  @param request <#request description#>
 *  @param error   <#error description#>
 */
- (void)requestFailed:(NSObject *)request error:(NSError*)error;
/**
 *  获取到响应头回调
 *
 *  @param request         <#request description#>
 *  @param responseHeaders <#responseHeaders description#>
 */
- (void)request:(NSObject *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;

@end

/**
 *  进度delegate，调用方向为msg creator->msg manager
 */
@protocol GWProviderManagerProgressDelegate <NSObject>
@optional
/**
 *  下载进度回调
 *
 *  @param request    <#request description#>
 *  @param bytes      <#bytes description#>
 *  @param totalBytes <#totalBytes description#>
 */
- (void)request:(NSObject *)request didReceiveBytes:(long long)bytes totalBytes:(long long)totalBytes;
@end

/**
 *  请求delegate, 调用方向为msg manager->msg creator
 */
@protocol GWProviderManagerRequestDelegate <NSObject>
@property (nonatomic, assign) id<GWProviderManagerResponseDelegate> responseDelegate;
@property (nonatomic, assign) id<GWProviderManagerProgressDelegate> progressDelegate;
/**
 *  msgmanager调用发送请求
 *
 *  @param provider <#provider description#>
 *  @param urlStr   <#urlStr description#>
 *  @param params   <#params description#>
 *
 *  @return 返回创建的request
 */
- (NSObject*)operationWithProvider:(GWBaseProvider*)provider
                        withUrlStr:(NSMutableString*)urlStr
                        withParams:(NSDictionary*)params;
/**
 *  获取当前请求响应的status code
 *
 *  @param request <#request description#>
 *
 *  @return status code
 */
- (NSInteger)responseStatusCodeWithRequest:(NSObject*)request;

/**
 *  如果响应是反回的是string，调用此方法
 *
 *  @param request <#request description#>
 *
 *  @return 响应内容
 */
- (NSString*)responseStringWithRequest:(NSObject*)request;
/**
 *  如果响应返回的是data，调用此方法
 *
 *  @param request <#request description#>
 *
 *  @return 响应内容
 */
- (NSData*)responseDataWithRequest:(NSObject*)request;

/**
 *  取消某个请求
 *
 *  @param request <#request description#>
 */
- (void)cancelRequest:(NSObject*)request;
@end