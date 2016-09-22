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

@interface PlayVideoViewController()<PrePlayViewDelegate>

@property (nonatomic, strong) PrePlayView *prePlayView;
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation PlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.width * 0.6)];
    _videoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_videoView];
    
//    [self addBtn];
    _prePlayView = [[PrePlayView alloc] initWithFrame:_videoView.bounds];
    _prePlayView.delegate = self;
    _prePlayView.video = self.model;
    [_videoView addSubview:_prePlayView];
    
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
}

-(void)videoDidFinished:(NSNotification *)notice{
    
    if (_htPlayer.screenType == UIHTPlayerSizeFullScreenType){
        
        [self toCell];//先变回cell
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    self.prePlayView.hidden = false;
    [UIView animateWithDuration:0.3 animations:^{
        _htPlayer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_htPlayer removeFromSuperview];
        [self releaseWMPlayer];
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
}

//开始播放
-(void)startPlayVideo:(UIButton *)sender{
    
    if (_htPlayer) {
        [_htPlayer removeFromSuperview];
        [_htPlayer setVideoURLStr:_model.vediolink];
        
    }else{
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
@end
