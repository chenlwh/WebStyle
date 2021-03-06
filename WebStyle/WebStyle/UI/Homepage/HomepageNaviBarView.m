//
//  HomepageNaviBarView.m
//  WebStyle
//
//  Created by liudan on 8/25/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "HomepageNaviBarView.h"
#import "MsgDefine.h"
#import "UIView+Gewara.h"
#import "UIView+GWCorner.h"
#import "FTUtils.h"

@interface HomepageNaviBarView()

@property (nonatomic, strong) UIView *graidentView; //渐变的视图
@property (nonatomic, strong) UIView *transparentView; //透明的视图

@end

@implementation HomepageNaviBarView


-(id) init
{
    if(self = [super init])
    {
    }
    return self;
}
-(void)reloadView
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(!self.leftButton)
    {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.frame = CGRectMake(10, 6, 54, 40);
        [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
//        [self.leftButton setTitle:kAppName forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"icon_app"] forState:UIControlStateNormal];
        [self.leftButton addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        self.leftButton.top = (self.height - self.leftButton.height)/2;
//        self.leftButton.layer.cornerRadius = 3.0f;
//        self.leftButton.layer.borderWidth = 0.8;
//        self.leftButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    [self addSubview:self.leftButton];
    
    if(!self.dramaHomeSearchView)
    {
        CGFloat searchViewWidth = self.width - self.leftButton.right - 2 * 15;
        self.dramaHomeSearchView = [[GWDramaHomeSearchView alloc] initWithFrame:CGRectMake(self.leftButton.right + 15, (self.height - kDramaHomeSearchViewHeight)/2, searchViewWidth, kDramaHomeSearchViewHeight)];
//        self.dramaHomeSearchView.backgroundColor = [UIColor yellowColor];
//        self.dramaHomeSearchView.centerY = self.centerY;
//        self.dramaHomeSearchView.center = self.center;
        self.dramaHomeSearchView.textFieldEnable = NO;
        WeakObjectDef(self);
        [self.dramaHomeSearchView setSelectSearchClick:^{
            [weakself.delegate naviBarsearchBtnClick];
        }];
        [self addSubview:self.dramaHomeSearchView];
    }
    
}

-(void) setNaviBarAlpha:(CGFloat)alpha
{
    if(alpha == fThreshold)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    else
    {
        self.backgroundColor = RGBACOLOR(0xeb, 0x61, 0x1f, alpha);
    }
}

-(void)leftBtnClick
{
}
@end
