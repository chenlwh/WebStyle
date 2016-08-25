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

@implementation HomepageNaviBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)reloadView
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(!self.dramaHomeSearchView)
    {
        CGFloat searchViewWidth = self.width - 64*2;
        self.dramaHomeSearchView = [[GWDramaHomeSearchView alloc] initWithFrame:CGRectMake(64, (self.height - kDramaHomeSearchViewHeight)/2, searchViewWidth, kDramaHomeSearchViewHeight)];
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
@end
