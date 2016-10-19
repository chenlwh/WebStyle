//
//  NewPlayerVideoProvider.m
//  WebStyle
//
//  Created by liudan on 10/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "NewPlayerVideoProvider.h"
#import "UrlDefine.h"
@implementation NewPlayerVideoProvider
-(id)init
{
    if(self = [super init])
    {
        self.urlString = kNewPlayerVideo;
        self.cacheUrlString = kNewPlayerVideo;
        
        [self useDownloadCache:[GWSimpleLocalCache sharedCache]
                   cacheSecond:10
                   cachePolicy:EGWCachePolicyNetworkFirst];
        
        [self setResponseHandler:^id(id response, NSError **error) {
            
//            NSLog(@"response %@", response);
            
            return response;
        }];
    }
    return self;
}
@end
