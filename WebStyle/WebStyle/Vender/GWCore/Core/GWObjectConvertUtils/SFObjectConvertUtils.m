//
//  SFObjectConvertUtils.m
//  SimpleFramework
//
//  Created by yangzexin on 13-7-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SFObjectConvertUtils.h"

#import "TBXML+TBXMLAddition.h"

#import "MJExtension.h"




@implementation SFObjectConvertUtils


+(NSDictionary*)dictionaryFromTBXMLElement:(TBXMLElement*)aXMLElement
{
    NSMutableDictionary *dictReturn = [NSMutableDictionary dictionary];
    if (!aXMLElement) {
        return nil;
    }
    
    NSMutableArray *alternativeArray = [[NSMutableArray alloc] init];
    
    TBXMLElement *childEle = aXMLElement->firstChild;
    if (childEle) {
        while (childEle) {
            [alternativeArray addObject:[NSValue valueWithPointer:childEle]];
            childEle = childEle->nextSibling;
        }
    }
    
    for (NSValue *tmpValue in alternativeArray) {
        TBXMLElement *tmpElement = [tmpValue pointerValue];
        NSString *text = [TBXML textForElement:tmpElement];
        NSString *name = [TBXML elementName:tmpElement];
        if ((text!=nil)&&(name!=nil)) {
            [dictReturn setValue:text forKey:name];
        }
    }
    
    [alternativeArray release];
    
    return dictReturn;
}

+ (NSArray *)objectsWithClass:(Class)clss parent:(TBXMLElement *)parent mapping:(NSDictionary*)mappingDict
{
    NSMutableArray *arrReturn = [NSMutableArray array];
    TBXMLElement *tmpElement = parent;
    TBXMLElement *childEle = tmpElement->firstChild;
    
    while (childEle) {
        id tmpObject = [SFObjectConvertUtils objectWithClass:clss
                                                      parent:childEle
                                                     mapping:mappingDict];
        
        [arrReturn addObject:tmpObject];
        childEle = childEle->nextSibling;
    }
    return arrReturn;
    
    //return [[SFTBXMLObjectConverter createWithReplaceMapping:mapping] objectListWithClass:clss parentTBXMLElement:parent];
}

+ (id)objectWithClass:(Class)clss parent:(TBXMLElement *)parent mapping:(NSDictionary*)mappingDict
{
    //TODO:yangxueya 这个地方到时候换成MJ的那个分类
    
    NSDictionary *dict = [SFObjectConvertUtils dictionaryFromTBXMLElement:parent];
    
    [clss mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return mappingDict;
    }];
    
    NSObject *retObj = [clss mj_objectWithKeyValues:dict];
    
    [clss mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{};
    }];
    
    return retObj;
}

@end
