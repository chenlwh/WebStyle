//
//  HomeNewPlayerVideoViewController.m
//  WebStyle
//
//  Created by liudan on 8/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "HomeNewPlayerVideoViewController.h"

@interface HomeNewPlayerVideoViewController ()

@end

@implementation HomeNewPlayerVideoViewController

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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.dataArray.count==0||self.dataArray.count<=indexPath.row) {
        return;
    }
    
    PreferVideo * movie = self.dataArray[indexPath.row];
    VideoCard * cardView = (id)[cell viewWithTag:cardTag];
    
    if ([self.delegate respondsToSelector:@selector(gotoMovieDetail:withMovieCard:)]) {
        [self.delegate gotoMovieDetail:movie withMovieCard:cardView];
    }
}

#pragma mark getter && setter
-(NSString*)cellIdentifier
{
    return @"NewPlayerVideoVCIdentifier";
}

@end
