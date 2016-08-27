//
//  GWErrorInterceptorHandler.h
//  GewaraCore
//
//  Created by wushengtao on 14-5-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWErrorInterceptorHandler : NSObject
@property (nonatomic, retain) NSMutableArray* errorInterceptors;

/**
 *  捕获错误
 *
 *  @param responseString 需要解析的xml或json
 *  @param description    url description
 *
 *  @return 有错误返回错误信息，无错误返回nil
 */
- (NSError *)searchError:(NSString *)responseString description:(NSString*)description format:(NSString*)format;
@end
