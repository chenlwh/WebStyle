//
//  UIScrollView+GWWebDragBackAnimation.m
//  GWMovie
//
//  Created by 段成杰 on 15/1/7.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+GWWebDragBackAnimation.h"
#import "MsgDefine.h"

static char KGWBACKANIMATIONKEy;
static char KGWBACKANIMATIONDelegate;


@implementation UIScrollView (GWWebDragBackAnimation)

@dynamic ifAgreeBackAnimation;

- (void)setIfAgreeBackAnimation:(BOOL)ifAgreeBackAnimation{
    objc_setAssociatedObject(self, &KGWBACKANIMATIONKEy, [NSNumber numberWithBool:ifAgreeBackAnimation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ifAgreeBackAnimation{
    return [objc_getAssociatedObject(self, &KGWBACKANIMATIONKEy) boolValue];
}

- (void)setDragBackAnimationDelegate:(id<GWScrollViewDragBackAnimationDelegate>)dragBackAnimationDelegate
{
     objc_setAssociatedObject(self, &KGWBACKANIMATIONDelegate, [NSValue valueWithPointer:(__bridge const void *)(dragBackAnimationDelegate)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<GWScrollViewDragBackAnimationDelegate>)dragBackAnimationDelegate
{
    return [objc_getAssociatedObject(self, &KGWBACKANIMATIONDelegate) pointerValue];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([self.dragBackAnimationDelegate respondsToSelector:@selector(canDragBack:gestureRecognizer:)]) {
        BOOL canBack = [self.dragBackAnimationDelegate canDragBack:self gestureRecognizer:gestureRecognizer];
        
        return canBack;
    }
    
    
    if (self.ifAgreeBackAnimation) {
        if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
        {
            UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
            CGPoint translation = [panGesture translationInView:self];
            
            
            if(DefaultGreatAndEqualFloats(0, self.contentOffset.x) && IsRightSlideGesture(translation))
            {
                return NO;
            }
        }
    }
    return YES;
}

@end
