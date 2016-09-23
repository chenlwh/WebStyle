//
//  VideoBrowserTableViewCell.h
//  WebStyle
//
//  Created by liudan on 9/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoBrowserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

+(NSString *)cellIndentifier;
@end
