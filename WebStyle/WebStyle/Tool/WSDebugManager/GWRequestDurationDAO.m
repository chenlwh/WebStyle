//
//  GWRequestDurationDAO.m
//  GWMovie
//
//  Created by wushengtao on 15/5/25.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWRequestDurationDAO.h"

//#ifdef __USE_DEBUGTOOL__
#import "GWDebugDBManager.h"

@implementation GWRequestDurationDAO
+ (NSString*)tableName
{
    return @"request_duration";
}

+ (GWDBManager*)dbManager
{
    return [GWDebugDBManager shareDBManager];
}

- (void)paramsAdditionmWithDuration:(GWRequestDurationDAO*)dao
{
    self.successCount += dao.successCount;
    self.successTotalTime += dao.successTotalTime;
    self.socketTmeout += dao.socketTmeout;
    self.http400 += dao.http400;
    self.httpGt400 += dao.httpGt400;
    self.http500 += dao.http500;
    self.http502 += dao.http502;
    self.http503 += dao.http503;
}

- (BOOL)valueIsIncorrect
{
    return ([self.ip length] == 0 || [self.method length] == 0);
}
@end

//#endif

#ifdef __USE_DEBUGTOOL__
@implementation GWRequestDebugDurationDAO
+ (NSString*)tableName
{
    return @"request_debug_duration";
}

+ (GWDBManager*)dbManager
{
    return [GWDebugDBManager shareDBManager];
}
@end
#endif
