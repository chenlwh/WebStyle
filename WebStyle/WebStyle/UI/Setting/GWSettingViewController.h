//
//  GWSettingViewController.h
//  GWMovie
//
//  Created by gewara10 on 13-12-10.
//  Copyright (c) 2013年 gewara. All rights reserved.
//

#import "BasicViewController.h"

typedef enum{
    SettingCellStyleOther,
    SettingCellStyleOpinion
}SettingCellStyle;

//设置
@interface GWSettingViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *settingTableView;




@end
