//
//  GWAppGroupsForMovie.h
//  GewaraCore
//
//  Created by yangxueya on 9/22/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString* const GWUserCacheUserKey;//用户登陆信息
extern NSString* const GWWidgetMovieListKey;//电影列表key



//这个是因为格瓦拉项目都可以用，所以放到这边，而且还加了一些业务逻辑

@class GWWidgetUser;
@class GWUser;
@class GWLoginInfo;

@interface GWAppGroupsForMovie : NSObject

+ (void)setDefaultAppGroupWithSuiteName:(NSString*)suiteName;
+ (NSUserDefaults*)shareMovieAppGroupUserDefaults;//默认userdefault

/**
 *  关于登陆用户的信息，一旦登陆成功就需要更新(暂时需求，)
 */
+ (NSUserDefaults*)loginUserUserDefaults;//保存登陆信息的userdefault
+ (GWUser*)readLastLoginUser;
+ (void)saveLastLoginUser:(GWUser*)user;
+ (void)saveWidgetUser:(GWWidgetUser*)widgetUser;
+ (GWWidgetUser*)readWidgetUser;

+ (NSUserDefaults*)appConfigUserDefaults;//保存配置信息的

+ (NSURL*)shareCachePath;
@end
