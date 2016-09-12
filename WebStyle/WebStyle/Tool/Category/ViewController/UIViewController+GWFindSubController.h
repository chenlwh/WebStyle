//
//  UIViewController+GWFindSubController.h
//  GWMovie
//
//  Created by wushengtao on 15/10/26.
//  Copyright © 2015年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GWFindSubController)
/**
 *  有效的presentedViewController,可能self.presentedViewController已经presented了一个VC，那么应该是self.presentedViewController.presentedViewController，循环遍历
 *
 *  @return 有效的presentedViewController
 */
- (UIViewController*)vaildPresentedViewController;

/**
 *  有效的presentingViewController
 *
 *  @return 有效的presentedViewController
 */
- (UIViewController*)vaildPresentingViewController;
@end
