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
#import "UIImage+Utils.h"
#import "GWNewUserCenterTopCell.h"
#import "WSAppContext+WSLogin.h"
#import "LogingViewController.h"

#define kTopHeightRatio 0.65
//    UserCentenrRowStyleMyLike = 0
typedef enum {
    UserCentenrRowStyleMyAccount = 0,
    UserCentenrRowStyleSuggestion,
    UserCentenrRowStyleContactMe
}UserCentenrRowStyle;

@interface MyProfieViewController()<UITableViewDelegate, UITableViewDataSource, UserCenterHeaderDelegate>

@property (nonatomic, strong) UIView *customNaviView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UserCenterHeader *pUserCenterHeaderView;

@property (nonatomic, strong) UIView *bottomCoverView; // 头部滚动视图
@property (nonatomic, strong) UIImageView *scrollImageView; // 滚动图片

@end
@implementation MyProfieViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
//    [self setStatusBarLight];
    [self setNav];
    [self createTableView];
    [self createBottomScrollView];
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
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    self.tableView.scrollsToTop = true;
    self.tableView.sectionHeaderHeight = 0.1f;
    [self.view insertSubview:self.tableView belowSubview:self.customNaviView];
    
    CGRect frame = CGRectMake(0.0f, 0.0f,self.view.width,self.view.width * kTopHeightRatio);
    self.pUserCenterHeaderView = [[UserCenterHeader alloc] initWithFrame:frame];
    self.pUserCenterHeaderView.backgroundColor = [UIColor clearColor];
    self.pUserCenterHeaderView.delegate = self;
    [self.tableView setTableHeaderView:self.pUserCenterHeaderView];
}

- (void)createBottomScrollView
{
    CGFloat fCoverHeight = self.view.width * kTopHeightRatio;
    self.bottomCoverView = [[UIView alloc] init];
    self.bottomCoverView.clipsToBounds = YES;
    self.bottomCoverView.frame = CGRectMake(0.0f, kStatusHegiht + kNaviHeight, self.view.frame.size.width, fCoverHeight);
    [self.view insertSubview:self.bottomCoverView belowSubview:self.tableView];
    
    UIImageView *tempUserImageView = [[UIImageView alloc] init];
    tempUserImageView.contentMode = UIViewContentModeScaleAspectFill;
    tempUserImageView.clipsToBounds = YES;
    tempUserImageView.frame = CGRectMake(0, 0, self.view.width, fCoverHeight);
    tempUserImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.scrollImageView = tempUserImageView;
    [self.bottomCoverView addSubview:tempUserImageView];
    
//    if (self.currentRecommendInfo.hasHeaderImage) {
//        [self changeCurrentScrollImageWidth];
//    } else {
//        [self changeScrollViewWithImage:[GWMovieImage imageDefaultUserHeader] blurLevel:0.3];
//    }
    
    self.scrollImageView.image = [UIImage blurryImage:[UIImage imageNamed:@"icon_defaultAvatar"] withBlurLevel:0.3];
    self.scrollImageView.width = self.view.width;
    
    
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5f;
    blackView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    blackView.userInteractionEnabled = NO;
    blackView.frame = CGRectMake(0, 0, self.bottomCoverView.width, fCoverHeight);
    [self.bottomCoverView addSubview:blackView];
    [self.bottomCoverView bringSubviewToFront:blackView];
}

-(void)settingClick
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)userCenterUserLoginFunction
{
    __weak typeof(self) bself = self;
    [[GWLogin sharedInstance] showLoginWithCancelHandler:^(BOOL success) {
        
    } LoginFinishHandler:^(BOOL success) {
//        [bself operateAfterUserLogin];
    }];
}




#pragma mark UITableViewDataSource && UITableViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    D_Log(@"%@", scrollView);
    [self updateImagePosition:scrollView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 10;
    }
    return 0.1f;
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return UserCentenrRowStyleContactMe + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return kUserCenterTopCellHeight;
    }
    else if(indexPath.section == 1)
    {
        return UserCenterBaseCellHeight;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"GWNewUserCenterTopCell";
        
        GWNewUserCenterTopCell *pNewUserCenterTopCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (pNewUserCenterTopCell == nil)
        {
            pNewUserCenterTopCell = [[GWNewUserCenterTopCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                  reuseIdentifier:cellIdentifier];
//            pNewUserCenterTopCell.delegate = self;
            pNewUserCenterTopCell.backgroundColor = [UIColor clearColor];
            pNewUserCenterTopCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return pNewUserCenterTopCell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *cellIdentfier = @"userCenterBaseCell";
        UserCenterBaseCell *pUserCenterBaseCell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
        
        if (pUserCenterBaseCell == nil) {
            pUserCenterBaseCell = [[UserCenterBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfier];
            pUserCenterBaseCell.backgroundColor = [UIColor clearColor];
            pUserCenterBaseCell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
//        if(indexPath.row == UserCentenrRowStyleMyLike)
//        {
//            pUserCenterBaseCell.hasDescription = YES;
//            [pUserCenterBaseCell setDescriptionWithText:@"你收集的都在这儿"];
//            [pUserCenterBaseCell setIconName:@"my_like" title:@"我的收藏"];
//        }
//        else
        if(indexPath.row == UserCentenrRowStyleMyAccount)
        {
            pUserCenterBaseCell.hasDescription = NO;
            [pUserCenterBaseCell setIconName:@"my_account" title:@"账号设置"];
        }
        else if (indexPath.row == UserCentenrRowStyleSuggestion)
        {
            pUserCenterBaseCell.hasDescription = NO;
            [pUserCenterBaseCell setIconName:@"my_yjfk" title:@"意见反馈"];
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
    return nil;
}

- (void)updateImagePosition:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat fInitTop = kStatusHegiht + kNaviHeight;
    _bottomCoverView.top = fInitTop - offsetY;
//    if (offsetY <= 0)
//    {
//        _bottomCoverView.top = 0;
//        _bottomCoverView.height = self.view.width * kTopHeightRatio + ABS(offsetY);
//        _bottomCoverView.width = self.view.width + ABS(offsetY);
//    }
//    else
//    {
//        _bottomCoverView.top = -offsetY;
//        _bottomCoverView.height = self.view.width * kTopHeightRatio;
//        _bottomCoverView.width = self.view.width;
//    }
}

#pragma mark GWNewUserCenterTopCelllDelegate

- (void)userCenterTopCell:(GWNewUserCenterTopCell *)userCenterTopCell clickWithStyle:(GWUserCenterTopCellStyle)topCellStyle
{
    if(topCellStyle == GWUserCenterTopCellMyFavorStyle)
    {
        D_Log(@"我喜欢的视频");
    }
    else if (topCellStyle == GWUserCenterTopCellMyViedoStyle)
    {
        D_Log(@"我的视频");
    }
    else if (topCellStyle == GWUserCenterTopCellPostVideoStyle)
    {
        D_Log(@"发布视频");
    }
}

#pragma mark UserCenterHeaderDelegate

- (void)editButtonClick:(UserCenterHeader *)userCenterHeaderView
{
    if(![[WSAppContext appContext] isLoging])
    {
        [self userCenterUserLoginFunction];
        return;
    }
    
    //跳转到个人信息编辑界面；
    
}

@end
