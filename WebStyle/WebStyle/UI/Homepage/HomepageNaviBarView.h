//
//  HomepageNaviBarView.h
//  WebStyle
//
//  Created by liudan on 8/25/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWDramaHomeSearchView.h"

#define fThreshold 0.1

@protocol CustomNaviBarDelegate <NSObject>

-(void) naviBarsearchBtnClick;

-(void) AppNameBtnClick;

@end

@interface HomepageNaviBarView : UIView
@property (nonatomic, strong) GWDramaHomeSearchView *dramaHomeSearchView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, weak) id <CustomNaviBarDelegate> delegate;

-(void)reloadView;

-(void) setNaviBarAlpha:(CGFloat)alpha;

@end
