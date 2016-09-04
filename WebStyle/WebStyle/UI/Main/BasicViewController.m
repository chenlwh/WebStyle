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
