//
//  GWErrorInterceptor.h
//  GewaraCore
//
//  Created by wushengtao on 14-5-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWErrorInterceptor : NSObject
- (NSError *)findError:(NSString *)string description:(NSString*)description format:(NSString*)format;
@end


@interface GWCommonErrorInterceptor : GWErrorInterceptor
@end
@interface GWCommonJsonErrorInterceptor : GWErrorInterceptor
@end

@interface GWCommonError2Interceptor : GWErrorInterceptor
@end
@interface GWCommonJsonError2Interceptor : GWErrorInterceptor
@end

@interface GWDataStructureValidateErrorInterceptor : GWErrorInterceptor
@end

@interface GWJsonForSportsErrorInterceptor : GWErrorInterceptor
@end