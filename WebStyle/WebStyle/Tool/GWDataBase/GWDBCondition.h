//
//  GWDBCondition.h
//  GWMovie
//
//  Created by wushengtao on 14-12-3.
//  Copyright (c) 2014年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWDBConditionPair : NSObject
@property (nonatomic, strong) NSArray* conditionArray;
@property (nonatomic, strong) NSDictionary* equlPair;
@property (nonatomic, strong) NSDictionary* likePair;
@end

@interface GWDBCondition : NSObject
@property (nonatomic, strong) GWDBConditionPair* andPairs;
@property (nonatomic, strong) GWDBConditionPair* orPairs;

- (NSString*)conditionStringAddValues:(NSMutableArray*)values;
@end

@interface GWDBSearchCondition : GWDBCondition
@property (nonatomic, strong) NSArray* columnList;   //表示 select {xxx} from 语句里的xxx，内部会自动把columnList组装成以逗号分割的字符串
@property (nonatomic, strong) NSArray* groupByList;  //表示 GROUP BY {xxx} 语句里的xxx，内部会自动把columnList组装成以逗号分割的字符串
@property (nonatomic, strong) NSArray* orderByList;  //表示 ORDER BY {xxx} 语句里的xxx，内部会自动把columnList组装成以逗号分割的字符串
@property (nonatomic, assign) BOOL ascSort;          //ORDER BY {ASC/DESC}，YES: ASC, NO: DESC

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;      

- (NSString*)cloumString;
@end
