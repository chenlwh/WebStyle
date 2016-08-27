//
//  YDate.m
//
//  Created by Xueya Yang on 11-3-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YDate.h"
#import "NSDateAdditions.h"

static NSArray *arrCONSTELLATIONS;

@implementation YDate

+ (void)initialize
{
    arrCONSTELLATIONS = [[NSArray arrayWithObjects:@"白羊座",@"金牛座",@"双子座",
                         @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"魔羯座", @"水瓶座", @"双鱼座", nil] retain];
	// TODO set a timer for midnight to recache this value
}
+ (NSString*)constellationWithMonth:(NSInteger)month day:(NSInteger)day
{
    int ID = 0;
    switch (month) {
		case 1:
			if (day <= 20) {
				ID = 9;
			} else {
				ID = 10;
			}
			break;
		case 2:
			if (day <= 19) {
				ID = 10;
			} else {
				ID = 11;
			}
			break;
		case 3:
			if (day <= 20) {
				ID = 11;
			} else {
				ID = 0;
			}
			break;
		case 4: 
			if (day <= 20) {
				ID = 0;
			} else {
				ID = 1;
			}
			break;
		case 5:  
			if (day <= 21) {
				ID = 1;
			} else {
				ID = 2;
			}
			break;
		case 6:
			if (day <= 21) {
				ID = 2;
			} else {
				ID = 3;
			}
			break;
		case 7:
			if (day <= 22) {
				ID = 3;
			} else {
				ID = 4;
			}
			break;
		case 8:
			if (day <= 23) {
				ID = 4;
			} else {
				ID = 5;
			}
			break;
		case 9:
			if (day <= 23) {
				ID = 5;
			} else {
				ID = 6;
			}
			break;
		case 10:
			if (day <= 23) {
				ID = 6;
			} else {
				ID = 7;
			}
			break;
		case 11:
			if (day <= 22) {
				ID = 7;
			} else {
				ID = 8;
			}
			break;
		case 12:
			if (day <= 21) {
				ID = 8;
			} else {
				ID = 9;
			}
			break;
		default:
			break;
    }
    
    return [arrCONSTELLATIONS objectAtIndex:ID];
}

- (NSString *)dateWithWeek
{
    NSString *week = nil ;
    switch ([self weekDay]) {
        case 1:
            week = @"周日";
            break;
        case 2:
            week = @"周一";
            break ;
        case 3:
            week = @"周二";
            break;
        case 4:
            week = @"周三";
            break ;
        case 5:
            week = @"周四";
            break;
        case 6:
            week = @"周五";
            break ;
        case 7:
            week = @"周六";
            break;
        default:
            break;
    }
    
    return week ;
}


+ (YDate *)dateForYear:(unsigned int)year 
				  month:(unsigned int)month 
					Day:(unsigned int)day 
				   hour:(unsigned int)hour 
				 minute:(unsigned int)minute 
				 second:(unsigned int)second;
{
	return [[[YDate alloc] initForYear:year month:month Day:day hour:hour minute:minute second:second] autorelease];
}

+ (YDate *)dateFromNSDate:(NSDate *)date
{
	NSDateComponents *parts = [date cc_componentsForYearMonthDayHourMinuteAndSecond];
	return [YDate dateForYear:[parts year] 
						 month:[parts month] 
						   Day:[parts day] 
						  hour:[parts hour] 
						minute:[parts minute] 
						second:[parts second]];
}

- (id)initForYear:(unsigned int)year 
			month:(unsigned int)month 
			  Day:(unsigned int)day 
			 hour:(unsigned int)hour 
		   minute:(unsigned int)minute 
		   second:(unsigned int)second;
{
	if ((self = [super init])) {
		a.day = day;
		a.month = month;
		a.year = year;
		a.hour = hour;
		a.minute = minute;
		a.second = second;
	}
	return self;
}

- (unsigned int)day { return a.day; }
- (unsigned int)month { return a.month; }
- (unsigned int)year { return a.year; }
- (unsigned int)hour { return a.hour; }
- (unsigned int)minute { return a.minute; }
- (unsigned int)second { return a.second; }

