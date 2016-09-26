//
//  VideoListViewController.m
//  WebStyle
//
//  Created by liudan on 9/26/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "VideoListViewController.h"
#import "THVideoCell.h"
#import "HTPlayer.h"
#import "PlayVideoViewController.h"
#import "PreferVideo.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "XYString.h"
#import "MJExtension.h"

@interface VideoListViewController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *table;
@property (strong, nonatomic)NSIndexPath *currentIndexPath;
@property (strong, nonatomic)THVideoCell *currentCell;//当前播放的cell
@property (strong, nonatomic)HTPlayer *htPlayer;
@property (assign, nonatomic)BOOL isSmallScreen;
@property (strong, nonatomic)PlayVideoViewController *detail;
@property (strong, nonatomic)UIView *customNaviView;
@end

@implementation VideoListViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.table];
    [self.table registerClass:[THVideoCell class] forCellReuseIdentifier:@"VideoCell"];
    
    [self addMJRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popDetail:)
                                                 name:kHTPlayerPopDetailNotificationKey
                                               object:nil];
    [self addObserver];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarLight];
}

-(void)setNav
{
    self.navigationController.navigationBar.hidden = true;
    
    self.customNaviView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusHegiht, self.view.width, kNaviHeight)];
    self.customNaviView.backgroundColor = AppMainColor;
    [self.view addSubview:self.customNaviView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(4, 2, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_0"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNaviView addSubview:backBtn];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = self.title ? self.title : @"视频列表";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:16.0f];
    [titleLab sizeToFit];
    [self.customNaviView addSubview:titleLab];
    titleLab.left = (self.customNaviView.width - titleLab.width)/2;
    titleLab.top = (self.customNaviView.height - titleLab.height)/2;
    D_Log(@"%@", titleLab);
}


- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:)
                                                 name:kHTPlayerFinishedPlayNotificationKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:)
                                                 name:kHTPlayerFullScreenBtnNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTheVideo:)
                                                 name:kHTPlayerCloseVideoNotificationKey
                                               object:nil];
    
}

-(void)videoDidFinished:(NSNotification *)notice{
    
    if (_htPlayer.screenType == UIHTPlayerSizeFullScreenType){
        
        [self toCell];//先变回cell
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _htPlayer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_htPlayer removeFromSuperview];
        [self releaseWMPlayer];
    }];
    
}
-(void)closeTheVideo:(NSNotification *)obj{
    
    [UIView animateWithDuration:0.3 animations:^{
        _htPlayer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_htPlayer removeFromSuperview];
        [self releaseWMPlayer];
    }];
}

-(void)fullScreenBtnClick:(NSNotification *)notice{
    
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        if (_isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
}

-(void)releaseWMPlayer{
    
    [_htPlayer releaseWMPlayer];
    _htPlayer = nil;
    _currentIndexPath = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadData];
}
-(void)loadData{
    if (self.dataSource.count == 0) {
        [self refreshData];
    }
}

- (void)refreshData
{
    __unsafe_unretained UITableView *tableView = self.table;
    D_Log(@"______%@",self.url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *temArray  = [XYString getObjectFromJsonString:operation.responseString];
        _dataSource = [NSMutableArray arrayWithArray:[PreferVideo mj_objectArrayWithKeyValuesArray:temArray]];
        D_Log(@"kHotPlayerVideo count %lu", (unsigned long)_dataSource.count);
        [tableView reloadData];
        [tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D_Log(@"请求失败");
    }];
    
}

