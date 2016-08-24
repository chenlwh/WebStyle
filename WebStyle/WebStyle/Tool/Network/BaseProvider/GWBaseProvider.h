 //
//  GWBaseProvider.h
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWObject.h"
#import "GWCacheInfo.h"
#import "GWProviderResultPackage.h"
#import "GWProviderAppConfig.h"

typedef void (^CompleteHandler)(id response, NSError *error);
typedef id(^ResponseHandler)(id rsp, NSError **error);
typedef void(^DidReceiveHandler)(long long bytes, long long totalBytes);
typedef void(^ReadCacheCompletion)(id<NSCoding> cache, NSError* error);
typedef void(^SaveCacheCompletion)(BOOL success);
typedef NSDictionary* (^ReplacePropertyValue)();

static NSString* const HttpMethodGet = @"GET";
static NSString* const HttpMethodPost = @"POST";

typedef enum{
    EGWHTTPRequestResponseTypeString = 0 //string类型
    , EGWHTTPRequestResponseTypeData  //data类型
}GWHTTPRequestResponseType;

typedef enum : NSInteger {
    EGWProviderPriorityVeryLow = -8L
    , EGWProviderPriorityLow = -4L
    , EGWProviderPriorityNormal = 0
    , EGWProviderPriorityHigh = 4
    , EGWProviderPriorityVeryHigh = 8
} EGWProviderPriority;


typedef enum : NSUInteger {
    EGWProviderStatusIdle = 0   //空闲，不处于请求中
    , EGWProviderStatusWaiting  //请求正在等待
    , EGWProviderStatusSend     //处于asi请求中
    , EGWProviderStatusCacheSaving  //正在缓存中
    , EGWProviderStatusParse    //处于解析中
} EGWProviderStatus;

typedef enum : NSUInteger {
    EGWReadCacheErrorCodeUnknown = 0
    , EGWReadCacheErrorCodeCacheEmpty
    , EGWReadCacheErrorCodeCacheExpired
} EGWReadCacheErrorCode;

@protocol GWProviderDelegate;
@class GWErrorInterceptorHandler;

/**
 *  最基础的Provider，不包含任何业务参数
 */
@interface GWBaseProvider : GWObject

/**
 *  url请求里的interface
 */
@property (nonatomic, copy) NSString* interfaceName;

/**
 *  url地址
 */
@property (nonatomic, copy) NSString* urlString;

/**
 *  缓存url地址，防止动态ip获取后缓存对应的url变化造成缓存读取不对的问题
 */
@property (nonatomic, copy) NSString* cacheUrlString;

/**
 *  标识为Get还是Post请求，默认为Post
 */
@property (nonatomic, copy) NSString* httpMethod;

/**
 *  是否需要https，默认:NO 不需要
 */
@property (nonatomic, assign) BOOL needHttps;


@property (nonatomic, readonly) GWCacheInfo* cache;

/**
 *  请求返回响应的类型
 */
@property (nonatomic, assign) GWHTTPRequestResponseType responseType;

/**
 *  发送者，标识请求者是哪个obj
 */
@property (nonatomic, weak) id<GWProviderDelegate> sender;

/**
 *  是否需要默认等待对话框，默认NO不需要
 */
@property (nonatomic, assign) BOOL modelReq;

/**
 *  下载数据的回调
 */
@property (nonatomic, copy) DidReceiveHandler receiveHandler;

/**
 *  解析的block，此block默认再parseResponed:error里被调用，如不设置block，可以重载parseResponed:error进行解析
 */
@property (nonatomic, copy) ResponseHandler responseHandler;

/**
 *  消息请求结束后的回调block
 */
@property (nonatomic, copy) CompleteHandler completeHandler;

/**
 *  属性值替换，根据block返回的key替换为其value
 */
@property (nonatomic, copy) ReplacePropertyValue replacePropertyValue;

/**
 *  创建的请求operation，使用ASIHttpRequest则为ASIHTTPRequest或ASIFormDataRequest，使用AFNetWork则为AFJSONRequestOperation或AFHTTPRequestOperation等
 */
@property (nonatomic, weak) NSObject* operation;

@property (nonatomic, assign) EGWProviderPriority requestPriority;

/**
 *  设置默认错误，默认为空
 */
@property(nonatomic, strong) NSError* defaultNetworkError;

/**
 *  消息发送产生错误调用，返回YES则重发该消息，为NO则丢弃
 */
@property (nonatomic, copy) BOOL (^errorblock)(NSError* error);

/**
 *  消息重试次数
 */
@property (nonatomic, assign) NSUInteger resendTimes;