- (NSDate *)NSDate
{
	NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.day = a.day;
	c.month = a.month;
	c.year = a.year;
	c.hour = a.hour;
	c.minute = a.minute;
	c.second = a.second;
    
    NSCalendar* calender =  [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
	return [calender dateFromComponents:c];
}

- (NSComparisonResult)compare:(YDate *)otherDate
{
    NSDate *temp = [self NSDate];
    NSDate *other = [otherDate NSDate];
    
    return [temp compare:other];
}

#pragma mark -
#pragma mark NSObject interface

- (BOOL)isEqual:(id)anObject
{
	if (![anObject isKindOfClass:[YDate class]])
		return NO;
	
	YDate *d = (YDate*)anObject;
	return a.day==[d day] && a.month==[d month] && a.year==[d year] && a.hour==[d hour] && a.minute==[d minute] && a.second==[d second];
}


- (NSString *)description
{
	return [NSString stringWithFormat:@"%u/%u/%u %u:%u:%u", a.year, a.month, a.day, a.hour, a.minute, a.second];
}


- (NSInteger)weekDay
{
	NSDate *dt = [self NSDate];
    
	return [dt cc_weekday];
}


/*
 * 输入月+日 得到 星座ID 0=白羊座
 * 
 * 0白羊座：3月21日－4月20日 　　
 * 1金牛座：4月21日－5月21日 　　
 * 2双子座：5月22日－6月21日 　　
 * 3巨蟹座：6月22日－7月22日
 * 4狮子座：7月23日－8月23日 　　
 * 5处女座：8月24日－9月23日 　　
 * 6天秤座：9月24日－10月23日
 * 7天蝎座：10月24日－11月22日 　　
 * 8射手座：11月23日－12月21日 　　
 * 9魔羯座：12月22日－1月20日
 * 10水瓶座：1月21日－2月19日 　　
 * 11双鱼座：2月20日－3月20日
 */



-(NSString*)constellation
{
    NSInteger month = a.month;
    NSInteger day = a.day;
    int ID = 0;
    switch (month) {
		case 1:
			if (day <= 20) {
				ID = 9;
			} else {
				ID = 10;
			}
			break;
		case 2:
			if (day <= 19) {
				ID = 10;
			} else {
				ID = 11;
			}
			break;
		case 3:
			if (day <= 20) {
				ID = 11;
			} else {
				ID = 0;
			}
			break;
		case 4: 
			if (day <= 20) {
				ID = 0;
			} else {
				ID = 1;
			}
			break;
		case 5:  
			if (day <= 21) {
				ID = 1;
			} else {
				ID = 2;
			}
			break;
		case 6:
			if (day <= 21) {
				ID = 2;
			} else {
				ID = 3;
			}
			break;
		case 7:
			if (day <= 22) {
				ID = 3;
			} else {
				ID = 4;
			}
			break;
		case 8:
			if (day <= 23) {
				ID = 4;
			} else {
				ID = 5;
			}
			break;
		case 9:
			if (day <= 23) {
				ID = 5;
			} else {
				ID = 6;
			}
			break;
		case 10:
			if (day <= 23) {
				ID = 6;
			} else {
				ID = 7;
			}
			break;
		case 11:
			if (day <= 22) {
				ID = 7;
			} else {
				ID = 8;
			}
			break;
		case 12:
			if (day <= 21) {
				ID = 8;
			} else {
				ID = 9;
			}
			break;
		default:
			break;
    }
    
    return [arrCONSTELLATIONS objectAtIndex:ID];
}

- (BOOL)isSameDayWith:(YDate *)otherDate
{
    return (a.year==otherDate.year)&&(a.month==otherDate.month)&&(a.day==otherDate.day);
}

-(BOOL)isAfterHour:(NSInteger)aHour
{
    return a.hour>=aHour;
}


+(NSDate*)beijingTimeNow
{
    NSDate* date = [NSDate date];
    NSTimeZone* bj = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeZone* local = [NSTimeZone systemTimeZone];
    int offset = [bj secondsFromGMT] - [local secondsFromGMT];
    return [NSDate dateWithTimeInterval:offset sinceDate:date];
}

@end
