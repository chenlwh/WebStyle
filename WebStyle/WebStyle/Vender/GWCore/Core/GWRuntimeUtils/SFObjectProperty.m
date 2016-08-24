//
//  RTProperty.m
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SFObjectProperty.h"
#import "SFRuntimeUtils.h"


@interface SFObjectProperty ()

@property(nonatomic, copy)NSString *attributes;
@property(nonatomic, copy)NSString *setterMethodName;
@property(nonatomic, copy)NSString *getterMethodName;

@end

@implementation SFObjectProperty

@synthesize objc_property;
@synthesize name;
@synthesize type;
@synthesize accessType;
@synthesize attributes;
@synthesize className;
@synthesize setterMethodName;
@synthesize getterMethodName;

- (void)dealloc
{
    [name release];
    [attributes release];
    [className release];
    self.setterMethodName = nil;
    self.getterMethodName = nil;
    [super dealloc];
}

- (id)initWithProperty:(objc_property_t)property
{
    self = [super init];
    
    self.objc_property = property;
    
    return self;
}

- (void)setObjc_property:(objc_property_t)property
{
    objc_property = property;
    
    if(objc_property){
        const char *cname = property_getName(property);
        const char *cattributes = property_getAttributes(property);
        
        if(name){
            [name release];
        }
        name = [[NSString stringWithFormat:@"%s", cname] retain];
        
        self.attributes = [NSString stringWithFormat:@"%s", cattributes];
        
        NSArray *attributeList = [self.attributes componentsSeparatedByString:@","];
        if(attributeList.count > 1){
            type = [self.class typeOfDesc:[attributeList objectAtIndex:0]];
            if(self.type == SFObjectPropertyTypeObject){
                if (className) {
                    [className release];
                }
                
                className = nil;
                
                className = [[self.class classNameOfDesc:[attributeList objectAtIndex:0]] copy];
            }
            accessType = [self.class accessTypeOfDesc:[attributeList objectAtIndex:1]];
        }
        
        NSString *firstLetter = [self.name substringToIndex:1];
        firstLetter = [firstLetter uppercaseString];
        self.setterMethodName = [NSString stringWithFormat:@"set%@%@:", firstLetter, [self.name substringFromIndex:1]];
        self.getterMethodName = self.name;
        for(NSString *tmpAttribute in attributeList){
            if([tmpAttribute hasPrefix:@"S"]){
                self.setterMethodName = [tmpAttribute substringFromIndex:1];
            }else if([tmpAttribute hasPrefix:@"G"]){
                self.getterMethodName = [tmpAttribute substringFromIndex:1];
            }
        }
    }
}

- (void)setWithString:(NSString *)value targetObject:(id<NSObject>)obj
{
    [SFRuntimeUtils invokeMethodWithObject:obj methodName:[self setterMethodName] parameters:value, nil];
}

- (NSString *)getStringFromTargetObject:(id)obj
{
    
    id value = [obj valueForKey:self.name];
    
    return value == nil ? @"" : [NSString stringWithFormat:@"%@", value];
}

+ (SFObjectPropertyAccessType)accessTypeOfDesc:(NSString *)desc
{
    if(desc.length == 1){
        return [desc isEqualToString:@"R"] ? SFObjectPropertyAccessTypeReadOnly : SFObjectPropertyAccessTypeReadWrite;
    }
    return SFObjectPropertyAccessTypeReadOnly;
}

+ (NSString *)classNameOfDesc:(NSString *)desc
{
    return [[desc stringByReplacingOccurrencesOfString:@"T@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

+ (SFObjectPropertyType)typeOfDesc:(NSString *)desc
{
    if([desc hasPrefix:@"T"] && desc.length > 1){
        const unsigned char ctype = [desc characterAtIndex:1];
        switch(ctype){
            case 'c':
                return SFObjectPropertyTypeChar;
            case 'i':
                return SFObjectPropertyTypeInt;
            case 's':
                return SFObjectPropertyTypeShort;
            case 'l':
                return SFObjectPropertyTypeLong;
            case 'q':
                return SFObjectPropertyTypeLongLong;
            case 'C':
                return SFObjectPropertyTypeUnsignedChar;
            case 'I':
                return SFObjectPropertyTypeUnsignedInt;
            case 'S':
                return SFObjectPropertyTypeUnsignedShort;
            case 'L':
                return SFObjectPropertyTypeUnsignedLong;
            case 'Q':
                return SFObjectPropertyTypeUnsignedLongLong;
            case 'f':
                return SFObjectPropertyTypeFloat;
            case 'd':
                return SFObjectPropertyTypeDouble;
            case 'B':
                return SFObjectPropertyTypeBOOL;
            case 'v':
                return SFObjectPropertyTypeVoid;
            case '*':
                return SFObjectPropertyTypeCharPoint;
            case '@':
                return SFObjectPropertyTypeObject;
            case '#':
                return SFObjectPropertyTypeClass;
            case ':':
                return SFObjectPropertyTypeSEL;
            case '[':
                return SFObjectPropertyTypeArray;
            case '{':
                return SFObjectPropertyTypeStructure;
            case '(':
                return SFObjectPropertyTypeUnion;
            case 'b':
                return SFObjectPropertyTypeBit;
            case '^':
                return SFObjectPropertyTypePointerToType;
            case '?':
                return SFObjectPropertyTypeUnknown;
            default:
                return SFObjectPropertyTypeUnknown;
        }
    }
    return SFObjectPropertyTypeUnknown;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\t%@", self.name, self.className];
}

@end
