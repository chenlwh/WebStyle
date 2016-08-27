//
//  PlayerScrollView.h
//  WebStyle
//
//  Created by liudan on 8/26/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "SwipeView.h"
#import "PreferPlayer.h"

#define kPeopleViewHeight GWTranslateWidthBase4P7ScreenValue(105)

@interface PlayerCard : UIView
@property (nonatomic, strong) UIImageView* headImageView;
@property (nonatomic, strong) PreferPlayer* people;
@property (nonatomic, assign) BOOL showBorderFrame;

@end

@interface PlayerScrollView : SwipeView
@property (nonatomic, strong) NSArray* personList;
//@property (nonatomic, copy) void (^selectPeopleBlock)(GWPeople* people);
//@property (nonatomic, copy) void (^scrollDidLoadCompletion)();

@property (nonatomic, assign) BOOL showBorderFrame; // 显示边框,默认YES
@end
