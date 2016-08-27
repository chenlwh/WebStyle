//
//  RTProperty.h
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/**
 Example:
    
     RTProperty *pro = [RuntimeUtils objectPropertyWithPropertyName:@"name" targetClass:[City class]];
     City *city = [[City new] autorelease];
     [pro setWithString:@"cityname" targetObject:city];
 
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum{
    SFObjectPropertyTypeObject,
    SFObjectPropertyTypeChar,
    SFObjectPropertyTypeInt,
    SFObjectPropertyTypeShort,
    SFObjectPropertyTypeLong,
    SFObjectPropertyTypeLongLong,
    SFObjectPropertyTypeUnsignedChar,
    SFObjectPropertyTypeUnsignedInt,
    SFObjectPropertyTypeUnsignedShort,
    SFObjectPropertyTypeUnsignedLong,
    SFObjectPropertyTypeUnsignedLongLong,
    SFObjectPropertyTypeFloat,
    SFObjectPropertyTypeDouble,
    SFObjectPropertyTypeBOOL,
    SFObjectPropertyTypeVoid,
    SFObjectPropertyTypeCharPoint,
    SFObjectPropertyTypeClass,
    SFObjectPropertyTypeSEL,
    SFObjectPropertyTypeArray,
    SFObjectPropertyTypeStructure,
    SFObjectPropertyTypeUnion,
    SFObjectPropertyTypeBit,
    SFObjectPropertyTypePointerToType,
    SFObjectPropertyTypeUnknown,
}SFObjectPropertyType;

typedef enum{
    SFObjectPropertyAccessTypeReadOnly,
    SFObjectPropertyAccessTypeReadWrite,
}SFObjectPropertyAccessType;

@interface SFObjectProperty : NSObject

- (id)initWithProperty:(objc_property_t)property;

@property(nonatomic, assign)objc_property_t objc_property;
@property(nonatomic, readonly)NSString *name;
@property(nonatomic, readonly)NSString *className;
@property(nonatomic, readonly)SFObjectPropertyType type;
@property(nonatomic, readonly)SFObjectPropertyAccessType accessType;
@property(nonatomic, readonly)NSString *setterMethodName;
@property(nonatomic, readonly)NSString *getterMethodName;

- (void)setWithString:(NSString *)string targetObject:(id<NSObject>)obj;
- (NSString *)getStringFromTargetObject:(id<NSObject>)obj;

@end
