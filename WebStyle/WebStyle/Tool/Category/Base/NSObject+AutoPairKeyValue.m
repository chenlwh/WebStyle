//
//  NSObject+AutoPairKeyValue.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+AutoPairKeyValue.h"

@interface GWForAutoPairObject : NSObject<NSObject>
@end

@implementation GWForAutoPairObject
@end

@implementation NSObject (AutoPairKeyValue)
- (NSMutableDictionary*)dictionaryFromObjectWithclassDecider:(BOOL(^)(Class tmpClass, BOOL *stop))classDecider
{
    NSMutableDictionary* pairs = [NSMutableDictionary new];
    Class tmpClass = [self class];
    NSSet* filterSet = [self filterSet];
    while(tmpClass){
        
        if(classDecider){
            BOOL stop = NO;
            while(tmpClass && !classDecider(tmpClass, &stop)){
                tmpClass = class_getSuperclass(tmpClass);
            }
            if(stop){
                break;
            }
        }
        
        unsigned int count = 0;
        objc_property_t *firstProperty = class_copyPropertyList(tmpClass, &count);
        objc_property_t property;
        NSString* keyname;
        for(NSInteger i = 0; i < count; ++i)
        {
            property = *(firstProperty + i);
            keyname = [NSString stringWithUTF8String:property_getName(property)];
            //            const char *cattributes = property_getAttributes(property);
//            MSGLOG(@"%@, %@, %@", keyname, [self valueForKey:keyname], tmpClass);
            if(![filterSet containsObject:keyname])
            {
                [pairs setValue:[self valueForKey:keyname] forKey:keyname];
            }
            else
            {
//                MSGLOG(@"%@/%@ filterSet igonore:%@", tmpClass, [self class], keyname);
            }
        }
        free(firstProperty);
        
        tmpClass = class_getSuperclass(tmpClass);
    }
    
    return pairs;
}

- (NSSet*)filterSet
{
    static NSMutableSet* filterSet = nil;
    if(!filterSet)
    {
        NSArray* filterArray = [GWForAutoPairObject keyFromObjectWithClassDecider:nil];
        filterSet = [[NSMutableSet alloc] initWithArray:filterArray];
    }
    
    return filterSet;
}

- (NSMutableArray*)keyFromObjectWithClassDecider:(BOOL(^)(Class tmpClass, BOOL *stop))classDecider
{
    NSMutableArray* pairs = [[self class] keyFromObjectWithClassDecider:classDecider];
    NSSet* filterSet = [self filterSet];
    for(NSString* key in filterSet)
    {
        [pairs removeObject:key];
    }

    return pairs;
}

+ (NSMutableArray*)keyFromObjectWithClassDecider:(BOOL(^)(Class tmpClass, BOOL *stop))classDecider
{
    NSMutableArray* pairs = [NSMutableArray new];
    Class tmpClass = [self class];
    while(tmpClass){
        
        if(classDecider){
            BOOL stop = NO;
            while(tmpClass && !classDecider(tmpClass, &stop)){
                tmpClass = class_getSuperclass(tmpClass);
            }
            if(stop){
                break;
            }
        }
        
        unsigned int count = 0;
        objc_property_t *firstProperty = class_copyPropertyList(tmpClass, &count);
        objc_property_t property;
        NSString* keyname;
        for(NSInteger i = 0; i < count; ++i){
            property = *(firstProperty + i);
            keyname = [NSString stringWithUTF8String:property_getName(property)];
            //            const char *cattributes = property_getAttributes(property);
//            MSGLOG(@"%@, %@", keyname, tmpClass);
            [pairs addObject:keyname];
        }
        free(firstProperty);
        
        tmpClass = class_getSuperclass(tmpClass);
    }
    
    return pairs;
}

@end
