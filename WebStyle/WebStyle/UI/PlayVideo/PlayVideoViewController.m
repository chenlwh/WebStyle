//
//  PlayVideoViewController.m
//  WebStyle
//
//  Created by liudan on 9/18/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "UIViewExt.h"
#import "PrePlayView.h"
#import "VideoTitleTableViewCell.h"
#import "VideoBrowserTableViewCell.h"
#import "BottomToolBar.h"
#import "UrlDefine.h"
#import "AFNetworking.h"
#import "XYString.h"
#import "MJExtension.h"
#import "UIViewController+Alert.h"
#import "QueryIsFavoriteProvider.h"
#import "WSAppContext+WSLogin.h"


@interface PlayVideoViewController()<PrePlayViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PrePlayView *prePlayView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *heightDict;
@property (nonatomic, strong) BottomToolBar *bottombar;
@property (nonatomic, strong) QueryIsFavoriteProvider *queryFavoriteProvider;
@property (nonatomic, assign) FavoStatusType favorStatus;
@end
@implementation PlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _favorStatus = FavoStatusUnKown;
    
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.width * 0.6)];
    _videoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_videoView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
//    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoBrowserTableViewCell" bundle:nil] forCellReuseIdentifier:[VideoBrowserTableViewCell cellIndentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoTitleTableViewCell" bundle:nil] forCellReuseIdentifier:[VideoTitleTableViewCell cellIndentifier]];
    self.tableView.frame = CGRectMake(0, self.videoView.bottom, self.view.width, self.view.height -self.videoView.bottom - kBottomBarHeight);
    
    _prePlayView = [[PrePlayView alloc] initWithFrame:_videoView.bounds];
    _prePlayView.delegate = self;
    _prePlayView.video = self.model;
    [_videoView addSubview:_prePlayView];
    
    self.bottombar = [BottomToolBar createBottomToolBarWithView:self.view];
    self.bottombar.video = self.model;
    self.bottombar.attachedVC = self;
    [self.bottombar reloadData];
    [self.bottombar setObserverScrollView:self.tableView];
    
//    [self queryFavoriteRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
//    [self setGradientColorBarLight:[UIColor clearColor]];
    [self setStatusBarLight];
    
}

-(NSMutableDictionary*)heightDict
{
    if(!_heightDict)
    {
        _heightDict = [[NSMutableDictionary alloc] init];
    }
    return _heightDict;
}

-(void) addBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 300, 50, 50);
    btn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick:(UIButton*)btn
{
    btn.selected = !btn.selected;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTheVideo:)
                                                 name:kHTPlayerPopDetailNotificationKey
                                               object:nil];
    
}

-(void)closeTheVideo:(NSNotification *)notice
{
    WeakObjectDef(self);
    [UIView animateWithDuration:0.3 animations:^{
        _htPlayer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_htPlayer removeFromSuperview];
        [weakself releaseWMPlayer];
        [weakself.navigationController popViewControllerAnimated:true];
    }];
}

-(void)videoDidFinished:(NSNotification *)notice{
    
    if (_htPlayer.screenType == UIHTPlayerSizeFullScreenType){
        
        [self toCell];//先变回cell
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    WeakObjectDef(self);
    self.prePlayView.hidden = false;
    [UIView animateWithDuration:0.3 animations:^{
        _htPlayer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_htPlayer removeFromSuperview];
        [weakself releaseWMPlayer];
        //添加重新播放的页面；
    }];
    
}

-(void)fullScreenBtnClick:(NSNotification *)notice{
    
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self toCell];
    }
}

-(void)toCell{
    
    [_htPlayer toDetailScreen:_videoView];
}

-(void)toDetial{
    
    [_htPlayer toDetailScreen:_videoView];
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [_htPlayer toFullScreenWithInterfaceOrientation:interfaceOrientation];
}

-(void)releaseWMPlayer{
    
    [_htPlayer releaseWMPlayer];
    _htPlayer = nil;
}

-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [self releaseWMPlayer];
}

- (void)reloadData
{
    [self addObserver];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_htPlayer) {
        [self toDetial];
    }else{
        [self startPlayVideo:nil];
    }
    
}

-(void)setModel:(PreferVideo *)model
{
    _model = model;
//    [self reloadData];
    [self requestGoodsInfo];
}
#pragma mark request

//请求商品信息;
-(void) requestGoodsInfo
{
    WeakObjectDef(self);
    NSString * urlString = [NSString stringWithFormat:@"%@%@", kGoodsVideo, _model.vedioID];
    D_Log(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        D_Log(@"operation response %@", operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D_Log(@"请求失败");
    }];
}

