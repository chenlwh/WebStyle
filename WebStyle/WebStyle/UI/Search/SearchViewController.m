//
//  SearchViewController.m
//  WebStyle
//
//  Created by liudan on 8/25/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "SearchViewController.h"
#import "UrlDefine.h"
#import "AFHTTPRequestOperationManager.h"
#import "XYString.h"
#import "PreferVideo.h"
#import "PreferPlayer.h"
#import "MJExtension.h"
#import "SearchedVideoCell.h"
#import "SearchedPlayerCell.h"
#import "GWProgressHUD.h"
#import "GWMessageView.h"

#define  kHistoryRecordFileName   @"GWSearchViewController_HistorySearchRecord"
#define tableViewHeadHeight 45

enum {
    searchWord = 0,
    searchInfo = 1,
    searchButton
};


@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView       *historyTableView;
@property (nonatomic, strong) NSMutableArray    *historyList;
@property (nonatomic, strong) NSMutableArray    *searchedVideoList;
@property (nonatomic, strong) NSMutableArray    *searchedPlayerList;

@property (nonatomic, strong) UITableView       *mainTableView;

@property (nonatomic, strong) UITextField           *searchTF;

@property (nonatomic,strong) UIView *currentNavView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.historyList == nil) {
        self.historyList = [NSMutableArray array];
        
        NSArray *tempList = [[NSUserDefaults standardUserDefaults] objectForKey:kHistoryRecordFileName];
        [self.historyList addObjectsFromArray:tempList];
    }
    
    [self loadAllView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatusBarDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if (self.showSelectedMode) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        }else{
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
//    } else {
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//            self.navigationController.navigationBar.barTintColor = self.navBarColor;
//        }else{
//            self.navigationController.navigationBar.tintColor = self.navBarColor;
//        }
//    }
    [self.navigationController.navigationBar addSubview:self.currentNavView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.historyList forKey:kHistoryRecordFileName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        self.navigationController.navigationBar.barTintColor = [GWPColor navTintColorForIOS7];
//    }else{
//        self.navigationController.navigationBar.tintColor = [GWPColor navTintColorForIOS7];
//    }
    [self.currentNavView removeFromSuperview];
}

-(void)loadAllView
{
    UIImageView *image;
    UIView *singleLine;
    UIButton *pCancleBtn;
    NSString *placeHolder;
    UIView *pTopBarView;
    
    self.navigationItem.leftBarButtonItem = nil;
    
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    CGFloat buttonPadding = 0;
    CGFloat leftPadding = 8;
    D_Log(@"");
    if (IS_IPHONE_4P7_INCH) {
        buttonPadding = 1.5;
    } else if (IS_IPHONE_5P5_INCH) {
        offsetX = 2.8;
        offsetY = 2;
        buttonPadding = 0;
        leftPadding = 12;
    }
    pTopBarView = [[UIView alloc] initWithFrame:CGRectMake(leftPadding, 7, self.view.width-2*leftPadding, 30)];
    self.currentNavView = pTopBarView;
    UIImage *clearImage = [UIImage imageNamed:@"icon_cancel"];
    UIButton *pClearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pClearButton.frame = CGRectMake(0, 0, clearImage.size.width, clearImage.size.height);
    [pClearButton setImage:clearImage forState:UIControlStateNormal];
    [pClearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (IS_IPHONE_4_INCH_DECREASE) {
        placeHolder =@"  搜索电影、演出、影人、影院...";
    } else {
        placeHolder =@"  搜索电影、演出、影人、影院、用户";
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:placeHolder];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBACOLORFromRGBHex(0xff9966) range:NSMakeRange(0, [placeHolder length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [placeHolder length])];
    
    
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(-1.5 - offsetX, .5 - offsetY, pTopBarView.width - 60, pTopBarView.height)];
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_searchw"]];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.width+8, image.height)];
    [leftView addSubview:image];
    image.centerX = leftView.width/2;
    _searchTF.leftView = leftView;
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchTF.placeholder = placeHolder;
    _searchTF.attributedPlaceholder = attributedString;
    [_searchTF addTarget:self action:@selector(searchTrigger:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.delegate = self;
    _searchTF.textColor = [UIColor whiteColor];
    _searchTF.backgroundColor = RGBACOLORFromRGBHex(0xeb611f);
    _searchTF.font = [UIFont systemFontOfSize:14];
    _searchTF.clearButtonMode = UITextFieldViewModeNever;
    _searchTF.rightView = pClearButton;
    _searchTF.rightViewMode = UITextFieldViewModeWhileEditing;
    //[_searchTF becomeFirstResponder];
    [pTopBarView addSubview:_searchTF];
    
    
    singleLine = [[UIView alloc] initWithFrame:CGRectMake(_searchTF.left + 5, _searchTF.bottom - 1 + offsetY, _searchTF.width -20, 0.8)];
    singleLine.backgroundColor = [UIColor whiteColor];
    [pTopBarView addSubview:singleLine];
    
    CGSize buttonSize = CGSizeMake(60, pTopBarView.height);
    
    pCancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pCancleBtn.backgroundColor = [UIColor clearColor];
    pCancleBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    pCancleBtn.frame = CGRectMake(pTopBarView.width - buttonSize.width - buttonPadding, 0, buttonSize.width, buttonSize.height);
    [pCancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pCancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [pCancleBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    pCancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [pTopBarView addSubview:pCancleBtn];

    _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = RGBACOLORFromRGBHex(0xf0efef);
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    _mainTableView.height = self.view.height;
//    _mainTableView.top = 64;
    _mainTableView.hidden = YES;
    [self.view addSubview:_mainTableView];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"SearchedVideoCell" bundle:nil] forCellReuseIdentifier:SearchedVideoCellIndentifier];
    [_mainTableView registerNib:[UINib nibWithNibName:@"SearchedPlayerCell" bundle:nil] forCellReuseIdentifier:SearchedPlayerCellIndentifier];
    
    _historyTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [_historyTableView setBackgroundColor:RGBACOLORFromRGBHex(0xf0efef)];
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    _historyTableView.height = self.view.height -64;
    _historyTableView.top = 64;
    [_historyTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    _historyTableView.hidden = YES;
    [self.view addSubview:_historyTableView];
    [self.historyTableView reloadData];
    
    if (true) {
        image.image = [UIImage imageNamed:@"icon_search"];
        image.width=20.0;
        image.height=20.0;
        image.top -=2;
        singleLine.hidden = YES;
        _searchTF.backgroundColor = [UIColor whiteColor];
        _searchTF.textColor = [UIColor blackColor];
        _searchTF.font = [UIFont systemFontOfSize:16];
        
        NSString *tempPlaceHolder;
        tempPlaceHolder = @"  搜索视频、主播";
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempPlaceHolder];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBACOLORFromRGBHex(0xcccccc) range:NSMakeRange(0, [tempPlaceHolder length])];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [tempPlaceHolder length])];
        _searchTF.attributedPlaceholder = attributedString;
        [pCancleBtn setTitleColor:[UIColor colorWithRed:244.0/255.0 green:101.0/255.0 blue:34.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
        pTopBarView.backgroundColor = [UIColor whiteColor];
    }

    
    WeakObjectDef(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.searchTF becomeFirstResponder];
    });
    
}

