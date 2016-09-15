//
//  UserCenterHeader.h
//  WebStyle
//
//  Created by liudan on 9/8/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@class UserCenterHeader;
@protocol UserCenterHeaderDelegate <NSObject>
@optional
- (void)editButtonClick:(UserCenterHeader *)userCenterHeaderView;
- (void)settingButtonClick:(UserCenterHeader *)userCenterHeaderView;
@end

@interface UserCenterHeader : UIView

@property (nonatomic, strong) Member *currentMember;
@property (nonatomic, weak) id<UserCenterHeaderDelegate> delegate;

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
