//
//  GWObject.m
//  GewaraCore
//
//  Created by yangxueya on 6/5/13.
//  Copyright (c) 2013 Chuan. All rights reserved.
//

#import "GWObject.h"
#import "SFRuntimeUtils.h"
#import "SFObjectProperty.h"
#import "NSObject+AutoPairKeyValue.h"
//#import "GWMsgdefine.h"


@implementation GWObject



- (GWUserDefaults*)gwUserDefaults
{
    if(!_gwUserDefaults)
    {
        _gwUserDefaults = [[GWUserDefaults alloc] init];
    }
    
    return _gwUserDefaults;
}

-(id)valueForUndefinedKey:(NSString *)key

{
    return Nil;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key

{
}


-(id)initWithDictionary:(NSDictionary*)propertyDict
{
    self = [super init];
    
    
    //TODO:sheen value非nsstring但obj是nsstring，iphone4，os7会闪退
    [propertyDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [self setValue:obj forKey:key];
        }
        
    }];
    
    return self;
}

- (BOOL)shouldCodeWithPropertyName:(NSString *)propertyName
{
    return YES;
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)coder
{
    NSMutableDictionary* params = [self dictionaryFromObjectWithclassDecider:^BOOL(Class tmpClass, BOOL *stop) {
        if(tmpClass == [GWObject class])
        {
            *stop = YES;
            return NO;
        }
        return YES;
    }];

    
    NSString* key;
    NSString* value;
    for(key in [params allKeys])
    {
        if(![self shouldCodeWithPropertyName:key])
        {
            continue;
        }
        
        value = [params objectForKeyedSubscript:key];
        if([[value class] conformsToProtocol:@protocol(NSCoding)])
        {
            [coder encodeObject:value forKey:key];
        }
    }
}

- (id)initWithCoder:(NSCoder *)coder
{
    NSMutableArray* params = [self keyFromObjectWithClassDecider:^BOOL(Class tmpClass, BOOL *stop) {
        if(tmpClass == [NSObject class])
        {
            *stop = YES;
            return NO;
        }
        return YES;
    }];
    
    
   
    
    NSString* key;
    NSString* value;
    for(key in params)
    {
        if(![self shouldCodeWithPropertyName:key])
        {
            continue;
        }
        
        value = [coder decodeObjectForKey:key];
        if(value)
        {
            [self setValue:value forKeyPath:key];
        }
    }
    
    return self;
}

@end
