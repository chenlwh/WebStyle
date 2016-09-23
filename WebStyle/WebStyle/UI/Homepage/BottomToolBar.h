//
//  BottomToolBar.h
//  WebStyle
//
//  Created by liudan on 9/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomToolBar : UIView

@property (nonatomic, readonly) UIButton *likeBtn;
@property (nonatomic, readonly) UIButton *customBtn;
@property (nonatomic, readonly) UILabel* likeTitleView;
@property (nonatomic, strong) UIScrollView* observerScrollView;

+ (BottomToolBar*)createBottomToolBarWithView:(UIView*)superView;
@end
