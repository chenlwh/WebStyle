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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setKeyWindow];
    [self setAppAppearance];
    
    
    return YES;
}

//当一次时返回引导页， 以后返回主页；
-(UIViewController*)showLeadpage
{
    return [MainTabBarController new];
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

@end
