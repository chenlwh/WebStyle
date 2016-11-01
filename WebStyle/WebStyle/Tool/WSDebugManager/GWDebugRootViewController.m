//
//  GWDebugRootViewController.m
//  GWMovie
//
//  Created by wushengtao on 15/4/1.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWDebugRootViewController.h"



//#import "GWDebugSettingViewController.h"

#import "WSDebugManager.h"
#import "GWProviderManager.h"
#import "GWBaseProvider.h"
#import "UIView+Gewara.h"
//#import "SDWebImageDownloaderOperation.h"

@interface GWDebugRootViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIButton* titleButton;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GWDebugRootViewController

- (void)viewDidLoad
{
//    self.backItemString = @"关闭";
    
    [super viewDidLoad];
    
    self.title = @"请求列表";
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.frame = CGRectMake(0, 0, 200, 40);
    [_titleButton setTitle:@"请求列表" forState:UIControlStateNormal];
    [_titleButton setTitle:@"图片下载列表" forState:UIControlStateSelected];
    [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleButton;
    _titleButton.backgroundColor = [UIColor clearColor];
    
    [self createTableView];
    
//    [self setGoBackHandler:^{
//        [[WSDebugManager shareInstance] displayFullDebugController:NO];
//    }];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"设置" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    rightButton.height = MAX(rightButton.height, 44);
    rightButton.width = rightButton.width + 10;
    
    UIBarButtonItem	*item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftButton sizeToFit];
    leftButton.height = MAX(leftButton.height, 44);
    leftButton.width = leftButton.width + 10;
    UIBarButtonItem	*leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)createTableView
{
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
}
- (void)settingButtonClicked:(id)sender
{
//    [self.navigationController pushViewController:[[GWDebugSettingViewController alloc] init] animated:YES];
}

-(void)closeButtonClicked:(id)sender
{
    [[WSDebugManager shareInstance] displayFullDebugController: NO];
}

- (void)reloadDisplay
{
    [self.tableView reloadData];
}

- (void)titleButtonClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    
    [self reloadDisplay];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_titleButton.selected)
    {
        return [_imageOperations count];
    }
    
    GWProviderManager* manager = [GWProviderManager instance];
    return [[manager allProviders] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    if(_titleButton.selected)
    {
        cell.detailTextLabel.numberOfLines = 0;
        //SDWebImageCombinedOperation
        id op = _imageOperations[indexPath.row];
//        cell.textLabel.text = [op valueForKey:@"key"];
        cell.detailTextLabel.text = [op valueForKey:@"key"];
        D_Log(@"%@", cell.detailTextLabel.text);
    }
    else
    {
        cell.detailTextLabel.numberOfLines = 1;
        GWBaseProvider* provider = [[GWProviderManager instance] allProviders][indexPath.row];
        cell.textLabel.text = [provider thumbDescription];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"sender:%@", provider.sender/*NSStringFromClass([provider.sender class])*/];
    }
    return cell;
}
@end

