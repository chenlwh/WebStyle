//
//  GWRegisterView.m
//  GWMovie
//
//  Created by Chenyao Cai on 15/3/17.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWRegisterView.h"
#import "UIView+Gewara.h"
//#import "UIImage+GWMovie.h"
#import "FTUtils.h"
//#import "GWMovieTheme.h"

@interface GWRegisterView ()
{
    CALayer *phoneLayer;
    CALayer *checkLayer;
    CALayer *nameLayer;
    CALayer *passwordLayer;
}
@end

@implementation GWRegisterView

+(GWRegisterView*)createView:(CGRect)frame
{
    GWRegisterView*view = [[[NSBundle mainBundle] loadNibNamed:@"GWRegisterView" owner:nil options:nil] lastObject];
    view.frame = frame;
    [view loadAllControlers];
    return view;
}
-(void)loadAllControlers
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addTarget:self action:@selector(resignALL) forControlEvents:UIControlEventTouchUpInside];
    _checkButton.selected = YES;
    
    _phoneNumberField.leftView = [self addLeftView:@"icon_mobile"];
    _phoneNumberField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_phoneNumberField setDelegate:self];
    [_phoneNumberField setTintColor:defaultTextColor];
    [_phoneNumberField setTextColor:defaultTextColor];
    _phoneNumberField.leftViewMode = UITextFieldViewModeAlways;
    [_phoneNumberField setBackgroundColor:[UIColor clearColor]];
    _phoneNumberField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:textfieldLayerDefaultColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_phoneNumberField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    phoneLayer = [[CALayer alloc] init];
    [phoneLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [_phoneNumberField.layer addSublayer:phoneLayer];
    
    
    _checkNumberField.leftView = [self addLeftView:@"icon_code"];
    _checkNumberField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_checkNumberField setDelegate:self];
    [_checkNumberField setTintColor:defaultTextColor];
    [_checkNumberField setTextColor:defaultTextColor];
    _checkNumberField.leftViewMode = UITextFieldViewModeAlways;
    [_checkNumberField setBackgroundColor:[UIColor clearColor]];
    _checkNumberField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:textfieldLayerDefaultColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_checkNumberField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    checkLayer = [[CALayer alloc] init];
    [checkLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [_checkNumberField.layer addSublayer:checkLayer];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [rightView setBackgroundColor:[UIColor clearColor]];
    
    UIButton * getButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    getButton.centerY = rightView.height/2;
    getButton.left = rightView.width - getButton.width;
    [getButton setTitle:@"获取" forState:UIControlStateNormal];
    [getButton setTitleColor:textfieldLayerDefaultColor forState:UIControlStateNormal];
    [getButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    getButton.layer.cornerRadius = 4.0f;
    getButton.clipsToBounds = YES;
    getButton.layer.borderColor = textfieldLayerDefaultColor.CGColor;
    getButton.layer.borderWidth = textFieldLayerDefaultHeight;
    [getButton addTarget:self action:@selector(getMethod:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:getButton];
    _checkNumberField.rightView = rightView;
    _checkNumberField.rightViewMode = UITextFieldViewModeAlways;
    
    _nameField.leftView = [self addLeftView:@"icon_userid"];
    _nameField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_nameField setDelegate:self];
    [_nameField setTintColor:defaultTextColor];
    [_nameField setTextColor:defaultTextColor];
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    [_nameField setBackgroundColor:[UIColor clearColor]];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"你的用户名" attributes:@{NSForegroundColorAttributeName:textfieldLayerDefaultColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    nameLayer = [[CALayer alloc] init];
    [nameLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [_nameField.layer addSublayer:nameLayer];
    
    _passwordField.leftView = [self addLeftView:@"icon_password"];
    _passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_passwordField setDelegate:self];
    [_passwordField setTintColor:defaultTextColor];
    [_passwordField setTextColor:defaultTextColor];
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    [_passwordField setBackgroundColor:[UIColor clearColor]];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码（6-14字符）" attributes:@{NSForegroundColorAttributeName:textfieldLayerDefaultColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    passwordLayer = [[CALayer alloc] init];
    [passwordLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [_passwordField.layer addSublayer:passwordLayer];
    
    [_enterButton setBackgroundColor:[UIColor clearColor]];
    _enterButton.layer.cornerRadius = 2;
    _enterButton.clipsToBounds = YES;
    _enterButton.layer.borderColor = defaultTextColor.CGColor;
    _enterButton.layer.borderWidth = textFieldLayerDefaultHeight;
    [_enterButton setTitleColor:defaultTextColor forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_enterButton setTitle:@"注册" forState:UIControlStateNormal];
    [self changeButtonStatus:NO];
    
    [self.quickEnterButton setTitleColor:defaultTextColor forState:UIControlStateNormal];
    
    [_readLabel setTextColor:defaultTextColor];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [phoneLayer setFrame:CGRectMake(0, _phoneNumberField.height-1, _phoneNumberField.width, textFieldLayerDefaultHeight)];
    [nameLayer setFrame:CGRectMake(0, _nameField.height-1, _nameField.width, textFieldLayerDefaultHeight)];
    [checkLayer setFrame:CGRectMake(0, _checkNumberField.height-1, _checkNumberField.width, textFieldLayerDefaultHeight)];
    [passwordLayer setFrame:CGRectMake(0, _passwordField.height-1, _passwordField.width, textFieldLayerDefaultHeight)];
}
-(void)resignALL
{
    [self.phoneNumberField resignFirstResponder];
    [self.checkNumberField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
- (IBAction)checkMethods:(id)sender {
    _checkButton.selected = !self.checkButton.selected;
    if (_checkButton.selected == YES) {
        [_checkButton setImage:[UIImage imageNamed:@"icon_checkbox2"] forState:UIControlStateNormal];
    }else{
        [_checkButton setImage:[UIImage imageNamed:@"icon_checkboxb"] forState:UIControlStateNormal];
    }
}

- (IBAction)agreementMethod:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showAgreement)]) {
        [self.delegate showAgreement];
    }
}
- (IBAction)quickLoginMethod:(id)sender {
    if ([self.delegate respondsToSelector:@selector(registerBackClicked)]) {
        [self.delegate registerBackClicked];
    }
}
-(void)getMethod:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(verifyButtonTapped)]) {
        [self.delegate verifyButtonTapped];
    }
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
    if ([self.delegate respondsToSelector:@selector(registerFinish)]) {
        [self.delegate registerFinish];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneNumberField) {
        [_phoneNumberField resignFirstResponder];
        [_checkNumberField becomeFirstResponder];
    }
    if (textField == _checkNumberField) {
        [_checkNumberField resignFirstResponder];
        [_nameField becomeFirstResponder];
    }
    if (textField == _nameField) {
        [_nameField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }
    if (textField == _passwordField) {
        [_passwordField resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(registerFinish)]) {
            [self.delegate registerFinish];
        }
    }
    return YES;
}
-(void)textFieldDidChange:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(changeStatus:)]) {
        [self.delegate changeStatus:[self checkTextLength]];
    }
}
-(BOOL)checkTextLength
{
    BOOL check = YES;
    /*
    if (self.phoneNumberField.text.length == 0) {
        check = NO;
    }else if (self.checkNumberField.text.length ==0){
        check = NO;
    }else if (self.nameField.text.length ==0) {
        check = NO;
    }else if (self.passwordField.text.length ==0) {
        check = NO;
    }
    */
    if (self.nameField.text.length ==0) {
        check = NO;
    }else if (self.passwordField.text.length ==0) {
        check = NO;
    }
    return check;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self defaultLayer];
    if (textField == _phoneNumberField) {
        [phoneLayer setBackgroundColor:textfieldLayerSelectColor.CGColor];
        [phoneLayer setFrame:CGRectMake(0, _phoneNumberField.height-1, _phoneNumberField.width, textFieldLayerSelectHeight)];
    }
    if (textField == _checkNumberField) {
        [checkLayer setBackgroundColor:textfieldLayerSelectColor.CGColor];
        [checkLayer setFrame:CGRectMake(0, _checkNumberField.height-1, _checkNumberField.width, textFieldLayerSelectHeight)];
    }
    if (textField == _nameField) {
        [nameLayer setBackgroundColor:textfieldLayerSelectColor.CGColor];
        [nameLayer setFrame:CGRectMake(0, _nameField.height-1, _nameField.width, textFieldLayerSelectHeight)];
    }
    if (textField == _passwordField) {
        [passwordLayer setBackgroundColor:textfieldLayerSelectColor.CGColor];
        [passwordLayer setFrame:CGRectMake(0, _passwordField.height-1, _passwordField.width, textFieldLayerSelectHeight)];
    }
    if ([self.delegate respondsToSelector:@selector(beginEdit:)]) {
        [self.delegate beginEdit:textField];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self defaultLayer];
}
-(void)defaultLayer
{
    [nameLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [passwordLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [checkLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [phoneLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [phoneLayer setFrame:CGRectMake(0, _phoneNumberField.height-1, _phoneNumberField.width, textFieldLayerDefaultHeight)];
    [nameLayer setFrame:CGRectMake(0, _nameField.height-1, _nameField.width, textFieldLayerDefaultHeight)];
    [checkLayer setFrame:CGRectMake(0, _checkNumberField.height-1, _checkNumberField.width, textFieldLayerDefaultHeight)];
    [passwordLayer setFrame:CGRectMake(0, _passwordField.height-1, _passwordField.width, textFieldLayerDefaultHeight)];
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
