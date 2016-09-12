//
//  GWPasswordFindView.m
//  GWMovie
//
//  Created by Chenyao Cai on 15/3/17.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWPasswordFindView.h"
#import "UIView+Gewara.h"
//#import "BudleImageCache+GWMovie.h"
#import "FTUtils.h"
//#import "GWMovieTheme.h"
@interface GWPasswordFindView ()
{
    CALayer *phoneLayer;
    CALayer *checkLayer;
    CALayer *newPasswordLayer;
}
@end

@implementation GWPasswordFindView

+(GWPasswordFindView*)createView:(CGRect)frame
{
    GWPasswordFindView*view = [[[NSBundle mainBundle] loadNibNamed:@"GWPasswordFindView" owner:nil options:nil] lastObject];
    view.frame = frame;
    [view loadAllControlers];
    return view;
}
-(void)loadAllControlers
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addTarget:self action:@selector(resignALL) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneField.leftView = [self addLeftView:@"icon_mobile"];
    _phoneField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_phoneField setDelegate:self];
    [_phoneField setTintColor:defaultTextColor];
    [_phoneField setTextColor:defaultTextColor];
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    [_phoneField setBackgroundColor:[UIColor clearColor]];
    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:textfieldLayerDefaultColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_phoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    phoneLayer = [[CALayer alloc] init];
    [phoneLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [_phoneField.layer addSublayer:phoneLayer];
    
    _checkField.leftView = [self addLeftView:@"icon_code"];
    _checkField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_checkField setDelegate:self];
    [_checkField setTintColor:defaultTextColor];
    [_checkField setTextColor:defaultTextColor];
    _checkField.leftViewMode = UITextFieldViewModeAlways;
    [_checkField setBackgroundColor:[UIColor clearColor]];
    _checkField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:textfieldLayerDefaultColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_checkField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    checkLayer = [[CALayer alloc] init];
    [checkLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [_checkField.layer addSublayer:checkLayer];
    
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [rightView setBackgroundColor:[UIColor clearColor]];
    
    UIButton * getButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    getButton.centerY = rightView.height/2;
    getButton.left = rightView.width - getButton.width;
    [getButton setTitle:@"获取" forState:UIControlStateNormal];
    [getButton setTitleColor:textfieldLayerDefaultColor forState:UIControlStateNormal];
    [getButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    getButton.layer.cornerRadius = 4.0f;
    getButton.clipsToBounds = YES;
    getButton.layer.borderColor = textfieldLayerDefaultColor.CGColor;
    getButton.layer.borderWidth = textFieldLayerDefaultHeight;
    [getButton addTarget:self action:@selector(getMethod:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:getButton];
    _checkField.rightView = rightView;
    _checkField.rightViewMode = UITextFieldViewModeAlways;
    
    _newpasswordField.leftView = [self addLeftView:@"icon_password2"];
    _newpasswordField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_newpasswordField setDelegate:self];
    [_newpasswordField setTintColor:defaultTextColor];
    [_newpasswordField setTextColor:defaultTextColor];
    _newpasswordField.leftViewMode = UITextFieldViewModeAlways;
    [_newpasswordField setBackgroundColor:[UIColor clearColor]];
    _newpasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"新密码（6-14字符）" attributes:@{NSForegroundColorAttributeName:textfieldLayerDefaultColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_newpasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    newPasswordLayer = [[CALayer alloc] init];
    [newPasswordLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [_newpasswordField.layer addSublayer:newPasswordLayer];
    
    [_enterButton setBackgroundColor:[UIColor clearColor]];
    _enterButton.layer.cornerRadius = 2;
    _enterButton.clipsToBounds = YES;
    _enterButton.layer.borderColor = defaultTextColor.CGColor;
    _enterButton.layer.borderWidth = textFieldLayerDefaultHeight;
    [_enterButton setTitleColor:defaultTextColor forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_enterButton setTitle:@"找回" forState:UIControlStateNormal];
    [self changeButtonStatus:NO];
    
    [self.quickEnterButton setTitleColor:defaultTextColor forState:UIControlStateNormal];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [phoneLayer setFrame:CGRectMake(0, _phoneField.height-1, _phoneField.width, textFieldLayerDefaultHeight)];
    [checkLayer setFrame:CGRectMake(0, _checkField.height-1, _checkField.width, textFieldLayerDefaultHeight)];
    [newPasswordLayer setFrame:CGRectMake(0, _newpasswordField.height-1, _newpasswordField.width, textFieldLayerDefaultHeight)];
}
- (IBAction)quickLoginMethod:(id)sender {
    if ([self.deletgate respondsToSelector:@selector(passwordBackClicked)]) {
        [self.deletgate passwordBackClicked];
    }
}
-(void)getMethod:(id)sender
{
    if ([self.deletgate respondsToSelector:@selector(getCheckNumber)]) {
        [self.deletgate getCheckNumber];
    }
}
-(void)resignALL
{
    [self.phoneField resignFirstResponder];
    [self.checkField resignFirstResponder];
    [self.newpasswordField resignFirstResponder];
}
-(UIView*)addLeftView:(NSString*)name
{
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *nameImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [nameImage setImage:[UIImage imageNamed:name]];
    [nameImage setCenter:CGPointMake(leftView.width/2, leftView.height/2)];
    [leftView addSubview:nameImage];
    
    return leftView;
}
-(void)enterButtonClick:(id)sender
{
    if ([self.deletgate respondsToSelector:@selector(passwordFinish)]) {
        [self.deletgate passwordFinish];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneField) {
        [_phoneField resignFirstResponder];
        [_checkField becomeFirstResponder];
    }
    if (textField == _checkField) {
        [_checkField resignFirstResponder];
        [_newpasswordField becomeFirstResponder];
    }
    if (textField == _newpasswordField) {
        [_newpasswordField resignFirstResponder];
        if ([self.deletgate respondsToSelector:@selector(passwordFinish)]) {
            [self.deletgate passwordFinish];
        }
    }
    return YES;
}
-(void)textFieldDidChange:(id)sender
{
    if ([self.deletgate respondsToSelector:@selector(changeStatus:)]) {
        [self.deletgate changeStatus:[self checkTextLength]];
    }
}
-(BOOL)checkTextLength
{
    BOOL check = YES;
    if (self.phoneField.text.length ==0) {
        check = NO;
    }else if(self.newpasswordField.text.length ==0) {
        check = NO;
    }else if (self.checkField.text.length==0){
        check =NO;
    }
    return check;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self defaultLayer];
    if (textField == _phoneField) {
        [phoneLayer setBackgroundColor:textfieldLayerSelectColor.CGColor];
        [phoneLayer setFrame:CGRectMake(0, _phoneField.height-1, _phoneField.width, textFieldLayerSelectHeight)];
    }
    if (textField == _checkField) {
        [checkLayer setBackgroundColor:textfieldLayerSelectColor.CGColor];
        [checkLayer setFrame:CGRectMake(0, _checkField.height-1, _checkField.width,textFieldLayerSelectHeight)];
    }
    if (textField == _newpasswordField) {
        [newPasswordLayer setBackgroundColor:textfieldLayerSelectColor.CGColor];
        [newPasswordLayer setFrame:CGRectMake(0, _newpasswordField.height-1, _newpasswordField.width, textFieldLayerSelectHeight)];
    }
    if ([self.deletgate respondsToSelector:@selector(beginEdit:)]) {
        [self.deletgate beginEdit:textField];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self defaultLayer];
}
-(void)defaultLayer
{
    [phoneLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [checkLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [newPasswordLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [phoneLayer setFrame:CGRectMake(0, _phoneField.height-1, _phoneField.width, textFieldLayerDefaultHeight)];
    [checkLayer setFrame:CGRectMake(0, _checkField.height-1, _checkField.width, textFieldLayerDefaultHeight)];
    [newPasswordLayer setFrame:CGRectMake(0, _newpasswordField.height-1, _newpasswordField.width, textFieldLayerDefaultHeight)];
}
-(void)changeButtonStatus:(BOOL)enable
{
    if (enable) {
        self.enterButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.enterButton.backgroundColor = RGBACOLORFromRGBHex(0xff5200);
        [self.enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.enterButton setEnabled:enable];
    }else{
        [self.enterButton setBackgroundColor:[UIColor clearColor]];
        self.enterButton.layer.borderColor = defaultTextColor.CGColor;
        [self.enterButton setTitleColor:defaultTextColor forState:UIControlStateNormal];
        [self.enterButton setEnabled:enable];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
