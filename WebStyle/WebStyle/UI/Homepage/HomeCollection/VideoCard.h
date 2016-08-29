//
//  VideoCard.h
//  WebStyle
//
//  Created by liudan on 8/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferVideo.h"
#import "MsgDefine.h"

#define movieCardHeight GWTranslateWidthBase4P7ScreenValue(102 + 20)
#define movieCardWidth GWTranslateWidthBase4P7ScreenValue(170)
#define movieCardImgHeight GWTranslateWidthBase4P7ScreenValue(102)

@interface VideoCard : UIControl

@property (nonatomic, strong) PreferVideo *video;
@property (nonatomic, copy) void (^videoClick)(PreferVideo *video);
@property (nonatomic, strong) UIImageView *videoImageView;
@property(nonatomic,strong) UIImageView *maskBottomImageView;
@property (nonatomic, strong) UILabel *anchorLabel; //作者名称
@property (nonatomic, strong) UILabel *titleLabel; //标题


@end
