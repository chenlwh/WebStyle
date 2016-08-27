//
//  PlayerScrollView.m
//  WebStyle
//
//  Created by liudan on 8/26/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "PlayerScrollView.h"
#import "UIScrollView+GWWebDragBackAnimation.h"
#import "MsgDefine.h"
#import "UIImageView+WebCache.h"
#import "FTUtils.h"
#import "UIView+Gewara.h"

#define imageWidth GWTranslateWidthBase4P7ScreenValue(55)
#define imageHeight2 GWTranslateWidthBase4P7ScreenValue(62)

const CGFloat kV6MoviePhotoMargin = 2.5;
const NSUInteger cardViewTag = 12345;

@interface PlayerCard()
@property (nonatomic, strong) UIImageView* maskImage;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* infoLabel;
@property (nonatomic, strong) UIImage* cacheImage;
@end

@implementation PlayerCard

-(void)dealloc
{
    [_headImageView sd_cancelCurrentImageLoad];
}

- (void)adjustImageView
{
    [_headImageView setAlpha:1];
    _headImageView.width = imageWidth;
    CGFloat height = (imageWidth / _headImageView.image.size.width * _headImageView.image.size.height);
    _headImageView.height = height < imageHeight2 ? imageHeight2 : height;
}

- (void)configureBorderFrame
{
    if (self.showBorderFrame)
    {
        self.layer.borderColor = RGBACOLORFromRGBHex(0xe9e8e8).CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 2.0f;
    }
    else
    {
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = 0;
    }
}


-(void)setPeople:(PreferPlayer*)people
{
    [self configureBorderFrame];
    
    CGFloat edge = GWTranslateWidthBase4P7ScreenValue(5);
    
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, GWTranslateWidthBase4P7ScreenValue(14), imageWidth, imageHeight2)];
    //    [headView setBackgroundColor:[UIColor whiteColor]];
    [headView setBackgroundColor:RGBACOLORFromRGBHex(0xe9e8e8)];
    [headView setClipsToBounds:YES];
    headView.centerX = self.width / 2;
    [self addSubview:headView];
    
    if(!_headImageView)
    {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight2)];
//        _headImageView.loadSuccessAnimation = EGWLoadSuccessAnimationTypeShowIfEmpty;
        [_headImageView setAlpha:0];
        _headImageView.contentMode = UIViewContentModeScaleToFill;
    }
    WeakObjectDef(self);
    [_headImageView sd_cancelCurrentImageLoad];
    if(_cacheImage)
    {
        _headImageView.image = _cacheImage;
        [self adjustImageView];
    }
    else
    {
//        [_headImageView setFitSizeImageWithURLString:people.headlogo
//                                    placeholderImage:_cacheImage
//                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                               if (!error && image) {
//                                                   [weakself.headImageView setAlpha:1];
//                                                   [weakself adjustImageView];
//                                               }
//                                           }];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:people.headimage] placeholderImage:_cacheImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error && image) {
                [weakself.headImageView setAlpha:1];
                [weakself adjustImageView];
            }
        }];
    }
    
    [headView addSubview:_headImageView];
    
    if(!self.maskImage)
    {
        self.maskImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _maskImage.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *mskImage = [UIImage imageNamed:@"head_mask"];
        [_maskImage setImage:mskImage];
    }
    _maskImage.frame = headView.frame;
    _maskImage.width = headView.width + 2;
    _maskImage.height = headView.height + 2;
    _maskImage.top -= 1;
    _maskImage.left -= 1 ;
    [self addSubview:_maskImage];
    
    if(!self.nameLabel)
    {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(edge, 0, 0, 0)];
        [_nameLabel setFont:[UIFont systemFontOfSize:GWTranslateWidthBase4P7ScreenValue(12.0f)]];
        [_nameLabel setTextColor:RGBACOLORFromRGBHex(0x5f5f5f)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    _nameLabel.top = headView.bottom + GWTranslateWidthBase4P7ScreenValue(8);
    [_nameLabel setText:people.nickname];
    [_nameLabel sizeToFit];
    _nameLabel.width = self.width - edge * 2;
    [self addSubview:_nameLabel];
    
//    if(!self.infoLabel)
//    {
//        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(edge, 0, 0, 0)];
//        [_infoLabel setFont:[UIFont systemFontOfSize:GWTranslateWidthBase4P7ScreenValue(9.0f)]];
//        _infoLabel.textAlignment = NSTextAlignmentCenter;
//        [_infoLabel setTextColor:RGBACOLORFromRGBHex(0xa0a0a0)];
//    }
//    
//    _infoLabel.top = _nameLabel.bottom + GWTranslateWidthBase4P7ScreenValue(2);
//    [_infoLabel setText:people.region];
//    [_infoLabel sizeToFit];
//    _infoLabel.width = self.width - edge * 2;
//    [self addSubview:_infoLabel];
    
    _people = people;
}



