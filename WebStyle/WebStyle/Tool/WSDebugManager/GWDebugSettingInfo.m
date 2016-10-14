//
//  GWDebugSettingInfo.m
//  WebStyle
//
//  Created by liudan on 10/14/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "GWDebugSettingInfo.h"

@implementation GWDebugSettingInfo
+ (GWDebugSettingInfo*)createDebugSettingInfoIfEmpty
{
    NSData* currentData = [NSData dataWithContentsOfFile:[[self class] savePath]];
    
    GWDebugSettingInfo* info = [NSKeyedUnarchiver unarchiveObjectWithData:currentData];
    if(!info)
    {
        info = [[GWDebugSettingInfo alloc] init];
    }
    
    return info;
}

+ (NSString*)savePath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [NSString stringWithFormat:@"%@/debugInfo", [paths firstObject]];
    return path;
}

- (void)setDebugMainBarMinimize:(BOOL)debugMainBarMinimize
{
    _debugMainBarMinimize = debugMainBarMinimize;
    [self saveDebugInfo];
}

- (void)setFpsBarHidden:(BOOL)fpsBarHidden
{
    _fpsBarHidden = fpsBarHidden;
    [self saveDebugInfo];
}
-(void)setPlayRate:(NSInteger)playRate
{
    _playRate = playRate;
    [self saveDebugInfo];
}
- (void)saveDebugInfo
{
    NSData* currentData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [currentData writeToFile:[[self class] savePath] atomically:YES];
}

@end
