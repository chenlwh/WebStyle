//
//  GWPagingProvider.m
//  GewaraCore
//
//  Created by wushengtao on 14-6-6.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWPagingProvider.h"

@implementation GWPagingProvider


- (id)init
{
    self = [super init];
    
    self.from = 0;
    self.maxnum = 10;
    
    return self;
}

- (void)resetPageCursor
{
    self.from = 0;
}

- (void)providerWillStart
{
    [super providerWillStart];
}

- (void)updateModelWithResponed:(id)respond error:(NSError *)error
{
    if(!error)
    {
//        if([respond isKindOfClass:[NSArray class]])
//        {
//            self.from += [(NSArray*)respond count];
//        }
//        else
        {
            self.from += self.maxnum;
        }
    }
}

- (void)responedComplete:(GWProviderResultPackage*)package
{
    [super responedComplete:package];
    
    [self updateModelWithResponed:package.providerResult error:package.providerError];
}

- (void)nextPageWithCompletionHandler:(void(^)(NSArray *resultArray, NSError *error))completionHandler
{
    [self requestWithResponseHandler:self.responseHandler
                   completionHandler:completionHandler];
}



@end