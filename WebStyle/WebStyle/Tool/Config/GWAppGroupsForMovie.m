//
//  GWAppGroupsForMovie.m
//  GewaraCore
//
//  Created by yangxueya on 9/22/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GWAppGroupsForMovie.h"
//#import "GWCommkit.h"
//#import "GWUser.h"
#import "Msgdefine.h"



NSString* const GWUserCacheUserKey = @"GWUserCacheUserKey";
NSString* const GWWidgetMovieListKey = @"GWWidgetMovieListKey";


//内部用
NSString* const GWUserCacheWidgetUserKey = @"GWUserCacheWidgetUserKey";



static NSString *suiteNameForMovie = @"group.ios8";

@implementation GWAppGroupsForMovie
#pragma mark - user
/**
 *  关于登陆用户的信息，一旦登陆成功就需要更新
 */


+(void)setDefaultAppGroupWithSuiteName:(NSString*)suiteName
{
    suiteNameForMovie= nil;
    suiteNameForMovie = [suiteName copy];
}

+ (NSUserDefaults*)shareMovieAppGroupUserDefaults;//默认userdefault
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        static NSUserDefaults* userDefault = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if(!userDefault){
                userDefault = [[NSUserDefaults alloc] initWithSuiteName:suiteNameForMovie];
            }
        });
        return userDefault;
    }else{
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        return userDefault;
    }
}

+ (NSUserDefaults*)loginUserUserDefaults
{
    return [GWAppGroupsForMovie shareMovieAppGroupUserDefaults];
}

+ (GWUser*)readLastLoginUser
{
    NSUserDefaults *userDefault = [GWAppGroupsForMovie loginUserUserDefaults];
    
    NSData *data = [userDefault objectForKey:GWUserCacheUserKey];
    GWUser *gwUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return gwUser;
}
+ (void)saveLastLoginUser:(GWUser*)user
{
    NSData* currentData = [NSKeyedArchiver archivedDataWithRootObject:user];
    NSUserDefaults *userDefault = [GWAppGroupsForMovie loginUserUserDefaults];
    
    [userDefault setObject:currentData forKey:GWUserCacheUserKey];
    [userDefault synchronize];
    
}

+ (void)saveWidgetUser:(GWWidgetUser*)widgetUser
{
    NSData* currentData = [NSKeyedArchiver archivedDataWithRootObject:widgetUser];
    NSUserDefaults *userDefault = [GWAppGroupsForMovie loginUserUserDefaults];
    
    [userDefault setObject:currentData forKey:GWUserCacheWidgetUserKey];
    [userDefault synchronize];
    
}

+ (GWWidgetUser*)readWidgetUser
{
 
    NSUserDefaults *userDefault = [GWAppGroupsForMovie loginUserUserDefaults];
    
    NSData *data = [userDefault objectForKey:GWUserCacheWidgetUserKey];
   
    GWWidgetUser *gwUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return gwUser;
}


+ (NSUserDefaults*)appConfigUserDefaults
{
    return [GWAppGroupsForMovie shareMovieAppGroupUserDefaults];
}

+ (NSURL*)shareCachePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* containerURL = nil;
    if([fileManager respondsToSelector:@selector(containerURLForSecurityApplicationGroupIdentifier:)])
    {
        containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:suiteNameForMovie];
        containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/"]];
    }
    else
    {
        NSArray *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        containerURL = [NSURL fileURLWithPath:[cachePath firstObject]];
    }
    
//    MSGLOG(@"shareCachePath: %@", containerURL.absoluteString);
    return containerURL;
}

@end
