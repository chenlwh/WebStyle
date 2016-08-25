//
//  UIView+GWCorner.h
//  GWMovie
//
//  Created by ace on 15/4/22.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    GWBaseCornerViewTypeTop, //顶部位置
    GWBaseCornerViewTypeMiddle, //中间位置
    GWBaseCornerViewTypeBottom, //底部位置
    GWBaseCornerViewTypeSingle, //单独位置
    GWBaseCornerViewTypeNone
}GWBaseCornerViewType;


@interface UIView (GWCorner)

@property (nonatomic, assign) GWBaseCornerViewType viewType; //所处位置，根据位置设置圆
@property (nonatomic, strong) UIColor *borderColor; //边框颜色

@property (nonatomic, assign) CGFloat cornerRadius; //圆角半径

@property (nonatomic, assign) CGFloat lineWidth; //边框宽度

@property (nonatomic, assign) CGFloat cornerMargin; //距离左边边距

@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer;
@property (nonatomic, strong, readonly) CAShapeLayer *maskLayer;


- (void)needDrawCorner; //画圆角




//add
- (void)setCornerOnTop:(CGSize)radius;
- (void)setCornerOnBottom:(CGSize)radius;
- (void)setAllCornerWithRadius:(CGFloat)radius;
- (void)setAllCorner;
- (void)setNoneCorner;

@end
