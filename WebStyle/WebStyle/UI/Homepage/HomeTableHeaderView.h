//
//  HomeTableHeaderView.h
//  WebStyle
//
//  Created by liudan on 8/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) UIButton *allButton; //查看全部按钮
@property (nonatomic,strong) UILabel *titleLabel; //头部名称标签
@property (nonatomic,strong) UIView * orangeView; //橘色图标

/**
 *  根据标示符和视图宽度 生成头部视图
 *
 *  @param reuseIdentifier 标示符
 *  @param viewWidth       视图宽度
 *
 *  @return 头部视图
 */
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier withViewWidth:(CGFloat)viewWidth;


-(void)updateHeaderTitle:(NSString*)title;
@end
