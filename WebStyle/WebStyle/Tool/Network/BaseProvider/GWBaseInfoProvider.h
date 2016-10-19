//
//  GWBaseInfoProvider.h
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWBaseProvider.h"
//#import "GWConstants.h"
#import <UIKit/UIKit.h>
#import "GWSimpleLocalCache.h"

extern NSString *const GWFormatXML;
extern NSString *const GWFormatJASON;

//参数传0，1时
extern NSString *const GWFlag0;
extern NSString *const GWFlag1;


/**
 *  格瓦拉基础Provider
 */
@interface GWBaseInfoProvider : GWBaseProvider
/**
 * url请求里的method
 */
@property (nonatomic, copy) NSString* method;

/**
 *  是否需要memberencode
 */
@property (nonatomic, assign) BOOL needMemberEncode;

/**
 *  MemberEncode
 */
@property (nonatomic, copy) NSString* memberEncode;

/**
 * 接入应用名称
 */
@property (nonatomic, copy) NSString* apptype;

@property (nonatomic, copy) NSString* appSource;

/**
 * 手机类型
 */
@property (nonatomic, copy) NSString* mobileType;

/**
 * 时间戳
 */
@property (nonatomic, copy) NSString* timestamp;

/**
 * 加密方式
 */
//@property (nonatomic, copy) NSString* signmethod;

/**
 * 终端类型
 */
@property (nonatomic, copy) NSString* osType;

/**
 * app版本号
 */
@property (nonatomic, copy) NSString* appVersion;

/**
 * iOS版本号
 */
@property (nonatomic, copy) NSString* osVersion;

/**
 * 联网方式 wifi等
 */
@property (nonatomic, copy) NSString* mnet;

/**
 * 签名
 */
//@property (nonatomic, copy) NSString* sign;

/**
 * appkey iphonepk2009
 */
@property (nonatomic, copy) NSString* appkey;

/**
 * 数据返回格式 xml/json
 */
@property (nonatomic, copy) NSString* format;

/**
 * =1.0
 */
@property (nonatomic, copy) NSString* v;

/**
 * 经度
 */
@property (nonatomic, copy) NSString* pointx;

/**
 * 纬度
 */
@property (nonatomic, copy) NSString* pointy;

/**
 * 城市代码
 */
@property (nonatomic, copy) NSString* citycode;

/**
 * 城市名称
 */
@property (nonatomic, copy) NSString* cityname;

/**
 * idfa
 */
@property (nonatomic, copy) NSString* idfa;
/**
 *  用户认证码
 */
@property (nonatomic, copy) NSString* securityCode;
/**
 *  deviceid
 */
@property (nonatomic, copy) NSString* deviceid;

- (void)addReturnFields:(NSString *)fields, ...;
- (void)removeReturnField:(NSString *)field;
- (void)removeAllReturnField;

- (void)doInit;
- (void)resetUrlWithDynamicIPInfo:(GWDynamicIPInfo*)info
                           config:(id<GWAppConfigDelegate>)config;

/**
 *  获取服务器时间
 */
+ (NSString*)timeStampForServer;
@end

