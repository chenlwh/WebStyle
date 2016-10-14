//
//  GWDebugDBManager.h
//  GWMovie
//
//  Created by wushengtao on 15/5/25.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWDBManager.h"

//#ifdef __USE_DEBUGTOOL__
@interface GWDebugDBManager : GWDBManager
+ (id)shareDBManager;
- (void)openDBAndCreateTable;
@end
//#endif