#pragma mark get
-(NSMutableArray *)searchedVideoList
{
    if(!_searchedVideoList)
    {
        _searchedVideoList = [NSMutableArray new];
    }
    return _searchedVideoList;
}


-(NSMutableArray *)searchedPlayerList
{
    if(!_searchedPlayerList)
    {
        _searchedPlayerList = [NSMutableArray new];
    }
    return _searchedPlayerList;
}

- (void)cancelButtonClicked:(UIButton*)sender
{
    [_searchTF resignFirstResponder];
    [self dismiss];
}

- (void)searchTrigger:(UITextField *)pTextField
{
    D_Log(@"%@ %@", self, NSStringFromSelector(_cmd));
    NSString *pText = pTextField.text;
    [pTextField resignFirstResponder];
    
    [self requestSearchWithParams:pText];
//    [self requestSearchDrams:pText isClean:YES];
}

-(void)dismiss
{
    D_Log(@"%@ %@", self, NSStringFromSelector(_cmd));
    _searchTF.text = @"";
    
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
    //    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)clearAction
{
    D_Log(@"%@ %@", self, NSStringFromSelector(_cmd));
    _searchTF.text = @"";
}


-(void)requestSearchWithParams:(NSString*)searchName
{
//    [self showSearchMode:NO];
    self.historyTableView.hidden = YES;
    
    [self addTextToHistory:searchName];
    
    [GWProgressHUD showHUDAddedTo:self.view  animated:NO];
    
    WeakObjectDef(self);
    NSString * urlString = [NSString stringWithFormat:@"%@%@", kQueryInfo, [searchName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//    NSString *transString = [NSString stringWithString:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    D_Log(@"______%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [GWProgressHUD hideHUDForView:weakself.view animated:YES];
        [GWMessageView hideMSGForView:weakself.view animated:YES];
        
        D_Log(@"%@", operation.responseString);
        id obj = [XYString getObjectFromJsonString:operation.responseString];
         D_Log(@"%@", obj);
        if([obj isKindOfClass:[NSArray class]])
        {
            [weakself.searchedPlayerList removeAllObjects];
            [weakself.searchedVideoList removeAllObjects];
            for(id o in obj)
            {
                id tag = o[@"tag"];
                id data = o[@"data"];
                if([tag isKindOfClass:[NSString class]]
                   && [data isKindOfClass:[NSArray class]])
                {
                    
                    if([tag isEqualToString:@"player"])
                    {
                        weakself.searchedPlayerList = [NSMutableArray arrayWithArray:[PreferPlayer mj_objectArrayWithKeyValuesArray:data]];
                    }
                    else if([tag isEqualToString:@"video"])
                    {
                         weakself.searchedVideoList = [NSMutableArray arrayWithArray:[PreferVideo mj_objectArrayWithKeyValuesArray:data]];
                    }
                }
            }
        }
        if(weakself.searchedPlayerList.count || weakself.searchedVideoList.count)
        {
            [weakself showSearchMode:NO];
        }
        else
        {
            //show msg 未找到相关内容
            [GWMessageView showMSGAddedTo:weakself.view text:@"未找到相关内容" animated:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        D_Log(@"请求失败");
    }];
}

- (void)showSearchMode:(BOOL)searchMode
{
    if (searchMode) {
        self.historyTableView.hidden = NO;
        self.mainTableView.hidden = YES;
        
        [GWMessageView hideMSGForView:self.view animated:YES];
        [GWProgressHUD hideHUDForView:self.view animated:YES];
    }else{
        self.historyTableView.hidden = YES;
        self.mainTableView.hidden = NO;
    }
//    [self.refreshFooter endRefreshing];
//    [self.refreshHeader endRefreshing];
    [self.mainTableView reloadData];
    [self.historyTableView reloadData];
}

- (void)addTextToHistory:(NSString *)pRecordString
{
    if ([self.historyList containsObject:pRecordString]){
        [self.historyList removeObject:pRecordString];
    }
    [self.historyList insertObject:pRecordString atIndex:0];
    if (self.historyList.count>5) {
        self.historyList = [NSMutableArray arrayWithArray:[self.historyList subarrayWithRange:NSMakeRange(0, 5)]];
    }
}

-(void)cleanHistoryText
{
    [self.historyList removeAllObjects];
    [self.historyTableView reloadData];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView)
    {
        if(indexPath.section == 0)
        {
            
            if(indexPath.row == self.searchedVideoList.count - 1)
            {
                return [SearchedVideoCell SearchedVideoCellHeight] - 10;
            }
            else
            {
                return [SearchedVideoCell SearchedVideoCellHeight];
            }
            
        }
        else
        {
            if(indexPath.row == self.searchedPlayerList.count - 1)
            {
                return [SearchedPlayerCell SearchedPlayerCellHeight] - 10;
            }
            else
            {
                return [SearchedPlayerCell SearchedPlayerCellHeight];
            }
        }
        return 10;
    }
    else
    {
        return 48;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.mainTableView){
        //搜索到的 video 与 player, section 0 固定为 video, section 1固定为 player;
        return 2;
//        self.mainList.count;
    }else if (tableView == self.historyTableView){
        if (self.historyList.count>0) {
            return 3;
        }else{
            return 0;
        }
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.historyTableView) {
        return .1f;
    }
    else
    {
        if(section == 0) // 搜索到的视频
        {
            if(self.searchedVideoList.count > 0)
            {
                return tableViewHeadHeight;
            }
            else
            {
                return 0.1f;
            }
        }
        else
        {
            if(self.searchedPlayerList.count > 0)
            {
                return tableViewHeadHeight;
            }
            else
            {
                return 0.1f;
            }
        }
    }
    return .1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mainTableView){
//        GWSearch *tmpSearch = self.mainList[section];
//        return tmpSearch.itemList.count;
        
        if(section == 0)
        {
            return self.searchedVideoList.count;
        }
        else
        {
            return self.searchedPlayerList.count;
        }
        return 0;
    }else{
        if (section == searchInfo) {
            return self.historyList.count;
        }else if (section == searchWord){
            return 1;
        }else if (section == searchButton){
            return 1;
        }
        return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.historyTableView) {
        return nil;
    }
    else
    {
        NSMutableArray *tmpArray;
        if(section == 0)
        {
            tmpArray = self.searchedVideoList;
        }
        else
        {
            tmpArray = self.searchedPlayerList;
        }
        
        if(tmpArray.count == 0)
        {
            UIView *tmpView = [UIView new];
            tmpView.backgroundColor = [UIColor clearColor];
            return tmpView;
        }
        else
        {
            CGFloat height = tableViewHeadHeight;
            
            
            UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, height)];
            
//            tableHeadView.backgroundColor = [UIColor yellowColor];
            UILabel*sectionInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            NSString *totalString = [NSString stringWithFormat:@"%lu", (unsigned long)tmpArray.count];
            NSString * labelString = [NSString stringWithFormat:@"%@%@", totalString, (section == 0 ? @"部相关视频" : @"名相关玩家")];
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:labelString];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, labelString.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:RGBACOLORFromRGBHex(0xa0a0a0) range:NSMakeRange(0, labelString.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:RGBACOLORFromRGBHex(0xef662f) range:NSMakeRange(0, totalString.length)];
            sectionInfoLabel.attributedText = attString;
            [sectionInfoLabel sizeToFit];
            sectionInfoLabel.left = 30;
            sectionInfoLabel.bottom= tableHeadView.height - 15;
            [tableHeadView addSubview:sectionInfoLabel];
//            [tableHeadView setBackgroundColor:[UIColor redColor]];
            return tableHeadView;
        }
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierDefault = @"CellIdentifierDefault";
    if (tableView == self.historyTableView)
    {
        static NSString *cellIdentifierWord = @"CellIdentifierWord";
        static NSString *CellIdentifierClean = @"CellIdentifierClean";
        if (indexPath.section == searchWord) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierWord];
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierWord];
                cell.backgroundColor = self.view.backgroundColor;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
                cell.textLabel.left = 25;
                [cell.textLabel setText:@"搜索历史"];
                [cell.textLabel setTextColor:RGBACOLORFromRGBHex(0xa0a0a0)];
                [cell.textLabel setFont:[UIFont systemFontOfSize:12.0f]];
                
            }
            
            return cell;
        }else if (indexPath.section == searchInfo) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDefault];
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDefault];
                cell.backgroundColor = self.view.backgroundColor;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
            }
            
            if (indexPath.row < [self.historyList count]){
                NSString *text = self.historyList[indexPath.row];
                
                cell.textLabel.text = [NSString stringWithFormat:@"  %@", text];
            }
            return cell;
        }else if (indexPath.section == searchButton){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierClean];
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierClean];
                cell.backgroundColor = self.view.backgroundColor;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setFont:[UIFont systemFontOfSize:15.0f]];
                [label setTextColor:RGBACOLORFromRGBHex(0xac9169)];
                [label setText:@"清除历史数据"];
                label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [cell addSubview:label];
            }
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDefault];
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDefault];
                cell.backgroundColor = self.view.backgroundColor;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }

    }
    else if(tableView == _mainTableView)
    {
        if(indexPath.section == 0)
        {
            SearchedVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchedVideoCellIndentifier];
            if(indexPath.row < self.searchedVideoList.count)
            {
                PreferVideo *video = self.searchedVideoList[indexPath.row];
                [cell setVideoInfo:video];
                if(indexPath.row == self.searchedVideoList.count - 1)
                {
                    cell.seprateView.hidden = YES;
                }
                else
                {
                    cell.seprateView.hidden = NO;
                }
            }
            return cell;
        }
        else
        {
            SearchedPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchedPlayerCellIndentifier];
            if(indexPath.row < self.searchedPlayerList.count)
            {
                PreferPlayer *player = self.searchedPlayerList[indexPath.row];
                [cell setPlayerInfo:player];
                if(indexPath.row == self.searchedPlayerList.count - 1)
                {
                    cell.seprateView.hidden = YES;
                }
                else
                {
                    cell.seprateView.hidden = NO;
                }
            }
            return cell;
        }
    }
        
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _historyTableView){
        return @"删除";
    }else{
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _historyTableView){
        return NO;
    }else{
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _historyTableView){
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _historyTableView && editingStyle == UITableViewCellEditingStyleDelete){
        if (indexPath.row < [self.historyList count]){
            [self.historyList removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _historyTableView)
    {
        
        if (indexPath.section == searchInfo) {
            if (indexPath.row < [self.historyList count]){
                [_searchTF resignFirstResponder];
                _searchTF.text = self.historyList[indexPath.row];
//                [self requestSearchDrams:self.historyList[indexPath.row] isClean:YES];
                [self requestSearchWithParams:self.historyList[indexPath.row]];
            }
        }else if(indexPath.section == searchButton) {
            [self cleanHistoryText];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showSearchMode:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0){
        return NO;
    }
    return YES;
}

@end
