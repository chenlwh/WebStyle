//
//  PrePlayView.m
//  WebStyle
//
//  Created by liudan on 9/21/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "PrePlayView.h"
#import "UIView+Gewara.h"
#import "Color+Hex.h"

@implementation PrePlayView
- (void)initSubViewFrame:(CGRect)rect
{
    
    _imgView = [[UIImageView alloc] initWithFrame:self.backView.bounds];
    _imgView.backgroundColor = [UIColor hexStringToColor:@"#dbdbdb"];
    _imgView.layer.masksToBounds = YES;
    _imgView.contentMode = UIViewContentModeCenter;
    _imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    [_imgView layer].shadowPath =[UIBezierPath bezierPathWithRect:_imgView.bounds].CGPath;
    
    [self addSubview:_imgView];
    
    
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_play_btn_bg@2x" ofType:@"png"]];
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame = CGRectMake((self.width-img.size.width)/2, (self.height-img.size.height)/2, img.size.width, img.size.height);
    [_playBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self addSubview:_playBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.width - 30, 33)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLabel];
}
@end
