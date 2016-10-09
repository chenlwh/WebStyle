//
//  NSDate+Gewara.m
//  GewaraCore
//
//  Created by Chuan on 12-11-20.
//  Copyright (c) 2012年 Chuan. All rights reserved.
//

#import "NSDate+Gewara.h"
#import "NSDateFormatter+Gewara.h"
//#import "YDate.h"
#import "NSDateAdditions.h"

static NSCalendar* defaultCalendar = nil;

@implementation NSDate (Gewara)

+ (NSDateFormatter*)defaultFormatter
{
    return [NSDateFormatter dateFormatterWithDateFotmat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDateFormatter*)yearMonthDayFormatter
{
    return [NSDateFormatter dateFormatterWithDateFotmat:@"yyyy-MM-dd"];
}

+ (NSCalendar*)defaultCalendar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    });
    
    return defaultCalendar;
}

+ (NSDate *)BeijingTime
{
    NSDate* date = [NSDate date];
    NSTimeZone* bj = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeZone* local = [NSTimeZone systemTimeZone];
    NSInteger offset = [bj secondsFromGMT] - [local secondsFromGMT];
    return [NSDate dateWithTimeInterval:offset sinceDate:date];
}

+ (NSDate *)dateFromString:(NSString *)str
{
    NSDateFormatter* formatter = [NSDate yearMonthDayFormatter];
    [formatter setCalendar:[NSDate defaultCalendar]];
    //formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *date = [formatter dateFromString:str];
    return date;
}


- (NSString *)stringFromDate:(GWDateFormat)format
{
    NSArray* formmats = @[@"MM'月'dd'日'",
                          @"yyyy'年'MM'月'dd'日'",
                          @"MM-dd",
                          @"yyyy-MM-dd",
                          @"yyyy-MM-dd HH:mm",
                          @"yyyy-MM-dd HH:mm:ss",
                          @"HH:mm"];
    NSDateFormatter* formatter = [NSDateFormatter dateFormatterWithDateFotmat:[formmats objectAtIndex:format]];
    [formatter setCalendar:[NSDate defaultCalendar]];
    //formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString* str = [formatter stringFromDate:self];
    return str;
}

- (NSString*)stringFromFormat:(NSString*)formatStr
{
    NSDateFormatter* formatter = [NSDateFormatter dateFormatterWithDateFotmat:formatStr];
    [formatter setCalendar:[NSDate defaultCalendar]];
    //formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString* str = [formatter stringFromDate:self];
    return str;
}


/**
 *  格式化日期
 *  按以下格式返回：今天，明天，后天，如果不在此日期范围内，则返回nil
 *  @return 返回：今天，明天，后天，如果不在此日期范围内，则返回nil
 */
- (NSString *)todayTomorrowChinesesString
{
    NSArray* suffixes = [NSArray arrayWithObjects:@"今天", @"明天", @"后天", nil];
    NSDate* bjDate = [NSDate BeijingTime];
    NSArray* bjDatesArray = [NSArray arrayWithObjects:[bjDate stringFromDate:GWDateDashYearMonthDay],
                             [(NSDate*)[bjDate dateByAddingTimeInterval:24*60*60] stringFromDate:GWDateDashYearMonthDay],
                             [(NSDate*)[bjDate dateByAddingTimeInterval:24*60*60*2] stringFromDate:GWDateDashYearMonthDay], nil];
    
    NSString * strDate = [self stringFromDate:GWDateDashYearMonthDay];
    NSUInteger inn = [bjDatesArray indexOfObject:strDate];
    if (inn < [suffixes count]) {
        return [suffixes objectAtIndex:inn];
    }
    else
        return nil;
}
- (NSString *)todayYesterdayChinesesString
{
    NSArray* suffixes = [NSArray arrayWithObjects:@"今天", @"昨天", nil];
    NSDate* bjDate = [NSDate BeijingTime];
    NSArray* bjDatesArray = [NSArray arrayWithObjects:[bjDate stringFromDate:GWDateDashYearMonthDay],
                             [(NSDate*)[bjDate dateByAddingTimeInterval:-24*60*60] stringFromDate:GWDateDashYearMonthDay], nil];
    
    NSString * strDate=[self stringFromDate:GWDateDashYearMonthDay];
    NSUInteger inn = [bjDatesArray indexOfObject:strDate];
    if (inn < [suffixes count]) {
        return [suffixes objectAtIndex:inn];
    }
    else
        return nil;
}

/*
 1、今日麻辣哇啦
 2、7月22日
 3、2015年8月15日
 */
+(NSString*)malawalaDateString:(NSString*)walaDateStr
{
    NSDate *curDate = [NSDate date];
    NSDate *walaDate = [[NSDate yearMonthDayFormatter] dateFromString:walaDateStr];
    NSDateComponents *curParts = [curDate cc_componentsForMonthDayAndYear];
    NSDateComponents *walaParts  = [walaDate cc_componentsForMonthDayAndYear];
    if(curParts.year == walaParts.year)
    {
        if(curParts.month == walaParts.month && curDate.day == walaParts.day)
        {
            return @"今日哇啦";
        }
        else
        {
            return [NSString stringWithFormat:@"%d月%d日", walaParts.month, walaParts.day];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)walaParts.year, (long)walaParts.month, walaParts.day];
    }
}

+(NSString*)dateDescInfoWithDateString:(NSString*)dateStr
{
    NSDate *curDate = [NSDate date];
    NSDate *timeDate = [[NSDate defaultFormatter] dateFromString:dateStr];
    NSDateComponents *curParts = [curDate cc_componentsForMonthDayAndYear];
    NSDateComponents *timeParts  = [timeDate cc_componentsForMonthDayAndYear];
    if(curParts.year == timeParts.year)
    {
        if(curParts.month == timeParts.month && curDate.day == timeParts.day)
        {
            return [NSString stringWithFormat:@"今日%ld时%ld分", (long)timeParts.hour, (long)timeParts.minute];
        }
        else
        {
            return [NSString stringWithFormat:@"%ld月%ld日", timeParts.month, timeParts.day];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%ld年%ld月%ld日", timeParts.year, timeParts.month, timeParts.day];
    }
}

- (NSDate*)dateWithAdditionTimeInterval:(NSTimeInterval)seconds
{
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    timeInterval += seconds;
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}
/*
 如果是时间是今天则返回“今天”，当年的则返回“x月x号”,非当年则显示“x年x月x号”
 */

- (NSString*)dateSplitByDayChineseString{
    
    NSDate* bjDate = [NSDate BeijingTime];
    
    //当天
    //当年
    //其他年
    
   NSDateComponents *currParts = [bjDate cc_componentsForYearMonthDayHourMinuteAndSecond];
   NSDateComponents *myParts  = [self cc_componentsForYearMonthDayHourMinuteAndSecond];
 
    
    
    if (myParts.year != currParts.year) {
        
        return [self stringFromDate:GWDateChineseYearMonthDay];
        
    }
    
    if (myParts.day == currParts.day) {
        return @"今天";
    }else{
        return [self stringFromDate:GWDateChineseMonthDay];
    }
    
    
}

-(BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year
    && nowCmps.month == selfCmps.month
    && nowCmps.day == selfCmps.day;
}

@end
