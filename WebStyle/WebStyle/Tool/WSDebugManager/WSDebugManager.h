//
//  WSDebugManager.h
//  WebStyle
//
//  Created by liudan on 10/13/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSDebugWindow.h"
#import "GWDebugSettingInfo.h"



@interface WSDebugManager : NSObject
@property (nonatomic, readonly) WSDebugWindow* notificationWindow;
@property (nonatomic, readonly) GWDebugSettingInfo* debugSettingInfo;

+ (WSDebugManager*)shareInstance;
- (void)displayDebugView;
- (void)displayFullDebugController:(BOOL)show;

- (void)startTimer;
- (void)stopTimer;

- (void)mainBarSizeChangedIfNeed;
@end
