//
//  VideoBrowserTableViewCell.m
//  WebStyle
//
//  Created by liudan on 9/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "VideoBrowserTableViewCell.h"

@implementation VideoBrowserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLabelText:(NSString*)info
{
    _infoLabel.text = info;
}

+(NSString *)cellIndentifier
{
    return @"VideoBrowserTableViewCell";
}
@end
