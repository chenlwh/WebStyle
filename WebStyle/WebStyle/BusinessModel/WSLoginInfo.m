//
//  WSLoginInfo.m
//  WebStyle
//
//  Created by liudan on 9/14/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "WSLoginInfo.h"

@implementation WSLoginInfo
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _username = [[aDecoder decodeObjectForKey:@"username"] copy];
        _password = [[aDecoder decodeObjectForKey:@"password"] copy];
    }
    
    return self;
}

- (void)dealloc
{
    _username = nil;
    _password = nil;
    
}

@end
