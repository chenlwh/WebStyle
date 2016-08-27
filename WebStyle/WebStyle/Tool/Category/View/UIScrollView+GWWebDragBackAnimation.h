//
//  UIScrollView+GWWebDragBackAnimation.h
//  GWMovie
//
//  Created by 段成杰 on 15/1/7.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GWScrollViewDragBackAnimationDelegate <NSObject>

- (BOOL)canDragBack:(UIScrollView*)scrollView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

@end


@interface UIScrollView (GWWebDragBackAnimation)
//是否允许拖动返回动画开启
@property (nonatomic , assign) BOOL ifAgreeBackAnimation;

@property (nonatomic , weak) id<GWScrollViewDragBackAnimationDelegate> dragBackAnimationDelegate;

@end
