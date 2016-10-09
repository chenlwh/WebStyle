//
//  DoFavoriteProvider.m
//  WebStyle
//
//  Created by liudan on 9/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "DoFavoriteProvider.h"
#import "UrlDefine.h"
@implementation DoFavoriteProvider
-(id)init
{
    if(self = [super init])
    {
        self.urlString = kDoFavorite;
        self.cacheUrlString = kDoFavorite;
        
        
        [self setResponseHandler:^id(id response, NSError **error) {
            
            
            return response;
        }];
    }
    return self;
}
@end
