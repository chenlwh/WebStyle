//
//  SearchedVideoCell.m
//  WebStyle
//
//  Created by 刘丹 on 16/9/6.
//  Copyright © 2016年 liudan. All rights reserved.
//

#import "SearchedVideoCell.h"
#import "UIView+Gewara.h"
#import "MsgDefine.h"

@implementation SearchedVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.contentView.width
}

+(CGFloat) SearchedVideoCellHeight
{
    return GWScreenW * 0.45 * 0.75 + 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
