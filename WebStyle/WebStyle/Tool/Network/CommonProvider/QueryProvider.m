//
//  QueryProvider.m
//  WebStyle
//
//  Created by liudan on 10/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "QueryProvider.h"
#import "UrlDefine.h"

@implementation QueryProvider
-(id)init
{
    if(self = [super init])
    {
        self.urlString = kQueryInfo;
        self.cacheUrlString = kQueryInfo;
        self.httpMethod = @"Get";
        
        [self setResponseHandler:^id(id response, NSError **error) {
            
            NSLog(@"response %@", response);
            
            return response;
        }];
    }
    return self;
}
@end
