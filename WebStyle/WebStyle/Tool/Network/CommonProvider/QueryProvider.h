//
//  QueryProvider.h
//  WebStyle
//
//  Created by liudan on 10/9/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "GWBaseInfoProvider.h"

@interface QueryProvider : GWBaseInfoProvider
//搜索的内容
@property (nonatomic, strong) NSString *query;
@end
