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
#import "NSObject+MJKeyValue.h"
#import "HomepageHeaderView.h"
#import "UINavigationBar+Awesome.h"
#import "HomepageNaviBarView.h"
#import "SearchViewController.h"
@interface HomepageViewController()<UITableViewDelegate, UITableViewDataSource, GWProviderDelegate, CustomNaviBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HomepageHeaderView *headView;
@property (nonatomic, strong) HomepageScrollProvider *topScrollProvider;
@property (nonatomic, strong) NSMutableArray *preferVideoArr;
@property (nonatomic, strong) HomepageNaviBarView *customNaviView;
@end

@implementation HomepageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self createTableView];
    
    [self createTopScrollRequest];
    
    [self.tableView.header beginRefreshing];
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
-(void)setNav
{
    self.navigationController.navigationBar.hidden = true;
//    self.navigationItem.title = @"首页";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImageName:@"search_1" HighlightedImageName:@"search_2" Target:self Action:@selector(searchBtnClick)];
    
//    self.navigationController.navigationBar.translucent = YES;
    
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
    [self.tableView setBackgroundColor: RGBACOLORFromRGBHex(0xf6f6f6)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    self.tableView.scrollsToTop = true;
    [self.view addSubview:self.tableView];
    
    [self.tableView setTableHeaderView:self.headView];
}


#pragma setter & getter

-(HomepageHeaderView*)headView
{
    if(!_headView)
    {
        _headView = [[HomepageHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 125)];
        _headView.backgroundColor = [UIColor greenColor];
    }
    return _headView;
}



#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark CustomNaviDelegate
-(void)naviBarsearchBtnClick
{
    D_Log(@"search");
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    
    searchVc.navBarColor = RGBACOLORFromRGBHex(0xeb611f);

    
//    WeakObjectDef(self);
//    [searchVc setGoBackHandlerWithViewController:^(GWBaseViewController *vc) {
//        [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
//    }];
    
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:searchVc];
    [self presentViewController:navVc animated:YES completion:^(){
    }];
//    UISearchController *searchVC = [UISearchController new];
//    [self presentViewController:searchVC animated:true completion:nil];
//    [self.navigationController pushViewController:searchVC animated:true];
}
@end
