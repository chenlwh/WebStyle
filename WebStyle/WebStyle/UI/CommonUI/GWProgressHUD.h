//
//  GWProgressHUD.h
//  GWMovie
//
//  Created by yangxueya on 12/30/13.
//  Copyright (c) 2013 gewara. All rights reserved.
//

#import "MBProgressHUD.h"

/**
 *  这个是全屏加载的控件，录像带动画那个
 */

@interface GWProgressHUD : MBProgressHUD

+ (GWProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated;

+ (GWProgressHUD *)HUDForView:(UIView *)view;
+ (NSArray *)allHUDsForView:(UIView *)view;

@end
