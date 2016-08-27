//
//  ChatEmotionSelectView.m
//  Test
//
//  Created by yzx on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SVChatEmotionSelectView.h"
#import "iCarousel.h"
#import "SVChatEmotionItemView.h"
#import "BudleImageCache.h"

#define COLUMN_CAPACITY 7
#define ROW_CAPACITY 3

@interface SVChatEmotionSelectView () <iCarouselDelegate, iCarouselDataSource, SVChatEmotionItemViewDelegate>

@property(nonatomic, retain)iCarousel *carousel;

@end

@implementation SVChatEmotionSelectView

@synthesize delegate;
@synthesize title;
@synthesize isTextEmotion;
@synthesize emotionList;
@synthesize numberOfRows;
@synthesize numberOfColumns;
@dynamic pageSize;
@dynamic pageIndex;

@synthesize carousel;

- (void)dealloc
{
    self.title = nil;
    self.emotionList = nil;
    self.carousel = nil;
    [super dealloc];
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.numberOfColumns = COLUMN_CAPACITY;
    self.numberOfRows = ROW_CAPACITY;
    
    self.carousel = [[[iCarousel alloc] initWithFrame:self.bounds] autorelease];
    [self addSubview:self.carousel];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.decelerationRate = 0.40f;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.carousel.frame = self.bounds;
    [self.carousel reloadData];
}

- (void)setEmotionList:(NSArray *)emotionList_
{
    if(emotionList != emotionList_){
        [emotionList release];
        emotionList = nil;
    }
    emotionList = [emotionList_ retain];
    
    [self.carousel reloadData];
    [self setNeedsLayout];
}

- (void)setNumberOfRows:(NSInteger)numOfRows
{
    numberOfRows = numOfRows;
    [self.carousel reloadData];
}

- (void)setNumberOfColumns:(NSInteger)numOfColumns
{
    numberOfColumns = numOfColumns;
    [self.carousel reloadData];
}

- (NSInteger)pageSize
{
    NSInteger pageSize = self.emotionList.count / (self.numberOfRows * self.numberOfColumns);
    if(self.emotionList.count % (self.numberOfRows * self.numberOfColumns)){
        ++pageSize;
    }
    return pageSize;
}

- (NSInteger)pageIndex
{
    return self.carousel.currentItemIndex;
}

#pragma mark - instance methods
- (void)scrollToFirstPage
{
    [self.carousel scrollToItemAtIndex:0 animated:NO];
}

#pragma mark - events
- (void)onEmotionItemTapped:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(chatEmotionSelectView:didSelectEmotionAtIndex:)]){
        [self.delegate chatEmotionSelectView:self didSelectEmotionAtIndex:btn.tag];
    }
}

- (void)emotionItemGestureRecognized:(UIGestureRecognizer *)gr
{
    UIView *sourceView = gr.view;
    if([self.delegate respondsToSelector:@selector(chatEmotionSelectView:didSelectEmotionAtIndex:)]){
        [self.delegate chatEmotionSelectView:self didSelectEmotionAtIndex:sourceView.tag];
    }
}

#pragma mark - iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self pageSize];
}

- (UIView *)carousel:(iCarousel *)carousel_ viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    SVChatEmotionItemView *chatEmoView = nil;
    if(view){
        chatEmoView = (id)view;
    }else{
        chatEmoView = [[[SVChatEmotionItemView alloc] initWithFrame:carousel_.bounds] autorelease];
        chatEmoView.delegate = self;
        chatEmoView.numberOfRows = self.numberOfRows;
        chatEmoView.numberOfColumns = self.numberOfColumns;
    }
    chatEmoView.frame = carousel_.bounds;
    chatEmoView.tag = index;
    [chatEmoView reloadView];
    return chatEmoView;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel_
{
    if([self.delegate respondsToSelector:@selector(chatEmotionSelectView:didChangeToPageIndex:)]){
        [self.delegate chatEmotionSelectView:self didChangeToPageIndex:self.carousel.currentItemIndex];
    }
}

#pragma mark - ChatEmotionViewDelegate
- (UIView *)chatEmotionItemView:(SVChatEmotionItemView *)chatEmotionView viewAtRow:(NSInteger)row column:(NSInteger)column
{
    NSInteger pageIndex = chatEmotionView.tag;
    NSInteger startIndex = pageIndex * self.numberOfRows * self.numberOfColumns;
    NSInteger targetIndex = startIndex + row * self.numberOfColumns + column;
    if(targetIndex >= self.emotionList.count){
        return nil;
    }
    
    if([self.delegate respondsToSelector:@selector(chatEmotionSelectView:viewWithImageName:)]){
        UIView *view = [self.delegate chatEmotionSelectView:self viewWithImageName:[self.emotionList objectAtIndex:targetIndex]];
        if(view){
            [view addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emotionItemGestureRecognized:)] autorelease]];
            view.tag = targetIndex;
            view.userInteractionEnabled = YES;
            //view.backgroundColor = [UIColor redColor];
            return view;
        }
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = targetIndex;
    [btn addTarget:self action:@selector(onEmotionItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    if(self.isTextEmotion){
        NSString *text = [self.emotionList objectAtIndex:targetIndex];
        [btn setTitle:text forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    }else{
        NSString *image = [self.emotionList objectAtIndex:targetIndex];
        UIImage *img = nil;
        if([self.delegate respondsToSelector:@selector(chatEmotionSelectView:imageForImageName:)]){
            img = [self.delegate chatEmotionSelectView:self imageForImageName:image];
        }else{
            img = [BudleImageCache imageNamed:image];
        }
        [btn setImage:img forState:UIControlStateNormal];
    }
    
    return btn;
}

@end
