//
//  HomepageHeaderView.h
//  WebStyle
//
//  Created by liudan on 8/25/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@interface HomepageHeaderView : UIView


/**
 *  滚动图片区
 */
@property(nonatomic ,strong) SDCycleScrollView * cycleScrollView;


@property (nonatomic, strong) NSArray *dataArray;
@end
