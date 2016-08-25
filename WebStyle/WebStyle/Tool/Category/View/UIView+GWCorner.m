//
//  UIView+GWCorner.m
//  GWMovie
//
//  Created by ace on 15/4/22.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "UIView+GWCorner.h"
#import <objc/runtime.h>
//#import "GWCommkit.h"
#import "FTUtils.h"

static char cornerKey;
static char borderColorKey;
static char shapeLayerKey;
static char maskLayerKey;
static char cornerRadiusKey;
static char lineWidthKey;
static char cornerMarginKey;

#define cellCornerRadius 2

@implementation UIView (GWCorner)

-(void)setViewType:(GWBaseCornerViewType)viewType
{
    objc_setAssociatedObject(self, &cornerKey, [NSNumber numberWithInt:viewType] , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(GWBaseCornerViewType)viewType
{
    return [objc_getAssociatedObject(self, &cornerKey) intValue];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    objc_setAssociatedObject(self, &cornerRadiusKey, [NSNumber numberWithFloat:cornerRadius] , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)cornerRadius
{
    return [objc_getAssociatedObject(self, &cornerRadiusKey) floatValue];
}

-(void)setLineWidth:(CGFloat)lineWidth
{
    objc_setAssociatedObject(self, &lineWidthKey, [NSNumber numberWithFloat:lineWidth] , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)lineWidth
{
    return [objc_getAssociatedObject(self, &lineWidthKey) floatValue];
}

-(void)setBorderColor:(UIColor *)borderColor
{
    objc_setAssociatedObject(self, &borderColorKey, borderColor , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor *)borderColor
{
    return objc_getAssociatedObject(self, &borderColorKey);
}

- (void)setShapeLayer:(CAShapeLayer *)shapeLayer
{
    objc_setAssociatedObject(self, &shapeLayerKey, shapeLayer , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)shapeLayer
{
    return objc_getAssociatedObject(self, &shapeLayerKey);
}

- (void)setMaskLayer:(CAShapeLayer *)maskLayer
{
    objc_setAssociatedObject(self, &maskLayerKey, maskLayer , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CAShapeLayer *)maskLayer
{
    return objc_getAssociatedObject(self, &maskLayerKey);
}

-(void)setCornerMargin:(CGFloat)cornerMargin
{
    objc_setAssociatedObject(self, &cornerMarginKey, [NSNumber numberWithFloat:cornerMargin] , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)cornerMargin
{
    return [objc_getAssociatedObject(self, &cornerMarginKey) floatValue];
}

-(void)needDrawCorner
{
    CGRect frame = self.bounds;
    CGFloat height = frame.size.height+1;
    CGFloat width = frame.size.width;
    CGRect maskFrame = frame; //加边框的frame
    if (self.cornerMargin >0 ) {
        width -= self.cornerMargin*2;
        maskFrame = CGRectMake(self.cornerMargin, 0, width, height);

    }
    
    if (self.viewType == GWBaseCornerViewTypeNone) {
        self.layer.mask = nil;
        if (self.shapeLayer) {
            [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[CAShapeLayer class]]) {
                    CAShapeLayer *layer = obj;
                    if (layer == self.shapeLayer) {
                        [layer removeFromSuperlayer];
                        *stop = YES;
                    }
                }
            }];
            
        }
        return;
    }
    CGFloat radius = self.cornerRadius > 0 ? self.cornerRadius : cellCornerRadius;
    CGSize cornerRadii = CGSizeMake(radius, radius);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:cornerRadii];
    
    CGMutablePathRef shapePath  = CGPathCreateMutable();

    if (self.viewType == GWBaseCornerViewTypeTop) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:cornerRadii];
        
        CGPathMoveToPoint(shapePath, NULL, self.cornerMargin, height);
        CGPathAddLineToPoint(shapePath, NULL, self.cornerMargin, radius);
        CGPathAddArc(shapePath, NULL, self.cornerMargin + radius, radius, radius, M_PI, 1.5*M_PI, NO);
        CGPathMoveToPoint(shapePath, NULL, self.cornerMargin, 0);
        CGPathAddLineToPoint(shapePath, NULL, width + self.cornerMargin-radius, 0);
        CGPathAddArc(shapePath, NULL, width + self.cornerMargin - radius, radius, radius, 1.5*M_PI, 2*M_PI, NO);
        CGPathAddLineToPoint(shapePath, NULL, width+self.cornerMargin, height);

    }else if(self.viewType == GWBaseCornerViewTypeSingle){
        maskPath = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:cornerRadii];
        CGPathRelease(shapePath);
        shapePath = CGPathCreateMutableCopy(maskPath.CGPath);
    }else if(self.viewType == GWBaseCornerViewTypeMiddle){
        maskPath = [UIBezierPath bezierPathWithRect:maskFrame];
        
        CGPathMoveToPoint(shapePath, NULL, self.cornerMargin, height);
        CGPathAddLineToPoint(shapePath, NULL, self.cornerMargin, 0);
        CGPathMoveToPoint(shapePath, NULL, width+self.cornerMargin, 0);
        CGPathAddLineToPoint(shapePath, NULL, width+self.cornerMargin, height);
    }else if (self.viewType == GWBaseCornerViewTypeBottom){
        
        CGPathMoveToPoint(shapePath, NULL, self.cornerMargin, 0);
        CGPathAddLineToPoint(shapePath, NULL, self.cornerMargin, height-radius);
        CGPathAddArc(shapePath, NULL, self.cornerMargin + radius, height - radius, radius, M_PI, M_PI_2, YES);
        CGPathAddLineToPoint(shapePath, NULL, width+self.cornerMargin-radius, height);
        CGPathAddArc(shapePath, NULL, width + self.cornerMargin - radius, height - radius, radius, M_PI_2, 0, YES);
        CGPathAddLineToPoint(shapePath, NULL, width+self.cornerMargin, 0);
    }
    
    __block BOOL flag = NO ;
    [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[CAShapeLayer class]]) {
            CAShapeLayer *layer = obj;
            if (layer == self.shapeLayer) {
                layer.path = shapePath;
                flag = YES;
                *stop = YES;
            }
        }
    }];
    
    if (self.layer.mask == self.maskLayer) {
        CAShapeLayer *layer = (CAShapeLayer *)self.layer.mask;
        layer.path = maskPath.CGPath;
    }
    
    // 创建 shapeLayer
    if (!flag) {
        // 切割边框
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = frame;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        self.maskLayer = maskLayer;
        
        // 给边框加颜色
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.frame = frame;
        shape.path = shapePath;
        shape.lineWidth = self.lineWidth > 0 ? self.lineWidth: 1.0f;
        UIColor *color = self.borderColor ? self.borderColor : RGBACOLORFromRGBHex(0xe9e8e8);
//        color = [UIColor redColor];
        shape.strokeColor = color.CGColor;
        shape.fillColor = nil;
        self.shapeLayer = shape;
        [self.layer addSublayer:self.shapeLayer];
    }
    CGPathRelease(shapePath);
}




//
- (void)setCornerOnTop:(CGSize)radius
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOnBottom:(CGSize)radius
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setAllCornerWithRadius:(CGFloat)radius
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setAllCorner
{
    [self setAllCornerWithRadius:cellCornerRadius];
}

- (void)setNoneCorner
{
    self.layer.mask = nil;
}

@end
