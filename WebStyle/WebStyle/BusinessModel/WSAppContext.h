//
//  WSAppContext.h
//  WebStyle
//
//  Created by liudan on 9/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSUser.h"

@interface WSAppContext : NSObject
+ (instancetype)appContext;

@property(nonatomic, strong) WSUser *wsUserInfo;

/**
 *  获取应用名称
 *
 *  @return 应用名称
 */
+ (NSString *)appName;


/**
 *  创建一个设备id
 *
 *  @return <#return value description#>
 */
+ (NSString*)createAppUUID;

/**
 *  获取设备id，删除app后不变
 *
 *  @return 设备id
 */
+ (NSString*)appUUID;

@end
