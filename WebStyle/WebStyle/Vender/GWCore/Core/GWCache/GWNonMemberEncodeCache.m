//
//  GWNonMemberEncodeCache.m
//  GewaraCore
//
//  Created by wushengtao on 14-8-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWNonMemberEncodeCache.h"
#import <CommonCrypto/CommonHMAC.h>


@implementation GWNonMemberEncodeCache

- (id)init
{
    if(self = [super init])
    {
        [self.replaceDictionary setObject:@"" forKey:@"memberEncode"];
    }
    
    return self;
}
@end
