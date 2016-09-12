//
//  DialogTools.m
//
//
//  Created by yangzexin on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SFDialogTools.h"
#import <objc/runtime.h>
#import "MsgDefine.h"

#pragma mark - Class AlertDialog

static char STRONGOBJ_IDENTIFER;







@interface SFAlertDialog : NSObject <UIAlertViewDelegate>

@property(nonatomic, copy)void(^callback)(NSInteger buttonIndex, NSString *buttonTitle);


@end

@implementation SFAlertDialog

- (void)dealloc
{
    self.callback = nil;
    NSLog(@"SFAlertDialog dealloc");
    
}

- (instancetype)init{

    self = [super init];
    
    return self;

}

- (void)showWithTitle:(NSString *)title
              message:(NSString *)message
           completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
{
    
   // SFAlertDialog *stongSelf = self;
    
    self.callback = completion;
    
 
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
    //UIAlertView 对SFAlertDialog强引用 防止回调的时候SFAlertDialog被释放掉
    alertView.strongObject = self;
    
    for(NSString *title in otherButtonTitles){
        [alertView addButtonWithTitle:title];
    }
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex:%zd",buttonIndex);
    
    if(self.callback){
        self.callback(buttonIndex, [alertView buttonTitleAtIndex:buttonIndex]);
    }
  
}

@end

#pragma mark - Class ImagePicker
@interface SFImagePicker : NSObject

@end

#define kTitleSelectPicture @"选择图片"
#define kTitlePicture       @"照片"
#define kTitleCamera        @"拍照"

@interface SFImagePicker () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, retain)UIViewController *presentingViewController;
@property(nonatomic, copy)void(^callback)(UIImage *selectedImage);

@end

@implementation SFImagePicker

@synthesize presentingViewController;
@synthesize callback;

- (void)dealloc
{
    self.presentingViewController = nil;
    self.callback = nil;
    
}

- (void)pickImageByActionSheetInViewController:(UIViewController *)viewController completion:(void(^)(UIImage *selectedImage))completion
{
    
    self.presentingViewController = viewController;
    self.callback = completion;
    
    UIActionSheet *tmpActionSheet = nil;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        tmpActionSheet = [[UIActionSheet alloc] initWithTitle:kTitleSelectPicture
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:kTitleCamera, kTitlePicture, nil];
    }else{
        tmpActionSheet = [[UIActionSheet alloc] initWithTitle:kTitleSelectPicture
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:kTitlePicture, nil];
    }
    
    tmpActionSheet.strongObject = self;
    
    [tmpActionSheet showInView:self.presentingViewController.view];
    

   
}

- (void)pickImageByAlertDialogWithViewController:(UIViewController *)viewController completion:(void(^)(UIImage *selectedImage))completion
{
    
    
    __block typeof(self) bself = self;
    self.callback = completion;
    self.presentingViewController = viewController;
    
    void(^dialogCallbck)(NSInteger, NSString *)  = ^(NSInteger buttonIndex, NSString *buttonTitle) {
        UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
        imgPickerController.strongObject = self;
        imgPickerController.delegate = self;
        imgPickerController.allowsEditing = YES;
        if([buttonTitle isEqualToString:kTitleCamera]){
            imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if([buttonTitle isEqualToString:kTitlePicture]){
            imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
          
            return;
        }
        [viewController presentViewController:imgPickerController animated:YES completion:nil];
    };
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [SFDialogTools alertWithTitle:kTitleSelectPicture
                              message:nil
                           completion:dialogCallbck
                    cancelButtonTitle:@"取消"
                    otherButtonTitles:kTitleCamera, kTitlePicture, nil];
    }else{
        [SFDialogTools alertWithTitle:kTitleSelectPicture
                              message:nil
                           completion:dialogCallbck
                    cancelButtonTitle:@"取消"
                    otherButtonTitles:kTitlePicture, nil];
    }
}

#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *actionTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([actionTitle isEqualToString:@"取消"]){
    
        return;
    }
    
    
    UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
    imgPickerController.delegate = self;
    imgPickerController.strongObject = self;
    imgPickerController.allowsEditing = YES;
    if([actionTitle isEqualToString:kTitleCamera]){
        imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if([actionTitle isEqualToString:kTitlePicture]){
        imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self.presentingViewController presentViewController:imgPickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    if(self.callback){
        self.callback(image);
    }
 
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
   
}

@end

#pragma mark - Class InputDialog

#define kInputFieldPortraitY    75
#define kInputFieldLandscapeY   57

@interface SFInputDialog : NSObject <UIAlertViewDelegate>

@property(nonatomic, weak)UIAlertView *alertView;
@property(nonatomic, strong)UITextField *addedTextField;
@property(nonatomic, assign)BOOL useCustomTextField;
@property(nonatomic, copy)void(^completion)(NSString *);

@end

@implementation SFInputDialog

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.alertView = nil;
    self.addedTextField = nil;
    self.completion = nil;
    
}

