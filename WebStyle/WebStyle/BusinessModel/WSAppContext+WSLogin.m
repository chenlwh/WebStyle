//
//  WSAppContext+WSLogin.m
//  WebStyle
//
//  Created by liudan on 9/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "WSAppContext+WSLogin.h"
#import "MsgDefine.h"

@implementation WSAppContext (WSLogin)

- (void)logout
{
    self.wsUserInfo = nil;
}

- (BOOL)isLoging
{
    return self.wsUserInfo != nil;
}

#pragma mark login request

- (void)autoLogin
{
    D_Log(@"%@ %@", self, NSStringFromSelector(_cmd));
}
@end
