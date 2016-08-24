//
//  NSDateFormatter+Gewara.m
//  GewaraCore
//
//  Created by wushengtao on 15/10/8.
//  Copyright © 2015年 __MyCompanyName__. All rights reserved.
//

#import "NSDateFormatter+Gewara.h"

@implementation NSDateFormatter (Gewara)

+ (NSDateFormatter*)dateFormatterWithDateFotmat:(NSString*)dateFormat
{
    if([dateFormat length] == 0)
        return nil;
    
    NSMutableDictionary *formatterDic = [[NSThread currentThread] threadDictionary];
    
    NSString* keyFormat = [NSString stringWithFormat:@"gewara_%@", dateFormat];
    NSDateFormatter* formatter = formatterDic[keyFormat];
    if(!formatter)
    {
        @synchronized(self)
        {
            if(!formatter)
            {
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:dateFormat];
                [formatterDic setValue:formatter forKey:keyFormat];
                [formatter release];
            }
            else
            {
                if(![formatter.dateFormat isEqualToString:dateFormat])
                {
                    formatter.dateFormat = dateFormat;
                }
                formatter.calendar = nil;
            }
        }
    }
    else
    {
        @synchronized(self)
        {
            if(![formatter.dateFormat isEqualToString:dateFormat])
            {
                formatter.dateFormat = dateFormat;
            }
            formatter.calendar = nil;
        }
    }
    
    return formatter;
}


@end
