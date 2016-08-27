//
//  GWLocalCache.h
//  GWMovie
//
//  Created by wushengtao on 14-10-8.
//  Copyright (c) 2014年 gewara. All rights reserved.
//

#import "EGOCache.h"

@interface GWLocalCache : EGOCache
+ (GWLocalCache*)currentCache;
+ (GWLocalCache*)currentCacheForPath:(NSString*)cachePath;
@end
