//
//  GWSettingViewController.m
//  GWMovie
//
//  Created by gewara10 on 13-12-10.
//  Copyright (c) 2013年 gewara. All rights reserved.
//

#import "GWSettingViewController.h"
#import "WSAppContext+WSLogin.h"
#import "GWUserCenterBaseCornerCell.h"
#import "Masonry.h"
#import "UIViewController+Alert.h"
@interface GWSettingViewController ()



@property (strong, nonatomic) NSMutableArray *otherSettingTextArray;

@property (strong, nonatomic) NSMutableArray *opinionSettingTextArray;



@property (strong, nonatomic) UIView *settingTableFootView;

@property (assign, nonatomic) float cacheFileSize;

@end

@implementation GWSettingViewController




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
//    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"设置";
    
    self.settingTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.settingTableView.backgroundColor= [UIColor clearColor];
    self.settingTableView.delegate = self;
    self.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.settingTableView.dataSource = self;
    [self.view addSubview:self.settingTableView];
    
//    self.pushSettingTextArray = [NSMutableArray arrayWithObjects:@"观影前提醒",/*@"关注新片排片提醒",*/@"哇啦被评论/喜欢",@"每日红包提醒", nil];
    
    
    self.otherSettingTextArray = [NSMutableArray arrayWithObjects:@"喜欢网红派?去评分吧!", @"关于我们",nil];
    
    self.opinionSettingTextArray =[NSMutableArray arrayWithObjects:@"意见反馈", nil];
    
//    self.appRecommendTextArray =[NSMutableArray arrayWithObjects:@"更多精彩应用",nil];
    
    if ([[WSAppContext appContext] isLoging]) {
        [self layoutTableFootView];
        self.settingTableView.tableFooterView = self.settingTableFootView;
    }
    
    //暂时不需要推送状态更新
    //[self requestData];
    
//    [self initNotification];
    
    
    _cacheFileSize =[self getCacheFileSize];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self.settingTableView
//                                             selector:@selector(reloadData)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
}





#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case SettingCellStyleOther:
            return [self.otherSettingTextArray count];
            break;
        case SettingCellStyleOpinion:
            return 0;
//            return isLoging ? [self.opinionSettingTextArray count] : 0;
            break;
        default:
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case SettingCellStyleOther:
            return @"其他";
            break;
        default:
            break;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
        
    static NSString *cellIdentifier = @"Cell";
    GWUserCenterBaseCornerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[GWUserCenterBaseCornerCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.textLabel.font =[UIFont systemFontOfSize:14.0f];
    }
    
    cell.cellBackImageView.position =GWBaseCellGroundViewPositionMiddle;
    if (indexPath.row ==0) {
        cell.cellBackImageView.position =GWBaseCellGroundViewPositionTop;
    }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1){
        cell.cellBackImageView.position =GWBaseCellGroundViewPositionBottom;
    }
    
//    [cell.cellBackGroundView needDrawCorner];
    
    switch (indexPath.section) {
        case SettingCellStyleOther:{
            cell.textLabel.text =[self.otherSettingTextArray objectAtIndex:indexPath.row];
            if (indexPath.row ==4) {
                if (_cacheFileSize == 0.0f) {
                    cell.bcRightTextLabel.text =@"";
                }else{
                    cell.bcRightTextLabel.text =[NSString stringWithFormat:@"%.1fM",_cacheFileSize];
                }
            }
        }
            break;
        case SettingCellStyleOpinion:
            cell.textLabel.text =[self.opinionSettingTextArray objectAtIndex:indexPath.row];
            cell.cellBackImageView.position =GWBaseCellGroundViewPositionSingle;
            break;

            
        default:
            break;
    }
    
    
    return cell;
}
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.section) {
        case SettingCellStyleOther:
        {
            if (indexPath.row ==0) {
                /**
                 * 为应用评分
                 */
                [self score];
            }else if (indexPath.row == 1){
                /**
                 * 关于我们
                 */
                [self aboutUs];
            }else if (indexPath.row == 2){
                /**
                 * 清除缓存
                 */
                [self clearCacheAction:nil];
                
            }
        }
            break;
        case SettingCellStyleOpinion:
            //意见反馈
//            [self gotoFeedBackViewAction:nil];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return tableViewIndentationLevel;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == SettingCellStyleOther){
        return 40; //isLoging ? 40 : 0;
    }else if (section == SettingCellStyleOpinion){
        return 0;
//        return isLoging ? 10 : 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    BOOL isLoging = [[WSAppContext appContext] isLoging];
 if (section == SettingCellStyleOpinion){
        return 0;
    }

    return isLoging ? 10 : 0;
}

#pragma mark - push



#pragma mark - other request

/**
 *  加载页面数据
 */
//- (void)loadData{
//    
//    GWUserCenterSwitchCell *moviecell = (GWUserCenterSwitchCell *)[self reloadViewDateWithIndexrRow:0 indexSection:0];
//
//    moviecell.pushSwitch.on = [GWSettingViewController bPush];
//
//    GWUserCenterSwitchCell *walacell =(GWUserCenterSwitchCell *) [self reloadViewDateWithIndexrRow:1 indexSection:0];
//    [walacell.pushSwitch setOn:[self.pushModel isPushWala] animated:YES];
//    
//    GWUserCenterSwitchCell *redPacketcell = (GWUserCenterSwitchCell *)[self reloadViewDateWithIndexrRow:2 indexSection:0];
//    
//    [redPacketcell.pushSwitch setOn:[self.events hasRedPackEvent] animated:YES];
//}


