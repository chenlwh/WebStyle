//
//  NSObject+AutoPairKeyValue.h
//  GewaraCore
//
//  Created by wushengtao on 14-5-20.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoPairKeyValue)
- (NSMutableDictionary*)dictionaryFromObjectWithclassDecider:(BOOL(^)(Class tmpClass, BOOL *stop))classDecider;
- (NSMutableArray*)keyFromObjectWithClassDecider:(BOOL(^)(Class tmpClass, BOOL *stop))classDecider;
- (NSSet*)filterSet;
@end
