//
//  BasicViewController.h
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTUtils.h"
#import "MJRefresh.h"
#import "UIView+Gewara.h"
#import "MsgDefine.h"
#import "UIViewController+GWFindSubController.h"

@interface BasicViewController : UIViewController
@property (nonatomic,strong) UIColor *navBarColor;

//- (void)setStatusBarBackgroundColor:(UIColor *)color;
-(void)setStatusBarLight;

-(void)setGradientColorBarLight:(UIColor*)color;

-(void)setStatusBarDefault;
@end
