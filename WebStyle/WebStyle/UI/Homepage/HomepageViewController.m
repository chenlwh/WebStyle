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
#import "UINavigationBar+Awesome.h"
#import "SearchViewController.h"
#import "HomeTableHeaderView.h"
#import "PlayerScrollView.h"
#import "HomeNewPlayerVideoViewController.h"
#import "HomeHotPlayerVideoViewController.h"
#import "HomeTopVideoViewController.h"
#import "UrlDefine.h"

#import "HomepageViewController+GradientNaviBar.h"


@interface HomepageViewController()<UITableViewDelegate, UITableViewDataSource, GWProviderDelegate, CustomNaviBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HomepageScrollProvider *topScrollProvider;
@property (nonatomic, strong) NSMutableArray *preferVideoArr;
@property (nonatomic, strong) NSMutableArray *preferPlayerArr;

//@property (nonatomic, strong) NSMutableArray *pNewPlayerVideoArr; //新主播视频
//@property (nonatomic, strong) HomepageNaviBarView *customNaviView;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) HomeNewPlayerVideoViewController *pNewPlayerVideoVC;
@property (nonatomic, strong) HomeHotPlayerVideoViewController *pHotPlayerVideoVC;
@property (nonatomic, strong) HomeTopVideoViewController *pTopVideoVC;

@end

const NSString *playerList = @"主播列表";
const NSString *newPlayerVideo = @"新主播视频";
const NSString *hotPlayerVideo = @"大主播视频";
const NSString *topVideo = @"视频排行";


@implementation HomepageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSectionArrayData];
    
    [self setNav];
    [self createTableView];
    
    [self createTopScrollRequest];
    [self createPreferPlayerRequest];
    [self createNewPlayerVideoRequest];
    [self createHotPlayerVideoRequest];
    [self createTopVideoRequest];
    
//    [self.tableView.header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self setStatusBarLight];
//    [self setGradientColorBarLight:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]];
    [self scrollViewDidScroll:self.tableView];
}

-(void)createSectionArrayData
{
    [self.sectionArray addObject:playerList];
    [self.sectionArray addObject:newPlayerVideo];
    [self.sectionArray addObject:hotPlayerVideo];
    [self.sectionArray addObject:topVideo];
}

-(void)createTopScrollRequest
{
    
    WeakObjectDef(self);
    NSString * urlString = KPreferVideoURL;
    D_Log(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSArray *temArray  = [XYString getObjectFromJsonString:operation.responseString];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[PreferVideo mj_objectArrayWithKeyValuesArray:temArray]];
        weakself.preferVideoArr = arrayM;
        [weakself.headView setDataArray:weakself.preferVideoArr];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D_Log(@"请求失败");
    }];
}

-(void)createPreferPlayerRequest
{
    WeakObjectDef(self);
    NSString * urlString = KPreferPlayer;
    D_Log(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *temArray  = [XYString getObjectFromJsonString:operation.responseString];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[PreferPlayer mj_objectArrayWithKeyValuesArray:temArray]];
        weakself.preferPlayerArr = arrayM;
        [weakself.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D_Log(@"请求失败");
    }];
}

-(void)createNewPlayerVideoRequest
{
    WeakObjectDef(self);
    NSString * urlString = kNewPlayerVideo;
    D_Log(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *temArray  = [XYString getObjectFromJsonString:operation.responseString];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[PreferVideo mj_objectArrayWithKeyValuesArray:temArray]];
        D_Log(@"kNewPlayerVideo count %lu", (unsigned long)arrayM.count);
        weakself.pNewPlayerVideoVC.dataArray = arrayM;
        [weakself.pNewPlayerVideoVC.collectionView reloadData];
        [weakself.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D_Log(@"请求失败");
        //        [_myRefreshView endRefreshing];
    }];
}

-(void)createHotPlayerVideoRequest
{
    WeakObjectDef(self);
    NSString * urlString = kHotPlayerVideo;
    D_Log(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *temArray  = [XYString getObjectFromJsonString:operation.responseString];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[PreferVideo mj_objectArrayWithKeyValuesArray:temArray]];
        D_Log(@"kHotPlayerVideo count %lu", (unsigned long)arrayM.count);
        weakself.pHotPlayerVideoVC.dataArray = arrayM;
        [weakself.pHotPlayerVideoVC.collectionView reloadData];
        [weakself.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D_Log(@"请求失败");
        //        [_myRefreshView endRefreshing];
    }];
}

