//
//  GWBaseInfoProvider.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWBaseInfoProvider.h"
#import "GWProviderAppConfig.h"
#import "NSDate+Gewara.h"
#import "GWErrorDomain.h"
#import "TBXML.h"
#import "GWErrorInterceptorHandler.h"
#import "NSError+GWRError.h"
#import "NSDate+Gewara.h"
//#import "GWMsgdefine.h"

NSString *const GWFormatXML = @"xml";
NSString *const GWFormatJASON = @"json";

NSString *const GWFlag0 = @"0";
NSString *const GWFlag1 = @"1";


@interface GWBaseInfoProvider()
/**
 *  过滤字段数组
 */
@property(nonatomic, retain) NSMutableArray *fields;
@end

@implementation GWBaseInfoProvider

+ (NSString*)timeStampForServer
{
    NSTimeInterval interval = [[[self class] config] timeChaIntervalWithServer];
    
    NSDate* nowDate = [[NSDate BeijingTime] dateByAddingTimeInterval:interval];
    NSCalendar* calendar = [NSDate defaultCalendar];
    NSDateComponents *components = nil;
    @synchronized(calendar)
    {
        components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                 fromDate:nowDate];
    }
    
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger hour = components.hour;
    NSInteger minute = components.minute;
    NSInteger second = components.second;
    
    NSMutableString* timestampStr = [[NSMutableString alloc] init];
    [timestampStr appendFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:%02ld", (long)year,(long)month,(long)day,(long)hour,(long)minute,(long)second];
    return timestampStr;
}



- (id)init
{
    if(self = [super init])
    {
        self.method = @"";

        self.mobileType = [[UIDevice currentDevice] model];
        self.osVersion = [[UIDevice currentDevice] systemVersion];
        self.format = GWFormatJASON;
        self.v = @"1.0";
        
        self.needMemberEncode = NO;
        
        self.fields = [NSMutableArray array];
        
        [self setPropertyNameAsNonparameterable:@"fields"];
        [self setPropertyNameAsNonparameterable:@"needMemberEncode"];
        
        [self doInit];
        
        [self setErrorblock:^BOOL(NSError *error) {
            //如果是时间差问题允许重发该请求
            return (GWErrorCode_ServerTimeMismatch == error.code);
        }];
        
//        self.defaultNetworkError = [NSError errorWithDomain:NSStringFromClass(self.class)
//                                                       code:-1
//                                                   userInfo:[NSDictionary dictionaryWithObject:@"网络连接错误"
//                                                                                        forKey:NSLocalizedDescriptionKey]];
    }
    
    return self;
}

-(NSString*)requestMethod
{
    return self.method;
}

- (void)resetUrlWithDynamicIPInfo:(GWDynamicIPInfo*)info
                           config:(id<GWAppConfigDelegate>)config
{
    self.urlString = info.ip;
    self.cacheUrlString = [config restfulBaseURLString];
}

- (void)doInit
{
    id<GWAppConfigDelegate> config = [[self class] config];
    
    NSString* menberEncode = [config memberEncode];
    self.memberEncode = [menberEncode length] > 0 ? menberEncode : nil;
    
//    GWDynamicIPInfo* info = [config dynamicIpInfoWithMethod:self.method];
//    [self resetUrlWithDynamicIPInfo:info config:config];
//    
//    if(![self.urlString isEqualToString:self.cacheUrlString])
//    {
//        [self.requestHeaders setValue:info.domain forKey:@"Host"];
//    }
    
    if([config respondsToSelector:@selector(httpHeaderAddition)])
    {
        [self initRequestHeadersWithAddition:[config httpHeaderAddition]];
    }
    
    self.apptype = [config appType];
    self.appSource = [config appSource];
    self.osType = [config osType];
    self.appVersion = [config appVersion];
    
    self.idfa = [config idfa];
    self.deviceid = [config deviceid];
    
    self.mnet = [config mnet];
    self.appkey = [config key];
    
    self.pointy = [config pointy];
    self.pointx = [config pointx];
    self.citycode = [config citycode];
    
    self.cityname = [config cityname];
    self.timestamp = [[self class] timeStampForServer];
    self.securityCode = [config securityCode];
}

- (void)initRequestHeadersWithAddition:(NSDictionary*)addition
{
    for(NSString* key in [addition allKeys])
    {
        [self.requestHeaders setValue:addition[key] forKey:key];
    }
}

- (void)setNeedMemberEncode:(BOOL)needMemberEncode
{
    _needMemberEncode = needMemberEncode;
    [self removePropertyNameAsNonparameterable:@"memberEncode"];
    
    if(!_needMemberEncode)
    {
        [self setPropertyNameAsNonparameterable:@"memberEncode"];
    }
}


- (void)addReturnFields:(NSString *)fields, ...
{
    va_list params;
    va_start(params, fields);
    for(id item = fields; item != nil; item = va_arg(params, id))
    {
        NSString *tmpField = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([tmpField length] && [_fields indexOfObject:tmpField] == NSNotFound)
        {
            [_fields addObject:tmpField];
        }
    }
    va_end(params);
}

- (void)removeReturnField:(NSString *)field
{
    [_fields removeObject:field];
}

- (void)removeAllReturnField
{
    [_fields removeAllObjects];
}

- (void)providerWillStart
{
    [super providerWillStart];
    
    [self doInit];
    
    if([self.fields count])
    {
        NSString *fields = [self.fields componentsJoinedByString:@","];
        [self setParameterWithKey:@"fields" value:fields];
    }
    else
    {
        [self removeParameterWithKey:@"fields"];
    }
    

    
//    if (!self.cache.isUseCache) {
//        self.httpMethod = HttpMethodPost;
//    }
    
    //这个因为除了线上环境以外，其他的服务器都没有https的
//    if(![self.cacheUrlString hasPrefix:GWAPIReleaseURLString])
//    {
//        self.needHttps = NO;
//    }
}

- (NSError *)searchError:(NSString *)responseString description:(NSString*)description errorHandler:(GWErrorInterceptorHandler*)errorHandler
{
    return [errorHandler searchError:responseString
                         description:description
                              format:self.format];
}


- (NSString*)thumbDescription
{
    return NSStringFromClass([self class]);
}

@end