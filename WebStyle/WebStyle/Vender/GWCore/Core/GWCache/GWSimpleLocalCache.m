//
//  GWSimpleLocalCache.m
//  GWMovie
//
//  Created by wushengtao on 14-10-10.
//  Copyright (c) 2014年 gewara. All rights reserved.
//

#import "GWSimpleLocalCache.h"


@implementation GWSimpleLocalCache

- (id)init
{
    if(self = [super init])
    {
        [self.replaceDictionary setObject:@"" forKey:@"memberEncode"];
        [self.replaceDictionary setObject:@"" forKey:@"pointx"];
        [self.replaceDictionary setObject:@"" forKey:@"pointy"];
        [self.replaceDictionary setObject:@"" forKey:@"cityname"];
    }
    
    return self;
}

@end
