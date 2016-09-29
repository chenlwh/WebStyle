//
//  HomepageHeaderView.h
//  WebStyle
//
//  Created by liudan on 8/25/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "PreferVideo.h"

@interface HomepageHeaderView : UIView<SDCycleScrollViewDelegate>

/**
 *  滚动图片区
 */
@property(nonatomic ,strong) SDCycleScrollView * cycleScrollView;
@property(nonatomic, copy) void (^selectVideoBlock)(PreferVideo* video);


@property (nonatomic, strong) NSArray *dataArray;
@end
