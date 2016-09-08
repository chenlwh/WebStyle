//
//  UserCenterHeader.h
//  WebStyle
//
//  Created by liudan on 9/8/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@interface UserCenterHeader : UIView

@property (nonatomic, strong) Member *currentMember;

/**
 *  设置未登录状态
 */
- (void)restUserCenterIfNotLogin;

/**
 *  设置当前用户头像
 *
 *  @param pImage
 */
- (void)setCurrentUserHeaderImage:(UIImage *)pImage;

/**
 *  设置当前用户昵称
 *
 *  @param nickName
 */
- (void)setCurrentUserNickName:(NSString *)nickName;

@end
