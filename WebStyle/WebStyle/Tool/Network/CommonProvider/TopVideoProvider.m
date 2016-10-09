//
//  TopVideoProvider.m
//  WebStyle
//
//  Created by liudan on 10/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "TopVideoProvider.h"
#import "UrlDefine.h"

@implementation TopVideoProvider
-(id)init
{
    if(self = [super init])
    {
        self.urlString = kTopVideo;
        self.cacheUrlString = kTopVideo;
        
        
        [self setResponseHandler:^id(id response, NSError **error) {
            
            NSLog(@"response %@", response);
            
            return response;
        }];
    }
    return self;
}
@end
