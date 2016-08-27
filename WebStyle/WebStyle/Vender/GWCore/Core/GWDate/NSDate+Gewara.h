//
//  NSDate+Gewara.h
//  GewaraCore
//
//  Created by Chuan on 12-11-20.
//  Copyright (c) 2012年 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    GWDateChineseMonthDay,
    GWDateChineseYearMonthDay,
    GWDateDashMonthDay,
    GWDateDashYearMonthDay,
    GWDateDashYearMonthDayHourMinute,
    GWDateDashYearMonthDayHourMinuteSecond,
    GWDateDashYearHourMinute
};

typedef NSUInteger GWDateFormat;

@interface NSDate (Gewara)

/**
 *  标准的时间
 *
 *  @return  @"yyyy-MM-dd HH:mm:ss"格式的formatter
 */
+ (NSDateFormatter*)defaultFormatter;

/**
 *  标准的时间
 *
 *  @return  @"yyyy-MM-dd"格式的formatter
 */
+ (NSDateFormatter*)yearMonthDayFormatter;

+ (NSCalendar*)defaultCalendar;


+ (NSDate *)BeijingTime;
+ (NSDate *)dateFromString:(NSString *)str;//年月日的
- (NSString *)stringFromDate:(GWDateFormat)format;
- (NSString*)stringFromFormat:(NSString*)formatStr;
/**
 *  格式化日期
 *  按以下格式返回：今天，明天，后天，如果不在此日期范围内，则返回nil
 *  @return 返回：今天，明天，后天，如果不在此日期范围内，则返回nil
 */
-(NSString *) todayTomorrowChinesesString;
/**
 *  格式化日期
 *  按以下格式返回：今天，昨天，则返回nil
 *  @return 返回：今天，昨天，则返回nil
 */
-(NSString *) todayYesterdayChinesesString;

/*
 * 麻辣哇啦专用
 1、今日麻辣哇啦
 2、7月22日
 3、2015年8月15日
 */
+(NSString*)malawalaDateString:(NSString*)walaDateStr;


- (NSDate*)dateWithAdditionTimeInterval:(NSTimeInterval)seconds;
- (NSString*)dateSplitByDayChineseString;

-(BOOL)isToday;
@end
