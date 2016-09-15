//
//  GWBaseCellGroundView.h
//  GWMovie
//
//  Created by gewara10 on 13-12-16.
//  Copyright (c) 2013年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    GWBaseCellGroundViewPositionTop,
    GWBaseCellGroundViewPositionMiddle,
    GWBaseCellGroundViewPositionBottom,
    GWBaseCellGroundViewPositionSingle
} GWBaseCellGroundViewPosition;

/**
 *  基础列表排版 圆角图页面
 */
@interface GWBaseCellGroundView : UIView

@property (strong, nonatomic) UIImageView *baseCellImageView;
@property (assign, nonatomic) GWBaseCellGroundViewPosition position;

/**
 *  自定义
 *
 *  @param imageViewName
 *  @param highImageName
 */
- (void)settingbaseCellImageView:(NSString *)imageViewName
            HighlightedImage:(NSString *)highImageName;
@end
