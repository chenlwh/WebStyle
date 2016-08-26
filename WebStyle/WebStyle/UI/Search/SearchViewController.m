//
//  SearchViewController.m
//  WebStyle
//
//  Created by liudan on 8/25/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "SearchViewController.h"

#define  kHistoryRecordFileName   @"GWSearchViewController_HistorySearchRecord"

@interface SearchViewController ()
@property (nonatomic, strong) UITableView       *historyTableView;
@property (nonatomic, strong) NSMutableArray    *historyList;

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
//    _searchTF.delegate = self;
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

    _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    _mainTableView.delegate = self;
//    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = RGBACOLORFromRGBHex(0xf0efef);
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    _mainTableView.height = self.view.height -64;
    _mainTableView.top = 64;
    [self.view addSubview:_mainTableView];
    
    _historyTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [_historyTableView setBackgroundColor:RGBACOLORFromRGBHex(0xf0efef)];
//    _historyTableView.delegate = self;
//    _historyTableView.dataSource = self;
    [_historyTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _historyTableView.hidden = YES;
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

- (void)cancelButtonClicked:(UIButton*)sender
{
    [_searchTF resignFirstResponder];
    [self dismiss];
}

- (void)searchTrigger:(UITextField *)pTextField
{
    NSString *pText = pTextField.text;
    [pTextField resignFirstResponder];
    
//    [self requestSearchDrams:pText isClean:YES];
}

-(void)dismiss
{
    _searchTF.text = @"";
    
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
    //    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)clearAction
{
    _searchTF.text = @"";
}
@end
