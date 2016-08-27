//
//  TBXML+TBXMLAddition.h
//  Badminton
//
//  Created by yang xueya on 2/13/12.
//  Copyright (c) 2012 gewara. All rights reserved.
//

#import "TBXML.h"


@interface TBXML (TBXMLAddition)

/*
    下面这些直接解析字典的方法适用于单纯节点，多种节点混合的不能用
 */
/**
 *  这个是返回数组成员对象是NSValue
 */
//for (NSValue *tmpValue in array) {
//    TBXMLElement *tmpElement = [tmpValue pointerValue];
//}
-(NSArray*)arrayByElement:(TBXMLElement*)aXMLElement;

//终极节点，返回字典数组
-(NSArray*)dictionaryArrayByElement:(TBXMLElement*)aXMLElement;

//这个是返回数组成员对象是NSValue
//for (NSValue *tmpValue in array) {
//    TBXMLElement *tmpElement = [tmpValue pointerValue];
//}
-(NSArray*)arrayByElementName:(NSString*)aName;
-(NSArray*)arrayByElementName:(NSString*)aName parentElement:(TBXMLElement*)aXMLElement;

//这个直接返回数组，成员对象就是字典
-(NSArray*)arrayByElementName:(NSString*)aName subName:(NSString*)subName;
-(NSArray*)arrayByElementName:(NSString*)aName subName:(NSString*)subName parentElement:(TBXMLElement*)aXMLElement;

//对于节点名字返回子节点字典，条件是子节点没有重复
-(NSDictionary*)dictionaryByElementName:(NSString*)aName;

//返回该节点字典，条件是子节点没有重复
-(NSDictionary*)dictionaryFromTBXMLElement:(TBXMLElement*)aXMLElement;


-(BOOL)isResultSuccess;
-(NSString*)resultString;
-(BOOL)isError;
-(NSString*)errorString;
-(NSString*)errorCode;
-(NSError*)error;


@end
