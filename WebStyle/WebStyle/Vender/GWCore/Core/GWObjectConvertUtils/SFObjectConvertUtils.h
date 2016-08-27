//
//  SFObjectConvertUtils.h
//  SimpleFramework
//
//  Created by yangzexin on 13-7-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface SFObjectConvertUtils : NSObject

+ (NSArray *)objectsWithClass:(Class)clss parent:(TBXMLElement *)parent mapping:(NSDictionary*)mappingDict;
+ (id)objectWithClass:(Class)clss parent:(TBXMLElement *)parent mapping:(NSDictionary*)mappingDict;

@end
