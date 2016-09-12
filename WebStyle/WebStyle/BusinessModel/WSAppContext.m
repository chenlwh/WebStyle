//
//  WSAppContext.m
//  WebStyle
//
//  Created by liudan on 9/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "WSAppContext.h"
#import "NSString+WSUpload.h"
#import "SSKeychain.h"

NSString* const WSKeychainServiceKey = @"com.webstyle.public";

NSString* const kAppKeyChainUUIDKey = @"uuid";

@implementation WSAppContext
+ (instancetype)appContext
{
    static WSAppContext* appContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appContext = [[WSAppContext alloc] init];
    });
    return appContext;
}

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString*)createAppUUID
{
    return [NSString uuidNameWithMD5:NO];
}

+ (NSString*)appUUID
{
    NSString* uuidStr = [SSKeychain passwordForService:WSKeychainServiceKey
                                               account:kAppKeyChainUUIDKey];
    if(!uuidStr)
    {
        uuidStr = [[self class] createAppUUID];
        [SSKeychain setPassword:uuidStr
                     forService:WSKeychainServiceKey
                        account:kAppKeyChainUUIDKey];
    }
    else
    {
        //        D_Log(@"uuid:%@===============================", uuidStr);
    }
    
    return uuidStr;
}

@end
