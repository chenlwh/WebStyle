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
#import "UIImageView+WebCache.h"

@implementation PrePlayView

-(id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
    _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imgView.backgroundColor = [UIColor hexStringToColor:@"#dbdbdb"];
    _imgView.layer.masksToBounds = YES;
    _imgView.contentMode = UIViewContentModeCenter;
    _imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    [_imgView layer].shadowPath =[UIBezierPath bezierPathWithRect:_imgView.bounds].CGPath;
    
    [self addSubview:_imgView];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [_backBtn setFrame:CGRectMake(8, 4, 40, 40)];
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_play_btn_bg@2x" ofType:@"png"]];
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame = CGRectMake((self.width-img.size.width)/2, (self.height-img.size.height)/2, img.size.width, img.size.height);
    [_playBtn setBackgroundImage:img forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backBtn.right + 5, 0, self.width - 30, 33)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLabel];
    _titleLabel.centerY = _backBtn.centerY;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_video == nil) return;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_video.vedioimage] placeholderImage:nil];
    
    self.titleLabel.text = _video.vedioDesc;
}

-(void)playBtnClick:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(playVideo)])
    {
        [_delegate playVideo];
    }
}
-(void)backBtnClick:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(goBack)])
    {
        [_delegate goBack];
    }
}

@end
