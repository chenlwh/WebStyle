//
//  SearchedPlayerCell.m
//  WebStyle
//
//  Created by liudan on 9/7/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "SearchedPlayerCell.h"
#import "UIImageView+WebCache.h"
#import "MsgDefine.h"

@implementation SearchedPlayerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setPlayerInfo:(PreferPlayer*)player
{
    [_playerImgView sd_setImageWithURL:[NSURL URLWithString:player.headimage] completed:nil];
    [_nickName setText:player.nickname];
    [_aboutMeInfo setText:[NSString stringWithFormat:@"简介：%@", player.aboutme.length > 0 ? player.aboutme : @"什么都没有留下,"]];
}

+(CGFloat) SearchedPlayerCellHeight
{
    return GWScreenW * 0.3 + 30;
}

@end
