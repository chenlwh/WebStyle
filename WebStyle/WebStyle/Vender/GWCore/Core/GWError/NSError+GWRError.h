//
//  NSError+GWRError.h
// 
//
//  Created by yang xueya on 6/15/12.
//  Copyright (c) 2012 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWErrorDomain.h"

@interface NSError (GWRError)

+(NSError*)errorWithGWRequestErrorString:(NSString*)errorString
                                    code:(NSInteger)code
                                  domain:(NSString*)errorDomain;

+(NSError*)errorWithGWRequestErrorString:(NSString*)errorString
                                    code:(NSInteger)code;

+(NSError*)errorWithLocalizedDescription:(NSString*)errorString;

-(NSString*)gwrDescription;

@end
