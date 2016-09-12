//
//  Toast.m
//  imyvoa
//
//  Created by yangzexin on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Toast.h"
#import <QuartzCore/QuartzCore.h>
#import "DelayController.h"
#import "SFKeyboardStateListener.h"
#import "NSString+GWStringDrawing.h"

#define ROUND_RECT_ALPHA 0.72f

typedef void(^HideCallBack)(void);

@interface Toast () <DelayControllerDelegate>

@property(nonatomic, retain)UIView *view;
@property(nonatomic, retain)UIView *roundRectView;
@property(nonatomic, retain)UILabel *label;

@property(nonatomic, retain)DelayController *delayController;
@property(nonatomic, retain)DelayController *animationDelayController;

@property(nonatomic, copy)HideCallBack hideCallback;

@end

@implementation Toast

@synthesize view = _view;
@synthesize roundRectView = _roundRectView;
@synthesize label = _label;

@synthesize delayController = _delayController;
@synthesize animationDelayController = _animationDelayController;

@synthesize hideCallback;

+ (Toast *)defaultToast
{
    static Toast *instance = nil;
    @synchronized(self){
        if(!instance){
            instance = [[Toast alloc] init];
        }
    }
    
    return instance;
}

- (void)dealloc
{
    _view = nil;
    _roundRectView = nil;
    _label = nil;
    
    [_delayController cancel]; _delayController = nil;
    [_animationDelayController cancel]; _animationDelayController = nil;
    
    self.hideCallback = nil;
    
}

- (id)init
{
    self = [super init];
    
    self.view = [[UIView alloc] init];
    self.view.hidden = YES;
    self.view.userInteractionEnabled = NO;
    
    self.roundRectView = [[UIView alloc] init];
    [self.view addSubview:self.roundRectView];
    self.roundRectView.layer.cornerRadius = 7.0f;
    self.roundRectView.backgroundColor = [UIColor blackColor];
    self.roundRectView.alpha = ROUND_RECT_ALPHA;
    
    self.label = [[UILabel alloc] init];
    [self.view addSubview:self.label];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    
    return self;
}

#pragma mark - override methods


#pragma mark - private methods

#pragma mark - instance methods

- (void)show:(NSString *)content hideAfterInterval:(NSTimeInterval)interval completion:(void (^)(void))completion{

    [self showToastInView:nil withString:content hideAfterInterval:interval completion:completion];

}

- (void)showToastInView:(UIView *)parentView withString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval completion:(void(^)(void))completion
{
    self.hideCallback = completion;
    
    //这里为了能使App extension也能使用所以这里只能这么写，使用到了一些runtime
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
    UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
    
    if(hasApplication && !parentView){
        parentView = [[app windows] lastObject];
    }

    


    
    [self.view removeFromSuperview];
    [parentView addSubview:self.view];
    self.view.frame = parentView.bounds;
    self.roundRectView.alpha = ROUND_RECT_ALPHA;
    self.label.alpha = 1.0f;
    
    self.label.text = string;
    
    CGFloat paddingLabel = 10;
    CGFloat paddingRoundRect = 10;
    
    CGFloat stringMaxWidth = self.view.frame.size.width - paddingRoundRect * 2 - paddingLabel * 2;
    CGSize stringSize = [string sizeWithFont:self.label.font];
    CGFloat labelWidth = stringSize.width;
    CGFloat labelHeight = self.label.font.lineHeight;
    if(stringSize.width > stringMaxWidth){
        labelWidth = stringMaxWidth;
        labelHeight = [string sizeWithFont:self.label.font
                         constrainedToSize:CGSizeMake(labelWidth, 1000)
                             lineBreakMode:NSLineBreakByTruncatingTail].height;
    }
    
    CGFloat availableScreenHeight = self.view.frame.size.height;
    if([SFKeyboardStateListener sharedInstance].keyboardVisible){
        availableScreenHeight -= 216;
    }
    
    CGFloat labelX = (self.view.frame.size.width - labelWidth) / 2;
    CGFloat labelY = (availableScreenHeight - labelHeight) / 2;
    
    self.label.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    self.roundRectView.frame = CGRectMake(labelX - paddingLabel,
                                          labelY - paddingLabel,
                                          labelWidth + paddingLabel * 2,
                                          labelHeight + paddingLabel * 2);
    [self.view.superview bringSubviewToFront:self.view];
    self.view.hidden = NO;
    
    if(self.animationDelayController){
        [self.animationDelayController cancel];
        self.animationDelayController = nil;
    }
    if(self.delayController){
        [self.delayController cancel];
        self.delayController = nil;
    }
    self.delayController = [[DelayController alloc] initWithInterval:interval];
    self.delayController.delegate = self;
    [self.delayController start];
}
- (void)showToastInView:(UIView *)parentView withString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval
{
    [self showToastInView:parentView withString:string hideAfterInterval:interval completion:nil];
}

- (void)showToastWithString:(NSString *)string hideAfterInterval:(NSTimeInterval)interval
{
    [self showToastInView:nil withString:string hideAfterInterval:interval];
}

#pragma mark - DelayControllerDelegate
- (void)delayControllerDidFinishedDelay:(DelayController *)controller
{
    if(controller == self.delayController){
        NSTimeInterval animationDuration = 0.25f;
        
        if(self.animationDelayController){
            [self.animationDelayController cancel];
            self.animationDelayController = nil;
        }
        self.animationDelayController = [[DelayController alloc] initWithInterval:animationDuration];
        self.animationDelayController.delegate = self;
        [self.animationDelayController start];
        
//        self.roundRectView.alpha = 0.2f;
//        self.label.alpha = 0.2f;
//        CGRect frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height, 0, 0);
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:animationDuration];
        
        self.roundRectView.alpha = 0.0f;
        self.label.alpha = 0.0f;
//        self.roundRectView.frame = frame;
//        self.label.frame = frame;
        
        [UIView commitAnimations];
    }else if(controller == self.animationDelayController){
        self.view.hidden = YES;
        if(self.hideCallback){
            self.hideCallback();
        }
        self.hideCallback = nil;
    }
}

@end
