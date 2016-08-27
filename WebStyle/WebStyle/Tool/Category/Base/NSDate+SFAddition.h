//
//  NSDate+SFAddition.h
//  GewaraCore
//
//  Created by yangzexin on 13-8-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SFAddition)

+ (NSString *)weekNameForWeekDay:(NSInteger)weekDay;
+ (NSDate *)gw_dateFromRFC1123String:(NSString *)string;
- (NSDateComponents *)componentsUsingCurrentCalendar;

@end
