//
//  GWBaseCell.m
//  GWMovie
//
//  Created by gewara10 on 13-12-18.
//  Copyright (c) 2013年 gewara. All rights reserved.
//

#import "GWBaseCell.h"
#import "Masonry.h"
#import "MsgDefine.h"
#import "UIView+Gewara.h"
@interface GWBaseCell ()


@end

@implementation GWBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        /**
         * 设置cell 圆角背景图
         */
        
        if (IOS7) {
            self.cellBackImageView =[[GWBaseCellGroundView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.width - 20, self.height)];
            [self.contentView addSubview:self.cellBackImageView];
            self.cellBackImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        }else{
            self.cellBackImageView =[[GWBaseCellGroundView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width - 20, self.height)];
            self.backgroundView = self.cellBackImageView;
        }
        
        /**
         *  设置 selectedBackgroundView 背景为 clearColor
         *  达到点击cell 高亮显示
         */
        self.selectedBackgroundView= [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor =[UIColor clearColor];
        
        
        
    }
    return self;
}

-(void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType{
    [self layoutUcAccessoryView:accessoryType];
}

#pragma mark
/**
 *  显示accesoryView
 */
- (void)layoutUcAccessoryView:(UITableViewCellAccessoryType)type{
    
    /**
     * 设置cell accessoryView
     */
    if (type == UITableViewCellAccessoryDisclosureIndicator) {
        
        CGRect bcAccessoryViewFrame =CGRectMake(0.0f, 0.0f,160.0f, 35.0f);
        self.bcAccessoryView =[[UIView alloc] initWithFrame:bcAccessoryViewFrame];
        self.bcAccessoryView.backgroundColor =[UIColor clearColor];
        self.bcAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.accessoryView =self.bcAccessoryView;
//        [self.contentView addSubview:self.bcAccessoryView];
//        [self.bcAccessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.width.equalTo(@(100));
//            make.height.equalTo(@(35));
//        }];
        
        UIImage *arrowImage =[UIImage imageNamed:@"icon_arrow_right"];
        self.bcArrowImageView =[[UIImageView alloc] initWithImage:arrowImage];
        self.bcArrowImageView.frame =CGRectMake(self.bcAccessoryView.width -(arrowImage.size.width+10), 10.0f, arrowImage.size.width, arrowImage.size.height);
        self.bcArrowImageView.backgroundColor =[UIColor clearColor];
        [self.bcAccessoryView addSubview:self.bcArrowImageView];
        
        CGRect ucRightFrame =CGRectMake(0.0f, 6.0f,self.bcAccessoryView.width-(self.bcArrowImageView.width+10), 21.0f);
        self.bcRightTextLabel =[[UILabel alloc] initWithFrame:ucRightFrame];
        self.bcRightTextLabel.font =[UIFont systemFontOfSize:14.0f];
        self.bcRightTextLabel.textColor =[UIColor lightGrayColor];
        self.bcRightTextLabel.textAlignment =NSTextAlignmentRight;
        self.bcRightTextLabel.backgroundColor =[UIColor clearColor];
        self.bcRightTextLabel.adjustsFontSizeToFitWidth =YES;
        [self.bcAccessoryView addSubview:self.bcRightTextLabel];
        
    }else{
        [self.bcAccessoryView removeFromSuperview];
    }
    //cell背景图autolayout
    if (IOS7) {
        [self.cellBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0f);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right).offset(-10.0f);
            make.height.equalTo((self.mas_height));
        }];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
