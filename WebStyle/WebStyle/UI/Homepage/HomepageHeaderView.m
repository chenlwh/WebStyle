//
//  HomepageHeaderView.m
//  WebStyle
//
//  Created by liudan on 8/25/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "HomepageHeaderView.h"

@implementation HomepageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self reloadViews];
}
-(void) reloadViews
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(!self.cycleScrollView)
    {
        self.cycleScrollView = [[SDCycleScrollView alloc] init];
    }
    self.cycleScrollView.frame = self.bounds;
    [self addSubview:self.cycleScrollView];
    
    
    NSMutableArray * imagesURLStrings = [NSMutableArray array];
    NSMutableArray * titles = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PreferVideo *video = obj;
        [imagesURLStrings addObject:video.vedioimage];
        [titles addObject:video.vedioDesc];
    }];
    
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;// 分页控件位置
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;// 分页控件风格
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.titlesGroup = titles;
    self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    self.cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"303"];
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if(index >= self.dataArray.count)
        return;
    PreferVideo *video = self.dataArray[index];
    if(self.selectVideoBlock)
    {
        self.selectVideoBlock(video);
    }
    
}

@end
