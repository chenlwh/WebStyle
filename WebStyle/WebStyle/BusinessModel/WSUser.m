//
//  WSUser.m
//  WebStyle
//
//  Created by liudan on 9/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "WSUser.h"

#define Login_User_Key  @"login_User"

@implementation WSUser


+ (WSUser *)readLastUserInfo
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData * codedData = [userDefault objectForKey:Login_User_Key];
    WSUser *loginInfo = [NSKeyedUnarchiver unarchiveObjectWithData:codedData];
    
    return loginInfo;
}

+ (void)saveUserInfo:(WSUser *)userInfo
{
    if (userInfo)
    {
        NSData* currentData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        [userDefault setObject:currentData forKey:Login_User_Key];
        [userDefault synchronize];
    }
    else
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        [userDefault setObject:nil forKey:Login_User_Key];
        [userDefault synchronize];
    }
}
@end
