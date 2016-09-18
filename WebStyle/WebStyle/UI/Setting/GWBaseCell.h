//
//  GWBaseCell.h
//  GWMovie
//
//  Created by gewara10 on 13-12-18.
//  Copyright (c) 2013年 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWBaseCellGroundView.h"


@interface GWBaseCell : UITableViewCell

@property (strong, nonatomic) GWBaseCellGroundView *cellBackImageView;
@property (strong, nonatomic) UIView *bcAccessoryView;
@property (strong, nonatomic) UILabel *bcRightTextLabel;
@property (strong, nonatomic) UIImageView *bcArrowImageView;

@end