/**
 *  消息重试最大次数
 */
@property (nonatomic, assign) NSUInteger resendMaxTimes;

/**
 *  当前请求状态
 */
@property (atomic, assign) EGWProviderStatus sendStatus;

/**
 *  请求头
 */
@property (nonatomic, readonly) NSMutableDictionary* requestHeaders;

/**
 *  响应头
 */
@property (nonatomic, strong) NSDictionary* responseHeaders;

/**
 *  服务器时间
 */
@property (nonatomic, copy) NSDate* serverDate;

/**
 *  请求开始时间
 */
@property (nonatomic, assign) NSTimeInterval sendTime;

/**
 *  请求结束时间
 */
@property (nonatomic, assign) NSTimeInterval responseTime;

/**
 *  是否使用了缓存
 */
@property (nonatomic, readonly) BOOL isUsedCachedData;

@property (nonatomic, strong) GWProviderResultPackage* resultPackage;

/**
 *  是否需要同一个sender的provider(needRecord同时为YES)完成后获得通知(需要GWProviderDelegate实现providersDidSendFinish方法)
 */
@property (nonatomic, assign) BOOL needRecord;

/**
 *  超时时间，默认60s
 */
@property (assign) NSTimeInterval timeOutSeconds;

/**
 *  下载文件保存路径
 */
@property (nonatomic, copy) NSString* fileDownloadPath;

/**
 *  临时文件下载路径
 */
@property (nonatomic, copy) NSString* temporaryFileDownloadPath;

/**
 *  是否允许断点续传，默认YES
 */
@property (nonatomic, assign) BOOL allowResumeForFileDownloads;


/**
 *  判断sender是否被清除（用于sender没有发送cancel而被dealloc后野指针问题，类似ARC下的[@property (nonatomic, weak) id sender]）
 *
 *  @return YES：被清除，NO：未被清除
 */
- (BOOL)senderByDealloc;

- (id)initWithSender:(id<GWProviderDelegate>)sender;

/**
 *  判断provider是否空闲
 *
 *  @return YES:空闲，NO:不空闲
 */
- (BOOL)isIdle;

@end

@interface GWBaseProvider (Cache)

- (void)useCacheInfo:(BOOL)useCache;

- (void)useDownloadCache:(GWDownloadCache*)downloadCache
             cacheSecond:(NSTimeInterval)cacheSecond;

- (void)useDownloadCache:(GWDownloadCache*)downloadCache
             cacheSecond:(NSTimeInterval)cacheSecond
             cachePolicy:(EGWCachePolicy)cachePolicy;

/**
 *  异步读取缓存
 *
 *  @param completion <#completion description#>
 */
- (void)readLocalCacheWithCompletion:(ReadCacheCompletion)completion;

/**
 *  异步写入缓存
 *
 *  @param cacheObject <#cacheObject description#>
 *  @param completion  <#completion description#>
 */
- (void)saveLocalCache:(id<NSCoding>)cacheObject completion:(SaveCacheCompletion)completion;


/**
 *  从配置好的provider读取相应的缓存
 *
 *  @return 缓存对象
 */
- (id<NSCoding>)readLocalCache  __deprecated_msg("后期会逐渐删除，请使用readLocalCacheWithError");

/**
 *  从配置好的provider读取相应的缓存
 *
 *  @param error 读取时产生的错误(目前只有缓存过期才有提示)
 *
 *  @return 缓存对象
 */
- (id<NSCoding>)readLocalCacheWithError:(NSError**)error;

/**
 *  从配置好的provider中读取
 *
 *  @param cacheObject 需要存储的对象
 *
 *  @return YES：成功， NO：失败
 */
- (BOOL)saveLocalCache:(id<NSCoding>)cacheObject;

/**
 *  清除当前配置好的provider缓存
 */
- (void)clearLocalCache;

@end


@interface GWBaseProvider (MsgEncode)

/**
 *  请求即将开始处理前回调，做一些准备工作
 */
- (void)providerWillStart;

/**
 *  模型转字典
 *
 *  @return 转出的字典
 */
- (NSMutableDictionary*)dictionaryOfPropertyNameAsKeyAndValueAsParameter;

/**
 *  替换属性字典里的属性
 *
 *  @param propertyName 需要替换的属性
 *
 *  @return 新的属性
 */
- (NSString *)replacementForPropertyName:(NSString *)propertyName;

/**
 *  新属性对应的新值
 *
 *  @param value        新属性
 *  @param propertyName 旧值
 *
 *  @return 新值
 */
- (NSString *)replacementForPropertyValue:(NSString *)value propertyName:(NSString *)propertyName;

