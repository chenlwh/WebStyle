//
//  VideoTitleTableViewCell.m
//  WebStyle
//
//  Created by liudan on 9/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "VideoTitleTableViewCell.h"

@implementation VideoTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)cellIndentifier
{
    return @"VideoTitleTableViewCell";
}
@end
