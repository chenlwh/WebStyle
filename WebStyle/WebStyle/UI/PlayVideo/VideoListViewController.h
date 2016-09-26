//
//  VideoListViewController.h
//  WebStyle
//
//  Created by liudan on 9/26/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
@interface VideoListViewController : BasicViewController
@property (nonatomic, strong) NSString *url;
@property (strong, nonatomic)NSMutableArray *dataSource; //数据源
@property (nonatomic, strong) NSString *title;
@end
