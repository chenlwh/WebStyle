//
//  GWDownloadCache.m
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWDownloadCache.h"

static NSMutableDictionary *cacheDictionary = nil;

@implementation GWDownloadCache
+ (id)sharedCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheDictionary = [[NSMutableDictionary alloc] init];
    });
    
    GWDownloadCache* sharedCache = nil;
    @synchronized(self)
    {
        sharedCache = [cacheDictionary objectForKey:NSStringFromClass([self class])];
        if(!sharedCache)
        {
            sharedCache = [[[[self class] alloc] init] autorelease];
            [cacheDictionary setObject:sharedCache forKey:NSStringFromClass([self class])];
        }
    }
    
	return sharedCache;
}

- (id)init
{
    if(self = [super init])
    {
        self.replaceDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"sign" : @"", @"timestamp" : @""}];
    }
    
    return self;
}


- (NSString *)keyForURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
	if ([urlString length] == 0) {
		return nil;
	}
    
	// Strip trailing slashes so http://allseeing-i.com/ASIHTTPRequest/ is cached the same as http://allseeing-i.com/ASIHTTPRequest
	if ([[urlString substringFromIndex:[urlString length]-1] isEqualToString:@"/"]) {
		urlString = [urlString substringToIndex:[urlString length]-1];
	}
    
    //http://test.gewala.net/openapi2/router/rest?sign=AE83351D7DDE4144DC89C86F569B9943&signmethod=MD5&appSource=AS02&appVersion=5.0.0&appkey=iphonepk2009&apptype=cinema&citycode=310000&format=xml&method=com.gewara.mobile.index.commendCinemaList&mobileType=iPhone%20Simulator&osType=IPHONE&osVersion=7.0.3&timestamp=2014-01-08%2018:12:27&v=1.0&version=1.0
    
    //** 去除 sign  timestamp 字段
    NSMutableString *mutableStr = [NSMutableString stringWithString:urlString];
    
    for(NSString* key in [_replaceDictionary allKeys])
    {
        [mutableStr replaceOccurrencesOfString:[NSString stringWithFormat:@"%@=.*?&", key]
                                    withString:[_replaceDictionary objectForKey:key]
                                       options:NSRegularExpressionSearch
                                         range:NSMakeRange(0, [mutableStr length])];
    }
    
	// Borrowed from: http://stackoverflow.com/questions/652300/using-md5-hash-on-a-string-in-cocoa
	const char *cStr = [mutableStr UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

@end
