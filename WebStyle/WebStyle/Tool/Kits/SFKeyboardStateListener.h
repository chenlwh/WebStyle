//
//  KeyboardState.h
//  Badminton
//
//  Created by yangzexin on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFKeyboardStateListener : NSObject {
    BOOL _keyboardVisible;
}

@property(nonatomic, readonly)BOOL keyboardVisible;

+ (SFKeyboardStateListener *)sharedInstance;

- (void)startListen;
- (void)stopListen;

@end
