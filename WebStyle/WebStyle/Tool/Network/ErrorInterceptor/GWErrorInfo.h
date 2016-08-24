//
//  GWErrorInfo.h
//  GewaraCore
//
//  Created by wushengtao on 15/10/26.
//  Copyright © 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWErrorInfo : NSObject
@end


@interface GWJumpUrlErrorInfo : GWErrorInfo
@property (nonatomic, copy) NSString* jumpUrl;
@end
