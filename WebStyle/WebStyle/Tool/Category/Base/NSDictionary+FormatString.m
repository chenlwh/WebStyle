//
//  NSDictionary+FormatString.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+FormatString.h"

@implementation NSDictionary (FormatString)

- (NSString*)urlString
{
    NSMutableArray* keys = [NSMutableArray arrayWithArray:[self allKeys]];
    [keys sortUsingComparator:(NSComparator)^(NSString *key1, NSString *key2){
        return [key1 compare:key2];
    }];
    NSMutableString* pairStr = [NSMutableString new];
    NSString* keyStr;
    for(keyStr in keys)
    {
        if(![[keys firstObject] isEqualToString:keyStr])
            [pairStr appendString:@"&"];
        [pairStr appendFormat:@"%@=%@", keyStr, [self objectForKey:keyStr]];
    }
    
    return pairStr;
}

@end
