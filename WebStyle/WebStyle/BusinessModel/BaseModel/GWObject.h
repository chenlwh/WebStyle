//
//  GWObject.h
//  GewaraCore
//
//  Created by yangxueya on 6/5/13.
//  Copyright (c) 2013 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWUserDefaults.h"

@interface GWObject : NSObject<NSCoding>

@property (nonatomic, assign) NSUInteger gwTag;
@property (nonatomic, retain) NSMutableDictionary* gwUserInfo;

@property (nonatomic, retain) GWUserDefaults * gwUserDefaults; // 保存object缓存信息

- (id)initWithDictionary:(NSDictionary*)propertyDict;// __deprecated_msg("后期会逐步退化掉该方法，字典转模型使用MJExtension里的[NSObject objectWithKeyValues:dic]来转换");
- (BOOL)shouldCodeWithPropertyName:(NSString *)propertyName;
@end
