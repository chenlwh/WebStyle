//
//  HomepageViewController.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "HomepageViewController.h"
#import "UIBarButtonItem+CustomInit.h"

@interface HomepageViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;

@end

@implementation HomepageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self createTableView];
    
    [self.tableView.header beginRefreshing];
}


-(void)setNav
{
//    self.navigationController.navigationBar.hidden = true;
    self.navigationItem.title = @"首页";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImageName:@"search_1" HighlightedImageName:@"search_2" Target:self Action:@selector(searchBtnClick)];
}

-(void)createTableView
{
    self.tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setBackgroundColor: RGBACOLORFromRGBHex(0xf6f6f6)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    self.tableView.scrollsToTop = true;
    [self.view addSubview:self.tableView];
    
    [self.tableView setTableHeaderView:self.headView];
}

-(void)searchBtnClick
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma setter & getter

-(UIView*)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 125)];
        _headView.backgroundColor = [UIColor greenColor];
    }
    return _headView;
}



#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