-(void)addMJRefresh{
    ///*
    __unsafe_unretained UITableView *tableView = self.table;
    __weak VideoListViewController *selfView = self;
    // 下拉刷新
    tableView.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [selfView refreshData];
    }];
    
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    // */
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"VideoCell";
    THVideoCell *cell = (THVideoCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.model = [_dataSource objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    cell.playBtn.tag = indexPath.row;
    
    return cell;
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView ==self.table){
        if (_htPlayer==nil) return;
        
        if (_htPlayer.superview) {
            CGRect rectInTableView = [self.table rectForRowAtIndexPath:_currentIndexPath];
            CGRect rectInSuperview = [self.table convertRect:rectInTableView toView:[self.table superview]];
            
            //            NSLog(@"rectInSuperview = %@",NSStringFromCGRect(rectInSuperview));
            
            if (rectInSuperview.origin.y-kNavbarHeight<-self.currentCell.backView.height||rectInSuperview.origin.y>self.view.height) {//往上拖动
                
                if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:_htPlayer]) {
                    //放widow上,小屏显示
                    [self toSmallScreen];
                }
                
            }else{
                if (![self.currentCell.backView.subviews containsObject:_htPlayer]) {
                    [self toCell];
                }
            }
        }
        
    }
}

-(void)toCell{
    
    self.currentCell = (THVideoCell *)[self.table cellForRowAtIndexPath:_currentIndexPath];
    [_htPlayer reductionWithInterfaceOrientation:self.currentCell.backView];
    _isSmallScreen = NO;
    [self.table reloadData];
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    [_htPlayer toFullScreenWithInterfaceOrientation:interfaceOrientation];
}
-(void)toSmallScreen{
    //放widow上
    [_htPlayer toSmallScreen];
    _isSmallScreen = YES;
}

//开始播放
-(void)startPlayVideo:(UIButton *)sender{
    _currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    
    self.currentCell = (THVideoCell *)[self.table cellForRowAtIndexPath:_currentIndexPath];
    PreferVideo *model = [_dataSource objectAtIndex:sender.tag];
    
    
    if (_htPlayer) {
        [_htPlayer removeFromSuperview];
        [_htPlayer setVideoURLStr:model.vediolink];
        
    }else{
        _htPlayer = [[HTPlayer alloc]initWithFrame:self.currentCell.backView.bounds videoURLStr:model.vediolink];
    }
    
    [_htPlayer setPlayTitle:model.vedioDesc];
    
    [self.currentCell.backView addSubview:_htPlayer];
    [self.currentCell.backView bringSubviewToFront:_htPlayer];
    
    if (_htPlayer.screenType == UIHTPlayerSizeSmallScreenType) {
        [_htPlayer reductionWithInterfaceOrientation:self.currentCell.backView];
    }
    _isSmallScreen = NO;
    
    [self.table reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_detail) {
        _detail = [[PlayVideoViewController alloc] init];
        _detail.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController addChildViewController:_detail];
        [self.navigationController.view addSubview:_detail.view];
        _detail.view.alpha = 0;
    }
    
    //    判断当前播放的视频，是否用户点击的视频。
    if (_currentIndexPath && _currentIndexPath.row != indexPath.row) {
        
        _isSmallScreen = NO;
        if (_htPlayer) {
            [self releaseWMPlayer];//关闭视频
        }
        
        _currentIndexPath = indexPath;
        _currentCell = [tableView cellForRowAtIndexPath:indexPath];
    }
    _detail.htPlayer = _htPlayer;
    PreferVideo *model = [_dataSource objectAtIndex:indexPath.row];
    _detail.model =model;
    
    [_detail reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        _detail.view.alpha = 1;
    }];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHTPlayerFinishedPlayNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHTPlayerFullScreenBtnNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHTPlayerFinishedPlayNotificationKey object:nil];
}

- (void)popDetail:(NSNotification *)obj
{
    _htPlayer = (HTPlayer *)obj.object;
    
    if (_htPlayer) {
        if (_isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _detail.view.alpha = 0.0;
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:_detail];
    [self addObserver];
}

- (UITableView *)table
{
    if (_table) return _table;
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.customNaviView.bottom, self.view.width, self.view.height - self.customNaviView.bottom)];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.contentInset = UIEdgeInsetsMake(0, 0, self.customNaviView.height, 0);
    return _table;
}

-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseWMPlayer];
}

#pragma mark event
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:true];
}
@end
