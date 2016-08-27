//
//  RuntimeUtils.h
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@class SFObjectProperty;

@interface SFRuntimeUtils : NSObject

+ (NSString *)descriptionOfObject:(id<NSObject>)obj;
+ (NSString *)descriptionOfObjects:(NSArray *)objs;

+ (void)printDescriptionOfObject:(id<NSObject>)obj;
+ (void)printDescriptionOfObjects:(NSArray *)objs;

+ (NSArray *)objectPropertiesOfClass:(Class)clss;
+ (SFObjectProperty *)objectPropertyWithPropertyName:(NSString *)propertyName targetClass:(Class)targetClass;
+ (NSArray *)objectPropertiesOfClass:(Class)clss classDecider:(BOOL(^)(Class tmpClass, BOOL *stop))classDecider;

+ (void)combineObjectPropertyValueWithObjects:(id<NSObject>)firstObject,...;

+ (NSString *)invokeMethodWithObject:(id)object methodName:(NSString *)methodName parameters:(NSString *)firstParameter, ...;

@end
