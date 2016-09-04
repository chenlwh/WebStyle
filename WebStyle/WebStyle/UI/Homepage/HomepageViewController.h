//
//  HomepageViewController.h
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "BasicViewController.h"
#import "HomepageHeaderView.h"
#import "HomepageNaviBarView.h"
@interface HomepageViewController : BasicViewController
@property (nonatomic, strong) HomepageHeaderView *headView;
@property (nonatomic, strong) HomepageNaviBarView *customNaviView;
@end
