//
//  NSDate+SFAddition.m
//  GewaraCore
//
//  Created by yangzexin on 13-8-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+SFAddition.h"

@implementation NSDate (SFAddition)

+ (NSString *)weekNameForWeekDay:(NSInteger)weekDay
{
    if(weekDay == 1){
        return @"周日";
    }else if(weekDay == 2){
        return @"周一";
    }else if(weekDay == 3){
        return @"周二";
    }else if(weekDay == 4){
        return @"周三";
    }else if(weekDay == 5){
        return @"周四";
    }else if(weekDay == 6){
        return @"周五";
    }else if(weekDay == 7){
        return @"周六";
    }
    return @"";
}

- (NSDateComponents *)componentsUsingCurrentCalendar
{
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    return [calender components:NSCalendarUnitYear
            | NSCalendarUnitMonth
            | NSCalendarUnitDay
            | NSCalendarUnitHour
            | NSCalendarUnitMinute
            | NSCalendarUnitSecond
            | NSCalendarUnitWeekOfMonth
            | NSCalendarUnitEra
            | NSCalendarUnitWeekday
            | NSCalendarUnitWeekdayOrdinal
            | NSCalendarUnitQuarter
            | NSCalendarUnitWeekOfMonth
            | NSCalendarUnitWeekOfYear
            | NSCalendarUnitYearForWeekOfYear
            | NSCalendarUnitCalendar
            | NSCalendarUnitTimeZone fromDate:self];
}

+ (NSDate *)gw_dateFromRFC1123String:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    // Does the string include a week day?
    NSString *day = @"";
    if ([string rangeOfString:@","].location != NSNotFound) {
        day = @"EEE, ";
    }
    // Does the string include seconds?
    NSString *seconds = @"";
    if ([[string componentsSeparatedByString:@":"] count] == 3) {
        seconds = @":ss";
    }
    [formatter setDateFormat:[NSString stringWithFormat:@"%@dd MMM yyyy HH:mm%@ z",day,seconds]];
    return [formatter dateFromString:string];
}

@end