- (void)showWithTitle:(NSString *)title
              message:(NSString *)message
      secureTextEntry:(BOOL)secureTextEntry
      clearButtonMode:(UITextFieldViewMode)clearButtonMode
    cancelButtonTitle:(NSString *)cancelButtonTitle
   approveButtonTitle:(NSString *)approveButtonTitle
           completion:(void(^)(NSString *input))completion
{

    self.completion = completion;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                 message:message
                                                delegate:self
                                       cancelButtonTitle:cancelButtonTitle
                                       otherButtonTitles:approveButtonTitle, nil];
    
    UITextField *textField = nil;
    self.useCustomTextField = ![alertView respondsToSelector:@selector(alertViewStyle)];
    if(self.useCustomTextField){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationDidChangeNotification:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        textField = [[UITextField alloc] initWithFrame:CGRectMake(10, [self yPositionForCustomTextField], 264, 35)];
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.borderStyle = UITextBorderStyleBezel;
        textField.tag = 1001;
        textField.backgroundColor = [UIColor whiteColor];
        textField.clearButtonMode = clearButtonMode;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.secureTextEntry = secureTextEntry;
        self.addedTextField = textField;
        [alertView addSubview:textField];
        alertView.message = [NSString stringWithFormat:@"%@\n\n\n", alertView.message ? alertView.message : @""];
        alertView.strongObject = self;
        self.alertView = alertView;
    }else{
        self.alertView.alertViewStyle = secureTextEntry ? UIAlertViewStyleSecureTextInput : UIAlertViewStylePlainTextInput;
        [[self.alertView textFieldAtIndex:0] setClearButtonMode:clearButtonMode];
        [self.alertView textFieldAtIndex:0].contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    

    [self.alertView show];
    [textField becomeFirstResponder];
}

- (UITextField *)inputTextField
{
    return self.useCustomTextField ? self.addedTextField : [self.alertView textFieldAtIndex:0];
}

#pragma mark - events
- (void)statusBarOrientationDidChangeNotification:(NSNotification *)noti
{
    CGRect tmpRect = self.addedTextField.frame;
    tmpRect.origin.y = [self yPositionForCustomTextField];
    [UIView animateWithDuration:0.25f animations:^{
        self.addedTextField.frame = tmpRect;
    }];
}

- (CGFloat)yPositionForCustomTextField
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? kInputFieldLandscapeY : kInputFieldPortraitY;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *text = nil;
    if(self.useCustomTextField){
        UITextField *textField = (id)[alertView viewWithTag:1001];
        text = textField.text;
    }else{
        text = [[self.alertView textFieldAtIndex:0] text];
    }
    if(buttonIndex == 1){
        self.completion(text);
    }
    
}

@end

#pragma mark - ActionSheet
@interface SFActionDialog : NSObject <UIActionSheetDelegate>

@property(nonatomic, weak)UIActionSheet *actionSheet;
@property(nonatomic, copy)void(^completion)(NSInteger, NSString *);

@end

@implementation SFActionDialog

- (void)dealloc
{
    self.actionSheet = nil;
    self.completion = nil;
    
    D_Log(@"SFActionDialog dealloc");
    
    
}

- (void)actionSheetWithTitle:(NSString *)title
                  completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
{
    

 
    self.completion = completion;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
    actionSheet.title = title;
    actionSheet.delegate = self;
    for(NSString *title in otherButtonTitles){
        [actionSheet addButtonWithTitle:title];
    }
    NSInteger count = otherButtonTitles.count;
    if(destructiveButtonTitle.length != 0){
        [actionSheet addButtonWithTitle:destructiveButtonTitle];
        actionSheet.destructiveButtonIndex = count++;
    }
    if(cancelButtonTitle.length != 0){
        [actionSheet addButtonWithTitle:cancelButtonTitle];
         actionSheet.cancelButtonIndex = count;
    }
    
    //这里的strongObject要在 self.actionSheet前调用
    actionSheet.strongObject = self;
    [actionSheet showInView:[[UIApplication sharedApplication].windows objectAtIndex:0]];
    self.actionSheet = actionSheet;

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.completion){
        self.completion(buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    }
  
}

@end

