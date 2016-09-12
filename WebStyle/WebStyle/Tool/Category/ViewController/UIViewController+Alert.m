//
//  UIViewController+Alert.m
//  VOA
//
//  Created by yangzexin on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Alert.h"
#import "Toast.h"
//#import "GWCommkit.h"

@implementation UIViewController (Alert)

- (void)alert:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:string 
                                                   delegate:nil 
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertTitle:(NSString *)title message:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showAutoHideToastWithString:(NSString *)string
{
    NSTimeInterval autoTimeInterval = [string length] * 0.2;
    autoTimeInterval = MIN(MAX(autoTimeInterval, 1), 10);
    [self showAutoHideToastWithString:string completion:nil];
}

- (void)showAutoHideToastWithString:(NSString *)string
                         completion:(void(^)(void))completion
{
    NSTimeInterval autoTimeInterval = [string length] * 0.2;
    autoTimeInterval = MIN(MAX(autoTimeInterval, 1), 10);
    
    [[Toast defaultToast] showToastInView:self.view
                               withString:string
                        hideAfterInterval:autoTimeInterval
                               completion:completion];
}

- (void)showToastWithString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval
{
    [[Toast defaultToast] showToastInView:self.view 
                               withString:string 
                        hideAfterInterval:interval];
}

- (void)showToastWithString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval completion:(void(^)(void))completion
{
    [[Toast defaultToast] showToastInView:self.view
                               withString:string
                        hideAfterInterval:interval
                               completion:completion];
}




@end

@implementation UIViewController (Present)

-(void)gwPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    [self presentViewController:modalViewController animated:animated completion:^{
    }];
}

-(void)gwDismissModalViewControllerAnimated:(BOOL)animated
{

    [self dismissViewControllerAnimated:animated completion:^{
    }];
}


-(UIViewController*)gwPresentedViewController
{

    return self.presentedViewController;
    
}


@end


#pragma mark - Utilities
@implementation UIViewController (Utilities)

- (void)alertWithMessage:(NSString *)message
{
    [self alertWithTitle:@"提示" message:message completion:nil];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)())completion
{
    [SFDialogTools alertWithTitle:title message:message completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        if(completion){
            completion();
        }
    } cancelButtonTitle:@"确定" otherButtonTitles:nil];
}

- (void)confirmWithTitle:(NSString *)title message:(NSString *)message approve:(void(^)())approve
{
    
 
    
    [SFDialogTools alertWithTitle:title message:message completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        if(buttonIndex != 0){
            if(approve){
                approve();
            }
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

- (void)confirmWithTitle:(NSString *)title message:(NSString *)message approve:(void(^)())approve cancel:(void(^)())cancel
{
    
   
    
    [SFDialogTools alertWithTitle:title message:message completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        if(buttonIndex != 0){
            if(approve){
                approve();
            }
        }else{
            if(cancel){
                cancel();
            }
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

@end

