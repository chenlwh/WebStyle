//
//  LogingViewController.m
//  WebStyle
//
//  Created by liudan on 9/12/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "LogingViewController.h"
#import "GWDoubleFadeView.h"
#import "UIViewController+Alert.h"
#import "AFHTTPRequestOperationManager.h"
#import "UrlDefine.h"
#import "JSONKit.h"

#define topHeight self.view.height*3/5 > 288 ? self.view.height*2/5 : self.view.height/4+50;

#define textlineColor RGBACOLORFromRGBHex(0x5f5f5f)

typedef enum{
    viewTypeLogin = 0,
    viewTypePassword,
    viewTypeRegist
}viewType;

typedef enum{
    backtoNull = 0,
    backtoLogin,
    backtopassword,
    backtoregist,
    backtodismiss
}backwayType;

@implementation GWLogin

+ (id)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}


/**
 *  显示登录画面
 */
- (void)showLoginWithCancelHandler:(void(^)(BOOL success))loginCancelHandler
                LoginFinishHandler:(void(^)(BOOL success))loginFinishHandler
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [self showLoginWithCancelHandler:loginCancelHandler
                  LoginFinishHandler:loginFinishHandler
                  rootViewController:keyWindow.rootViewController];
}

- (void)showLoginWithCancelHandler:(void(^)(BOOL success))loginCancelHandler
                LoginFinishHandler:(void(^)(BOOL success))loginFinishHandler
                rootViewController:(UIViewController*)aRootViewController;
{
    LogingViewController *loginViewController = [[LogingViewController alloc] init];
    
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    UIViewController* presentViewController = [aRootViewController vaildPresentedViewController];
    
    [presentViewController presentViewController:rootViewController animated:YES completion:nil];
    
//    [loginViewController setLoginCancelHandler:^(BOOL success){
//        if (success) {
//        }
//        
//        if (loginCancelHandler) {
//            loginCancelHandler(success);
//        }
//    }];
//    
//    [loginViewController setLoginFinishHandler:^(BOOL success) {
//        if (loginFinishHandler) {
//            loginFinishHandler(success);
//        }
//    }];
}


@end



@interface LogingViewController ()<GWLoginDelegate, GWRegisterViewDelegate, GWPasswordFindViewDelegate>

@property (nonatomic, assign) double animationDuration;
@property (nonatomic, assign) CGRect keyboardRect;

@property (nonatomic,assign) backwayType backway;
@property (nonatomic,assign) BOOL hung;
@property (nonatomic,assign) viewType currentType;


@property (nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UIImageView *logoImage;
@property (nonatomic,strong) UIScrollView *backScroller;

@end

@implementation LogingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    GWLoginInfo *loginInfo = [GWMovieComUtils readGWLoginInfo];
//    if (loginInfo) {
//        self.loginView.nameField.text = loginInfo.username;
//        self.loginView.passwordField.text = loginInfo.password;
//    }
    GWDoubleFadeView *backView = [[GWDoubleFadeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backView];
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(resignALL) forControlEvents:UIControlEventTouchUpInside];
    [control setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:control];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(20,20, 30, 30)];
    [self.backButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.backButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.backButton setTitleColor:textlineColor forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.logoImage= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    self.logoImage.centerX = self.view.width /2;
    self.logoImage.centerY = self.view.height*2/5 - 90;
    self.logoImage.layer.cornerRadius = 15;
    self.logoImage.clipsToBounds = YES;
    [self.logoImage setImage:[UIImage imageNamed:@"icon_60.png"]];
    [self.view addSubview:self.logoImage];
    
    CGFloat top = [self getTopHeight];
    self.backScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, self.view.width, self.view.height-top)];
    [self.backScroller setBackgroundColor:[UIColor clearColor]];
    [self.backScroller setContentSize:CGSizeMake(self.backScroller.width*3, self.backScroller.height)];
    [self.backScroller setContentOffset:CGPointMake(self.backScroller.width,0)];
    [self.backScroller setPagingEnabled:YES];
    [self.backScroller setScrollEnabled:NO];
    [self.view addSubview:self.backScroller];
    
    self.loginView = [GWLoginView createNewLoginView:CGRectMake(self.backScroller.width, 0,self.backScroller.width, self.backScroller.height)];
    self.loginView.delegate = self;
    [self.backScroller addSubview:self.loginView];
    self.passwordFindView = [GWPasswordFindView createView:CGRectMake(0, 0, self.backScroller.width, self.backScroller.height)];
    self.passwordFindView.deletgate = self;
    [self.backScroller addSubview:self.passwordFindView];
    self.registerView = [GWRegisterView createView:CGRectMake(self.backScroller.width*2, 0, self.backScroller.width, self.backScroller.height)];
    self.registerView.delegate = self;
    [self.backScroller addSubview:self.registerView];
    
    self.currentType = viewTypeLogin;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self updateStatusBar];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setStatusBarDefault];
    
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
//                                                animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

