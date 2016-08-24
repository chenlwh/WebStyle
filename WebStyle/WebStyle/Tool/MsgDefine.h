//
//  MsgDefine.h
//  WebStyle
//
//  Created by liudan on 8/24/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef MsgDefine_h
#define MsgDefine_h




#if DEBUG
#define MSGLOG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define MSGLOG(format, ...)
#endif


#ifdef DEBUG
#define D_Log(...) NSLog(__VA_ARGS__)
#else
#define D_Log(...)
#endif


#define WeakObjectDef(obj) __weak typeof(obj) weak##obj = obj


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IOS7 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
#define IOS8 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

#endif /* MsgDefine_h */