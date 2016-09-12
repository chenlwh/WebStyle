//
//  DialogTools.h
// 
//
//  Created by yangzexin on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SFAlertDialog;
@interface NSObject (StrongObj)
@property (nonatomic,strong) NSObject             *strongObject;
@end

@interface SFDialogTools : NSObject

@end

@interface SFDialogTools (Alert)

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
     cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitleList:(NSArray *)otherButtonTitleList;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)())completion;

+ (void)alertWithMessage:(NSString *)message completion:(void (^)())completion;

@end

@interface SFDialogTools (ImagePicker)

+ (void)pickImageByActionSheetInViewController:(UIViewController *)viewController completion:(void(^)(UIImage *selectedImage))completion;
+ (void)pickImageByAlertDialogWithViewController:(UIViewController *)viewController completion:(void(^)(UIImage *selectedImage))completion;

@end

@interface SFDialogTools (Input)

+ (UITextField *)inputWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
             approveButtonTitle:(NSString *)approveButtonTitle
                     completion:(void(^)(NSString *input))completion;

+ (UITextField *)inputWithTitle:(NSString *)title
                        message:(NSString *)message
                secureTextEntry:(BOOL)secureTextEntry
              cancelButtonTitle:(NSString *)cancelButtonTitle
             approveButtonTitle:(NSString *)approveButtonTitle
                     completion:(void(^)(NSString *input))completion;

@end

@interface SFDialogTools (Confirm)

+ (void)confirmWithTitle:(NSString *)title message:(NSString *)message approve:(void(^)())approve;
+ (void)confirmWithTitle:(NSString *)title message:(NSString *)message approve:(void(^)())approve cancel:(void(^)())cancel;

@end

@interface SFDialogTools (ActionSheet)

+ (void)actionSheetWithTitle:(NSString *)title
                  completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (void)actionSheetWithTitle:(NSString *)title
                  completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
        otherButtonTitleList:(NSArray *)otherButtonTitleList;

@end