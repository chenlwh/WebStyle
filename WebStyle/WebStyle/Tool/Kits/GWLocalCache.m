//
//  GWLocalCache.m
//  GWMovie
//
//  Created by wushengtao on 14-10-8.
//  Copyright (c) 2014年 gewara. All rights reserved.
//

#import "GWLocalCache.h"
#import "GWAppGroupsForMovie.h"

static GWLocalCache* __instance;
@implementation GWLocalCache
+ (GWLocalCache*)currentCache
{
    return [[self class] currentCacheForPath:[GWAppGroupsForMovie shareCachePath].path];
}

+ (GWLocalCache*)currentCacheForPath:(NSString*)cachePath
{
    @synchronized(self) {
        setEGoCacheDirectory(cachePath);
        
        if(!__instance) {
            __instance = [[[self class] alloc] init];
            __instance.defaultTimeoutInterval = 86400;
        }
    }
    
    return __instance;
}


#pragma mark parent method
- (void)flterCache
{

}

- (BOOL)earlierDate:(NSDate*)date
{
    return NO;
}
@end
