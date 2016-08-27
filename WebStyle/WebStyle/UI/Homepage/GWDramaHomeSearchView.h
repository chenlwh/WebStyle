//
//  GWDramaHomeSearchView.h
//  GWMovie
//
//  Created by liangscofield on 16/5/18.
//  Copyright © 2016年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDramaHomeSearchViewHeight  (30)

@interface GWDramaHomeSearchView : UIImageView

@property (nonatomic, copy) void(^selectSearchClick)();
@property (nonatomic, assign) BOOL textFieldEnable;

@end
