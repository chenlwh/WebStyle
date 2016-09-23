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
const CGFloat kBottomBarHeight = 48;
@interface BottomToolBar ()<UIScrollViewDelegate>
{
    
    GWProtocolInterceptor* _interceptor;
}

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
        [self loadAllControlls];
    }
    return self;
}

-(void) loadAllControlls
{
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
    [_likeBtn setImage:[UIImage imageNamed:@"icon_bigdislike"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"icon_bigdislike"] forState:UIControlStateSelected];
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


@end
