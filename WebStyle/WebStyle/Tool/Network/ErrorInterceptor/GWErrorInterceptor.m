//
//  GWErrorInterceptor.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWErrorInterceptor.h"
#import "TBXML.h"
#import "GWErrorDomain.h"
#import "JSONKit.h"
#import "GWBaseInfoProvider.h"
#import "GWErrorInfo.h"
#import "GWProviderManager.h"

@implementation GWErrorInterceptor
- (NSError *)findError:(NSString *)string description:(NSString*)description format:(NSString*)format
{
    return nil;
}
@end


#pragma mark - CommonErrorInterceptor － 后台错误拦截器
@implementation GWCommonErrorInterceptor
- (NSError *)findError:(NSString *)string description:(NSString*)description format:(NSString*)format
{
    if([format isEqualToString:GWFormatXML])
    {
        TBXML *xml = [TBXML tbxmlWithXMLString:string];
        TBXMLElement *resultElement = [TBXML childElementNamed:@"result" parentElement:xml.rootXMLElement];
        if(resultElement)
        {
            TBXMLElement *codeElement = [TBXML childElementNamed:@"code" parentElement:xml.rootXMLElement];
            NSString *codeString = [TBXML textForElement:codeElement];
            if([codeString length] != 0)
            {
                TBXMLElement *errorElement = [TBXML childElementNamed:@"error" parentElement:xml.rootXMLElement];
                NSString *errorString = [TBXML textForElement:errorElement];
                
                GWErrorInfo* errorInfo = nil;
                switch (codeString.intValue)
                {
                    case GWErrorCode_NeedShowWebAuth:
                    {
                        errorInfo = [[GWJumpUrlErrorInfo alloc] init];
                        TBXMLElement *jumpUrlElement = [TBXML childElementNamed:@"jumpUrl" parentElement:xml.rootXMLElement];
                        ((GWJumpUrlErrorInfo*)errorInfo).jumpUrl = [TBXML textForElement:jumpUrlElement];
                    }break;
                        
                    default:
                        break;
                }
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:@{ NSLocalizedDescriptionKey : errorString, GWErrorRequestURLKey : description}];
                [userInfo setValue:errorInfo forKey:GWErrorRequestResponeKey];
                return [NSError errorWithDomain:GWNetworkRequestErrorDomain
                                           code:[codeString intValue]
                                       userInfo:userInfo];
            }
        }
    }
    
    return nil;
}
@end

@implementation GWCommonJsonErrorInterceptor
- (NSError *)findError:(NSString *)string description:(NSString*)description format:(NSString*)format
{
    return nil;
}
@end


#pragma mark - CommonError2Interceptor － 后台错误拦截器2
@implementation GWCommonError2Interceptor
- (NSError *)findError:(NSString *)string description:(NSString*)description format:(NSString*)format
{
    if([format isEqualToString:GWFormatXML])
    {
        
        TBXML *xml = [TBXML tbxmlWithXMLString:string];
        TBXMLElement *resultElement = xml.rootXMLElement;
        if(resultElement){
            TBXMLElement *alertScoreElement = [TBXML childElementNamed:@"alertScore" parentElement:xml.rootXMLElement];
            TBXMLElement *alertScoreDescElement = [TBXML childElementNamed:@"alertScoreDesc" parentElement:xml.rootXMLElement];
            NSString *alertScoreString = [TBXML textForElement:alertScoreElement];
            NSString *alertScoreDescString = [TBXML textForElement:alertScoreDescElement];
            if (alertScoreString.length>0&&alertScoreDescString.length>0) {
                if([alertScoreString intValue]>0) {
                    NSMutableDictionary *notiObject = [[NSMutableDictionary alloc]init];
                    [notiObject setObject:alertScoreString forKey:@"alertScore"];
                    [notiObject setObject:alertScoreDescString forKey:@"alertScoreDesc"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:GWBaseHTTPResponseScore object:notiObject];
                }
            }
            TBXMLElement *codeElement = [TBXML childElementNamed:@"code" parentElement:xml.rootXMLElement];
            NSString *codeString = [TBXML textForElement:codeElement];
            if(codeString.length != 0){
                TBXMLElement *errorElement = [TBXML childElementNamed:@"error" parentElement:xml.rootXMLElement];
                NSString *errorString = [TBXML textForElement:errorElement];
                
                GWErrorInfo* errorInfo = nil;
                switch (codeString.intValue)
                {
                    case GWErrorCode_NeedShowWebAuth:
                    {
                        errorInfo = [[GWJumpUrlErrorInfo alloc] init];
                        TBXMLElement *jumpUrlElement = [TBXML childElementNamed:@"jumpUrl" parentElement:xml.rootXMLElement];
                        ((GWJumpUrlErrorInfo*)errorInfo).jumpUrl = [TBXML textForElement:jumpUrlElement];
                    }break;
                        
                    default:
                        break;
                }
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:@{ NSLocalizedDescriptionKey : errorString, GWErrorRequestURLKey : description}];
                [userInfo setValue:errorInfo forKey:GWErrorRequestResponeKey];
        
                return [NSError errorWithDomain:GWNetworkRequestErrorDomain
                                           code:codeString.intValue
                                       userInfo:userInfo];
            }
        }
    }
    
    return nil;
}
@end

