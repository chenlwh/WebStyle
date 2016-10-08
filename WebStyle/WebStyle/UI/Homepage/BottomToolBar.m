//
//  BottomToolBar.m
//  WebStyle
//
//  Created by liudan on 9/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "BottomToolBar.h"
#import "UIView+Gewara.h"
#import "Color+Hex.h"
#import "FTUtils.h"
#import "GWProtocolInterceptor.h"
#import "WSAppContext+WSLogin.h"

#import "QueryIsFavoriteProvider.h"
#import "DoFavoriteProvider.h"

#import "MsgDefine.h"
#import "XYString.h"

#import "LogingViewController.h"
#import "UIViewController+Alert.h"


const CGFloat kBottomBarHeight = 48;
@interface BottomToolBar ()<UIScrollViewDelegate>
{
    
    GWProtocolInterceptor* _interceptor;
}

@end
@interface BottomToolBar()

@property (nonatomic, assign) BOOL isReadySearch;
@property (nonatomic, strong) QueryIsFavoriteProvider *queryFavoriteProvider;
@property (nonatomic, strong) DoFavoriteProvider *doFavorProvider;
@end
@implementation BottomToolBar

+ (BottomToolBar*)createBottomToolBarWithView:(UIView*)superView
{
    BottomToolBar* barView = [[BottomToolBar alloc] initWithFrame:CGRectMake(0, superView.height - kBottomBarHeight, superView.width, kBottomBarHeight)];
    [superView addSubview:barView];
    return barView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.favorStatus = FavoStatusIsNotFavor;
        [self loadAllControlls];
    }
    return self;
}

-(void) loadAllControlls
{
    self.backgroundColor = RGBACOLORFromRGBHex(0xf6f6f6);
    
    CGFloat radio = 4/9.f;
    
    CGFloat customButtonWith = self.width*radio;
    CGFloat blockWidth = self.width*(1-radio)/2;
    CGFloat blockHeight = self.height;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, self.frame.size.width, self.frame.size.height-0.5)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:backView];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame = CGRectMake(0, 0, blockWidth, blockHeight);
    [_likeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_likeBtn setImage:[UIImage imageNamed:@"icon_dislike"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateSelected];
    CGFloat likeimageWidth = [_likeBtn imageForState:UIControlStateNormal].size.width;
    [_likeBtn  setImageEdgeInsets:UIEdgeInsetsMake(0, -blockWidth + likeimageWidth + 30, 0, 0)];
    [self addSubview:_likeBtn];
    
    _likeTitleView = [self createTipsLabel];
    _likeTitleView.text = @"收藏";
    [_likeTitleView sizeToFit];
    _likeTitleView.left = _likeBtn.left + _likeBtn.imageView.centerX + likeimageWidth/2 + 5;
    _likeTitleView.bottom = _likeBtn.centerY + [_likeBtn imageForState:UIControlStateNormal].size.height / 2;
    [self addSubview:_likeTitleView];
    
    
    _customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _customBtn.frame = CGRectMake(self.width - customButtonWith, 0, customButtonWith, self.height);
    [self customButtonEnable:YES];
    _customBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_customBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_customBtn];
    [_customBtn setTitle:@"点击购买" forState:UIControlStateNormal];
    _customBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    
    
    
    _likeBtn.frame = CGRectMake(3, 0, blockWidth, blockHeight);
    
    CGFloat walaImageWidth = [_likeBtn imageForState:UIControlStateNormal].size.width;
    _likeTitleView.left = _likeBtn.left + _likeBtn.imageView.centerX + walaImageWidth/2 + 5;
    _likeTitleView.bottom = _likeBtn.centerY + [_likeBtn imageForState:UIControlStateNormal].size.height / 2;
    
    
    _customBtn.frame = CGRectMake(self.width - customButtonWith, 0, customButtonWith, self.height);
}

- (UILabel*)createTipsLabel
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 1;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:11];
    label.frame = CGRectZero;
    label.textColor = [UIColor hexStringToColor:@"5f5f5f"];
    
    return label;
}

- (void)customButtonEnable:(BOOL)enable
{
    _customBtn.enabled = enable;
    UIColor* color = RGBCOLOR(255, 84, 0);
    _customBtn.backgroundColor = enable ? color : [color colorWithAlphaComponent:0.5];
}


-(void)buttonClick:(UIButton*)btn
{
    NSLog(@"btnClick");
    if(btn == self.likeBtn)
    {
        [self doFavorRequest];
    }
    else if (btn == self.customBtn)
    {
        D_Log(@"去购买");
        if([self.delegate respondsToSelector:@selector(customButtonClick)])
        {
            [self.delegate customButtonClick];
        }
    }
}