@end


@interface PlayerScrollView ()<SwipeViewDelegate, SwipeViewDataSource>
@property (nonatomic, strong) NSMutableSet* reuseViewSet;
@property (nonatomic, strong) NSMutableDictionary* cacheImageDic;
@end

@implementation PlayerScrollView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.alignment = SwipeViewAlignmentEdge;
        self.pagingEnabled = NO;
        self.clipsToBounds = NO;
        UIScrollView* scrollView = [self valueForKey:@"scrollView"];
        if(scrollView && [scrollView isKindOfClass:[UIScrollView class]])
        {
            scrollView.ifAgreeBackAnimation = YES;
        }
        
        _reuseViewSet = [NSMutableSet set];
        _cacheImageDic = [NSMutableDictionary dictionary];
        self.showBorderFrame = YES;
    }
    return self;
}

- (void)storeCacheImage
{
    [_cacheImageDic removeAllObjects];
    for(UIView* view in _reuseViewSet)
    {
        PlayerCard* card = (id)[view viewWithTag:cardViewTag];
        if(card.headImageView.image && [card.people.headimage length])
        {
            [_cacheImageDic setObject:card.headImageView.image forKey:card.people.headimage];
        }
    }
}

-(void)setPersonList:(NSArray *)personList
{
    _personList = personList;
    
    [_reuseViewSet addObjectsFromArray:self.visibleItemViews];
    [self storeCacheImage];
    self.delegate = self;
    self.dataSource = self;
    [self reloadData];
}


- (void)didTap:(UITapGestureRecognizer*)tapGesture
{
    UIView* view = tapGesture.view;
//    if([view isKindOfClass:[V6MoviePeopleCard class]] && self.selectPeopleBlock)
//    {
//        V6MoviePeopleCard* card = (id)view;
//        self.selectPeopleBlock(card.people);
//    }
}

//- (V6MoviePeopleCard*)cardWithIndex:(NSUInteger)index
//{
//    UIView* view = [self itemViewAtIndex:index];
//    V6MoviePeopleCard* card = (id)[view viewWithTag:cardViewTag];
//    return card;
//}

#pragma mark SwipeViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [_personList count] == 0 ? 4 : [_personList count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    PreferPlayer* people = ([_personList count] > index) ? _personList[index] : nil;
    if(!view)
    {
        view = [_reuseViewSet anyObject];
        if(!view)
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,GWTranslateWidthBase4P7ScreenValue(100), GWTranslateWidthBase4P7ScreenValue(105))];
        }
        else
        {
            [_reuseViewSet removeObject:view];
        }
    }
    
    PlayerCard* card = (id)[view viewWithTag:cardViewTag];
    if(!card)
    {
        card = [[PlayerCard alloc] initWithFrame:CGRectMake(0, 0, GWTranslateWidthBase4P7ScreenValue(95), GWTranslateWidthBase4P7ScreenValue(105))];
        card.center = view.center;
        card.tag = cardViewTag;
        [view addSubview:card];
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [card addGestureRecognizer:tapGesture];
    }
    else
    {
        //        if(card.headImageView.image && [card.people.headlogo length])
        //        {
        //            [_cacheImageDic setObject:card.headImageView.image forKey:card.people.headlogo];
        //        }
    }
    
    card.showBorderFrame = self.showBorderFrame;
    card.cacheImage = [_cacheImageDic objectForKey:people.headimage];
    card.people = people;
    
    return view;
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
//    if(_scrollDidLoadCompletion)
//    {
//        _scrollDidLoadCompletion();
//    }
}

- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView
{
//    if(_scrollDidLoadCompletion)
//    {
//        _scrollDidLoadCompletion();
//    }
}
@end