/**
 *  是否需要替换属性
 *
 *  @param propertyName 需要判断的属性
 *
 *  @return YES:需要; NO:不需要
 */
- (BOOL)shouldParameterableWithPropertyName:(NSString *)propertyName;

- (void)setPropertyNameAsNonparameterable:(NSString *)propertyName;
- (void)removePropertyNameAsNonparameterable:(NSString *)propertyName;
@end


@interface GWBaseProvider (MsgDecode)

/**
 *  响应头处理
 *
 *  @param header 响应头字典
 */
- (void)responseHeaders:(NSDictionary*)responseHeaders;

/**
 *  接收数据响应
 *
 *  @param bytes      接收部分大小
 *  @param totalBytes 总大小
 */
- (void)didReceiveBytes:(long long)bytes totalBytes:(long long)totalBytes;

/**
 *  请求转模型，对responseHandler进行一个封装
 *
 *  @param respond 请求data，需子类实现data转xml/json
 *  @param error   产生的错误，成功则为nil
 *
 *  @return 转化成的模型
 */
- (id)parseResponed:(id)respond error:(NSError**)error;


/**
 *  请求完成后被Manager调用，对completeblock进行一个封装
 *
 *  @param package 返回结果
 */
- (void)responedComplete:(GWProviderResultPackage*)package;

/**
 *  错误拦截（默认为空）
 *
 *  @param responseString 返回数据
 *  @param description    描述，目前为请求url
 *  @param errorHandler   错误拦截器
 *
 *  @return nil:无错误，非nil:相关错误信息
 */
- (NSError *)searchError:(NSString *)responseString description:(NSString*)description errorHandler:(GWErrorInterceptorHandler*)errorHandler;
@end

@interface GWBaseProvider (Sign)

/**
 *  签名
 *
 *  @param param 签名后参数所传入的字典
 */
- (void)signToParams:(NSMutableDictionary* )params;
@end

@interface GWBaseProvider (SendStatus)
/**
 *  provider是否正在请求中
 *
 *  @return YES:请求中， NO:空闲
 */
- (BOOL)isRunning;
@end


@interface GWBaseProvider(Send)

/**
 *  发起请求，需要设置provider.completeHandler() = ...和 provider.responseHandler() = ...
 */
- (void)request;

/**
 *  发起请求，需要设置 provider.responseHandler() = ...
 *
 *  @param completion 请求完成调用
 */
- (void)requestWithCompletionHandler:(CompleteHandler)completeHandler;

/**
 *  发起请求
 *
 *  @param responseHandler 解析时调用
 *  @param completion      请求完成调用
 */
- (void)requestWithResponseHandler:(ResponseHandler)responseHandler
                 completionHandler:(CompleteHandler)completeHandler;
@end

@interface GWBaseProvider(Cancal)
/**
 *  在队列中取消当前provider
 */
- (void)cancelProvider;
@end


@interface GWBaseProvider(AdditionalParameters)
- (void)setParameterWithKey:(NSString *)key value:(id)value;
- (void)setParametersFromDictionary:(NSDictionary *)dictionary;
- (void)removeParameterWithKey:(NSString *)key;
- (NSDictionary *)dictionaryOfAddedParameterAndValues;

/**
 *  该属性是否是url上传
 *
 *  @param property 属性名称string
 *
 *  @return YES:是 NO:否
 */
- (BOOL)isUploadFileUrlProperty:(NSString*)property;

/**
 *  设置属性为文件上传类型
 *
 *  @param property 属性名称string
 */
- (void)addUploadFileUrlProperty:(NSString*)property;

/**
 *  设置属性为非文件上传类型
 *
 *  @param property 属性名称string
 */
- (void)removeUploadFileUrlProperty:(NSString*)property;

/**
 *  属性对应的文件名
 *
 *  @param property 属性名称string
 *
 *  @return 文件名
 */
- (NSString*)fileNameWithFileProperty:(NSString*)property;
/**
 *  相关文件上传属性对应的contentType
 *
 *  @param property 属性名称string
 *
 *  @return contentType类型
 */
- (NSString*)contentTypeWithFileProperty:(NSString*)property;
@end

@interface GWBaseProvider(Additional)
/**
 *  参数选项配置项
 *
 *  @return <#return value description#>
 */
+ (id<GWAppConfigDelegate>)config;
/**
 *  请求话费时间
 *
 *  @return >0：话费时间， = 0：无法计算（请求未开始或未结束）
 */
- (NSTimeInterval)requestCostTime;
- (NSString*)thumbDescription;

- (void)logWithError:(NSError*)error;
@end
