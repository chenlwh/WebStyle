//
//  UIView+Gewara.m
//  GewaraCore
//
//  Created by Chuan on 12-11-16.
//  Copyright (c) 2012年 Chuan. All rights reserved.
//

#import "UIView+Gewara.h"

@implementation UIView (Gewara)

- (void)setTlPos:(CGPoint)tlPoint
{
    CGRect frame = self.frame;
    frame.origin = tlPoint;
    self.frame = frame;
}

- (void)setBrPos:(CGPoint)tlPoint
{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(tlPoint.x - frame.size.width, tlPoint.y - frame.size.height);
    self.frame = frame;
}

- (void)setPosx:(float)x{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width
                            , self.frame.size.height);
}
- (void)setPosy:(float)y{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}
- (CGPoint)brPos{
    return CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y+self.frame.size.height);
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGPoint)centerPos
{
	return CGPointMake([self width]/2, [self height]/2);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
-(CGFloat)centerX
{
    return self.center.x;
}
-(void)setCenterX:(CGFloat)centerX
{
    [self setCenter:CGPointMake(centerX, self.center.y)];
}
-(CGFloat)centerY
{
    return self.center.y;
}
-(void)setCenterY:(CGFloat)centerY
{
    [self setCenter:CGPointMake(self.center.x, centerY)];
}
@end




@implementation UIView (Theme)

-(void)themeClearBackgroundColor
{
    self.backgroundColor = [UIColor clearColor];
}

-(void)themeBackgroundColorWithImage:(UIImage*)image
{
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}


-(void)themeLayerShadowWithShadowOffset:(CGSize)offsetSize
                           shadowRadius:(CGFloat)radius
                                opacity:(CGFloat)opacity
                            shadowColor:(UIColor*)color
{
    [[self layer] setShadowOffset:offsetSize];
    [self.layer setShadowRadius:radius];
    [self.layer setShadowOpacity:opacity];
    [[self layer] setShadowColor:color.CGColor];
}
@end
