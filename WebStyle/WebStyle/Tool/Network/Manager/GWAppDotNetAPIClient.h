//
//  GWAppDotNetAPIClient.h
//  GWMovie
//
//  Created by gewara on 16/6/29.
//  Copyright © 2016年 gewara. All rights reserved.
//

#import "AFNetworking.h"

@interface GWAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
