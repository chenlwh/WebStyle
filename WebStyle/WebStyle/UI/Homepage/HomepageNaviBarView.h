//
//  HomepageNaviBarView.h
//  WebStyle
//
//  Created by liudan on 8/25/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWDramaHomeSearchView.h"

@protocol CustomNaviBarDelegate <NSObject>

-(void) naviBarsearchBtnClick;

@end

@interface HomepageNaviBarView : UIView
@property (nonatomic, strong) GWDramaHomeSearchView *dramaHomeSearchView;
@property (nonatomic, weak) id <CustomNaviBarDelegate> delegate;

-(void)reloadView;
@end
