//
//  GWDramaSearchHeaderView.m
//  GWMovie
//
//  Created by liangscofield on 16/5/19.
//  Copyright © 2016年 gewara. All rights reserved.
//

#import "GWDramaSearchHeaderView.h"
#import "FTUtils.h"
//#import "UIColor+Gewara.h"
#import "UIView+Gewara.h"

@interface GWDramaSearchHeaderView ()

@property (nonatomic, strong) UILabel *topDescLabel;
@property (nonatomic, strong) UILabel *bottomDescLabel;

@end

@implementation GWDramaSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUserInterface];
    }
    return self;
}


- (void)createUserInterface
{
    // 获取 搜索的数据源
    
    CGFloat offsetY = 15;
    
//    UILabel *topDescLabel = [self createLabelWithFont:[UIFont systemFontOfSize:13]
//                                              textAli:NSTextAlignmentLeft
//                                            textColor:[UIColor colorWithHexString:@"#a0a0a0"]];
//    topDescLabel.text = @"大家都在搜";
//    topDescLabel.left = 25;
//    topDescLabel.top = offsetY;
//    [self addSubview:topDescLabel];
//    
//    topDescLabel.height = 0;
//    topDescLabel.hidden = YES;
    
    UILabel *bottomDescLabel = [self createLabelWithFont:[UIFont systemFontOfSize:13]
                                                 textAli:NSTextAlignmentLeft
                                               textColor:RGBACOLORFromRGBHex(0xa0a0a0)];
    bottomDescLabel.text = @"历史记录";
    bottomDescLabel.left = 25;
    bottomDescLabel.top = offsetY;
    [self addSubview:bottomDescLabel];
    
    
    self.height = bottomDescLabel.bottom + offsetY;
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



@end
