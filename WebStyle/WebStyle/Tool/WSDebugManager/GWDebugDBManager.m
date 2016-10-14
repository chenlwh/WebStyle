//
//  GWDebugDBManager.m
//  GWMovie
//
//  Created by wushengtao on 15/5/25.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWDebugDBManager.h"

//#ifdef __USE_DEBUGTOOL__
#import "GWRequestDurationDAO.h"

static GWDebugDBManager* shareInstance = nil;
@implementation GWDebugDBManager
+ (id)shareDBManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!shareInstance)
        {
            shareInstance = [[GWDebugDBManager alloc] init];
        }
    });
    
    return shareInstance;
}

- (void)openDBAndCreateTable
{
    BOOL openFlag = [self openDBWithName:[NSString stringWithFormat:@"gewara_debug"]];
    
    if(!openFlag)
    {
        return;
    }
    
    //创建表
    [self createTable];
    //初始化时修改表
    [self updatedDBInit];
}

- (void)createTable
{
    [GWRequestDurationDAO createTable];
#ifdef __USE_DEBUGTOOL__
    [GWRequestDebugDurationDAO createTable];
#endif
}

- (void)updatedDBInit
{
}

#pragma mark
- (void)clearCacheByUser
{
    [GWRequestDurationDAO clearCacheByUser];
#ifdef __USE_DEBUGTOOL__
    [GWRequestDebugDurationDAO clearCacheByUser];
#endif
}
@end
//#endif
