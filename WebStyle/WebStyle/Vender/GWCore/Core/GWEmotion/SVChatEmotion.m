//
//  ChatEmotion.m
//  Quartz2d_Learning
//
//  Created by yangzexin on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SVChatEmotion.h"

@implementation SVChatEmotion

@synthesize code;
@synthesize imageName;

- (void)dealloc
{
    self.code = nil;
    self.imageName = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", self.code, self.imageName];
}

@end
