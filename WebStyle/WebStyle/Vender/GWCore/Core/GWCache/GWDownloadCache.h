//
//  GWDownloadCache.h
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface GWDownloadCache : NSObject
@property (nonatomic, retain) NSMutableDictionary* replaceDictionary;
+ (id)sharedCache;
- (NSString *)keyForURL:(NSURL *)url;
@end