-(CGFloat)getTopHeight
{
    CGFloat top = topHeight;
    if (IS_IPHONE_3P5_INCH) {
        top = top - 45;
    }else if (IS_IPHONE_4_INCH) {
        top = top - 20;
    }
    return top;
}

-(void)resignALL
{
    D_Log(@"%@ %@", self, NSStringFromSelector(_cmd));
//    [self.loginView resignALL];
//    [self.passwordFindView resignALL];
//    [self.registerView resignALL];
}

-(void)dismissView:(id)sender
{
    D_Log(@"%@ %@", self, NSStringFromSelector(_cmd));
//    if (self.loginCancelHandler) {
//        self.loginCancelHandler(YES);
//    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)updateStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [UIView animateWithDuration:0.3f animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }
}

-(void)doLogin
{
    D_Log(@"%@ %@", self, NSStringFromSelector(_cmd));
    NSString *name = self.loginView.nameField.text;
    NSString *passwd = self.loginView.passwordField.text;
    [self startLoading];
    [self.view bringSubviewToFront:self.backButton];
    
    WeakObjectDef(self);
    NSString * urlString = [NSString stringWithFormat:@"%@name=%@&pwd=%@", kLoginMethod, name, passwd];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    D_Log(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [weakself stopLoading];
        D_Log(@"%@", operation.responseString);
        D_Log(@"%@", operation.responseString);
        NSDictionary *dict = [operation.responseString objectFromJSONString];
        if([dict[@"code"] isEqualToString:@"02"])
        {
            //注册成功；
            [weakself showAutoHideToastWithString:@"登录成功"];
        }
        else  if ([dict[@"code"] isEqualToString:@"01"])
        {
            [weakself showAutoHideToastWithString:@"用户名或密码不正确"];
        }
        else if ([dict[@"code"] isEqualToString:@"03"])
        {
            [weakself showAutoHideToastWithString:@"用户名不能为空"];
        }
        else if ([dict[@"code"] isEqualToString:@"04"])
        {
            [weakself showAutoHideToastWithString:@"密码不能为空"];
        }
        else
        {
            [weakself showAutoHideToastWithString:@"其他未知错误"];
        }
        /*
        if(error){
            if (error.code == 1) {
                [weakSelf showAutoHideToastWithString:@"网络连接发生错误!"];
            }else{
                [self showAutoHideToastWithString:error.localizedDescription];
            }
        }else{
            typeof(self) strongSelf = weakSelf;
            if(strongSelf){
                strongSelf->logged = YES;
            }
            [weakSelf stopLoading];
            
            GWLoginInfo *loginfo = [GWLoginInfo new];
            loginfo.logInfoType = AutoLoginInfoTypeGewara;
            loginfo.username = strongSelf.loginView.nameField.text;
            loginfo.password = strongSelf.loginView.passwordField.text;
            
            [weakSelf loginSucessedWithLogInfo:loginfo
                                      userInfo:result];
        }
         */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakself stopLoading];
        [weakself showAutoHideToastWithString:@"请求失败"];
        D_Log(@"请求失败");
    }];

    
}