/**
 *   刷新页面数据
 *
 *  @param row
 *  @param section
 */
-(UITableViewCell *)reloadViewDateWithIndexrRow:(NSInteger)row indexSection:(NSInteger)section{
    NSIndexPath *cellIndexPath =[NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell = (UITableViewCell *)[self.settingTableView cellForRowAtIndexPath:cellIndexPath];
    return cell;
}

/**
 *  给应用评分
 */
- (void)score
{
    NSString *url = @"";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

/**
 *  关于我们
 */
-(void)aboutUs{
//    GWAboutUsViewController *aboutView =[[GWAboutUsViewController alloc] init];
//    [self.navigationController pushViewController:aboutView animated:YES];
}
/**
 *  创建table foot view 
 *  加载退出登录button
 */
-(void)layoutTableFootView{
    self.settingTableFootView =[[UIView alloc] init];
    self.settingTableFootView.frame =CGRectMake(0.0f, 0.0f, 300.0f, 100.0f);
    
    UIButton *logOutButton =[UIButton buttonWithType:UIButtonTypeCustom];
    logOutButton.layer.cornerRadius = 2;
    logOutButton.backgroundColor = RGBACOLORFromRGBHex(0xff5200);
    logOutButton.frame = CGRectMake(10.0f, 0.0f, self.settingTableFootView.width-20,40);
    [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logOutButton addTarget:self action:@selector(logOutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingTableFootView addSubview:logOutButton];
    [logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settingTableFootView.mas_top);
        make.left.equalTo(self.settingTableFootView.mas_left).offset(10.0f);
        make.right.equalTo(self.settingTableFootView.mas_right).offset(-10.0f);
        make.height.height.equalTo(@(40));
    }];
    
}
/**
 *  退出登录
 */
-(void)logOutButtonAction:(id)sender
{
    WeakObjectDef(self);
    [self confirmWithTitle:@"确定要退出嘛?"
                   message:@""
                   approve:^(void){
                       [weakself handleLogoutAction];
                   }];
}

- (void)handleLogoutAction
{
    
    //去除个推绑定 V7.0
    
//    if ([NSUserDefaults isStandardUserDefaultsContainObjectForKey:GWGeTuiDeviceToken]) {
//        
//        GWUnBindCidProvider  *unProvider = [[GWUnBindCidProvider alloc]initWithSender:self];
//        D_Log(@"unProvider--:%@",[unProvider description]);
//        [unProvider requestWithCompletionHandler:^(id response, NSError *error) {
//            if (!error) {
//                D_Log(@"response:%@",response);
//            }else{
//                D_Log(@"error:%@",error);
//            }
//        }];
//        
//    }

    
    
    //手动退出,清除password
    WSLoginInfo *lastInfo = [WSAppContext readLastLoginInfo] ;
    lastInfo.password = @"";
    [WSAppContext saveLastLoginInfo:lastInfo];
    
    //发通知的
    [[WSAppContext appContext] logout];
    
    [self backToHomeTab];
}

- (void)backToHomeTab
{
//    [self.sideMenuViewController showTab:GWTabTypeHome];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

/**
 *  清除缓存
 *
 *  @param sender
 */
-(void)clearCacheAction:(id)sender{
    WeakObjectDef(self);
    [self startLoading];
    [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //清除图片缓存
        
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        weakself.cacheFileSize = [weakself getCacheFileSize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//#ifdef __TEST__
//            [[GWPartnerDataSourceHandler instance] cancelAllLocalNotification];
//#endif
            [UIApplication sharedApplication].keyWindow.rootViewController.view.userInteractionEnabled = YES;
            [weakself stopLoading];
            [weakself showAutoHideToastWithString:@"清除成功"];
            GWBaseCell *cell =(GWBaseCell *)[weakself reloadViewDateWithIndexrRow:4 indexSection:1];
            if(weakself.cacheFileSize == 0.0f) {
                cell.bcRightTextLabel.text = @"";
            }else{
                cell.bcRightTextLabel.text = [NSString stringWithFormat:@"%.1fM", weakself.cacheFileSize];
            }
        });
    });
    
    
    
    
}

/**
 *  获取缓存文件大小
 */
-(float)getCacheFileSize{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachesDir =[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"ImageCache"];
//    return [self folderSizeAtPath:cachesDir];
    
    return  1.00f;
}

/**
 *  计算多个文件大小
 *
 *  @param folderPath 文件夹路径
 *
 *  @return float
 */
- (float)folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:folderPath]){
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
        NSString* fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize/(1024.0*1024.0);
    }
    return 0.0f;
}

/**
 *  计算单个文件大小
 *
 *  @param filePath 图片缓存路径
 *
 *  @return 文件大小
 */
- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



/**
 *  跳转到意见反馈页
 *
 *  @param sender
 */
-(void)gotoFeedBackViewAction:(id)sender{
    
}

/**
 * 跳转到更多应用页
 */
-(void)gotoAppRecommendViewAction:(id)sender{
  
}

-(void)settingViewcheckAppVersion{
 
}


@end
