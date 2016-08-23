//
//  MainTabBarController.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "HomepageViewController.h"
#import "MyProfieViewController.h"

@implementation MainTabBarController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.translucent = false;
    
    [self setUpAllChildViewController];
}


-(void) setUpAllChildViewController
{
    [self tabBarAddChildVC:[HomepageViewController new] Title:@"首页" DefaultImageName:@"homepage_1" SelectedImageName:@"homepage_2"];
    [self tabBarAddChildVC:[MyProfieViewController new] Title:@"我的" DefaultImageName:@"my_1" SelectedImageName:@"my_2"];
}

-(void)tabBarAddChildVC:(UIViewController *)vc
                  Title:(NSString* )title
       DefaultImageName:(NSString*)defaultImage
      SelectedImageName:(NSString*)selectedImage
{
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                  image:[UIImage imageNamed:defaultImage]
                                          selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
