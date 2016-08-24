//
//  GWProviderResultPackage.h
//  GewaraCore
//
//  Created by wushengtao on 15/2/6.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "GWObject.h"

@interface GWProviderResultPackage : GWObject
@property (nonatomic, retain) id providerResult;
@property (nonatomic, retain) NSError* providerError;
@property (nonatomic, assign) BOOL isUseCache;
@end
