//
//  GWPagingProvider.h
//  GewaraCore
//
//  Created by wushengtao on 14-6-6.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "GWBaseInfoProvider.h"

/**
 *  分页Provider
 */
@interface GWPagingProvider : GWBaseInfoProvider

/**
 *  起始索引
 */
@property(nonatomic, assign)NSInteger from;

/**
 *  内容数
 */
@property(nonatomic, assign)NSInteger maxnum;

@end


@interface GWPagingProvider (PageLoadable)
/**
 *  分页函数,务必设置responseHandler
 *
 *  @param completionHandler 回调block
 */
- (void)nextPageWithCompletionHandler:(void(^)(NSArray *resultArray, NSError *error))completionHandler;
- (void)resetPageCursor;

- (void)updateModelWithResponed:(id)respond error:(NSError *)error;



@end