//
//  GWDramaHomeSearchView.m
//  GWMovie
//
//  Created by liangscofield on 16/5/18.
//  Copyright © 2016年 gewara. All rights reserved.
//

#import "GWDramaHomeSearchView.h"

#import "UIView+GWCorner.h"
//#import "UIColor+Gewara.h"
#import "BudleImageCache.h"
#import "UIView+Gewara.h"
#import "FTUtils.h"

@interface GWDramaHomeSearchView ()

@property (nonatomic, strong) UITextField *searchTextField;

@end

@implementation GWDramaHomeSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
        
        UIImage *fixedImage = 
        [UIImage imageNamed:@"search_bg"];
//        [[UIImage imageNamed:@"search_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 50, 0, 50)];
        self.image = fixedImage;
        
        self.userInteractionEnabled = YES;
        self.textFieldEnable = YES;
        
        [self createUserInterface];
        
        UITapGestureRecognizer *pTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:pTapGestureRecognizer];
    }
    return self;
}


- (void)setTextFieldEnable:(BOOL)textFieldEnable
{
    _textFieldEnable = textFieldEnable;
    self.searchTextField.userInteractionEnabled = textFieldEnable;
}

- (void)createUserInterface
{
    UIImage *searchImage = [UIImage imageNamed:@"navi_search"];
    
    CGFloat searchWidth = searchImage.size.width;
    CGFloat searchHeight = searchImage.size.height;

    UIImageView *pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (kDramaHomeSearchViewHeight - searchHeight)/2, searchWidth, searchHeight)];
    pImageView.image = searchImage;
    pImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:pImageView];
    
    
    NSString *placeHolder = @"搜索最热门的主播、视频";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:placeHolder];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBACOLORFromRGBHex(0xa0a0a0) range:NSMakeRange(0, [placeHolder length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, [placeHolder length])];
    
    UITextField *_searchTF = [[UITextField alloc] initWithFrame:CGRectMake(pImageView.right + 10, 0, 200, kDramaHomeSearchViewHeight)];
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchTF.placeholder = placeHolder;
    _searchTF.attributedPlaceholder = attributedString;
//    [_searchTF addTarget:self action:@selector(searchTrigger:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.backgroundColor = [UIColor clearColor];
    _searchTF.font = [UIFont systemFontOfSize:12];
    _searchTF.clearButtonMode = UITextFieldViewModeNever;
    _searchTF.rightViewMode = UITextFieldViewModeWhileEditing;
    _searchTF.userInteractionEnabled = self.textFieldEnable;
    _searchTF.textColor = [UIColor blackColor];
    self.searchTextField = _searchTF;
    [self addSubview:_searchTF];
    
    
//    UILabel *pLabel = [[UILabel alloc] init];
//    pLabel.numberOfLines = 1;
//    pLabel.backgroundColor = [UIColor clearColor];
//    pLabel.textAlignment = NSTextAlignmentLeft;
//    pLabel.alpha = 1;
//    pLabel.userInteractionEnabled = NO;
//    pLabel.text = @"搜索最热门的演出";
//    pLabel.font = [UIFont systemFontOfSize:13];
//    pLabel.textColor = [UIColor colorWithHexString:@"#5f5f5f"];
//    pLabel.alpha = 0.6;
//    pLabel.frame = CGRectMake(pImageView.right + 10, 0, 200, kDramaHomeSearchViewHeight);
//    [self addSubview:pLabel];
}

- (void)tapClick
{
    if (self.selectSearchClick) {
        self.selectSearchClick();
    }
}

@end
