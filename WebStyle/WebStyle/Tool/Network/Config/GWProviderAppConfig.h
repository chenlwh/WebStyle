//
//  GWProviderAppConfig.h
//  GewaraCore
//
//  Created by wushengtao on 14-5-21.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWDynamicIPInfo.h"

@protocol GWAppConfigDelegate <NSObject>

@required

//用户拿到的访问参数，类似于token
- (NSString *)memberEncode;

//为了保证API接口正常访问，矫正时间用的，用来防止攻击（常用于客户端时间设置错误的情况）
- (NSTimeInterval)timeChaIntervalWithServer;

//应用类型
- (NSString *)appType;


- (NSString *)appVersion;
- (NSString *)appSource;

//设备型号
- (NSString *)osType;


//api 的key
- (NSString *)key;
- (NSString *)privateKey;

//api Url
- (NSString *)restfulBaseURLString;

//5.x以后为了数据挖掘，需要默认带的一些参数
- (NSString *)pointx;
- (NSString *)pointy;
- (NSString *)mnet;
- (NSString *)citycode;
- (NSString *)cityname;

//
- (NSString *)idfa;
- (NSString *)deviceid;

@optional
//v6.2.1开始使用
- (GWDynamicIPInfo *)dynamicIpInfoWithMethod:(NSString*)method;

- (NSString*)uuid;

/**
 *  http头附加参数
 *
 *  @return <#return value description#>
 */
- (NSDictionary*)httpHeaderAddition;

//验证码 V6.6开始
- (NSString*)securityCode;
@end

@interface GWProviderAppConfig : NSObject<GWAppConfigDelegate>

@property (nonatomic, assign) id<GWAppConfigDelegate> delegate;

+ (GWProviderAppConfig*)instance;

/**
 *  基础信息字典
 *
 *  @return <#return value description#>
 */
- (NSMutableDictionary*)normalParmDictionary;

/**
 *  根据属性名获取属性
 *
 *  @param key 属性名
 *
 *  @return 属性名对应字典
 */
- (NSDictionary*)normalParmDictionaryWithKey:(NSString*)key;
@end
