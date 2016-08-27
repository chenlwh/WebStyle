//
//  UIView+Gewara.h
//  GewaraCore
//
//  Created by Chuan on 12-11-16.
//  Copyright (c) 2012年 Chuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gewara)

- (void)setTlPos:(CGPoint)tlPoint;
- (void)setBrPos:(CGPoint)tlPoint;

- (void)setPosx:(float)x;
- (void)setPosy:(float)y;
- (CGPoint)brPos;
- (CGPoint)centerPos;

//
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;
@end


@interface UIView (Theme)

-(void)themeClearBackgroundColor;
-(void)themeBackgroundColorWithImage:(UIImage*)image;

-(void)themeLayerShadowWithShadowOffset:(CGSize)offsetSize
                           shadowRadius:(CGFloat)radius
                                opacity:(CGFloat)opacity
                            shadowColor:(UIColor*)color;



@end