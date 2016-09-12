//
//  BasicViewController.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "BasicViewController.h"
#import "Constants.h"


@implementation BasicViewController

- (NSMutableDictionary*)controllerUserInfo
{
    if(!_controllerUserInfo)
    {
        _controllerUserInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    
    return _controllerUserInfo;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[Constants SDBackgroundColor]];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)setStatusBarLight
{
    [self setStatusBarBackgroundColor:AppMainColor];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}

-(void)setGradientColorBarLight:(UIColor*)color
{
    [self setStatusBarBackgroundColor:color];
    if([UIApplication sharedApplication].statusBarStyle !=UIStatusBarStyleLightContent)
    {
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    }
}
-(void)setStatusBarDefault
{
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
}

@end


NSString* kLoadingViewKey = @"MBProgressHUD";
@implementation BasicViewController (GWShowLoading)

- (UIView*)hudSuperView
{
    return self.view;
}

- (MBProgressHUD*)progressHUD
{
    MBProgressHUD* progressHUD = self.controllerUserInfo[kLoadingViewKey];
    if(!progressHUD)
    {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.hudSuperView];
        progressHUD.labelFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        progressHUD.labelText = @"加载中...";
        [self.hudSuperView addSubview:progressHUD];
        
        [self.controllerUserInfo setValue:progressHUD forKey:kLoadingViewKey];
    }
    [progressHUD.superview bringSubviewToFront:progressHUD];
    return progressHUD;
}

- (void)loadingViewWillShow:(UIView*)loadingView
{
    [self.hudSuperView bringSubviewToFront:loadingView];
}

- (void)startLoading
{
    [self startLoadingWithAnimated:YES];
}

- (void)startLoadingWithAnimated:(BOOL)animated
{
    [[self progressHUD] show:animated];
}

- (void)startLoadingWithMessage:(NSString*)message
                   withAnimated:(BOOL)animated
{
    [self progressHUD].labelText = message;
    [self startLoadingWithAnimated:animated];
}

- (void)stopLoading
{
    [self stopLoadingWithAnimated:YES];
}

- (void)stopLoadingWithAnimated:(BOOL)animated
{
    [[self progressHUD] hide:animated];
}

- (void)showProgressViewWithEnableClickBack
{
    [self progressHUD].isEnableClickBack = YES;
}

@end