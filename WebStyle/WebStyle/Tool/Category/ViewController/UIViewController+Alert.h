//
//  UIViewController+Alert.h
//  VOA
//
//  Created by yangzexin on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//// hello git tooooo  2323232

#import <Foundation/Foundation.h>
#import "SFDialogTools.h"

@interface UIViewController (Alert)

- (void)alert:(NSString *)string;
- (void)alertTitle:(NSString *)title message:(NSString*)msg;

/**
 *  根据字符串长度调整隐藏时间，范围在1-10s之间
 *
 *  @param string <#string description#>
 */
- (void)showAutoHideToastWithString:(NSString *)string;
- (void)showAutoHideToastWithString:(NSString *)string
                         completion:(void(^)(void))completion;

- (void)showToastWithString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval;
- (void)showToastWithString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval completion:(void(^)(void))completion;

@end


@interface UIViewController (Present)

-(void)gwPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
-(void)gwDismissModalViewControllerAnimated:(BOOL)animated;


-(UIViewController*)gwPresentedViewController;

@end


@interface UIViewController (Utilities)
- (void)alertWithMessage:(NSString *)message;
- (void)alertWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)())completion;
- (void)confirmWithTitle:(NSString *)title message:(NSString *)message approve:(void(^)())approve;
- (void)confirmWithTitle:(NSString *)title message:(NSString *)message approve:(void(^)())approve cancel:(void(^)())cancel;
@end





