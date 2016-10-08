//
//  BottomToolBar.h
//  WebStyle
//
//  Created by liudan on 9/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferVideo.h"

typedef enum: NSInteger{
    FavoStatusUnKown = -1,
    FavoStatusIsFavor, //收藏，
    FavoStatusIsNotFavor //未收藏
}FavoStatusType;
@protocol  BottomBarDelegate <NSObject>

-(void)customButtonClick;

@end

OBJC_EXPORT const CGFloat kBottomBarHeight;
@interface BottomToolBar : UIView

@property (nonatomic, readonly) UIButton *likeBtn;
@property (nonatomic, readonly) UIButton *customBtn;
@property (nonatomic, readonly) UILabel* likeTitleView;
@property (nonatomic, strong) UIScrollView* observerScrollView;
@property (nonatomic, strong) PreferVideo *video;
@property (nonatomic, assign) FavoStatusType favorStatus;
@property (nonatomic, strong) UIViewController *attachedVC;
@property (nonatomic, assign) id <BottomBarDelegate> delegate;

+ (BottomToolBar*)createBottomToolBarWithView:(UIView*)superView;

//加载收藏状态
-(void)reloadData;
@end
