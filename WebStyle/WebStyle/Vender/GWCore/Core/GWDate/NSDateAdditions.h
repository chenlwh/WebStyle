/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <Foundation/Foundation.h>

@interface NSDate (KalAdditions)

// All of the following methods use [NSCalendar NSCalendarIdentifierGregorian] to perform
// their calculations.

- (NSDate *)cc_dateByMovingToBeginningOfDay;
- (NSDate *)cc_dateByMovingToEndOfDay;
- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth;
- (NSDateComponents *)cc_componentsForMonthDayAndYear;
- (NSDateComponents *)cc_componentsForYearMonthDayHourMinuteAndSecond;
- (NSUInteger)cc_weekday;
- (NSUInteger)cc_numberOfDaysInMonth;

+ (NSDate *)dateWithFromString:(NSString *)dateString ;


-(NSDate *)offsetMonth:(NSInteger)numMonths;
-(NSDate *)offsetDay:(NSInteger)numDays;
-(NSDate *)offsetHours:(NSInteger)hours;
-(NSInteger)numDaysInMonth;
-(NSInteger)firstWeekDayInMonth;
-(NSInteger)year;
-(NSInteger)month;
-(NSInteger)day;
-(NSInteger)hour;
-(NSInteger)minute;
-(NSInteger)second;


+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;
@end