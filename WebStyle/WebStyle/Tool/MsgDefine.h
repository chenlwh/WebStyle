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



#define kNaviHeight 44
#define kStatusHegiht 20
#define kAppName @"网红派"
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

#define DefaultFloatComparisonEpsilon    0.0001
#define EqualFloats(f1, f2, epsilon)    ( fabs( (f1) - (f2) ) < epsilon )
#define NotEqualFloats(f1, f2, epsilon)    ( !EqualFloats(f1, f2, epsilon) )
#define DefaultEqualFloats(f1, f2)    (EqualFloats(f1, f2, DefaultFloatComparisonEpsilon))
#define DefaultNotEqualFloats(f1, f2)    (NotEqualFloats(f1, f2, DefaultFloatComparisonEpsilon))
#define DefaultGreatAndEqualFloats(f1, f2)    (EqualFloats(f1, f2, DefaultFloatComparisonEpsilon) || (f1) > (f2))
#define DefaultLessAndEqualFloats(f1, f2)    (EqualFloats(f1, f2, DefaultFloatComparisonEpsilon) || (f1) < (f2))

#define IsRightSlideGesture(translation)  (translation.x > 0)

#define WeakObjectDef(obj) __weak typeof(obj) weak##obj = obj


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IOS7 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
#define IOS8 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

#define GWScreenW (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
#define GWScreenH (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))

#define AppMainColor RGBACOLORFromRGBHex(0xeb611f)

#define IS_IPHONE_4_INCH (fabs((double)GWScreenH-(double)568 ) < DBL_EPSILON )

#define IS_IPHONE_3P5_INCH (fabs((double)GWScreenH-(double)480 ) < DBL_EPSILON )

#define IS_IPHONE_4_INCH_DECREASE (fabs((double)GWScreenW-(double)320 ) == 0 )

#define IS_IPHONE_4P7_INCH_INCREASE (fabs((double)GWScreenW-(double)320 ) > 0 )

#define IS_IPHONE_4P7_INCH (fabs((double)GWScreenW-(double)375 ) < DBL_EPSILON )

#define IS_IPHONE_5P5_INCH (fabs((double)GWScreenW-(double)414 ) < DBL_EPSILON )

#define GWTranslateWidthBase4P7ScreenValue(value) ((value) * GWScreenW / 375)


#endif /* MsgDefine_h */