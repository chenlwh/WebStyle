//
//  SearchedVideoCell.h
//  WebStyle
//
//  Created by 刘丹 on 16/9/6.
//  Copyright © 2016年 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferVideo.h"

#define SearchedVideoCellIndentifier @"SearchedVideoCellIndentifier"

@interface SearchedVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *videoTime;
@property (weak, nonatomic) IBOutlet UILabel *videoAuthor;
@property (weak, nonatomic) IBOutlet UIView *seprateView;
-(void) setVideoInfo:(PreferVideo*)video;

+(CGFloat) SearchedVideoCellHeight;
@end
