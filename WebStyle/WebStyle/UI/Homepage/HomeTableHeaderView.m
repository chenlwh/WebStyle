//
//  HomeTableHeaderView.m
//  WebStyle
//
//  Created by liudan on 8/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "HomeTableHeaderView.h"
#import "FTUtils.h"
#import "UIView+Gewara.h"
#import "MsgDefine.h"

@interface HomeTableHeaderView ()
@property (nonatomic, strong) UIView *seprateView;

@end

@implementation HomeTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier withViewWidth:(CGFloat)viewWidth
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat itemHeight = 8 + 8;
        
        self.seprateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GWScreenW, 8)];
        self.seprateView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.seprateView];
        
        self.orangeView=[[UIView alloc] initWithFrame:CGRectMake(GWTranslateWidthBase4P7ScreenValue(15), itemHeight, 5, 15)];
        [self.orangeView setBackgroundColor:RGBACOLORFromRGBHex(0xeb611f)];
        [self addSubview:self.orangeView];
        
        self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.titleLabel.textColor = RGBACOLORFromRGBHex(0x5f5f5f);
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        self.allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.allButton setTitle:@"更多 >" forState:UIControlStateNormal];
        
        [self.allButton setTitleColor:RGBACOLORFromRGBHex(0xf26522) forState:UIControlStateNormal];
        self.allButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.allButton sizeToFit];
        
        self.allButton.centerY = self.orangeView.centerY;
        self.allButton.right = viewWidth - GWTranslateWidthBase4P7ScreenValue(15);
        [self addSubview:self.allButton];
    }
    return self;
}

//-(void)updateHeaderTitle:(NSString*)title
//{
//    self.orangeView.height = 15;
//    
//    [self.titleLabel setText:title];
//    [self.titleLabel sizeToFit];
//}
@end