- (void)setObserverScrollView:(UIScrollView *)observerScrollView
{
    if(_observerScrollView == observerScrollView)
        return;
    
    if(_observerScrollView)
    {
        _observerScrollView.delegate = _interceptor.receiver;
        _interceptor.receiver = nil;
        
    }
    _observerScrollView = observerScrollView;
    if(_observerScrollView)
    {
        _interceptor.receiver = _observerScrollView.delegate;
        _observerScrollView.delegate = (id<UIScrollViewDelegate>)_interceptor;
    }
    
    
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideWithAnimated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if(!scrollView.dragging && !scrollView.decelerating)
//        [self showWithAnimated:YES];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(!scrollView.dragging)
        [self showWithAnimated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
        [self showWithAnimated:YES];
}

-(void)showWithAnimated:(BOOL)animated
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = self.superview.height - self.height;
    [self updateFrameForAnimate:newFrame animated:animated];
}

-(void)hideWithAnimated:(BOOL)animated
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = self.superview.height;
    [self updateFrameForAnimate:newFrame animated:animated];
}

- (void)updateFrameForAnimate:(CGRect)newFrame animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = newFrame;
            //            if (self.updateFrameBlock) {
            //                self.updateFrameBlock(newFrame);
            //            }
        }];
    }
    else
    {
        self.frame = newFrame;
        //        if (self.updateFrameBlock) {
        //            self.updateFrameBlock(newFrame);
        //        }
    }
}

-(void)reloadData
{
    if(![[WSAppContext appContext] isLoging])
    {
        return;
    }
    
    if(!_isReadySearch && _video)
    {
        _isReadySearch = YES;
        [self queryFavoriteRequest];
    }
}

-(void)queryFavoriteRequest
{
    
    if(!self.queryFavoriteProvider)
    {
        self.queryFavoriteProvider = [[QueryIsFavoriteProvider alloc] init];
    }
    self.queryFavoriteProvider.name = [WSAppContext appContext].wsUserInfo.nickname;
    self.queryFavoriteProvider.id = self.video.vedioID;
    
    WeakObjectDef(self);
    [self.queryFavoriteProvider requestWithCompletionHandler:^(id resposne, NSError*err){
        D_Log(@"response %@", resposne);
        if(err == nil)
        {
            NSDictionary *dict = [XYString getObjectFromJsonString:resposne];
            if([dict[@"code"] isEqualToString: @"02"])
            {
                weakself.favorStatus = FavoStatusIsNotFavor;
                [weakself updateLikeBtnStatus];
            }
            else if([dict[@"code"] isEqualToString: @"01"])
            {
                weakself.favorStatus = FavoStatusIsFavor;
                [weakself updateLikeBtnStatus];
            }
            else
            {
                [weakself.attachedVC showAutoHideToastWithString:([dict[@"message"] length] > 0 ? dict[@"message"] : @"查询收藏状态失败") ];
            }
        }
    }];
}

-(void) doFavorRequest
{
    WeakObjectDef(self);
    if(![[WSAppContext appContext] isLoging])
    {
        [[GWLogin sharedInstance] showLoginWithCancelHandler:nil LoginFinishHandler:^(BOOL success){
            [weakself doFavorRequest];
        }];
        return;
    }
    
    if(!self.doFavorProvider)
    {
        self.doFavorProvider = [[DoFavoriteProvider alloc] init];
    }
    self.doFavorProvider.name = [WSAppContext appContext].wsUserInfo.nickname;
    self.doFavorProvider.id = self.video.vedioID;
    
    [self.doFavorProvider requestWithCompletionHandler:^(id resposne, NSError*err){
        D_Log(@"response %@", resposne);
        if(err == nil)
        {
            NSDictionary *dict = [XYString getObjectFromJsonString:resposne];
            if([dict[@"code"] isEqualToString: @"02"])
            {
                weakself.favorStatus = FavoStatusIsNotFavor;
                [weakself updateLikeBtnStatus];
            }
            else if([dict[@"code"] isEqualToString: @"01"])
            {
                weakself.favorStatus = FavoStatusIsFavor;
                [weakself updateLikeBtnStatus];
            }
            else
            {
                [weakself.attachedVC showAutoHideToastWithString:([dict[@"message"] length] > 0 ? dict[@"message"] : @"操作失败") ];
            }
        }
    }];
}
-(void)updateLikeBtnStatus
{
    if(self.favorStatus == FavoStatusUnKown)
    {
        _likeBtn.selected = FALSE;
    }
    else if(self.favorStatus == FavoStatusIsNotFavor)
    {
        _likeBtn.selected = FALSE;
        _likeTitleView.text = @"收藏";
        [_likeTitleView sizeToFit];
        CGFloat walaImageWidth = [_likeBtn imageForState:UIControlStateNormal].size.width;
        _likeTitleView.left = _likeBtn.left + _likeBtn.imageView.centerX + walaImageWidth/2 + 5;
    }
    else if (self.favorStatus == FavoStatusIsFavor)
    {
        _likeBtn.selected = YES;
        _likeTitleView.text = @"取消收藏";
        [_likeTitleView sizeToFit];
        CGFloat walaImageWidth = [_likeBtn imageForState:UIControlStateNormal].size.width;
        _likeTitleView.left = _likeBtn.left + _likeBtn.imageView.centerX + walaImageWidth/2 + 5;
    }
}

@end
