//
//  TBXML+TBXMLAddition.m
//  Badminton
//
//  Created by yang xueya on 2/13/12.
//  Copyright (c) 2012 gewara. All rights reserved.
//

#import "TBXML+TBXMLAddition.h"

@implementation TBXML (TBXMLAddition)


-(NSArray*)arrayByElement:(TBXMLElement*)aXMLElement
{
    if (!aXMLElement) {
        return nil;
    }
    
    NSMutableArray *arrReturn = [NSMutableArray array];
    TBXMLElement *tmpElement = aXMLElement;
    TBXMLElement *childEle = tmpElement->firstChild;

    while (childEle) {
        [arrReturn addObject:[NSValue valueWithPointer:childEle]];
        childEle = childEle->nextSibling;
    }
    
    return arrReturn;
}

-(NSArray*)dictionaryArrayByElement:(TBXMLElement*)aXMLElement
{
    if (!aXMLElement) {
        return nil;
    }
    
    NSMutableArray *arrReturn = [NSMutableArray array];
    TBXMLElement *tmpElement = aXMLElement;
    TBXMLElement *childEle = tmpElement->firstChild;
    
    while (childEle) {
        NSDictionary *dict = [self dictionaryFromTBXMLElement:childEle];
        [arrReturn addObject:dict];
        
        childEle = childEle->nextSibling;
    }
    
    return arrReturn;
}

-(NSArray*)arrayByElementName:(NSString*)aName
{
    TBXMLElement *root = self.rootXMLElement;
    return [self arrayByElementName:aName parentElement:root];
}
-(NSArray*)arrayByElementName:(NSString*)aName parentElement:(TBXMLElement*)aXMLElement
{
    NSMutableArray *arrReturn = [NSMutableArray array];
    TBXMLElement *root = aXMLElement;
    if (!root) {
        return nil;
    }
    
    NSMutableArray *levelArray = [[NSMutableArray alloc] init];    
    [levelArray addObject:[NSValue valueWithPointer:root]];

    while ([levelArray count]) {
        NSMutableArray *alternativeArray = [[NSMutableArray alloc] init];
        for (NSValue *tmpValue in levelArray) {
            TBXMLElement *tmpElement = [tmpValue pointerValue];
            TBXMLElement *childEle = tmpElement->firstChild;
            if (childEle) {
                while (childEle) {
                    NSString *name = [TBXML elementName:tmpElement];
                    if ([aName isEqualToString:name]) {
                        [arrReturn addObject:[NSValue valueWithPointer:childEle]];
                    }
                    [alternativeArray addObject:[NSValue valueWithPointer:childEle]];
                    childEle = childEle->nextSibling;
                }
            }else{
                //NSString *text = [TBXML textForElement:tmpElement];
                //NSString *name = [TBXML elementName:tmpElement];
            }
        }
        
        [levelArray removeAllObjects];
        [levelArray addObjectsFromArray:alternativeArray];
        [alternativeArray release];
    }
    
    [levelArray release];
    
    if ([arrReturn count]==0) {
        return nil;
    }else {
        return arrReturn;
    }
}

-(NSArray*)arrayByElementName:(NSString*)aName subName:(NSString*)subName
{
    TBXMLElement *root = self.rootXMLElement;
    return [self arrayByElementName:aName subName:subName parentElement:root];
    
}
-(NSArray*)arrayByElementName:(NSString*)aName subName:(NSString*)subName parentElement:(TBXMLElement*)aXMLElement
{
    NSMutableArray *arrReturn = [NSMutableArray array];
    
    NSArray *arr = [self arrayByElementName:aName parentElement:aXMLElement];
    for (NSValue *tmpValue in arr) {
        TBXMLElement *tmpElement = [tmpValue pointerValue];
        NSDictionary *dict = [self dictionaryFromTBXMLElement:tmpElement];
        [arrReturn addObject:dict];
    }

    return arrReturn;
}


-(NSDictionary*)dictionaryByElementName:(NSString*)aName
{
    NSMutableDictionary *dictReturn = [NSMutableDictionary dictionary];
    NSArray *arrayTBXMLElement = [self arrayByElementName:aName];
    
    for (NSValue *tmpValue in arrayTBXMLElement) {
        TBXMLElement *tmpElement = [tmpValue pointerValue];
        NSString *text = [TBXML textForElement:tmpElement];
        NSString *name = [TBXML elementName:tmpElement];
        if ((text!=nil)&&(name!=nil)) {
            [dictReturn setValue:text forKey:name];
        }
        
    }
    
    return dictReturn;

}

-(NSDictionary*)dictionaryFromTBXMLElement:(TBXMLElement*)aXMLElement
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


-(BOOL)isResultSuccess
{
    NSDictionary *dict = [self dictionaryByElementName:@"data"];
    NSString *result = [dict objectForKey:@"result"];
    if ([result isEqualToString:@"success"]||[result isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}
-(NSString*)resultString
{
    NSDictionary *dict = [self dictionaryByElementName:@"data"];
    NSString *result = [dict objectForKey:@"result"];

    return result;

}

-(BOOL)isError
{
    NSDictionary *dict = [self dictionaryByElementName:@"data"];
    if (dict == nil) {//unnormal error
        return YES;
    }else{
        return ([dict objectForKey:@"error"]==nil)?NO:YES;
    }
}
-(NSString*)errorString
{
    NSDictionary *dict = [self dictionaryByElementName:@"data"];
    if (dict == nil) {//unnormal error
        return @"网页错误";
    }else{
        return [dict objectForKey:@"error"];
    }
}

-(NSString*)errorCode
{
    NSDictionary *dict = [self dictionaryByElementName:@"data"];
    return [dict objectForKey:@"code"];
    
}

-(NSError*)error
{
    if ([self isError]) {
        
        NSString *errorString = [self errorString];

        NSDictionary *errorDict = errorString ==nil?nil:[NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey];
        
        return [NSError errorWithDomain:errorString
                                   code:[[self errorCode] integerValue]
                               userInfo:errorDict];
        
    }else{
        return nil;
    }
    
}

@end
