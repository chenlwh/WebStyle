//
//  MyPopularColletionViewController.m
//  WebStyle
//
//  Created by liudan on 9/21/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "MyPopularColletionViewController.h"

@implementation MyPopularColletionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 0, self.view.width, [self cellHeightWithLineCount:2])];
    
    [self.collectionView setFrame:self.view.bounds];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:self.cellIdentifier];
    
    [self.view addSubview:self.collectionView];
}


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
    return @"MyPopularVCIdentifier";
}
@end
