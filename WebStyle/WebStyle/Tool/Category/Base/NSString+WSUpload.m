//
//  NSString+WSUpload.m
//  WebStyle
//
//  Created by liudan on 9/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "NSString+WSUpload.h"
#import "NSString+MD5Addition.h"

@implementation NSString (WSUpload)
+ (NSString*)uuidNameWithMD5:(BOOL)useMD5
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    NSString* uuid = (__bridge NSString*)uuidStr;
    NSString* fileName = useMD5 ? [uuid stringFromMD5] : uuid;
    CFRelease(uuidStr);
    CFRelease(uuidRef);
    return fileName;
}
@end
