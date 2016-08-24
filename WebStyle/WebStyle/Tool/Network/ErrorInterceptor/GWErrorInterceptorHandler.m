//
//  GWErrorInterceptorHandler.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWErrorInterceptorHandler.h"
#import "GWErrorInterceptor.h"
#import "GWBaseInfoProvider.h"
#import "GWProviderAppConfig.h"
#import "Msgdefine.h"

@implementation GWErrorInterceptorHandler


- (id)init
{
    if(self = [super init])
    {
        _errorInterceptors = [[NSMutableArray alloc] initWithObjects:
                              [[GWCommonErrorInterceptor alloc] init],
                              [[GWCommonError2Interceptor alloc] init],
                              [[GWDataStructureValidateErrorInterceptor alloc] init],
                              nil];

        //这里不处理添加，外部根据项目添加需要的对象
//        if([[[GWProviderAppConfig instance] appType] isEqualToString:GWAppTypeMovie]
//           ||[[[GWProviderAppConfig instance] appType] isEqualToString:GWAppTypeCinemaMerchant])
//        {
//            [_errorInterceptors addObject:[[[GWCommonJsonError2Interceptor alloc] init] autorelease]];
//        }
//        else if ([[[GWProviderAppConfig instance] appType] isEqualToString:GWAppTypeSport])
//        {
//            [_errorInterceptors addObject:[[[GWJsonForSportsErrorInterceptor alloc] init] autorelease]];
//        }
    }
    
    return self;
}


- (NSError *)searchError:(NSString *)responseString
             description:(NSString*)description
                  format:(NSString*)format
{
    NSError *error = nil;
    
    for(GWErrorInterceptor* interceptor in _errorInterceptors)
    {
        error = [interceptor findError:responseString
                           description:description
                                format:format];
        if(error)
            break;
    }
    
    return error;
}
@end
