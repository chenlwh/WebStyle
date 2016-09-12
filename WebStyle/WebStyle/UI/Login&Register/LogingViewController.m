//
//  LogingViewController.m
//  WebStyle
//
//  Created by liudan on 9/12/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "LogingViewController.h"
#import "GWDoubleFadeView.h"

#define topHeight self.view.height*3/5 > 288 ? self.view.height*2/5 : self.view.height/4+50;

#define textlineColor RGBACOLORFromRGBHex(0x5f5f5f)

@implementation GWLogin

+ (id)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}


/**
 *  显示登录画面
 */
- (void)showLoginWithCancelHandler:(void(^)(BOOL success))loginCancelHandler
                LoginFinishHandler:(void(^)(BOOL success))loginFinishHandler
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [self showLoginWithCancelHandler:loginCancelHandler
                  LoginFinishHandler:loginFinishHandler
                  rootViewController:keyWindow.rootViewController];
}

- (void)showLoginWithCancelHandler:(void(^)(BOOL success))loginCancelHandler
                LoginFinishHandler:(void(^)(BOOL success))loginFinishHandler
                rootViewController:(UIViewController*)aRootViewController;
{
    LogingViewController *loginViewController = [[LogingViewController alloc] init];
    
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    UIViewController* presentViewController = [aRootViewController vaildPresentedViewController];
    
    [presentViewController presentViewController:rootViewController animated:YES completion:nil];
    
//    [loginViewController setLoginCancelHandler:^(BOOL success){
//        if (success) {
//        }
//        
//        if (loginCancelHandler) {
//            loginCancelHandler(success);
//        }
//    }];
//    
//    [loginViewController setLoginFinishHandler:^(BOOL success) {
//        if (loginFinishHandler) {
//            loginFinishHandler(success);
//        }
//    }];
}


@end



@interface LogingViewController ()

@end

@implementation LogingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    GWLoginInfo *loginInfo = [GWMovieComUtils readGWLoginInfo];
//    if (loginInfo) {
//        self.loginView.nameField.text = loginInfo.username;
//        self.loginView.passwordField.text = loginInfo.password;
//    }
    GWDoubleFadeView *backView = [[GWDoubleFadeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backView];
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(resignALL) forControlEvents:UIControlEventTouchUpInside];
    [control setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:control];
}

-(CGFloat)getTopHeight
{
    CGFloat top = topHeight;
    if (IS_IPHONE_3P5_INCH) {
        top = top - 45;
    }else if (IS_IPHONE_4_INCH) {
        top = top - 20;
    }
    return top;
}

-(void)resignALL
{
//    [self.loginView resignALL];
//    [self.passwordFindView resignALL];
//    [self.registerView resignALL];
}

@end
