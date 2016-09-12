//
//  KeyboardState.m
//  Badminton
//
//  Created by yangzexin on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SFKeyboardStateListener.h"

@implementation SFKeyboardStateListener

@synthesize keyboardVisible = _keyboardVisible;

+ (SFKeyboardStateListener *)sharedInstance
{
    static SFKeyboardStateListener *instance = nil;
    if(!instance){
        instance = [[SFKeyboardStateListener alloc] init];
    }
    return instance;
}
- (void)dealloc
{
    [self stopListen];
    
    
}
- (id)init
{
    self = [super init];
    
    return self;
}

#pragma mark - instance methods
- (void)startListen
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onKeyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onKeyboardDidHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
}
- (void)stopListen
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notifications
- (void)onKeyboardDidShow:(NSNotification *)n
{
    _keyboardVisible = YES;
}
- (void)onKeyboardDidHide:(NSNotification *)n
{
    _keyboardVisible = NO;
}

#pragma mark - override


@end
