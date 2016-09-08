//
//  UserCenterBaseCell.h
//  WebStyle
//
//  Created by liudan on 9/8/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UserCenterBaseCellHeight  (50)
@interface UserCenterBaseCell : UITableViewCell
/**
 *  是否有右边的描述信息
 */
@property (nonatomic, assign) BOOL hasDescription;

/**
 *  右边的描述信息位置
 */
@property (nonatomic) CGFloat rightDescriptionX;

/**
 *  右边的描述信息中间位置
 */
@property (nonatomic) CGFloat rightDescriptionCenterY;

/**
 *  设置右边的文字描述
 *
 *  @param text
 */
- (void)setDescriptionWithText:(NSString *)text;

/**
 *  设置左边的信息
 *
 *  @param iconName
 *  @param title
 */
- (void)setIconName:(NSString *)iconName title:(NSString *)title;


/**
 *  设置左边的信息图片
 *
 *  @param imageUrl 图片链接地址
 *  @param title
 */
- (void)setLeftIconWithImageUrl:(NSString *)imageUrl title:(NSString *)title;



@end
