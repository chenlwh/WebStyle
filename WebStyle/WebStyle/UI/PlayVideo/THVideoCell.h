//
//  THVideoCell.h
//  THPlayer
//
//  Created by inveno on 16/3/23.
//  Copyright © 2016年 inveno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferVideo.h"

@interface THVideoCell : UITableViewCell

@property (strong, nonatomic)PreferVideo *model;

@property (strong, nonatomic)UIImageView *imgView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UIButton *playBtn;

@property (strong, nonatomic)UIView *backView;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com