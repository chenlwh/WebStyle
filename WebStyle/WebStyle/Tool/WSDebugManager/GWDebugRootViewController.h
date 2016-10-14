//
//  GWDebugRootViewController.h
//  GWMovie
//
//  Created by wushengtao on 15/4/1.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __USE_DEBUGTOOL__

@interface GWDebugRootViewController : UIViewController
@property (nonatomic, copy) NSArray* imageOperations;
- (void)reloadDisplay;
@end

#endif
