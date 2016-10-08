//
//  AppDelegate.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "MainTabBarController.h"
#import "WSAppcontext.h"
#import "WSAppContext+WSLogin.h"
#import <ALBBSDK/ALBBSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setAliBBInfo];
    [self setKeyWindow];
    [self setAppAppearance];
    
    //处理自动登录
    [[WSAppContext appContext] autoLogin];
    
    
    return YES;
}

//当一次时返回引导页， 以后返回主页；
-(UIViewController*)showLeadpage
{
    return [MainTabBarController new];
}

//设置阿里配置
-(void) setAliBBInfo
{
    [[ALBBSDK sharedInstance] setDebugLogOpen:NO];//开发阶段打开日志开关，方便排查错误信息
    [[ALBBSDK sharedInstance] setUseTaobaoNativeDetail:YES];//优先使用手淘APP打开商品详情页面，如果没有安装手机淘宝，SDK会使用H5打开
    [[ALBBSDK sharedInstance] setViewType:ALBB_ITEM_VIEWTYPE_TAOBAO];//使用淘宝H5页面打开商品详情
    [[ALBBSDK sharedInstance] setISVCode:@"webstyle_1.0"];//设置全局的app标识，在电商模块里等同于isv_code,可以用来跟踪交易订单
    //基础SDK初始化
    [[ALBBSDK sharedInstance] asyncInit:^{
        NSLog(@"init success");
    } failure:^(NSError *error) {
        NSLog(@"init failure, %@", error);
    }];
}

-(void) setKeyWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[Constants MainBounds]];
    [self.window setRootViewController:[self showLeadpage]];
    [self.window makeKeyAndVisible];
}


-(void)setAppAppearance
{
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                             forState:UIControlStateNormal];
    
    //    UINavigationBar *naviBarAppearance = [UINavigationBar appearance];
    //    naviBarAppearance.translucent = false;
    //    naviBarAppearance.titleTextAttributes = @{NSFontAttributeName:[Constants SDNavTitleFont], NSForegroundColorAttributeName:[UIColor blackColor]};
    //    naviBarAppearance.backgroundColor = [UIColor blueColor];
    
    id item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSFontAttributeName: [Constants SDNavItemFont], NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL isHandledByALBBSDK=[[ALBBSDK sharedInstance] handleOpenURL:url];//处理其他app跳转到自己的app，如果百川处理过会返回YES
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    BOOL isHandledByALBBSDK=[[ALBBSDK sharedInstance] handleOpenURL:url];//处理其他app跳转到自己的app，如果百川处理过会返回YES
    
    return YES;
}


@end
