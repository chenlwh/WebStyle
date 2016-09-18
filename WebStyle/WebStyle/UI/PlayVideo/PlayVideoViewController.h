//
//  PlayVideoViewController.h
//  WebStyle
//
//  Created by liudan on 9/18/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "BasicViewController.h"
#import "HTPlayer.h"
#import "PreferVideo.h"
@interface PlayVideoViewController : BasicViewController

@property (strong, nonatomic)HTPlayer *htPlayer;
@property (strong, nonatomic)PreferVideo *model;
@property (strong, nonatomic)UIView *videoView;

@end
