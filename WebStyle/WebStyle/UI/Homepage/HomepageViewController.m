//
//  HomepageViewController.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "HomepageViewController.h"
#import "UIBarButtonItem+CustomInit.h"
#import "HomepageScrollProvider.h"
#import "GWProviderDelegate.h"
#import "AFURLRequestSerialization.h"
#import "AFNetworking.h"
#import "XYString.h"
#import "PreferVideo.h"
#import "PreferPlayer.h"
#import "NSObject+MJKeyValue.h"
#import "HomepageHeaderView.h"
#import "UINavigationBar+Awesome.h"
#import "HomepageNaviBarView.h"
#import "SearchViewController.h"
#import "HomeTableHeaderView.h"
#import "PlayerScrollView.h"
#import "HomeNewPlayerVideoViewController.h"

@interface HomepageViewController()<UITableViewDelegate, UITableViewDataSource, GWProviderDelegate, CustomNaviBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomepageHeaderView *headView;
@property (nonatomic, strong) HomepageScrollProvider *topScrollProvider;
@property (nonatomic, strong) NSMutableArray *preferVideoArr;
@property (nonatomic, strong) NSMutableArray *preferPlayerArr;

//@property (nonatomic, strong) NSMutableArray *pNewPlayerVideoArr; //新主播视频
@property (nonatomic, strong) HomepageNaviBarView *customNaviView;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) HomeNewPlayerVideoViewController *pNewPlayerVideoVC;
@end

const NSString *playerList = @"主播列表";
const NSString *newPlayerVideo = @"新主播视频";

@implementation HomepageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor greenColor];
    [self createSectionArrayData];
    
    [self setNav];
    [self createTableView];
    
    [self createTopScrollRequest];
    [self createPreferPlayerRequest];
    [self createNewPlayerVideoRequest];
    
//    [self.tableView.header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarLight];
}

-(void)createSectionArrayData
{
    [self.sectionArray addObject:playerList];
    [self.sectionArray addObject:newPlayerVideo];
}

-(void)createTopScrollRequest
{
    
    WeakObjectDef(self);
    NSString * urlString = KPreferVideoURL;
    NSLog(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSArray *temArray  = [XYString getObjectFromJsonString:operation.responseString];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[PreferVideo mj_objectArrayWithKeyValuesArray:temArray]];
        weakself.preferVideoArr = arrayM;
        [weakself.headView setDataArray:weakself.preferVideoArr];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"请求失败");
//        [_myRefreshView endRefreshing];
    }];
}

-(void)createPreferPlayerRequest
{
    WeakObjectDef(self);
    NSString * urlString = KPreferPlayer;
    NSLog(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *temArray  = [XYString getObjectFromJsonString:operation.responseString];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[PreferPlayer mj_objectArrayWithKeyValuesArray:temArray]];
        weakself.preferPlayerArr = arrayM;
        [weakself.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"请求失败");
        //        [_myRefreshView endRefreshing];
    }];
}

-(void)createNewPlayerVideoRequest
{
    WeakObjectDef(self);
    NSString * urlString = kNewPlayerVideo;
    NSLog(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *temArray  = [XYString getObjectFromJsonString:operation.responseString];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[PreferVideo mj_objectArrayWithKeyValuesArray:temArray]];
//        weakself.pNewPlayerVideoArr = arrayM;
        weakself.pNewPlayerVideoVC.dataArray = arrayM;
        [weakself.pNewPlayerVideoVC.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"请求失败");
        //        [_myRefreshView endRefreshing];
    }];
}
-(void)setNav
{
    self.navigationController.navigationBar.hidden = true;
    
    self.customNaviView = [[HomepageNaviBarView alloc] initWithFrame:CGRectMake(0, kStatusHegiht, self.view.width, kNaviHeight)];
    self.customNaviView.backgroundColor = AppMainColor;
//    [UIColor blueColor];
    self.customNaviView.delegate = self;
    [self.customNaviView reloadView];
    [self.view addSubview:self.customNaviView];
    
}

