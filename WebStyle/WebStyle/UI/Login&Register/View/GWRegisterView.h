//
//  GWRegisterView.h
//  GWMovie
//
//  Created by Chenyao Cai on 15/3/17.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWLoginBaseControl.h"
@protocol GWRegisterViewDelegate <NSObject>
-(void)verifyButtonTapped;
-(void)showAgreement;
-(void)registerBackClicked;
-(void)registerFinish;
-(void)changeStatus:(BOOL)status;
-(void)beginEdit:(UITextField*)field;
@end
@interface GWRegisterView : GWLoginBaseControl <UITextFieldDelegate>
{
    
}
@property (weak, nonatomic) id <GWRegisterViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *checkNumberField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIButton *quickEnterButton;
+(GWRegisterView*)createView:(CGRect)frame;
-(void)resignALL;
-(BOOL)checkTextLength;
-(void)changeButtonStatus:(BOOL)enable;
@end
