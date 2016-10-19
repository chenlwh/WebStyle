//
//  HotPlayerVideoProvider.m
//  WebStyle
//
//  Created by liudan on 10/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "HotPlayerVideoProvider.h"
#import "UrlDefine.h"
@implementation HotPlayerVideoProvider
-(id)init
{
    if(self = [super init])
    {
        self.urlString = kHotPlayerVideo;
        self.cacheUrlString = kHotPlayerVideo;
        
        
        [self setResponseHandler:^id(id response, NSError **error) {
            
//            NSLog(@"response %@", response);
            
            return response;
        }];
    }
    return self;
}
@end
