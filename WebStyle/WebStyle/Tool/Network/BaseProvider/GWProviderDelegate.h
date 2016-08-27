//
//  GWProviderDelegate.h
//  GewaraCore
//
//  Created by sheen on 15/1/26.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWProviderManager.h"

@protocol GWProviderDelegate <NSObject>
@optional
/**
 *  返回单个sender所有
 *
 *  @param results GWProviderResultPackage array
 */
- (void)providersDidSendFinish:(NSArray*)results;
@end
