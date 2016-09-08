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
#import "UIImageView+WebCache.h"
@implementation SearchedVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.contentView.width
}

+(CGFloat) SearchedVideoCellHeight
{
    return GWScreenW * 0.45 * 0.75 + 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setVideoInfo:(PreferVideo*)video
{
    [_videoImgView sd_setImageWithURL:[NSURL URLWithString:video.vedioimage] completed:nil];
    [_videoTime setText:[NSString stringWithFormat:@"发布时间：%@", video.date]];
    [_videoTitle setText:video.vedioDesc];
//    _videoAuthor setText:<#(NSString * _Nullable)#>
}

@end
