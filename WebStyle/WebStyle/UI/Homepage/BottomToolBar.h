//
//  BottomToolBar.h
//  WebStyle
//
//  Created by liudan on 9/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum: NSInteger{
    FavoStatusUnKown = -1,
    FavoStatusIsFavor, //收藏，
    FavoStatusIsNotFavor //未收藏
}FavoStatusType;

OBJC_EXPORT const CGFloat kBottomBarHeight;
@interface BottomToolBar : UIView

@property (nonatomic, readonly) UIButton *likeBtn;
@property (nonatomic, readonly) UIButton *customBtn;
@property (nonatomic, readonly) UILabel* likeTitleView;
@property (nonatomic, strong) UIScrollView* observerScrollView;

+ (BottomToolBar*)createBottomToolBarWithView:(UIView*)superView;
@end