-(void)queryFavoriteRequest
{
    if(![[WSAppContext appContext] isLoging])
    {
        return;
    }
    
    if(!self.queryFavoriteProvider)
    {
        self.queryFavoriteProvider = [[QueryIsFavoriteProvider alloc] init];
    }
    self.queryFavoriteProvider.name = [WSAppContext appContext].wsUserInfo.nickname;
    self.queryFavoriteProvider.id = self.model.vedioID;
    
    WeakObjectDef(self);
    [self.queryFavoriteProvider requestWithCompletionHandler:^(id resposne, NSError*err){
        D_Log(@"response %@", resposne);
        if(err == nil)
        {
            NSDictionary *dict = [XYString getObjectFromJsonString:resposne];
            if([dict[@"code"] isEqualToString: @"02"])
            {
                weakself.favorStatus = FavoStatusIsNotFavor;
            }
        }
    }];
}


//开始播放
-(void)startPlayVideo:(UIButton *)sender{
    
    if (_htPlayer) {
        [_htPlayer removeFromSuperview];
        [_htPlayer setVideoURLStr:_model.vediolink];
        
    }else{
        if(_model.vediolink.length == 0)
        {
            [self showToastWithString:@"视频地址不能为空" hideAfterInterval:2 completion:nil];
            return;
        }
        
        _htPlayer = [[HTPlayer alloc]initWithFrame:self.videoView.bounds videoURLStr:_model.vediolink];
    }
    
    _htPlayer.screenType = UIHTPlayerSizeDetailScreenType;
    
    [_htPlayer setPlayTitle:_model.vedioDesc];
    WeakObjectDef(self);
    [_htPlayer setStatus:^(UIHTPlayerStatusChangeType status){
        if(status == UIHTPlayerStatusLoadingType)
        {
            D_Log(@"正在加载中");
            
        }
        else if (status == UIHTPlayerStatusReadyToPlayType)
        {
            D_Log(@"开始播放");
            weakself.prePlayView.hidden = true;
            [MBProgressHUD showHUDAddedTo:weakself.videoView animated:YES];
        }
        else if(status == UIHTPlayeStatusrLoadedTimeRangesType)
        {
            [MBProgressHUD hideHUDForView:weakself.videoView animated:NO];
            D_Log(@"开始缓存");
        }
    }];
    [self.videoView addSubview:_htPlayer];
    [self.videoView bringSubviewToFront:_htPlayer];
    
    
    
    if (_htPlayer.screenType == UIHTPlayerSizeSmallScreenType) {
        [_htPlayer reductionWithInterfaceOrientation:self.videoView];
    }
}

#pragma mark PrePlayViewDelegate
-(void)playVideo
{
    [self reloadData];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        VideoBrowserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[VideoBrowserTableViewCell cellIndentifier]];
        cell.infoLabel.text = [NSString stringWithFormat:@"浏览%@次", _model.browsers];
//        cell.contentView.backgroundColor = [UIColor greenColor];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        VideoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[VideoTitleTableViewCell cellIndentifier]];
        cell.videoTimeLabel.text = [NSString stringWithFormat:@"今天14:23发布"];
        cell.videoTitleLabel.text = _model.vedioDesc;
//        cell.contentView.backgroundColor = [UIColor yellowColor];
//        cell.backgroundColor = [UIColor yellowColor];
        return cell;
    }
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 56;
    }
    else if(indexPath.section == 1)
    {
        NSNumber *number = [self.heightDict objectForKey:[NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
        if(number == nil)
        {
            VideoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[VideoTitleTableViewCell cellIndentifier]];
            cell.videoTimeLabel.text = [NSString stringWithFormat:@"今天14:23发布"];
            cell.videoTitleLabel.text = @"A4D4-2B8F10532FB5&method=com.gewara.pushcs.userDevice.save&mnet=wifi&mobileType=iPhone&osType=IPHONE&osVersion=9.3.5&pointx=121.350851&pointy=31.220344&pushToken=%3C8a68a3af%2075767396%20409fd49f%2034224a98%20892703e1%205e18a486%20e8d618e0%201111c78e%3E&securityCode=3DuPuUJSVmiWwyL&sign=57E716AC2A5FCC1D646F21EAAE514869&signmethod=MD5&timestamp=2016-09-23%2016:33:25&userId=64015347&uuid=AF435CE6-98B1-41D0-A4D4-2B8F10532FB5&v=1.0";
            [cell layoutIfNeeded];
            CGFloat fHeight = cell.videoTimeLabel.bottom + 5;
            
            number = @(fHeight);
            [self.heightDict setObject:number forKey:[NSString stringWithFormat:@"%ld_%ld", (long)indexPath.section, (long)indexPath.row]];
        }
        D_Log(@"fheight %f", [number floatValue]);
        return [number floatValue];
    }
    return 20;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(section == 1)
//    {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
//        view.backgroundColor = [UIColor redColor];
////        RGBACOLORFromRGBHex(0xf6f6f6);
//        return view;
//    }
//    return nil;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}


@end
