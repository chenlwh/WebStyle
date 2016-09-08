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
#import "UserCenterHeader.h"
#import "UserCenterBaseCell.h"


typedef enum {
    UserCentenrRowStyleMyLike = 0,
    UserCentenrRowStyleMyAccount,
    UserCentenrRowStyleSuggestion,
    UserCentenrRowStyleContactMe
}UserCentenrRowStyle;

@interface MyProfieViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *customNaviView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UserCenterHeader *pUserCenterHeaderView;
@end
@implementation MyProfieViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
//    [self setStatusBarLight];
    [self setNav];
    [self createTableView];
    
    /*http://bbs.csdn.net/topics/391833162 解释UITableView 与 UITableWarapperView 的 高度差*/
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
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
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    //    [self.tableView setBackgroundColor: RGBACOLORFromRGBHex(0xf6f6f6)];
//    [self.tableView setBackgroundColor:[UIColor greenColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    self.tableView.scrollsToTop = true;
    self.tableView.sectionHeaderHeight = 0.1f;
    [self.view insertSubview:self.tableView belowSubview:self.customNaviView];
    
    CGRect frame = CGRectMake(0.0f, 0.0f,self.view.width,self.view.width * 0.7);
    self.pUserCenterHeaderView = [[UserCenterHeader alloc] initWithFrame:frame];
    self.pUserCenterHeaderView.backgroundColor = [UIColor lightGrayColor];
    
    [self.tableView setTableHeaderView:self.pUserCenterHeaderView];
}



-(void)settingClick
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    D_Log(@"%@", scrollView);
}

#pragma mark UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return UserCentenrRowStyleContactMe + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UserCenterBaseCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentfier = @"userCenterBaseCell";
    UserCenterBaseCell *pUserCenterBaseCell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
    
    if (pUserCenterBaseCell == nil) {
        pUserCenterBaseCell = [[UserCenterBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfier];
        pUserCenterBaseCell.backgroundColor = [UIColor clearColor];
        pUserCenterBaseCell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if(indexPath.row == UserCentenrRowStyleMyLike)
    {
        pUserCenterBaseCell.hasDescription = YES;
        [pUserCenterBaseCell setDescriptionWithText:@"你收集的都在这儿"];
        [pUserCenterBaseCell setIconName:@"my_like" title:@"我的收藏"];
    }
    else if(indexPath.row == UserCentenrRowStyleMyAccount)
    {
        pUserCenterBaseCell.hasDescription = NO;
        [pUserCenterBaseCell setIconName:@"my_jjfk" title:@"账号设置"];
    }
    else if (indexPath.row == UserCentenrRowStyleSuggestion)
    {
        pUserCenterBaseCell.hasDescription = NO;
        [pUserCenterBaseCell setIconName:@"my_jjfk" title:@"意见反馈"];
    }
    else if(indexPath.row == UserCentenrRowStyleContactMe)
    {
        pUserCenterBaseCell.hasDescription = NO;
        [pUserCenterBaseCell setIconName:@"my_lxwm" title:@"联系客服"];
    }
    else
    {
        ;
    }
    
    return pUserCenterBaseCell;
        
}

@end
