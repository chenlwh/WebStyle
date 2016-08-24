//
//  GWCacheInfo.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWCacheInfo.h"

const NSTimeInterval kGWSecondsByMinute = 60;
const NSTimeInterval kGWSecondsByHour = 60 * 60;
const NSTimeInterval kGWSecondsByDay = 60 * 60 * 24;
const NSTimeInterval kGWSecondsByWeak = 60 * 60 * 24 * 7;
const NSTimeInterval kGWSecondsByYear = 60 * 60 * 24 * 365;

@implementation GWCacheInfo

- (void)dealloc
{
    if (_downloadCache) {
        [_downloadCache release];
    }
    
    _downloadCache = nil;
    
    [super dealloc];
}

@end
