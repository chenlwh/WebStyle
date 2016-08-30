//
//  HomeHotPlayerVideoViewController.m
//  WebStyle
//
//  Created by 刘丹 on 16/8/30.
//  Copyright © 2016年 liudan. All rights reserved.
//

#import "HomeHotPlayerVideoViewController.h"

@interface HomeHotPlayerVideoViewController ()

@end

@implementation HomeHotPlayerVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 0, self.view.width, [self cellHeightWithLineCount:2])];
    
    [self.collectionView setFrame:self.view.bounds];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:self.cellIdentifier];
    
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark getter && setter
-(NSString*)cellIdentifier
{
    return @"HotPlayerVideoVCIdentifier";
}
@end
