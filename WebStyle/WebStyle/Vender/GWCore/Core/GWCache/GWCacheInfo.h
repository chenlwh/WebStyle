//
//  GWCacheInfo.h
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWDownloadCache.h"

extern const NSTimeInterval kGWSecondsByMinute;
extern const NSTimeInterval kGWSecondsByHour;
extern const NSTimeInterval kGWSecondsByDay;
extern const NSTimeInterval kGWSecondsByWeak;
extern const NSTimeInterval kGWSecondsByYear;

typedef enum : NSUInteger {
    EGWCachePolicyNetworkFirst = 0     //不读取缓存
    , EGWCachePolicyCacheFirst         //缓存优先，没有缓存/缓存过期才请求网络
    , EGWCachePolicyCacheAlwaysRead    //只要缓存存在，不管是否过期，始终读取
} EGWCachePolicy;

@interface GWCacheInfo : NSObject

/**
 *  缓存策略
 */
@property (nonatomic, assign) EGWCachePolicy cachePolicy;
/**
 *  缓存有效期
 */
@property (nonatomic, assign) NSTimeInterval cacheSecond;

/**
 *  缓存过滤策略
 */
@property (nonatomic, retain) GWDownloadCache* downloadCache;
@end
