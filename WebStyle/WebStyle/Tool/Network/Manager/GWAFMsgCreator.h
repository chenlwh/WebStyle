//
//  GWAFMsgCreator.h
//  GWMovie
//
//  Created by wushengtao on 16/2/2.
//  Copyright © 2016年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWProviderManagerDelagate.h"



@interface GWAFMsgCreator : NSObject<GWProviderManagerRequestDelegate>
@property (nonatomic, assign) id<GWProviderManagerResponseDelegate> responseDelegate;
@property (nonatomic, assign) id<GWProviderManagerProgressDelegate> progressDelegate;
@end
