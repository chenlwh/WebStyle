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
#import "FTUtils.h"
#import "MsgDefine.h"
NSString* const WSKeychainServiceKey = @"com.webstyle.public";

NSString* const kAppKeyChainUUIDKey = @"uuid";

NSString* const kLastWSLoginInfo = @"kLastWSLoginInfo";




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
-(id) init
{
    if(self = [super init])
    {
//        _wsUserInfo = [WSUser new];
    }
    return self;
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

- (void)handleLoginSuccessWithObject:(id)result userInfo:(NSDictionary*)userInfo
{
    
}

+(void)saveLastLoginInfo:(WSLoginInfo*)loginInfo
{
    if (loginInfo) {
        
        NSString* cacheFile = nil;
        cacheFile = FTPathForFileInDocumentsDirectory(kLastWSLoginInfo);
        BOOL result = [NSKeyedArchiver archiveRootObject:loginInfo
                                                  toFile:cacheFile];
        if (!result) {
            D_Log(@"%@", @"writeCache failed");
        }
        
        
        
    }else {
        D_Log(@"write nil log info");
    }

}

+ (WSLoginInfo *)readLastLoginInfo
{
    NSString *cacheFile = FTPathForFileInDocumentsDirectory(kLastWSLoginInfo);
    if(cacheFile.length > 0)
    {
        WSLoginInfo* cache = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheFile];
        return cache;
    }
    return nil;
}
@end
