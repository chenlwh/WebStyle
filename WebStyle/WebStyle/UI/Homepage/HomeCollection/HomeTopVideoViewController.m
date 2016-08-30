//
//  HomeTopVideoViewController.m
//  WebStyle
//
//  Created by 刘丹 on 16/8/30.
//  Copyright © 2016年 liudan. All rights reserved.
//

#import "HomeTopVideoViewController.h"

@implementation HomeTopVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 0, self.view.width, [self cellHeightWithLineCount:2])];
    
    [self.collectionView setFrame:self.view.bounds];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:self.cellIdentifier];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark getter && setter
-(NSString*)cellIdentifier
{
    return @"TopVideoVCIdentifier";
}
@end
