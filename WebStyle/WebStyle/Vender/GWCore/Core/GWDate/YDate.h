//
//  YDate.h
//
//  Created by Xueya Yang on 11-3-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YDate : NSObject
{
	struct {
		unsigned int month : 4;
		unsigned int day : 5;
		unsigned int year : 15;
		unsigned int hour : 5;
		unsigned int minute : 6;
		unsigned int second : 6;
	} a;
}
+ (NSString*)constellationWithMonth:(NSInteger)month day:(NSInteger)day;
+ (YDate *)dateForYear:(unsigned int)year 
				  month:(unsigned int)month 
					Day:(unsigned int)day 
				  hour:(unsigned int)hour 
				minute:(unsigned int)minute 
				second:(unsigned int)second;

+ (YDate *)dateFromNSDate:(NSDate *)date;

- (id)initForYear:(unsigned int)year 
			month:(unsigned int)month 
			  Day:(unsigned int)day 
			 hour:(unsigned int)hour 
		   minute:(unsigned int)minute 
		   second:(unsigned int)second;

- (unsigned int)day;
- (unsigned int)month;
- (unsigned int)year;
- (unsigned int)hour;
- (unsigned int)minute;
- (unsigned int)second;

- (NSDate *)NSDate;
- (NSComparisonResult)compare:(YDate *)otherDate;

/*Weekday units are the numbers 1 through 7,
 For example Sunday is represented by 1.*/
- (NSInteger)weekDay;
- (NSString*)constellation;
- (BOOL)isSameDayWith:(YDate *)otherDate;

-(BOOL)isAfterHour:(NSInteger)aHour;
- (NSString *)dateWithWeek ;


+(NSDate*)beijingTimeNow;
@end
