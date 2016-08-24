//
//  MBProgressHUD+GWHud.h
//  GWV2
//
//  Created by yang xueya on 9/5/12.
//  Copyright (c) 2012 gewara. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (GWHud)

-(void)setCustomViewCheckMark:(NSString *)checkStr;
-(void)setCustomViewretry:(NSString *)retryStr;
-(void)setCustomViewSuccess:(NSString *)successStr;
-(void)setCustomViewAddSuccess:(NSString *)Labeltext detailsLabel:(NSString *)dedetailsLabel;
@end
