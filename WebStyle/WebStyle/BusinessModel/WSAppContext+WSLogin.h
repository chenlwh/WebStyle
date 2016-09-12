//
//  WSAppContext+WSLogin.h
//  WebStyle
//
//  Created by liudan on 9/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "WSAppContext.h"

@interface WSAppContext (WSLogin)

/**
 *  自动登陆操作
 */
- (void)autoLogin;


/**
 *  注销登陆
 */
- (void)logout;

/**
 *  判断是否登陆
 *
 *  @return 已经登陆 YES 没有登陆 NO
 */
- (BOOL)isLoging;

@end
