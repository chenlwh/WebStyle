//
//  MyProfieViewController.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "MyProfieViewController.h"
#import "UIBarButtonItem+CustomInit.h"

@implementation MyProfieViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
}

-(void) setNav
{
    self.navigationItem.title = @"我的";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImageName:@"setting_2" HighlightedImageName:@"setting_1" Target:self Action:@selector(settingClick)];
}

-(void)settingClick
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
@end
