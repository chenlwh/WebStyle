//
//  MyProfieViewController.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "MyProfieViewController.h"
#import "UIBarButtonItem+CustomInit.h"
#import "UIView+Gewara.h"

@interface MyProfieViewController()

@property (nonatomic, strong) UIView *customNaviView;
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation MyProfieViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
//    [self setStatusBarLight];
    [self setNav];
    [self createTableView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarLight];
}
//-(void) setNav
//{
//    self.navigationItem.title = @"我的";
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImageName:@"setting_2" HighlightedImageName:@"setting_1" Target:self Action:@selector(settingClick)];
//}

-(void)setNav
{
    self.navigationController.navigationBar.hidden = true;
    
    self.customNaviView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusHegiht, self.view.width, kNaviHeight)];
    self.customNaviView.backgroundColor = AppMainColor;
    //    [UIColor blueColor];
//    self.customNaviView.delegate = self;
    [self.view addSubview:self.customNaviView];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"我的";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:16.0f];
    [titleLab sizeToFit];
    [self.customNaviView addSubview:titleLab];
    titleLab.left = (self.customNaviView.width - titleLab.width)/2;
    titleLab.top = (self.customNaviView.height - titleLab.height)/2;
//    titleLab.center = self.customNaviView.center;
    D_Log(@"%@", titleLab);
}

-(void)createTableView
{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, kStatusHegiht + kNaviHeight , self.view.width, self.view.height - kStatusHegiht - kNaviHeight) style:UITableViewStylePlain];
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;
    //    [self.tableView setBackgroundColor: RGBACOLORFromRGBHex(0xf6f6f6)];
    [self.tableView setBackgroundColor:[UIColor greenColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    self.tableView.scrollsToTop = true;
    //    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.tableView belowSubview:self.customNaviView];
    
//    [self.tableView setTableHeaderView:self.headView];
}



-(void)settingClick
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
@end
