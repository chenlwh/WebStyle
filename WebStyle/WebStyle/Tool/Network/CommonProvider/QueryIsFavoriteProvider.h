//
//  QueryIsFavoriteProvider.h
//  WebStyle
//
//  Created by liudan on 9/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "GWBaseInfoProvider.h"

//查询该视频是否收藏;
@interface QueryIsFavoriteProvider : GWBaseInfoProvider
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *id;
@end