-(void)doRegister
{
    D_Log(@"%@ %@", self, NSStringFromSelector(_cmd));
    NSString *name = self.registerView.nameField.text;
    NSString *passwd = self.registerView.passwordField.text;
    [self startLoading];
    [self.view bringSubviewToFront:self.backButton];
    WeakObjectDef(self);
    NSString * urlString = [NSString stringWithFormat:@"%@name=%@&pwd=%@", kRegisterMethod, name, passwd];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    D_Log(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakself stopLoading];
        D_Log(@"%@", operation.responseString);
        NSDictionary *dict = [operation.responseString objectFromJSONString];
        if([dict[@"code"] isEqualToString:@"02"])
        {
            //注册成功；
           [weakself showAutoHideToastWithString:@"注册成功"];
        }
//        else
//        {
//            NSString *des = dict[@"message"];
//            des = [des stringByRemovingPercentEncoding];
//            [weakself showAutoHideToastWithString:des];
//        }
      //  /*
        else if ([dict[@"code"] isEqualToString:@"01"])
        {
            [weakself showAutoHideToastWithString:@"用户名已经存在"];
        }
        else if ([dict[@"code"] isEqualToString:@"03"])
        {
            [weakself showAutoHideToastWithString:@"用户名不能为空"];
        }
        else if ([dict[@"code"] isEqualToString:@"04"])
        {
            [weakself showAutoHideToastWithString:@"密码不能为空"];
        }
        else
        {
            [weakself showAutoHideToastWithString:@"其他未知错误"];
        }
         //*/
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakself stopLoading];
        [weakself showAutoHideToastWithString:@"请求失败"];
        D_Log(@"请求失败");
    }];
}
#pragma mark - NSNotification

-(void)showAnimation:(void (^)(void))compelete
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.logoImage.width = 35;
        self.logoImage.height = 35;
        self.logoImage.centerX = self.view.width/2;
        self.logoImage.centerY = 50;
        self.logoImage.layer.cornerRadius = 7;
        
        
        self.backScroller.top = IS_IPHONE_3P5_INCH ? 65 : 120;
        
    }completion:^(BOOL finish){
        if (finish) {
            if (compelete) {
                compelete();
            }
        }
    }];
}
-(void)hidenAnimation:(void (^)(void))compelete
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.logoImage.width = 75;
        self.logoImage.height = 75;
        self.logoImage.centerX = self.view.width /2;
        self.logoImage.centerY = self.view.height*2/5 - 90;
        
        self.backScroller.top = [self getTopHeight];
    }completion:^(BOOL finish){
        if (finish) {
            if (compelete) {
                compelete();
            }
        }
    }];
}
/**
 *  键盘即将显示
 *
 *  @param n NSNotification
 */
- (void)keyboardWillShowNotification:(NSNotification *)note
{
    CGRect rect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardRect = rect;
    self.animationDuration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self showAnimation:nil];
}
/**
 *  键盘即将消失
 *
 *  @param n NSNotification
 */
- (void)keyboardWillHideNotification:(NSNotification *)note
{
    CGRect rect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardRect = rect;
    self.animationDuration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self hidenAnimation:nil];
}

/**
 *  键盘即将改变frame
 *
 *  @param n NSNotification
 */
- (void)keyboardWillChangeFrameNotification:(NSNotification *)note
{
    
}
-(void)keyboardDidShow:(NSNotification*)note
{
    self.hung = YES;
}
/**
 *  键盘完成显示
 *
 *  @param n NSNotification
 */
- (void)keyboardHidden:(NSNotification *)note
{
    [self movingMethod];
    self.hung = NO;
}

