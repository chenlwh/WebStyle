//
//  GWUserDefaults.h
//  GewaraCore
//
//  Created by liangscofield on 15/10/12.
//  Copyright © 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWUserDefaults : NSObject

- (id)objectForKey:(NSString *)defaultName;
- (void)setObject:(id)value forKey:(NSString *)defaultName;
- (void)removeObjectForKey:(NSString *)defaultName;

@end
