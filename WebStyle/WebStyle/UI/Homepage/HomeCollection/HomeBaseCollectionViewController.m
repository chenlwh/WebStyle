//
//  HomeBaseCollectionViewController.m
//  WebStyle
//
//  Created by liudan on 8/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "HomeBaseCollectionViewController.h"
#import "MsgDefine.h"
#import "FTUtils.h"
#import "VideoCard.h"

#define movieCardHeight GWTranslateWidthBase4P7ScreenValue(102 + 20)
#define movieCardWidth GWTranslateWidthBase4P7ScreenValue(170)
#define viewMargin 10
#define movieCardLineCount 2

@interface HomeBaseCollectionViewController ()

@property (nonatomic, assign) CGFloat fCardWidth;
@property (nonatomic, assign) CGFloat fCardHeight;
@end

@implementation HomeBaseCollectionViewController

-(CGFloat)cellHeightWithLineCount:(NSInteger)lineCount
{
    return (self.fCardHeight + viewMargin) * lineCount;
//    if (lineCount == 1 || lineCount == 0 ) {
//        return self.fCardHeight + viewMargin;
//    }else{
//        return self.fCardHeight*lineCount + viewMargin;
//    }
}

-(CGFloat)updateViewHeightWithLineCount:(NSInteger)lineCount
{
    CGFloat height = [self cellHeightWithLineCount:lineCount];
    self.view.height = height;
    self.collectionView.height = self.view.height;
    return height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fCardWidth = (self.view.width - 3 * viewMargin)/2;
    _fCardHeight = _fCardWidth * 0.7;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionview dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = RGBACOLORFromRGBHex(0xe9e8e8);
    
//    GWMovieCard *_cellCard = (id)[cell.contentView viewWithTag:cardTag];
//    
//    if (_cellCard == nil) {
//        _cellCard = [[GWMovieCard alloc] initWithFrame:CGRectMake(0, 0, movieCardWidth, movieCardHeight) withType:MovieCardOnPlaying];
//        _cellCard.userInteractionEnabled = NO;
//        _cellCard.tag = cardTag;
//        [_cellCard checkSize];
//        [cell.contentView addSubview:_cellCard];
//    }
//    if (self.dataArray.count > indexPath.row) {
//        Movie *tmpMovie = self.dataArray[indexPath.row];
//        _cellCard.movie = tmpMovie;
//    }else{
//        _cellCard.movie = nil;
//    }
    
    VideoCard *card = [cell.contentView viewWithTag:cardTag];
    if(card == nil)
    {
        card = [[VideoCard alloc] initWithFrame:CGRectMake(0, 0, self.fCardWidth, self.fCardHeight)];
        card.userInteractionEnabled = NO;
        card.tag = cardTag;
        [cell.contentView addSubview:card];
    }
    
    if(self.dataArray.count > indexPath.row)
    {
        PreferVideo *video = self.dataArray[indexPath.row];
        card.video = video;
    }
    else
    {
        card.video = nil;
    }
    
    return cell;
}

#pragma mark collectionview delegate


#pragma mark collectionViewFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    D_Log(@"size %@", NSStringFromCGSize(CGSizeMake(self.fCardWidth, movieCardHeight)));
    return CGSizeMake(self.fCardWidth, self.fCardHeight);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, viewMargin, 0, viewMargin);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //上下的间隔
    return viewMargin;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
//    float space = (self.collectionView.width - viewMargin*2 - movieCardWidth*movieCardLineCount);
//    D_Log(@"space %f", space);
    return viewMargin;
}

#pragma mark  setter && getter
-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout*flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.scrollsToTop = NO;
        [_collectionView setScrollEnabled:NO];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
    }
    return _collectionView;
}

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    return _dataArray;
}



@end
