//
//  VideoCard.m
//  WebStyle
//
//  Created by liudan on 8/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "VideoCard.h"
#import "FTUtils.h"
#import "UIView+Gewara.h"
#import "UIImageView+WebCache.h"

@implementation VideoCard

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
//        self.layer.borderColor = RGBACOLORFromRGBHex(0xcccccc).CGColor;
//        self.layer.cornerRadius = 2;
//        self.backgroundColor = RGBACOLORFromRGBHex(0xe9e8e8);
        [self create];
    }
    return self;
}

-(void)create
{
    _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height * 0.85)];
    _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _videoImageView.clipsToBounds = YES;
    _videoImageView.backgroundColor = RGBACOLORFromRGBHex(0xe9e8e8);
    _videoImageView.layer.cornerRadius = 4.0f;
    [self addSubview:_videoImageView];
    
    UIImageView *maskBottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width , 20)];
    [maskBottomImage setImage:[UIImage imageNamed:@"bk_mask_bottom"]];
    maskBottomImage.bottom = _videoImageView.bottom;
    self.maskBottomImageView = maskBottomImage;
    maskBottomImage.clipsToBounds = YES;
    maskBottomImage.layer.cornerRadius = 4.0f;
    [self addSubview:maskBottomImage];
    
    _anchorLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, self.width * 0.7, self.height*0.125)];
    _anchorLabel.bottom = _videoImageView.bottom - 2;
    _anchorLabel.textColor = RGBACOLORFromRGBHex(0xa0a0a0);
    _anchorLabel.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:_anchorLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, self.width - 4, self.height * 0.15)];
    _titleLabel.top = _videoImageView.bottom + 2;
    _titleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    _titleLabel.textColor = RGBACOLORFromRGBHex(0x000000);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
}

-(void) setVideo:(PreferVideo *)video
{
    _video = video;
    
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:_video.vedioimage] completed:nil];
    _anchorLabel.text = _video.tag;
    
    _titleLabel.text = _video.vedioDesc;
}
@end