-(void)createTopVideoRequest
{
    WeakObjectDef(self);
    NSString * urlString = kTopVideo;
    D_Log(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *temArray  = [XYString getObjectFromJsonString:operation.responseString];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[PreferVideo mj_objectArrayWithKeyValuesArray:temArray]];
        D_Log(@"kTopVideo count %lu", (unsigned long)arrayM.count);
        weakself.pTopVideoVC.dataArray = arrayM;
        [weakself.pTopVideoVC.collectionView reloadData];
        [weakself.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        D_Log(@"请求失败");
        //        [_myRefreshView endRefreshing];
    }];
}

-(void)setNav
{
    self.navigationController.navigationBar.hidden = true;
    
    self.customNaviView = [[HomepageNaviBarView alloc] initWithFrame:CGRectMake(0, kStatusHegiht, self.view.width, kNaviHeight)];
    self.customNaviView.backgroundColor = AppMainColor;
    [self.customNaviView setNaviBarAlpha:fThreshold];
//    [UIColor blueColor];
    self.customNaviView.delegate = self;
    [self.customNaviView reloadView];
    [self.view addSubview:self.customNaviView];
}

-(void)createTableView
{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, -20 , self.view.width, self.view.height+20 ) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    [self.tableView setBackgroundColor: RGBACOLORFromRGBHex(0xf6f6f6)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    self.tableView.scrollsToTop = true;
//    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.tableView belowSubview:self.customNaviView];
    
    [self.tableView setTableHeaderView:self.headView];
}


#pragma mark setter & getter

-(HomepageHeaderView*)headView
{
    if(!_headView)
    {
        _headView = [[HomepageHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 125+kNaviHeight)];
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



-(HomeHotPlayerVideoViewController*)pHotPlayerVideoVC
{
    if(!_pHotPlayerVideoVC)
    {
        _pHotPlayerVideoVC = [[HomeHotPlayerVideoViewController alloc] init];
        
    }
    
    return _pHotPlayerVideoVC;
}


-(HomeTopVideoViewController*)pTopVideoVC
{
    if(!_pTopVideoVC)
    {
        _pTopVideoVC = [[HomeTopVideoViewController alloc] init];
        
    }
    
    return _pTopVideoVC;
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
    else if([hotPlayerVideo isEqualToString:self.sectionArray[indexPath.section]])
    {
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:newPlayerVideoIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newPlayerVideoIndentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell addSubview:self.pHotPlayerVideoVC.view];
        }
        return cell;
    }
    else if([topVideo isEqualToString:self.sectionArray[indexPath.section]])
    {
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:newPlayerVideoIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newPlayerVideoIndentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell addSubview:self.pTopVideoVC.view];
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
    else if([hotPlayerVideo isEqualToString:self.sectionArray[section]])
    {
        return 40;
    }
    else if([topVideo isEqualToString:self.sectionArray[section]])
    {
        return 40;
    }
    else
    {
        return 0.1;
    }
    
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
        CGFloat linenumber = self.pNewPlayerVideoVC.dataArray.count%2 == 0 ? self.pNewPlayerVideoVC.dataArray.count/2 : self.pNewPlayerVideoVC.dataArray.count/2 + 1;
        return [self.pNewPlayerVideoVC updateViewHeightWithLineCount:linenumber];
    }
    else if([hotPlayerVideo isEqualToString:sTmp])
    {
        CGFloat linenumber = self.pHotPlayerVideoVC.dataArray.count%2 == 0 ? self.pHotPlayerVideoVC.dataArray.count/2 : self.pHotPlayerVideoVC.dataArray.count/2 + 1;
        return [self.pHotPlayerVideoVC updateViewHeightWithLineCount:linenumber];
    }
    else if([topVideo isEqualToString:sTmp])
    {
        CGFloat linenumber = self.pTopVideoVC.dataArray.count%2 == 0 ? self.pTopVideoVC.dataArray.count/2 : self.pTopVideoVC.dataArray.count/2 + 1;
        return [self.pTopVideoVC updateViewHeightWithLineCount:linenumber];
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

        headView.contentView.backgroundColor = [UIColor whiteColor];
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
