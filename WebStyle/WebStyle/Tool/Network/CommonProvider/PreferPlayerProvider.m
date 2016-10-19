//
//  PreferPlayerProvider.m
//  WebStyle
//
//  Created by liudan on 10/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "PreferPlayerProvider.h"
#import "UrlDefine.h"
@implementation PreferPlayerProvider
-(id)init
{
    if(self = [super init])
    {
        self.urlString = KPreferPlayer;
        self.cacheUrlString = KPreferPlayer;
        
        
        [self setResponseHandler:^id(id response, NSError **error) {
            
//            NSLog(@"response %@", response);
            
            return response;
        }];
    }
    return self;
}
@end
