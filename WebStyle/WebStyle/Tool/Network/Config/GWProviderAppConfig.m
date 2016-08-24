//
//  GWProviderAppConfig.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-21.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWProviderAppConfig.h"

static GWProviderAppConfig* appConfig = nil;
@implementation GWProviderAppConfig

#define __delegate (self.delegate)

#define DELEGATE_ACCESSOR(accessor, ctype) \
- (ctype)accessor { \
return [__delegate accessor]; \
}

DELEGATE_ACCESSOR(memberEncode, NSString*)
DELEGATE_ACCESSOR(timeChaIntervalWithServer, NSTimeInterval)
DELEGATE_ACCESSOR(appType, NSString*)
DELEGATE_ACCESSOR(osType, NSString*)
DELEGATE_ACCESSOR(appVersion, NSString*)
DELEGATE_ACCESSOR(appSource, NSString*)
DELEGATE_ACCESSOR(key, NSString*)
DELEGATE_ACCESSOR(privateKey, NSString*)
DELEGATE_ACCESSOR(restfulBaseURLString, NSString*)
DELEGATE_ACCESSOR(pointx, NSString*)
DELEGATE_ACCESSOR(pointy, NSString*)
DELEGATE_ACCESSOR(mnet, NSString*)
DELEGATE_ACCESSOR(citycode, NSString*)
DELEGATE_ACCESSOR(cityname, NSString*)
DELEGATE_ACCESSOR(idfa, NSString*)
DELEGATE_ACCESSOR(deviceid, NSString*)

+ (GWProviderAppConfig*)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!appConfig)
            appConfig = [[GWProviderAppConfig alloc] init];
    });
    return appConfig;
}

- (GWDynamicIPInfo *)dynamicIpInfoWithMethod:(NSString*)method
{
    if([self.delegate respondsToSelector:@selector(dynamicIpInfoWithMethod:)])
    {
        GWDynamicIPInfo* info = [self.delegate dynamicIpInfoWithMethod:method];
        if(info)
        {
            return info;
        }
    }
    GWDynamicIPInfo* info = [[GWDynamicIPInfo alloc] init];
    info.ip = [self.delegate restfulBaseURLString];
    return info;
}

- (NSString*)uuid
{
    if([self.delegate respondsToSelector:@selector(uuid)])
    {
        return [self.delegate uuid];
    }
    
    return nil;
}

- (NSDictionary*)httpHeaderAddition
{
    if([self.delegate respondsToSelector:@selector(httpHeaderAddition)])
    {
        return [self.delegate httpHeaderAddition];
    }
    
    return nil;
}


- (NSMutableDictionary*)normalParmDictionary
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:[self memberEncode] forKey:@"memberEncode"];
    [dic setValue:[self appType] forKey:@"appType"];
    [dic setValue:[self osType] forKey:@"osType"];
    [dic setValue:[self appVersion] forKey:@"appVersion"];
    [dic setValue:[self appSource] forKey:@"appSource"];
    [dic setValue:[self key] forKey:@"key"];
    [dic setValue:[self pointx] forKey:@"pointx"];
    [dic setValue:[self pointy] forKey:@"pointy"];
    [dic setValue:[self mnet] forKey:@"mnet"];
    [dic setValue:[self citycode] forKey:@"citycode"];
    [dic setValue:[self cityname] forKey:@"cityname"];
    [dic setValue:[self idfa] forKey:@"idfa"];
    [dic setValue:[self deviceid] forKey:@"deviceid"];
    [dic setValue:[self uuid] forKey:@"uuid"];
    [dic setValue:[self securityCode] forKey:@"securityCode"];
    return dic;
}

- (NSDictionary*)normalParmDictionaryWithKey:(NSString*)key
{
    NSString * localKey = key;
    if ([key isEqualToString:@"appKey"]) {
        localKey = @"key";
    }
    
    SEL getSel = NSSelectorFromString(localKey);
    
    if ([self.delegate respondsToSelector:getSel]) {
         NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[self.delegate performSelector:getSel],key,nil];
        return dic;
    }
    
    return nil;
}

- (NSString*)securityCode
{
    if([self.delegate respondsToSelector:@selector(securityCode)])
    {
        return [self.delegate securityCode];
    }
    
    return nil;
}

@end
