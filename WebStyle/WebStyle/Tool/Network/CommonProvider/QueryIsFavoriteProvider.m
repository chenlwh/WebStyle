//
//  QueryIsFavorite.m
//  WebStyle
//
//  Created by liudan on 9/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "QueryIsFavoriteProvider.h"
#import "UrlDefine.h"
@implementation QueryIsFavoriteProvider
-(id)init
{
    if(self = [super init])
    {
        //        self.method = @"prefervideo";
        self.urlString = kQueryIsFavorite;
        self.cacheUrlString = kQueryIsFavorite;
        
        
        [self setResponseHandler:^id(id response, NSError **error) {
            
            
            return response;
        }];
    }
    return self;
}
@end
