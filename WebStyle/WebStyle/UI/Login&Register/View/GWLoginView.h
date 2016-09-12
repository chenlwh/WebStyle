//
//  GWLoginView.h
//  GWMovie
//
//  Created by Chenyao Cai on 15/3/17.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWLoginBaseControl.h"
@protocol GWLoginDelegate <NSObject>
@optional
-(void)weixinButtonClicked;
-(void)sinaButtonClicked;
-(void)qqButtonClicked;
-(void)alipayButtonClicked;

-(void)passwordFindClicked;
-(void)quickRegisterClicked;

-(void)enterReturn;

-(void)changeStatus:(BOOL)status;

-(void)beginEdit:(UITextField*)field;
@end

@interface GWLoginView : GWLoginBaseControl <UITextFieldDelegate>
{
//    __weak IBOutlet UIButton *passwordFind;
//    __weak IBOutlet UIButton *quickRegister;
//    __weak IBOutlet UIButton *weixinButton;
//    __weak IBOutlet UIButton *sinaButton;
//    __weak IBOutlet UIButton *qqButton;
//    __weak IBOutlet UIButton *alipayButton;
//    __weak IBOutlet UILabel *thirdLabel;
}
@property (nonatomic,weak) id <GWLoginDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *passwordFind;
@property (weak, nonatomic) IBOutlet UIButton *quickRegister;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *sinaButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

+(GWLoginView*)createNewLoginView:(CGRect)frame;
-(void)resignALL;
-(BOOL)checkTextLength;
-(void)changeButtonStatus:(BOOL)enable;
@end
