//
//  HomepageScrollProvider.m
//  WebStyle
//
//  Created by liudan on 8/25/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "HomepageScrollProvider.h"
#import "UrlDefine.h"
@implementation HomepageScrollProvider

-(id)init
{
    if(self = [super init])
    {
//        self.method = @"prefervideo";
        self.urlString = KGWHostURL;
        self.cacheUrlString = KGWHostURL;
        
        [self setResponseHandler:^id(id response, NSError **error) {
            
            NSLog(@"response %@", response);
            
            return @"xx";
        }];
    }
    return self;
}
@end
