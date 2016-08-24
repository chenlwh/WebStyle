#ifndef GewaraCore_GWErrorDomain_h
#define GewaraCore_GWErrorDomain_h

#import <Foundation/Foundation.h>


//这个code对应 GWNetworkRequestErrorDomain
typedef enum _GWErrorCode {
    GWErrorCode_DataStructureError = -1,
    GWErrorCode_ServerTimeMismatch = 20,
    GWErrorCode_NeedCancelUnPaidOrder = 3100,//要去未支付的订单,5.2开始对于进入支付网关的订单必须先取消订单
    GWErrorCode_MobileNumError = 4004,//手机号有错误
    GWErrorCode_4005 = 4005,//跟3100一样
    GWErrorCode_NeedCodeVerify = 4998, // 新版弹出验证码安全认证
    GWErrorCode_NeedSecurityVerify = 4999,//需要用户安全认证
    GWErrorCode_MemberEncodeFailure = 5000,
    GWErrorCode_NeedBindPhone = 8100,//有些操作需要绑定手机号，提示去绑定
    GWErrorCode_NeedShowWebAuth = 9900,  //需要弹出网页鉴权，防止黄牛等情况
} GWErrorCode;


//这个code对应GWHTTPRequestErrorDomain
typedef enum : NSUInteger {
    GWConnectionFailureErrorType = 1,
    GWRequestTimedOutErrorType = 2,  //超时
    GWAuthenticationErrorType = 3,
    GWRequestCancelledErrorType = 4,    //用户取消请求
    GWUnableToCreateRequestErrorType = 5,
    GWInternalErrorWhileBuildingRequestType  = 6,
    GWInternalErrorWhileApplyingCredentialsType  = 7,
    GWFileManagementError = 8,
    GWTooMuchRedirectionErrorType = 9,
    GWUnhandledExceptionError = 10,
    GWCompressionError = 11
} GWNetworkErrorType;


/**
 *  错误URL的key, 在error 的userinfo里面
 */
OBJC_EXPORT NSString *const GWErrorRequestURLKey;
OBJC_EXPORT NSString *const GWErrorRequestResponeKey;   //附带的错误信息，目前只有9900错误带jumpUrl

#pragma mark - 下面的是error的类型

/**
 *  统一的网络错误， error+code，服务器端返回的(http200成功，但数据返回格式异常)
 */
OBJC_EXPORT NSString* const GWNetworkRequestErrorDomain;

/**
 *  服务器错误（非http 200, 取代NetworkRequestErrorDomain， 为GWNetworkErrorType(code = 1-11)＋http状态码（code = 100+））
 */
OBJC_EXPORT NSString* const GWHTTPRequestErrorDomain;


/**
 *  这个是用户自定定义的一般error,一般code都一样，描述不同而已
 */
OBJC_EXPORT NSString* const GWRNormalErrorDomain;


//关于支付的错误类型
OBJC_EXPORT NSString* const GWPayDomain;




#endif
