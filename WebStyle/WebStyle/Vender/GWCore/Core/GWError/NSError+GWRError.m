//
//  NSError+GWRError.m
// 
//
//  Created by yang xueya on 6/15/12.
//  Copyright (c) 2012 gewara. All rights reserved.
//

#import "NSError+GWRError.h"
#import "GWErrorDomain.h"

@implementation NSError (GWRError)

+(NSError*)errorWithGWRequestErrorString:(NSString*)errorString
                                    code:(NSInteger)code
                                  domain:(NSString*)errorDomain
{
    if (errorDomain) {
        
        NSDictionary *errorDict = errorString==nil?nil:[NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:errorDomain
                                   code:code
                               userInfo:errorDict];
    }
    
    return nil;
}

+(NSError*)errorWithGWRequestErrorString:(NSString*)errorString code:(NSInteger)code
{
    return [self errorWithGWRequestErrorString:errorString
                                          code:code
                                        domain:GWNetworkRequestErrorDomain];
}


+(NSError*)errorWithLocalizedDescription:(NSString*)errorString
{
    return [self errorWithGWRequestErrorString:errorString
                                          code:0
                                        domain:GWRNormalErrorDomain];
}

-(NSString*)gwrDescription
{
    NSString *errorText = @"昂~服务器好像累坏了,休息一下再来";
    
    if ([self.domain isEqualToString:GWHTTPRequestErrorDomain]) {//网络错误
        if (self.code == GWRequestTimedOutErrorType) {
            errorText = @"大家都在链接请求,超时了内";;
        }else if (self.code == GWConnectionFailureErrorType){
            errorText = @"糟糕,网络没信号了!";
        }else if (self.code == GWRequestCancelledErrorType){
            errorText = nil;
        }else{
            errorText = self.localizedDescription;
        }
    }else if ([self.domain isEqualToString:GWNetworkRequestErrorDomain]) {//格瓦拉服务器错误
        errorText = self.localizedDescription;
    }else {
        errorText = [self localizedDescription];
    }

    return errorText;
//    return [NSString stringWithFormat:@"%@,%@,%@",self.domain, [self localizedDescription], [self localizedRecoverySuggestion]];
}

@end
