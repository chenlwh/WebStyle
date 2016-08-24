//
//  GWProviderManager.h
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWProgressObject.h"
#import "GWBaseProvider.h"
#import "GWProviderManagerDelagate.h"

OBJC_EXTERN NSString *const GWBaseHTTPRequestSeverDate;
OBJC_EXTERN NSString *const GWBaseHTTPRequestUserErrorFound;
OBJC_EXTERN NSString *const GWBaseHTTPResponseScore;
@protocol GWProviderDelegate;
typedef BOOL (^SelectBlock)(GWBaseProvider* tmpProvider);

@interface GWProviderManager : GWProgressObject
/**
 *  错误拦截器，默认不传使用GWErrorInterceptorHandler
 */
@property (nonatomic, readonly) GWErrorInterceptorHandler* errorHandler;
/**
 *  传递msg creator（目前包括GWASIMsgCreator和GWAFMsgCreator），默认不传则使用GWASIMsgCreator
 */
@property (nonatomic, retain) id<GWProviderManagerRequestDelegate> msgCreator;

+ (GWProviderManager*)instance;

/**
 *  所有的请求列表
 *
 *  @return <#return value description#>
 */
- (NSArray*)allProviders;

/**
 *  根据block方法获取相应的provider
 *
 *  @param selectBlock 规则block
 *
 *  @return provider 数组
 */
- (NSArray*)getProviderByBlock:(SelectBlock)selectBlock;

/**
 *  根据sender查找当前需要记录的provider
 *
 *  @param sender sender
 *
 *  @return provider 数组
 */
- (NSArray*)getRecordProvidersBySender:(id<GWProviderDelegate>)sender;

/**
 *  根据sender查找其所有provider
 *
 *  @param sender
 *
 *  @return provider 数组
 */
- (NSArray*)getProvidersBySender:(id<GWProviderDelegate>)sender;

/**
 *  根据provider请求类型获取其所有provider
 *
 *  @param class provider class
 *
 *  @return provider 数组
 */
- (NSArray*)getProviersByProviderClass:(Class)providerClass;

/**
 * @description 取消所有请求
 */
- (void)cancelAllProvider;

/**
 * @description 根据请求的结构体对象取消请求
 * @param reqData 请求的结构体
 */
- (void)cancelProvider:(GWBaseProvider*)provider;

/**
 *  取消一组provider
 *
 *  @param providers 
 */
- (void)cancelProviderInArray:(NSArray*)providers;

/**
 * @description 根据发送者者取消请求，一般用于该sender被销毁时调用
 * @param _delegate 对应的委托实现者
 */
- (void)cancelProviderBySender:(id<GWProviderDelegate>)sender;

/**
 *  调整请求优先级，除此之外的请求优先级置为EGWProviderPriorityNormal
 *
 *  @param priority     优先级
 *  @param sendProvider sender的集合
 */
- (void)resetPriority:(EGWProviderPriority)priority
          withSenders:(NSSet*)providers;

/**
 * @description 发送请求
 * @param reqData 请求的结构体对象
 */
- (void)sendProvider:(GWBaseProvider*)provider;

@end
