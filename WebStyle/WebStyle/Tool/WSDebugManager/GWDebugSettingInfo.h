//
//  GWDebugSettingInfo.h
//  WebStyle
//
//  Created by liudan on 10/14/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWDebugSettingInfo : NSObject
@property (nonatomic, assign) BOOL debugMainBarMinimize;
@property (nonatomic, assign) BOOL fpsBarHidden;
@property (nonatomic, assign) NSInteger playRate;

+ (GWDebugSettingInfo*)createDebugSettingInfoIfEmpty;
- (void)saveDebugInfo;
@end
