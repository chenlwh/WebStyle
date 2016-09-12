//
//  UIViewController+GWFindSubController.m
//  GWMovie
//
//  Created by wushengtao on 15/10/26.
//  Copyright © 2015年 gewara. All rights reserved.
//

#import "UIViewController+GWFindSubController.h"

@implementation UIViewController (GWFindSubController)
- (UIViewController*)vaildPresentedViewController
{
    UIViewController* presentedViewController = self;
    while (presentedViewController.presentedViewController)
    {
        presentedViewController = presentedViewController.presentedViewController;
    }
    
    return presentedViewController;
}

- (UIViewController*)vaildPresentingViewController
{
    
    UIViewController* presentingViewController = self;
    while (presentingViewController.presentingViewController)
    {
        presentingViewController = presentingViewController.presentingViewController;
    }
    
    return presentingViewController;
}
@end
