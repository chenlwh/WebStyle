//
//  GWASIMsgCreator.h
//  GewaraCore
//
//  Created by wushengtao on 16/2/2.
//  Copyright © 2016年 __MyCompanyName__. All rights reserved.
//


#if __has_include(<ASIHTTPRequest.h>)
#import <Foundation/Foundation.h>
#import "GWProviderManagerDelagate.h"
#import "ASIHTTPRequest.h"

@interface GWASIMsgCreator : NSObject<GWProviderManagerRequestDelegate>
@property (nonatomic, assign) id<GWProviderManagerResponseDelegate> responseDelegate;
@property (nonatomic, assign) id<GWProviderManagerProgressDelegate> progressDelegate;
@end
#endif