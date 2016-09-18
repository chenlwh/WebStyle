//
//  HomeBaseCollectionViewController.h
//  WebStyle
//
//  Created by liudan on 8/29/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Gewara.h"
#import "VideoCard.h"
#import "PreferVideo.h"

#define cardTag 1000


@protocol HomeBaseCollectionDelegate <NSObject>

- (void)gotoMovieDetail:(PreferVideo*)movie withMovieCard:(VideoCard*)movieCard; 


@end

@interface HomeBaseCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) NSString * cellIdentifier;

@property (nonatomic,weak) id<HomeBaseCollectionDelegate> delegate;


/**
 *  根据行数获取高度
 *
 *  @param lineCount 行数
 *
 *  @return 获取得到的高度
 */
-(CGFloat)cellHeightWithLineCount:(NSInteger)lineCount;

/**
 *  根据行数获取高度 并且更新view高度
 *
 *  @param lineCount 行数
 *
 *  @return 获取得到的高度
 */
-(CGFloat)updateViewHeightWithLineCount:(NSInteger)lineCount;

@end
