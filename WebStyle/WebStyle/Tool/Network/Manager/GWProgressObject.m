//
//  GWProgressObject.m
//  GewaraCore
//
//  Created by wushengtao on 15/2/12.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "GWProgressObject.h"
#import "MBProgressHUD.h"
#import "Msgdefine.h"

@interface GWProgressObject()
{
    MBProgressHUD* _progressHUD;
}

@end

@implementation GWProgressObject


#pragma mark  progress hud create/remove

- (void)removeProgressView
{
    [_progressHUD hide:YES];
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;
    
}

- (void)createProgressView
{
    [self removeProgressView];
    
    //这里为了能使App extension也能使用所以这里只能这么写，使用到了一些runtime
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
    BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
    
    if (hasApplication) {
        UIWindow* keyView = [app keyWindow];
        _progressHUD = [[MBProgressHUD alloc] initWithView:keyView];
        _progressHUD.labelFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        _progressHUD.labelText = @"加载中...";
        [keyView addSubview:_progressHUD];
    }
  
 
    
    [_progressHUD show:YES];

}
@end
