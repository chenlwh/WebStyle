//
//  BasicViewController.h
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTUtils.h"
#import "MJRefresh.h"
#import "UIView+Gewara.h"
#import "MsgDefine.h"
#import "UIViewController+GWFindSubController.h"
#import "MBProgressHUD.h"
#import "WSNotificationList.h"

@interface BasicViewController : UIViewController

@property (nonatomic,strong) UIColor *navBarColor;
@property(nonatomic,strong) NSMutableDictionary* controllerUserInfo;

- (void)setStatusBarBackgroundColor:(UIColor *)color;
-(void)setStatusBarLight;

-(void)setGradientColorBarLight:(UIColor*)color;

-(void)setStatusBarDefault;
@end


@interface BasicViewController (GWShowLoading)
- (void)loadingViewWillShow:(UIView*)loadingView;
- (void)startLoading;
- (void)startLoadingWithAnimated:(BOOL)animated;
- (void)startLoadingWithMessage:(NSString*)message
                   withAnimated:(BOOL)animated;
- (void)stopLoading;
- (void)stopLoadingWithAnimated:(BOOL)animated;
- (void)showProgressViewWithEnableClickBack; // 设置等待背景可以点击

// hud的父视图窗口
- (UIView*)hudSuperView;

- (MBProgressHUD*)progressHUD;

@end