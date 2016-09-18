//
//  BasicViewController+Login.h
//  WebStyle
//
//  Created by 刘丹 on 16/9/15.
//  Copyright © 2016年 liudan. All rights reserved.
//

#import "BasicViewController.h"
#import "WSLoginInfo.h"
#import "WSUser.h"
#import "WSAppContext.h"
//#import "LogingViewController.h"

@interface BasicViewController (Login)
-(void)loginSucessedWithUserInfo:(WSLoginInfo*)loginInfo;
@end
