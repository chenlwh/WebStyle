//
//  WSDebugWindow.m
//  WebStyle
//
//  Created by liudan on 10/13/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "WSDebugWindow.h"

@implementation WSDebugWindow
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    for (UIView *subview in self.subviews)
    {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil)
        {
            return YES;
        }
    }
    return NO;
}

//UIActionSheet showInView会把GWDebugWindow重置为keywindow导致错误，这里调整一下
- (void)becomeKeyWindow
{
    [super becomeKeyWindow];
    if(_appKeyWindow)
    {
        [_appKeyWindow makeKeyAndVisible];
    }
}
@end
