//
//  GWUserCenterBaseCornerCell.m
//  GWMovie
//
//  Created by 段成杰 on 15/4/22.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWUserCenterBaseCornerCell.h"
#import "UIView+Gewara.h"
#import "GWBaseCellGroundView.h"
#import "UIView+GWCorner.h"
#import "Masonry.h"
#import "MsgDefine.h"
#import "FTUtils.h"

@interface GWUserCenterBaseCornerCell ()

@property (nonatomic,strong) UIView * cellBackImageView;

@end

@implementation GWUserCenterBaseCornerCell

@dynamic cellBackImageView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.cellBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, GWScreenW - 20, 49)];
        [self.contentView addSubview:self.cellBackGroundView];
        
        self.cellBackGroundView.backgroundColor = [UIColor whiteColor];
        self.cellBackImageView.hidden = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
//        [self.cellBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(@(10));
//            make.right.equalTo(self.contentView.mas_right).offset(@(-10));
//            make.top.equalTo(self.contentView.mas_top);
//            make.height.equalTo(@(50));
//        }];
        self.cellBackImageView.hidden = YES;
        self.cellBackImageView.borderColor = RGBCOLOR(202, 200, 198);
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    int cellHeight = self.frame.size.height;
    int cellWidth = self.frame.size.width;
    self.textLabel.frame = CGRectMake(25, 0, cellWidth-15, cellHeight);
}
//-(void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType{
//    [self layoutUcAccessoryView:accessoryType];
//}

//- (void)layoutUcAccessoryView:(UITableViewCellAccessoryType)type{
//    ]
    /**
     * 设置cell accessoryView
     */
//    if (type == UITableViewCellAccessoryDisclosureIndicator) {
//        
//        CGRect bcAccessoryViewFrame =CGRectMake(0.0f, 0.0f,100.0f, 35.0f);
//        self.bcAccessoryView =[[UIView alloc] initWithFrame:bcAccessoryViewFrame];
//        self.bcAccessoryView.backgroundColor =[UIColor clearColor];
//        self.accessoryView =self.bcAccessoryView;
//        
//        UIImage *arrowImage =[BudleImageCache imageNamed:@"maparrow"];
//        self.bcArrowImageView =[[UIImageView alloc] initWithImage:arrowImage];
//        self.bcArrowImageView.frame =CGRectMake(self.bcAccessoryView.width -(arrowImage.size.width+10), 10.0f, arrowImage.size.width, arrowImage.size.height);
//        self.bcArrowImageView.backgroundColor =[UIColor clearColor];
//        [self.bcAccessoryView addSubview:self.bcArrowImageView];
//        
//        CGRect ucRightFrame =CGRectMake(0.0f, 6.0f,self.bcAccessoryView.width-(self.bcArrowImageView.width+10), 21.0f);
//        self.bcRightTextLabel =[[UILabel alloc] initWithFrame:ucRightFrame];
//        self.bcRightTextLabel.font =[UIFont systemFontOfSize:14.0f];
//        self.bcRightTextLabel.textColor =[UIColor lightGrayColor];
//        self.bcRightTextLabel.textAlignment =NSTextAlignmentRight;
//        self.bcRightTextLabel.backgroundColor =[UIColor clearColor];
//        self.bcRightTextLabel.adjustsFontSizeToFitWidth =YES;
//        [self.bcAccessoryView addSubview:self.bcRightTextLabel];
//    }else{
//        [self.bcAccessoryView removeFromSuperview];
//    }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
