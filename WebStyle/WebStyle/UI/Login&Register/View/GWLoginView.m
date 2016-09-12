//
//  GWLoginView.m
//  GWMovie
//
//  Created by Chenyao Cai on 15/3/17.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWLoginView.h"
//#import "BudleImageCache+GWMovie.h"
#import "UIView+Gewara.h"
#import "UIViewController+Alert.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "FTUtils.h"
//#import "GWMovieTheme.h"
//#import "GWMovieComUtils.h"
//#import "GWLoginInfo.h"
//#import <TencentOpenAPI/QQApiInterface.h>

@interface GWLoginView ()
{
    CALayer *nameLayer;
    CALayer *passwordLayer;
    
}
@property (nonatomic,strong) UIColor*defaultColor;
@end


@implementation GWLoginView

+(GWLoginView*)createNewLoginView:(CGRect)frame
{
    GWLoginView * view =  [[[NSBundle mainBundle] loadNibNamed:@"GWLoginView" owner:nil options:nil] lastObject];
    view.frame = frame;
    [view loadAllControlers];
    return view;
}
-(void)loadAllControlers
{
    
    self.weixinButton.hidden = YES;
    //self.qqButton.hidden = ![QQApi isQQInstalled];//QQ网页认证好了，所以把他打开，之前是应为网页登录不行才隐藏的

    
    [self setBackgroundColor:[UIColor clearColor]];
    [self addTarget:self action:@selector(resignALL) forControlEvents:UIControlEventTouchUpInside];
    
    _nameField.leftView = [self addLeftView:@"icon_userid"];
    _nameField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_nameField setTintColor:defaultTextColor];
    [_nameField setTextColor:defaultTextColor];
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    [_nameField setBackgroundColor:[UIColor clearColor]];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮箱、手机号" attributes:@{NSForegroundColorAttributeName:textfieldLayerDefaultColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
//    GWLoginInfo *lastInfo = [GWMovieComUtils readLastLoginInfo];
//    if ((lastInfo.logInfoType == AutoLoginInfoTypeGewara)&& (lastInfo.username.length > 0)) {
//        _nameField.text = lastInfo.username;
//    }
    
    
    nameLayer = [[CALayer alloc] init];
    [nameLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [_nameField.layer addSublayer:nameLayer];
    
    passwordLayer = [[CALayer alloc] init];
    [passwordLayer setBackgroundColor:textfieldLayerDefaultColor.CGColor];
    [_passwordField.layer addSublayer:passwordLayer];
    
    _passwordField.leftView = [self addLeftView:@"icon_password2"];
    _passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_passwordField setTintColor:defaultTextColor];
    [_passwordField setTextColor:defaultTextColor];
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    [_passwordField setBackgroundColor:[UIColor clearColor]];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:textfieldLayerDefaultColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [_passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_enterButton setBackgroundColor:[UIColor clearColor]];
    _enterButton.layer.cornerRadius = 2;
    _enterButton.clipsToBounds = YES;
    _enterButton.layer.borderColor = defaultTextColor.CGColor;
    _enterButton.layer.borderWidth = textFieldLayerDefaultHeight;
    [_enterButton setTitleColor:defaultTextColor forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_enterButton setTitle:@"登录" forState:UIControlStateNormal];
    [self changeButtonStatus:NO];
    
    [self.quickRegister setTitleColor:defaultTextColor forState:UIControlStateNormal];
    [self.passwordFind setTitleColor:defaultTextColor forState:UIControlStateNormal];
    [self.thirdLabel setTextColor:defaultTextColor];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _nameField.width = self.width - 40;
    _nameField.height = 40;
    _nameField.left = 20;
    _nameField.top = 20;
    [nameLayer setFrame:CGRectMake(0, _nameField.height -1, _nameField.width, textFieldLayerDefaultHeight)];
    
    _passwordField.width = self.width -40;
    _passwordField.height = 40;
    _passwordField.left = 20;
    _passwordField.top = _nameField.bottom + 10;
    [passwordLayer setFrame:CGRectMake(0, _passwordField.height-1, _passwordField.width, textFieldLayerDefaultHeight)];
    
    self.passwordFind.width = 60;
    self.passwordFind.height = 30;
    self.passwordFind.left = 30;
    self.passwordFind.top = _passwordField.bottom + 10;
    
    self.quickRegister.width = 60;
    self.quickRegister.height = 30;
    self.quickRegister.right = self.width - 30;
    self.quickRegister.top = _passwordField.bottom + 10;
    
    self.enterButton.width = self.nameField.width;
    self.enterButton.height = 45;
    self.enterButton.left = self.nameField.left;
    self.enterButton.top = self.quickRegister.bottom + 10;
    
    self.thirdLabel.left = 30;
    self.thirdLabel.width =70;
    self.thirdLabel.height = 20;
    self.thirdLabel.bottom = self.height - 35;
    
    CGFloat width = self.width - self.thirdLabel.right - 4*self.weixinButton.width;
    CGFloat peace = width/17;
    CGFloat right = self.thirdLabel.right;
    CGFloat center = self.thirdLabel.centerY;
    self.weixinButton.left = right + 4*peace;
    self.weixinButton.centerY = center;
    right += self.weixinButton.width + 4*peace;
    self.sinaButton.left = right + 3*peace;
    self.sinaButton.centerY = center;
    right += self.sinaButton.width + 3*peace;
    self.qqButton.left = right + 3*peace;
    self.qqButton.centerY = center;
    right += self.qqButton.width + 3*peace;
    self.alipayButton.left = right + 3*peace;
    self.alipayButton.centerY = center;
    
    CGRect rect0 = self.weixinButton.frame;
    CGRect rect1 = self.sinaButton.frame;
    CGRect rect2 = self.qqButton.frame;
    CGRect rect3 = self.alipayButton.frame;
    
    NSMutableArray *rectArr = [NSMutableArray array];
    [rectArr addObject:[NSValue valueWithCGRect:rect0]];
    [rectArr addObject:[NSValue valueWithCGRect:rect1]];
    [rectArr addObject:[NSValue valueWithCGRect:rect2]];
    [rectArr addObject:[NSValue valueWithCGRect:rect3]];
    
    NSMutableArray *btnArr = [NSMutableArray array];
    if (!self.weixinButton.hidden) {
        [btnArr addObject:self.weixinButton];
    }
    [btnArr addObject:self.sinaButton];
    if (!self.qqButton.hidden) {
        [btnArr addObject:self.qqButton];
    }
    [btnArr addObject:self.alipayButton];
    
    
    for (NSInteger idx = 0; idx < btnArr.count; idx++) {
        UIView *btnView = [btnArr objectAtIndex:idx];
        NSValue *val = rectArr[idx];
        btnView.frame = [val CGRectValue];
    }
    
    
    self.weixinButton.clipsToBounds = YES;
    self.qqButton.clipsToBounds = YES;
    self.sinaButton.clipsToBounds = YES;
    self.alipayButton.clipsToBounds = YES;
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
-(void)resignALL
{
    [self.nameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
- (IBAction)alipayMethod:(id)sender {
    if ([self.delegate respondsToSelector:@selector(alipayButtonClicked)]) {
        [self.delegate alipayButtonClicked];
    }
}
- (IBAction)qqMethod:(id)sender {
    if ([self.delegate respondsToSelector:@selector(qqButtonClicked)]) {
        [self.delegate qqButtonClicked];
    }
}
- (IBAction)sinaMethod:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sinaButtonClicked)]) {
        [self.delegate sinaButtonClicked];
    }
}
- (IBAction)weixinMethods:(id)sender {
    if ([self.delegate respondsToSelector:@selector(weixinButtonClicked)]) {
        [self.delegate weixinButtonClicked];
    }
}
- (IBAction)passwordMethod:(id)sender {
    if ([self.delegate respondsToSelector:@selector(passwordFindClicked)]) {
        [self.delegate passwordFindClicked];
    }
}
- (IBAction)quickRegistMethod:(id)sender {
    if ([self.delegate respondsToSelector:@selector(quickRegisterClicked)]) {
        [self.delegate quickRegisterClicked];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self defaultLayer];
    if (textField == _nameField) {
        [nameLayer setBackgroundColor:textfieldLayerSelectColor.CGColor];
        [nameLayer setFrame:CGRectMake(0, _nameField.height -1, _nameField.width, textFieldLayerSelectHeight)];
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
    [nameLayer setFrame:CGRectMake(0, _nameField.height -1, _nameField.width, textFieldLayerDefaultHeight)];
    [passwordLayer setFrame:CGRectMake(0, _passwordField.height-1, _passwordField.width, textFieldLayerDefaultHeight)];
}
-(void)enterButtonClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(enterReturn)]) {
        [self.delegate enterReturn];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameField) {
        [_nameField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }
    if (textField == _passwordField) {
        [_passwordField resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(enterReturn)]) {
            [self.delegate enterReturn];
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
    if (self.nameField.text.length == 0) {
        check =NO;
    }else if (self.passwordField.text.length ==0) {
        check = NO;
    }
    return check;
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
