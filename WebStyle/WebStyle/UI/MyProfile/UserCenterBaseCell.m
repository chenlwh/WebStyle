//
//  UserCenterBaseCell.m
//  WebStyle
//
//  Created by liudan on 9/8/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "UserCenterBaseCell.h"
#import "FTUtils.h"
#import "MsgDefine.h"
#import "UIView+Gewara.h"
#import "UIImageView+WebCache.h"

@interface UserCenterBaseCell()

@property (nonatomic, strong) UIImageView *leftIconImage;
@property (nonatomic, strong) UILabel *leftDescLabel;
@property (nonatomic, strong) UILabel *rightDescLabel;

@property (nonatomic, strong) UIImageView *rightArrowImageView;
@property (nonatomic, assign) CGPoint leftIconCenter;

@end

@implementation UserCenterBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUserInterface];
        self.hasDescription = NO;
    }
    
    return self;
}

- (void)createUserInterface
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *pSelectView = [UIView new];
    pSelectView.backgroundColor = RGBACOLORFromRGBHex(0xe8e6de);
    self.selectedBackgroundView = pSelectView;
    
    CGFloat bottomHeight = 0.5;
    UIView *bottomLine = [UIView new];
    bottomLine.frame = CGRectMake(0, UserCenterBaseCellHeight-bottomHeight, GWScreenW, bottomHeight);
    bottomLine.backgroundColor = RGBACOLORFromRGBHex(0xf6f6f6);
    [self.contentView addSubview:bottomLine];
    
    
    CGFloat imageWidth = 15;
    CGFloat imageHeight = 15;
    
    self.leftIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, (UserCenterBaseCellHeight - imageHeight)/2, imageWidth, imageHeight)];
    self.leftIconImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.leftIconImage];
    
    self.leftIconCenter = self.leftIconImage.center;
    
    self.leftDescLabel = [self createLabelWithFont:[UIFont systemFontOfSize:15]
                                           textAli:NSTextAlignmentLeft
                                         textColor:[UIColor blackColor]];
    
    self.leftDescLabel.left = self.leftIconImage.right + 15;
    self.leftDescLabel.top = (UserCenterBaseCellHeight - self.leftDescLabel.height)/2;
    [self.contentView addSubview:self.leftDescLabel];
    
    
    UIImage *arrowImage = [UIImage imageNamed:@"newUser_arrow"];
    self.rightArrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    self.rightArrowImageView.frame =CGRectMake(GWScreenW - (arrowImage.size.width+10), (UserCenterBaseCellHeight - arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height);
    self.rightArrowImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.rightArrowImageView];
    
    
    self.rightDescLabel = [self createLabelWithFont:[UIFont systemFontOfSize:10]
                                            textAli:NSTextAlignmentRight
                                          textColor:RGBACOLORFromRGBHex(0xa0a0a0)];
    
    self.rightDescLabel.right = self.rightArrowImageView.left - 8;
    self.rightDescLabel.top = (UserCenterBaseCellHeight - self.rightDescLabel.height)/2;
    [self.contentView addSubview:self.rightDescLabel];
    
}


- (UILabel *)createLabelWithFont:(UIFont *)font textAli:(NSTextAlignment)textAli textColor:(UIColor *)textColor
{
    CGSize constraint = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    NSString *text = @"占位";
    UIFont *labelFont = font;
    UIColor *labelTextColor = textColor;
    CGSize textSize = [text sizeWithFont:labelFont
                       constrainedToSize:constraint
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, textSize.height)];
    pLabel.numberOfLines = 1;
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textAlignment = textAli;
    pLabel.font = labelFont;
    pLabel.text = text;
    pLabel.textColor = labelTextColor;
    pLabel.alpha = 1;
    
    return pLabel;
}
- (void)setHasDescription:(BOOL)hasDescription
{
    _hasDescription = hasDescription;
    self.rightDescLabel.hidden = !hasDescription;
}

- (void)setDescriptionWithText:(NSString *)text
{
    self.rightDescLabel.text = text;
}

- (void)setIconName:(NSString *)iconName title:(NSString *)title
{
    UIImage *pCurrentImage = [UIImage imageNamed:iconName];
    
    if (pCurrentImage) {
        self.leftIconImage.image = pCurrentImage;
        self.leftIconImage.bounds = CGRectMake(0, 0, pCurrentImage.size.width+0.5, pCurrentImage.size.height);
        self.leftIconImage.center = self.leftIconCenter;
    }
    
    self.leftDescLabel.text = title;
}

- (CGFloat)rightDescriptionX
{
    return self.rightDescLabel.right;
}

- (CGFloat)rightDescriptionCenterY
{
    return self.rightDescLabel.centerY;
}

- (void)setLeftIconWithImageUrl:(NSString *)imageUrl title:(NSString *)title
{
//    if (imageUrl.length) {
//        
//        GWBaseNetworkPolicy* policy = [GWNewworkPolicyManager instance].defaultPolicy;
//        NSString *fitUrlStr = [policy fitImageUrlWithOriginUrl:imageUrl
//                                                  imageFitSize:self.leftIconImage.bounds.size];
//        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fitUrlStr];
//        
//        if (image) {
//            self.leftIconImage.image = image;
//        } else {
//           
//        }
//    }
    [self.leftIconImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    self.leftDescLabel.text = title;
}


@end