-(void)movingMethod
{
    if (self.backway == backtoNull) {
    }
    if (self.backway == backtodismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.backway == backtopassword) {
        self.currentType = viewTypePassword;
        [self.backScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (self.backway == backtoregist) {
        self.currentType = viewTypeRegist;
        [self.backScroller setContentOffset:CGPointMake(self.backScroller.width*2, 0) animated:YES];
    }
    if (self.backway == backtoLogin) {
        self.currentType = viewTypeLogin;
        [self.backScroller setContentOffset:CGPointMake(self.backScroller.width, 0) animated:YES];
    }
    self.backway = backtoNull;
    [self checkViewStatus];
}

-(void)checkViewStatus
{
    if (self.currentType == viewTypeLogin) {
        if ([self.loginView checkTextLength]) {
            [self.loginView changeButtonStatus:YES];
        }else{
            [self.loginView changeButtonStatus:NO];
        }
    }else if (self.currentType == viewTypePassword) {
        if ([self.passwordFindView checkTextLength]) {
            [self.passwordFindView changeButtonStatus:YES];
        }else{
            [self.passwordFindView changeButtonStatus:NO];
        }
    }else if (self.currentType == viewTypeRegist) {
        if ([self.registerView checkTextLength]) {
            [self.registerView changeButtonStatus:YES];
        }else{
            [self.registerView changeButtonStatus:NO];
        }
    }
}

#pragma mark GWLoginDelegate

-(void)changeStatus:(BOOL)status
{
    [self checkViewStatus];
}

-(void)passwordFindClicked
{
    self.backway = backtopassword;
    if (self.hung) {
        [self.passwordFindView.phoneField becomeFirstResponder];
    }
    [self movingMethod];
}
-(void)quickRegisterClicked
{
    self.backway = backtoregist;
    if (self.hung) {
        [self.registerView.phoneNumberField becomeFirstResponder];
    }
    [self movingMethod];
}

-(void)enterReturn
{
    [self.loginView.nameField resignFirstResponder];
    [self.loginView.passwordField resignFirstResponder];
    
    if ([self.loginView.nameField.text length]<=0) {
        [self showAutoHideToastWithString:@"用户名离家出走了咩"];
        return;
    }
    
    if ([self.loginView.passwordField.text length]<=0) {
        [self showAutoHideToastWithString:@"密码离家出走了咩"];
        return;
    }
    [self doLogin];
}

#pragma mark GWRegisterViewDelegate
-(void)verifyButtonTapped
{
//    if(self.registerView.phoneNumberField.text.length != 11){
//        [self alertWithMessage:@"请输入正确的手机号码"];
//        [self.registerView.phoneNumberField becomeFirstResponder];
//        return;
//    }
//    [self requestVerifyNumberWithMobile:self.registerView.phoneNumberField.text];
    
}
-(void)registerFinish
{
//    if(self.registerView.phoneNumberField.text.length != 11){
//        [self alertWithMessage:@"请输入正确的手机号码"];
//        [self.registerView.phoneNumberField becomeFirstResponder];
//        return;
//    }
//    if(self.registerView.checkNumberField.text.length == 0){
//        [self alertWithMessage:@"请输入验证码"];
//        [self.registerView.checkNumberField becomeFirstResponder];
//        return;
//    }
    if(self.registerView.nameField.text.length == 0){
        [self alertWithMessage:@"请输入正确的用户名"];
        [self.registerView.nameField becomeFirstResponder];
        return;
    }
    if(self.registerView.passwordField.text.length < 6){
        [self alertWithMessage:@"密码至少为6位"];
        [self.registerView.passwordField becomeFirstResponder];
        return;
    }
    
//    if (!self.registerView.checkButton.selected) {
//        [self alertWithMessage:@"你还没有同意协议内容"];
//        return;
//    }
    
    
    [self.registerView.phoneNumberField resignFirstResponder];
    [self.registerView.checkNumberField resignFirstResponder];
    [self.registerView.nameField resignFirstResponder];
    [self.registerView.passwordField resignFirstResponder];
    
//    [self checkNickName:self.registerView.checkNumberField.text];
    [self doRegister];

    
}
-(void)registerBackClicked
{
    self.backway = backtoLogin;
    if (self.hung) {
        [self.loginView.nameField becomeFirstResponder];
    }
    [self movingMethod];
}
-(void)showAgreement
{
//    GWAgreementViewController *agreementViewController = [[GWAgreementViewController alloc] init];
//    [self.navigationController pushViewController:agreementViewController animated:YES];
}
@end
