//
//  LogingViewController.h
//  WebStyle
//
//  Created by liudan on 9/12/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "BasicViewController.h"
#import "GWLoginView.h"
#import "GWPasswordFindView.h"
#import "GWRegisterView.h"

@interface GWLogin : NSObject

+ (id)sharedInstance;
/**
 *  显示登录画面
 */
- (void)showLoginWithCancelHandler:(void(^)(BOOL success))loginCancelHandler
                LoginFinishHandler:(void(^)(BOOL success))loginFinishHandler;

- (void)showLoginWithCancelHandler:(void(^)(BOOL success))loginCancelHandler
                LoginFinishHandler:(void(^)(BOOL success))loginFinishHandler
                rootViewController:(UIViewController*)rootViewController;
@end


@interface LogingViewController : BasicViewController
@property (nonatomic, copy) void(^loginFinishHandler)(BOOL success);
@property (nonatomic, copy) void(^loginCancelHandler)(BOOL success);

@property (weak, nonatomic) GWLoginView *loginView;
@property (weak, nonatomic) GWPasswordFindView *passwordFindView;
@property (weak, nonatomic) GWRegisterView *registerView;
@end
