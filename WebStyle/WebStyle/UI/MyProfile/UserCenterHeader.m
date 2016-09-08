//
//  UserCenterHeader.m
//  WebStyle
//
//  Created by liudan on 9/8/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "UserCenterHeader.h"
#import "UIView+Gewara.h"
#import "UIImageView+WebCache.h"

@interface UserCenterHeader ()
//@property (nonatomic, strong) GWExclusiveTouchButton *messageButton; // 消息按钮
//@property (nonatomic, strong) GWExclusiveTouchButton *settingButton; // 设置按钮

@property (nonatomic, strong) UIImageView *userHeaderImageView; // 用户头像
@property (nonatomic, strong) UIImageView *pencilImageView; // 铅笔图像

@property (nonatomic, strong) UILabel *nickName; // 用户昵称

//@property (nonatomic, strong) GWImageLabel *userDescImageLabel; // 用户打标

//@property (nonatomic,strong) GwMessageInfoView *messageInfoView;
@end

@implementation UserCenterHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUserCustomInfo:frame];
//        [self loadLeftRightButtons];
        
    }
    return self;
}

- (void)dealloc
{
}

- (void)loadUserCustomInfo:(CGRect)frame
{
    UIImageView *tempUserImageView =[[UIImageView alloc] init];
    tempUserImageView.layer.masksToBounds = YES;
    tempUserImageView.layer.cornerRadius = 69.0/2;
    tempUserImageView.contentMode = UIViewContentModeScaleAspectFill;
    tempUserImageView.clipsToBounds = YES;
    tempUserImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    tempUserImageView.layer.borderWidth = 2;
    tempUserImageView.image = [UIImage imageNamed:@"icon_defaultAvatar"];
    tempUserImageView.bounds = CGRectMake(0, 0, 70, 70);
    tempUserImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.userHeaderImageView = tempUserImageView;
    [self addSubview:tempUserImageView];
    
    
    CGSize constraint = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    NSString *text = @"点击登录";
    UIFont *labelFont = [UIFont systemFontOfSize:17];
    UIColor *labelTextColor = [UIColor whiteColor];
    CGSize textSize = [text sizeWithFont:labelFont
                       constrainedToSize:constraint
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.userHeaderImageView.bottom+12, frame.size.width, textSize.height)];
    pLabel.numberOfLines = 1;
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textAlignment = NSTextAlignmentCenter;
    pLabel.font = labelFont;
    pLabel.text = text;
    pLabel.textColor = labelTextColor;
    pLabel.alpha = 1;
    self.nickName = pLabel;
    [self addSubview:pLabel];
    
//    GWImageLabel *pUserDescImageLabel = [[GWImageLabel alloc] initWithFrame:CGRectZero];
//    
//    [pUserDescImageLabel setBackgroundColor:[UIColor clearColor]];
//    [pUserDescImageLabel setTextColor:[UIColor blackColor]];
//    [pUserDescImageLabel setFont:[UIFont systemFontOfSize:17]];
//    pUserDescImageLabel.frame = CGRectMake(pLabel.right, 0, 200, 20);
//    pUserDescImageLabel.centerY = pLabel.centerY;
//    self.userDescImageLabel = pUserDescImageLabel;
//    [self addSubview:self.userDescImageLabel];
    
    
    UIImage *pencilImage = [UIImage imageNamed:@"icon_edit"];
    UIImageView *pencilImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tempUserImageView.right - pencilImage.size.width, tempUserImageView.bottom - pencilImage.size.height, pencilImage.size.width, pencilImage.size.height)];
    pencilImageView.image = pencilImage;
    pencilImageView.backgroundColor = [UIColor clearColor];
    pencilImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.pencilImageView = pencilImageView;
    [self addSubview:pencilImageView];
}

- (void)restUserCenterIfNotLogin
{
    self.nickName.text = @"点击登录";
    self.nickName.width = [self userNameLabelWidth:_nickName.text];
    self.nickName.centerX = self.width/2;
    
    self.pencilImageView.hidden = YES;
//    self.userDescImageLabel.hidden = YES;
    self.userHeaderImageView.image = [UIImage imageNamed:@"icon_defaultAvatar"];
}


- (void)setCurrentMember:(Member *)currentMember
{
    if (!currentMember) {
        return;
    }
    
    _currentMember = currentMember;
    [self handleCurrentMemberInfo];
}

- (void)handleCurrentMemberInfo
{
//    NSString *fitUrlStr = [[GWFitSizeNetworkPolicy shareInstance] fitImageUrlWithOriginUrl:_currentMember.headpic
//                                                                              imageFitSize:self.userHeaderImageView.bounds.size];
//    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fitUrlStr];
//    
//    if (image)
//    {
//        self.userHeaderImageView.image = image;
//    }
//    else
//    {
//        image = self.userHeaderImageView.image ? self.userHeaderImageView.image : [GWMovieImage imageDefaultUserHeader];
//        [self.userHeaderImageView setFitSizeImageWithURLString:_currentMember.headpic
//                                              placeholderImage:image
//                                                     completed:nil];
//    }
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_currentMember.headpic] placeholderImage:nil];
    
//    [GWMovieAppContext appContext].gwUserInfo.headpic = _currentMember.headpic;
    
    if (_currentMember.nickname.length > 0)
    {
        self.nickName.text = _currentMember.nickname;
        self.nickName.width = [self userNameLabelWidth:_nickName.text];
    }
    
    self.nickName.centerX = self.width/2;
    
//    self.userDescImageLabel.centerY = self.nickName.centerY;
//    [self.userDescImageLabel displayTitleLabelWithMovieOrCinema:_currentMember.userMark];
//    self.userDescImageLabel.left = self.nickName.centerX + [self userNameLabelWidth:self.nickName.text]/2.0 + 1;
//    
//    self.userDescImageLabel.hidden = NO;
    self.pencilImageView.hidden = NO;
}

- (CGFloat)userNameLabelWidth:(NSString *)labelText
{
    CGSize textSize = [labelText sizeWithFont:self.nickName.font
                            constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat compairValue = self.width - 100;
    
    return textSize.width > compairValue ? compairValue : textSize.width;
}

- (void)setCurrentUserHeaderImage:(UIImage *)pImage
{
    if (pImage) {
        self.userHeaderImageView.image = pImage;
    }
}

- (void)setCurrentUserNickName:(NSString *)nickName
{
    if (nickName.length)
    {
        self.nickName.text = nickName;
        self.nickName.width = [self userNameLabelWidth:nickName];
        self.nickName.centerX = self.width/2;
        
//        self.userDescImageLabel.left = self.nickName.centerX + [self userNameLabelWidth:nickName]/2.0 + 1;
    }
}


@end
