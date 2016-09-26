//
//  PrePlayView.h
//  WebStyle
//
//  Created by liudan on 9/21/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferVideo.h"

@protocol PrePlayViewDelegate <NSObject>

-(void)playVideo;
-(void)goBack;

@end

@interface PrePlayView : UIView

@property(strong, nonatomic) PreferVideo *video;

@property (strong, nonatomic)UIImageView *imgView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UIButton *playBtn;
@property (strong, nonatomic)UIButton *backBtn;

//@property (strong, nonatomic)UIView *backView;
@property (nonatomic, weak) id<PrePlayViewDelegate> delegate;

//- (instancetype)initSubViewFrame:(CGRect)rect;
@end
