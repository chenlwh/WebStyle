//
//  GWUserDefaults.m
//  GewaraCore
//
//  Created by liangscofield on 15/10/12.
//  Copyright © 2015年 __MyCompanyName__. All rights reserved.
//

#import "GWUserDefaults.h"

@interface GWUserDefaults ()

@property (nonatomic, retain) NSMutableDictionary* gwUserInfo;

@end

@implementation GWUserDefaults

- (void)dealloc
{
    self.gwUserInfo = nil;
    
}

- (instancetype)init {
    self = [super init];
    
    self.gwUserInfo = [NSMutableDictionary dictionary];
    
    return self;
}

- (id)objectForKey:(NSString *)defaultName
{
    return [self.gwUserInfo objectForKey:defaultName];
}

- (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [self.gwUserInfo setValue:value forKey:defaultName];
}

- (void)removeObjectForKey:(NSString *)defaultName
{
    [self.gwUserInfo removeObjectForKey:defaultName];
}

@end