#pragma mark - Class DialogUtils
@implementation SFDialogTools

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSMutableArray *titleList = [NSMutableArray array];
    va_list params;
    va_start(params, otherButtonTitles);
    for(id item = otherButtonTitles; item != nil; item = va_arg(params, id)){
        [titleList addObject:item];
    }
    va_end(params);
    [self alertWithTitle:title message:message completion:completion cancelButtonTitle:cancelButtonTitle otherButtonTitleList:titleList];
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
     cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitleList:(NSArray *)otherButtonTitleList
{
    SFAlertDialog *dialog = [[SFAlertDialog alloc]init];
    
    [dialog showWithTitle:title message:message completion:completion cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitleList];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)())completion
{
    [self alertWithTitle:title message:message completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        if(completion){
            completion();
        }
    } cancelButtonTitle:NSLocalizedString(@"Continue", nil) otherButtonTitles:nil];
}

+ (void)alertWithMessage:(NSString *)message completion:(void (^)())completion
{
    [self alertWithTitle:@"" message:message completion:completion];
}

+ (void)pickImageByActionSheetInViewController:(UIViewController *)viewController completion:(void(^)(UIImage *selectedImage))completion
{
    SFImagePicker *imgPicker = [[SFImagePicker alloc] init];
    [imgPicker pickImageByActionSheetInViewController:viewController completion:^void(UIImage *image){
        if(completion){
            completion(image);
        }
    }];
}

+ (void)pickImageByAlertDialogWithViewController:(UIViewController *)viewController completion:(void(^)(UIImage *selectedImage))completion
{
    SFImagePicker *imgPicker = [[SFImagePicker alloc] init];
    [imgPicker pickImageByAlertDialogWithViewController:viewController completion:^void(UIImage *image){
        if(completion){
            completion(image);
        }
    }];
}

+ (UITextField *)inputWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
             approveButtonTitle:(NSString *)approveButtonTitle
                     completion:(void(^)(NSString *input))completion
{
    return [self inputWithTitle:title
                        message:message
                secureTextEntry:NO
              cancelButtonTitle:cancelButtonTitle
             approveButtonTitle:approveButtonTitle
                     completion:completion];
}

+ (UITextField *)inputWithTitle:(NSString *)title
                        message:(NSString *)message
                secureTextEntry:(BOOL)secureTextEntry
              cancelButtonTitle:(NSString *)cancelButtonTitle
             approveButtonTitle:(NSString *)approveButtonTitle
                     completion:(void(^)(NSString *input))completion
{
    SFInputDialog *inputDialog = [SFInputDialog new];
    [inputDialog showWithTitle:title
                       message:message
               secureTextEntry:secureTextEntry
               clearButtonMode:UITextFieldViewModeWhileEditing
             cancelButtonTitle:cancelButtonTitle
            approveButtonTitle:approveButtonTitle
                    completion:completion];
    return [inputDialog inputTextField];
}

+ (void)confirmWithTitle:(NSString *)title message:(NSString *)message approve:(void(^)())approve
{
    [self confirmWithTitle:title message:message approve:approve cancel:nil];
}

+ (void)confirmWithTitle:(NSString *)title message:(NSString *)message approve:(void(^)())approve cancel:(void(^)())cancel
{
    [self alertWithTitle:title message:message completion:^(NSInteger buttonIndex, NSString *buttonTitle) {
        if(buttonIndex == 1 && approve != nil){
            approve();
        }else if(buttonIndex == 0 && cancel != nil){
            cancel();
        }
    } cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Continue", nil)];
}

+ (void)actionSheetWithTitle:(NSString *)title
                  completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSMutableArray *titleList = [NSMutableArray array];
    va_list params;
    va_start(params, otherButtonTitles);
    for(id item = otherButtonTitles; item != nil; item = va_arg(params, id)){
        [titleList addObject:item];
    }
    va_end(params);
    [self actionSheetWithTitle:title
                    completion:completion
             cancelButtonTitle:cancelButtonTitle
        destructiveButtonTitle:destructiveButtonTitle
          otherButtonTitleList:titleList];
}

+ (void)actionSheetWithTitle:(NSString *)title
                  completion:(void(^)(NSInteger buttonIndex, NSString *buttonTitle))completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
        otherButtonTitleList:(NSArray *)otherButtonTitleList
{
    
    [[SFActionDialog new] actionSheetWithTitle:title
                                                  completion:completion
                                           cancelButtonTitle:cancelButtonTitle
                                      destructiveButtonTitle:destructiveButtonTitle
                                           otherButtonTitles:otherButtonTitleList];
}

@end


@implementation NSObject (StrongObj)

-(void)setStrongObject:(NSObject*)strongObject
{
    objc_setAssociatedObject(self, &STRONGOBJ_IDENTIFER, strongObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject*)strongObject
{
    return objc_getAssociatedObject(self, &STRONGOBJ_IDENTIFER);
}

@end
