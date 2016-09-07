//
//  SearchedPlayerCell.h
//  WebStyle
//
//  Created by liudan on 9/7/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferPlayer.h"

#define SearchedPlayerCellIndentifier @"SearchedPlayerCellIndentifier"

@interface SearchedPlayerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *playerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeInfo;
@property (weak, nonatomic) IBOutlet UIView *seprateView;

-(void) setPlayerInfo:(PreferPlayer*)player;

+(CGFloat) SearchedPlayerCellHeight;
@end
