//
//  GWAppDotNetAPIClient.m
//  GWMovie
//
//  Created by gewara on 16/6/29.
//  Copyright © 2016年 gewara. All rights reserved.
//

#import "GWAppDotNetAPIClient.h"

@implementation GWAppDotNetAPIClient

+ (instancetype)sharedClient {
    static GWAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GWAppDotNetAPIClient alloc] init];
    
    });
    
    return _sharedClient;
}

@end