@implementation GWCommonJsonError2Interceptor
- (NSError *)findError:(NSString *)string description:(NSString*)description format:(NSString*)format
{
    if([format isEqualToString:GWFormatJASON])
    {
        NSDictionary* jsonDic = [string objectFromJSONString];
        if([jsonDic isKindOfClass:[NSDictionary class]])
        {
            NSString *alertScoreString = jsonDic[@"alertScore"];
            NSString *alertScoreDescString = jsonDic[@"alertScoreDesc"];
            if (alertScoreString.length>0&&alertScoreDescString.length>0) {
                if([alertScoreString intValue]>0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:GWBaseHTTPResponseScore object:jsonDic];
                }
            }
            NSString *codeString = [jsonDic[@"code"] lowercaseString];
            if([codeString length] == 0)
            {
                codeString = [jsonDic[@"errcode"] lowercaseString];
            }
            if([codeString length] != 0 && [codeString intValue] != 0)
            {
                NSString *errorString = jsonDic[@"error"];
                if([errorString length] == 0)
                {
                    errorString = jsonDic[@"errmsg"];
                }
                errorString = errorString ? errorString : @"";
                
                GWErrorInfo* errorInfo = nil;
                switch (codeString.intValue)
                {
                    case GWErrorCode_NeedShowWebAuth:
                    {
                        errorInfo = [[GWJumpUrlErrorInfo alloc] init];
                        ((GWJumpUrlErrorInfo*)errorInfo).jumpUrl = jsonDic[@"jumpUrl"];
                    }break;
                        
                    default:
                        break;
                }
                NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:@{ NSLocalizedDescriptionKey : errorString, GWErrorRequestURLKey : description}];
                [userInfo setValue:errorInfo forKey:GWErrorRequestResponeKey];
                return [NSError errorWithDomain:GWNetworkRequestErrorDomain
                                           code:[codeString intValue]
                                       userInfo:userInfo];
            }
        }
    }
    
    return nil;
}
@end

#pragma mark - DataStructureValidateErrorInterceptor － 数据完整性错误拦截器
@implementation GWDataStructureValidateErrorInterceptor

- (NSError *)findError:(NSString *)string description:(NSString*)description format:(NSString*)format
{

  //  D_Log(@"findError:%@",string);
  //  D_Log(@"description:%@",description);
  //  D_Log(@"format:%@",format);
   
    
    if([format isEqualToString:GWFormatXML])
    {
        TBXML *xml = [TBXML tbxmlWithXMLString:string];
        if(!xml){
            return [NSError errorWithDomain:GWNetworkRequestErrorDomain
                                       code:GWErrorCode_DataStructureError
                                   userInfo:@{NSLocalizedDescriptionKey : @"数据有误", GWErrorRequestURLKey :  description}];
        }
        if(!xml.rootXMLElement){
            return [NSError errorWithDomain:GWNetworkRequestErrorDomain
                                       code:GWErrorCode_DataStructureError
                                   userInfo:@{NSLocalizedDescriptionKey : @"数据有误", GWErrorRequestURLKey : description}];
        }
        if(![[NSString stringWithUTF8String:xml.rootXMLElement->name] isEqualToString:@"data"]){
            return [NSError errorWithDomain:GWNetworkRequestErrorDomain
                                       code:GWErrorCode_DataStructureError
                                   userInfo:@{NSLocalizedDescriptionKey : @"网页错误", GWErrorRequestURLKey : description}];
        }
    }
    else if([format isEqualToString:GWFormatJASON])
    {
        id data = [string objectFromJSONString];
        if (data == nil) {
            return [NSError errorWithDomain:GWNetworkRequestErrorDomain
                                       code:GWErrorCode_DataStructureError
                                   userInfo:@{NSLocalizedDescriptionKey : @"数据有误", GWErrorRequestURLKey :  description}];
        }
    }

    return nil;
}
@end

#pragma mark 运动拦截
@implementation GWJsonForSportsErrorInterceptor
- (NSError *)findError:(NSString *)string description:(NSString*)description format:(NSString*)format
{
    if([format isEqualToString:GWFormatJASON])
    {
        NSDictionary* jsonDic = [string objectFromJSONString];
        if([jsonDic isKindOfClass:[NSDictionary class]])
        {
            NSString *msg = [[jsonDic objectForKey:@"msg"] lowercaseString];;
            if (![msg isEqualToString:@"ok"] && msg.length > 0) {
                NSString* errorString = [jsonDic objectForKey:@"msg"];
                return [NSError errorWithDomain:GWNetworkRequestErrorDomain
                                           code:errorString.intValue
                                       userInfo:@{NSLocalizedDescriptionKey : errorString, GWErrorRequestURLKey : description}];
            }
            
            NSString *error = [jsonDic objectForKey:@"error"];
            if (error.length > 0) {
                NSString *code = [jsonDic objectForKey:@"code"];
                return [NSError errorWithDomain:GWNetworkRequestErrorDomain
                                           code:code.intValue
                                       userInfo:@{NSLocalizedDescriptionKey : error, GWErrorRequestURLKey : description}];
            }
        }
    }
    
    return nil;
}
@end