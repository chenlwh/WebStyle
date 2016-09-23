//
//  VideoTitleTableViewCell.h
//  WebStyle
//
//  Created by liudan on 9/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;

+(NSString *)cellIndentifier;

@end