-(void)createTableView
{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 20 + kNaviHeight, self.view.width, self.view.height - 20 - kNaviHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    [self.tableView setBackgroundColor: RGBACOLORFromRGBHex(0xf6f6f6)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    self.tableView.scrollsToTop = true;
    [self.view addSubview:self.tableView];
    
    [self.tableView setTableHeaderView:self.headView];
}


#pragma mark setter & getter

-(HomepageHeaderView*)headView
{
    if(!_headView)
    {
        _headView = [[HomepageHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 125)];
        _headView.backgroundColor = [UIColor greenColor];
    }
    return _headView;
}


-(NSMutableArray *)sectionArray
{
    if(!_sectionArray)
    {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return _sectionArray;
}

-(HomeNewPlayerVideoViewController*)pNewPlayerVideoVC
{
    if(!_pNewPlayerVideoVC)
    {
        _pNewPlayerVideoVC = [[HomeNewPlayerVideoViewController alloc] init];
        
    }
    
    return _pNewPlayerVideoVC;
}

#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *playerListIndentifier = @"playerListIndentifier";
    static NSString *newPlayerVideoIndentifier = @"newPlayerVideoIndentifier";
    NSString *sTmp = self.sectionArray[indexPath.section];
    if([playerList isEqualToString:sTmp])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:playerListIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:playerListIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        PlayerScrollView *scrollView = [cell.contentView viewWithTag:100];
        if(scrollView == nil)
        {
            scrollView = [[PlayerScrollView alloc] initWithFrame:CGRectZero];
//            WeakObjectDef(self);
//            [scrollView setSelectPeopleBlock:^(GWPeople *people) {
//            }];

        }
        
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        CGFloat offset = 8;
        scrollView.frame = CGRectMake(offset, 5, GWScreenW - offset * 2, kPeopleViewHeight);
        scrollView.personList = self.preferPlayerArr;
        scrollView.tag = 100;
        [cell.contentView addSubview:scrollView];
        
        return cell;
    }
    else if([newPlayerVideo isEqualToString:self.sectionArray[indexPath.section]])
    {
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:newPlayerVideoIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newPlayerVideoIndentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell addSubview:self.pNewPlayerVideoVC.view];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([playerList isEqualToString:self.sectionArray[section]])
    {
//        if([self actorList].count > 0)
//        {
//            return 10;
//        }
//        else
//        {
//            return 5;
//        }
        return 40;
    }
    else if([newPlayerVideo isEqualToString:self.sectionArray[section]])
    {
        return 40;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sTmp = self.sectionArray[indexPath.section];
    if([playerList isEqualToString:sTmp])
    {
//        if([self actorList].count == 0)
//        {
//            return 0;
//        }
//        else
//        {
//            return kPeopleViewHeight;
//        }
        return kPeopleViewHeight + 10;
    }
    else if([newPlayerVideo isEqualToString:sTmp])
    {
        return 300;
    }
        
    return 0.1;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* headerIndentifier = @"HomeHeaderIndentifier";
    HomeTableHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIndentifier];
    if (headView == nil)
    {
        headView = [[HomeTableHeaderView alloc] initWithReuseIdentifier:headerIndentifier withViewWidth:self.tableView.width];
        [headView.allButton addTarget:self action:@selector(pushToDetailViewController) forControlEvents:UIControlEventTouchUpInside];

        headView.contentView.backgroundColor = [UIColor redColor];
    }
    [headView.titleLabel setText:self.sectionArray[section]];
    [headView.titleLabel sizeToFit];
    [headView.titleLabel setCenter:CGPointMake(0, headView.orangeView.center.y)];
    headView.titleLabel.left = headView.orangeView.right + 15;
    headView.allButton.centerY = headView.titleLabel.centerY;
    return headView;
}


#pragma mark CustomNaviDelegate
-(void)naviBarsearchBtnClick
{
    D_Log(@"search");
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    
    searchVc.navBarColor = RGBACOLORFromRGBHex(0xeb611f);
    
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:searchVc];
    [self presentViewController:navVc animated:YES completion:^(){
    }];
//    UISearchController *searchVC = [UISearchController new];
//    [self presentViewController:searchVC animated:true completion:nil];
//    [self.navigationController pushViewController:searchVC animated:true];
}
-(void) AppNameBtnClick
{
     D_Log(@"AppNameBtnClick");
}


#pragma mark 点击事件
-(void)pushToDetailViewController
{
    D_Log(@"pushToDetailViewController");
}
@end
