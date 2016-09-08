//
//  GWProgressHUD.m
//  GWMovie
//
//  Created by yangxueya on 12/30/13.
//  Copyright (c) 2013 gewara. All rights reserved.
//

#import "GWProgressHUD.h"
//#import "GWMovieComUtils.h"
#import <QuartzCore/QuartzCore.h>
//#import "GWMovieComUtils.h"
#import "UIView+Gewara.h"
//#import "GWCommkit.h"
#import "UIImage+GIF.h"
#import "FTUtils.h"
#import "MsgDefine.h"

@implementation GWProgressHUD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (GWProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
	GWProgressHUD *hud = [[GWProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	[hud show:animated];
	return hud;
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
	GWProgressHUD *hud = [GWProgressHUD HUDForView:view];
	if (hud != nil) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
		return YES;
	}
	return NO;
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
	NSArray *huds = [self allHUDsForView:view];
	for (GWProgressHUD *hud in huds) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
	}
	return [huds count];
}

+ (GWProgressHUD *)HUDForView:(UIView *)view {
	GWProgressHUD *hud = nil;
	NSArray *subviews = view.subviews;
	Class hudClass = [GWProgressHUD class];
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:hudClass]) {
			hud = (GWProgressHUD *)aView;
		}
	}
	return hud;
}

+ (NSArray *)allHUDsForView:(UIView *)view {
	NSMutableArray *huds = [NSMutableArray array];
	NSArray *subviews = view.subviews;
	Class hudClass = [GWProgressHUD class];
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:hudClass]) {
			[huds addObject:aView];
		}
	}
	return [NSArray arrayWithArray:huds];
}


#pragma mark --

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = RGBACOLORFromRGBHex(0xf0efef);
        self.dimBackground = NO;
        self.mode = MBProgressHUDModeCustomView;
        [self loadGif];

        self.yOffset = IS_IPHONE_4_INCH?-60:-30;
    }
    return self;
}


- (void)loadGif
{
    UIImageView *loadLogo  = [[UIImageView alloc] init];
    if (IS_IPHONE_5P5_INCH) {
        loadLogo.frame = CGRectMake(0, 0, 150, 150);
    }else{
        loadLogo.frame = CGRectMake(0, 0, 115, 115);
    }
    self.customView = loadLogo;

    //TODO:sheen 考虑使用弱引用image给全局使用
    WeakObjectDef(loadLogo);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString* name = @"loadingGIF.gif";
        NSString* filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
        NSData* imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage* gifImage = [UIImage sd_animatedGIFWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakloadLogo.image = gifImage;
        });
    });
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (self.dimBackground) {
		//Gradient colours
		size_t gradLocationsNum = 2;
		CGFloat gradLocations[2] = {0.0f, 1.0f};
		CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
		CGColorSpaceRelease(colorSpace);
		//Gradient center
		CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		//Gradient radius
		float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
		//Gradient draw
		CGContextDrawRadialGradient (context, gradient, gradCenter,
									 0, gradCenter, gradRadius,
									 kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
	}
    
    // Set background rect color
    if(self.color){
        CGContextSetFillColorWithColor(context, self.color.CGColor);
    } else {
        CGContextSetGrayFillColor(context, 0.0f, self.opacity);
    }
}

@end
