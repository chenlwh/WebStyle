//
//  BasicViewController+Login.m
//  WebStyle
//
//  Created by 刘丹 on 16/9/15.
//  Copyright © 2016年 liudan. All rights reserved.
//

#import "BasicViewController+Login.h"

@implementation BasicViewController (Login)
-(void)loginSucessedWithUserInfo:(WSLoginInfo*)loginInfo
{
    WSUser *user = [WSUser new];
    user.nickname = loginInfo.username;
    user.passwd = loginInfo.password;
    
    [WSAppContext appContext].wsUserInfo = user;
    
    [WSAppContext  saveLastLoginInfo:loginInfo];
    /*
    [[NSNotificationCenter defaultCenter] postNotificationName:WSMovieLoginDidSuccessNotification object:nil];
    
    NSArray *viewControlls = self.navigationController.viewControllers;
    if (viewControlls.count == 1 && ([viewControlls indexOfObject:self] != NSNotFound)) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.loginFinishHandler) {
                self.loginFinishHandler(YES);
            }
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        if (self.loginFinishHandler) {
            self.loginFinishHandler(YES);
        }
    }
     */
}
@end
