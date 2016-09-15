//
//  WSAppContext+WSLogin.m
//  WebStyle
//
//  Created by liudan on 9/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "WSAppContext+WSLogin.h"
#import "MsgDefine.h"
#import "WSLoginInfo.h"
#import "UrlDefine.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "BasicViewController+Login.h"

@implementation WSAppContext (WSLogin)

- (void)logout
{
   
    self.wsUserInfo = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WSMovieLogoutDidSuccessNotification
                                                        object:self.wsUserInfo];
}

- (BOOL)isLoging
{
    return self.wsUserInfo != nil;
}

#pragma mark login request

- (void)autoLogin
{
    D_Log(@"%@ %@", self, NSStringFromSelector(_cmd));
    WSLoginInfo *loginInfo = [WSAppContext readLastLoginInfo];
    if(loginInfo)
    {
        if(loginInfo.password.length > 0 && loginInfo.username.length > 0)
        {
            NSString * urlString = [NSString stringWithFormat:@"%@name=%@&pwd=%@", kLoginMethod, loginInfo.username, loginInfo.password];
            urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            D_Log(@"______%@",urlString);
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [weakself stopLoading];
                D_Log(@"%@", operation.responseString);
                NSDictionary *dict = [operation.responseString objectFromJSONString];
                if([dict[@"code"] isEqualToString:@"02"])
                {
                    //注册成功；
                    D_Log(@"登录成功");
                    WSUser *user = [WSUser new];
                    user.nickname = loginInfo.username;
                    user.passwd = loginInfo.password;
                    
                    [WSAppContext appContext].wsUserInfo = user;
                    
                    [WSAppContext  saveLastLoginInfo:loginInfo];
                }
                else if ([dict[@"code"] isEqualToString:@"01"])
                {
//                    [weakself showAutoHideToastWithString:@"用户名已经存在"];
                }
                else if ([dict[@"code"] isEqualToString:@"03"])
                {
//                    [weakself showAutoHideToastWithString:@"用户名不能为空"];
                }
                else if ([dict[@"code"] isEqualToString:@"04"])
                {
//                    [weakself showAutoHideToastWithString:@"密码不能为空"];
                }
                else
                {
//                    [weakself showAutoHideToastWithString:@"其他未知错误"];
                }
                //*/
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                D_Log(@"请求失败");
            }];
        }
    }
}
@end
