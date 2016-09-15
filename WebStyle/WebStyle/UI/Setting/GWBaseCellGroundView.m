//
//  GWBaseCellGroundView.m
//  GWMovie
//
//  Created by gewara10 on 13-12-16.
//  Copyright (c) 2013年 gewara. All rights reserved.
//

#import "GWBaseCellGroundView.h"
#import "MsgDefine.h"
#import "Masonry.h"

@implementation GWBaseCellGroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.baseCellImageView =[[UIImageView alloc] init];
        self.baseCellImageView.userInteractionEnabled = YES;
//        self.baseCellImageView.frame =CGRectMake(0.0f, 0.0f, self.width, self.height);
        self.baseCellImageView.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        self.baseCellImageView.backgroundColor =[UIColor clearColor];
        self.baseCellImageView.clipsToBounds = YES;
        self.baseCellImageView.layer.cornerRadius = 5.5f;

        [self addSubview:self.baseCellImageView];
        [self.baseCellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    return self;
}

/**
 *  设置表单类型
 *
 *  @param aposition
 */
-(void)setPosition:(GWBaseCellGroundViewPosition)aposition{
    _position = aposition;
 [self settingCellWithPosition:GWBaseCellGroundViewPositionMiddle];
}


- (void)settingCellWithPosition:(GWBaseCellGroundViewPosition)position{
    
    switch (position) {
        case GWBaseCellGroundViewPositionTop:
            self.baseCellImageView.image =[self settingImageWithImageName:@"table_top.png"];
            self.baseCellImageView.highlightedImage =[self settingImageWithImageName:@"table_top_pre.png"];
            break;
        case GWBaseCellGroundViewPositionMiddle:
            self.baseCellImageView.image =[self settingImageWithImageName:@"table_middle.png"];
            self.baseCellImageView.highlightedImage =[self settingImageWithImageName:@"table_middle_pre.png"];
            break;
        case GWBaseCellGroundViewPositionBottom:
            self.baseCellImageView.image =[self settingImageWithImageName:@"table_bottom.png"];
            self.baseCellImageView.highlightedImage =[self settingImageWithImageName:@"table_bottom_pre.png"];
            break;
        case GWBaseCellGroundViewPositionSingle:
            self.baseCellImageView.image =[self settingImageWithImageName:@"table_hole.png"];
            self.baseCellImageView.highlightedImage =[self settingImageWithImageName:@"table_hole_pre.png"];
            break;
            
        default:
            break;
    }
}

/**
 *  拉伸图片
 *
 *  @param imageName
 *
 *  @return UIImage
 */
-(UIImage *)settingImageWithImageName:(NSString *)imageName{
    UIImage *Image =[[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f)];
    return Image;
}

/**
 *  自定义
 *
 *  @param imageViewName
 *  @param highImageName
 */
- (void)settingbaseCellImageView:(NSString *)imageViewName
                HighlightedImage:(NSString *)highImageName{
    
    self.baseCellImageView.image =[self settingImageWithImageName:imageViewName];
    self.baseCellImageView.highlightedImage =[self settingImageWithImageName:highImageName];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
