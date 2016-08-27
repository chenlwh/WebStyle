//
//  PageIndicator.h
//  Quartz2d_Learning
//
//  Created by yangzexin on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SVPageIndicator : UIView 

@property(nonatomic, assign)NSInteger currentPageIndex;
@property(nonatomic, assign)NSInteger numberOfPages;
@property(nonatomic, assign)CGFloat spacing;
@property(nonatomic, assign)CGFloat indicatorSize;

@property(nonatomic, retain)UIColor *normalBackgroundColor;
@property(nonatomic, retain)UIColor *highlightBackgroundColor;

@property(nonatomic, readonly)CGFloat realWidth;

- (id)initWithNumberOfPages:(NSInteger)numOfPages;

@end
