//
//  GWNewUserCenterTopCell.m
//  GWMovie
//
//  Created by liangscofield on 16/4/20.
//  Copyright © 2016年 gewara. All rights reserved.
//

#import "GWNewUserCenterTopCell.h"
//#import "GWImagePolicyView.h"
//#import "BudleImageCache.h"
#import "UIView+Gewara.h"
//#import "UIColor+Gewara.h"
//#import "GWCommkit.h"
#import "MsgDefine.h"
#import "FTUtils.h"

@interface GWNewUserCenterTopCell ()

@property (nonatomic, strong) NSMutableArray *showViewList;

@end

@implementation GWNewUserCenterTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUserInterface];
    }
    
    return self;
}

- (void)createUserInterface
{
    self.showViewList = [NSMutableArray array];
    
    NSArray *iconList = @[@"my_like",@"my_video",@"my_uploadVideo"];
    NSArray *textList = @[@"我的收藏",@"我的视频",@"发布视频"];
    
    CGFloat increase = GWScreenW/3;
    CGFloat startX = 0;
    
    for (int i = 0 ; i < 3; i++)
    {
        CGRect frame = CGRectMake(startX, 0, increase, kUserCenterTopCellHeight);
        GWNewUserCenterShowView *pUserCenterShowView = [[GWNewUserCenterShowView alloc] initWithFrame:frame];
        pUserCenterShowView.tag = i;
        pUserCenterShowView.backgroundColor = [UIColor whiteColor];
        [pUserCenterShowView addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [pUserCenterShowView displayWithIconName:iconList[i] text:textList[i]];
        [self.contentView addSubview:pUserCenterShowView];
        [self.showViewList addObject:pUserCenterShowView];
        
        startX += increase;
    }
}

- (void)clickAction:(GWNewUserCenterShowView *)pShowView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userCenterTopCell:clickWithStyle:)])
    {
        [self.delegate userCenterTopCell:self clickWithStyle:(GWUserCenterTopCellStyle)pShowView.tag];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end


@interface GWNewUserCenterShowView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation GWNewUserCenterShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)displayWithIconName:(NSString *)iconName text:(NSString *)text
{
    UIImage *pImage = [UIImage imageNamed:iconName];
    
    self.imageView.image = pImage;
    self.imageView.frame = CGRectMake(0, 13, pImage.size.width, pImage.size.height);
    self.imageView.centerX = self.width/2;
    
    CGSize constraint = CGSizeMake(MAXFLOAT, MAXFLOAT);
    UIFont *labelFont = [UIFont systemFontOfSize:12];
    UIColor *labelTextColor = RGBACOLORFromRGBHex(0xa0a0a0);
    CGSize textSize = [text sizeWithFont:labelFont
                       constrainedToSize:constraint
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    self.textLabel.font = labelFont;
    self.textLabel.text = text;
    self.textLabel.textColor = labelTextColor;
    self.textLabel.frame = CGRectMake(0, self.imageView.bottom+10, self.width, textSize.height);
}


- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor clearColor];
//        _imageView.placeholderBackColor = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 1;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.alpha = 1;
        [self addSubview:_textLabel];
    }
    
    return _textLabel;
}

@end
