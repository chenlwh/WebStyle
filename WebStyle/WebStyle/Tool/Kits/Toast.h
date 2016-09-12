//
//  Toast.h
//  imyvoa
//
//  Created by yangzexin on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DelayController;

@interface Toast : NSObject {
    UIView *_view;
    UIView *_roundRectView;
    UILabel *_label;
    
    DelayController *_delayController;
    DelayController *_animationDelayController;
}

+ (Toast *)defaultToast;

- (void)showToastInView:(UIView *)parentView withString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval completion:(void(^)(void))completion;
- (void)showToastInView:(UIView *)parentView withString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval;
- (void)showToastWithString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval;

- (void)show:(NSString*)content hideAfterInterval:(NSTimeInterval)interval completion:(void(^)(void))completion;



@end
