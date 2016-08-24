//
//  PageIndicator.m
//  Quartz2d_Learning
//
//  Created by yangzexin on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SVPageIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define NORMAL_COLOR    [UIColor lightGrayColor]
#define HIGHLIGHT_COLOR [UIColor blackColor]

@interface SVPageIndicator ()

@property(nonatomic, retain)NSMutableArray *buttonList;

@end

@implementation SVPageIndicator

@synthesize currentPageIndex;
@synthesize numberOfPages;
@synthesize spacing;
@synthesize indicatorSize;

@synthesize normalBackgroundColor;
@synthesize highlightBackgroundColor;

@dynamic realWidth;

@synthesize buttonList;

- (void)dealloc
{
    self.normalBackgroundColor = nil;
    self.highlightBackgroundColor = nil;
    
    self.buttonList = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.currentPageIndex = 0;
    self.spacing = 5.0f;
    self.indicatorSize = 8.0f;
    self.normalBackgroundColor = NORMAL_COLOR;
    self.highlightBackgroundColor = HIGHLIGHT_COLOR;
    
    return self;
}

- (id)initWithNumberOfPages:(NSInteger)numOfPages
{
    self = [self init];
    
    self.numberOfPages = numOfPages;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat btnWidth = self.indicatorSize;
    CGFloat btnHeight = self.indicatorSize;
    for(NSInteger i = 0; i < self.buttonList.count; ++i){
        UIButton *btn = [self.buttonList objectAtIndex:i];
        btn.frame = CGRectMake((btnWidth + self.spacing) * i, 0, btnWidth, btnHeight);
        btn.layer.cornerRadius = btnWidth / 2;
        btn.backgroundColor = i == self.currentPageIndex ? self.highlightBackgroundColor : self.normalBackgroundColor;
    }
}

- (void)setNumberOfPages:(NSInteger)numOfPages
{
    numberOfPages = numOfPages;
    if(self.buttonList){
        for(UIView *view in self.buttonList){
            [view removeFromSuperview];
        }
        self.buttonList = nil;
    }
    self.buttonList = [NSMutableArray array];
    for(NSInteger i = 0; i < self.numberOfPages; ++i){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [self.buttonList addObject:btn];
    }
    [self setNeedsLayout];
}

- (void)setSpacing:(CGFloat)fSpacing
{
    spacing = fSpacing;
    [self setNeedsLayout];
}

- (void)setCurrentPageIndex:(NSInteger)pageIndex
{
    currentPageIndex = pageIndex;
    [self setNeedsLayout];
}

- (void)setIndicatorSize:(CGFloat)size
{
    indicatorSize = size;
    [self setNeedsLayout];
}

- (void)setNormalBackgroundColor:(UIColor *)color
{
    if(normalBackgroundColor != color){
        [normalBackgroundColor release];
        normalBackgroundColor = nil;
    }
    normalBackgroundColor = [color retain];
    [self setNeedsLayout];
}

- (void)setHighlightBackgroundColor:(UIColor *)color
{
    if(highlightBackgroundColor != color){
        [highlightBackgroundColor release];
        highlightBackgroundColor = nil;
    }
    highlightBackgroundColor = [color retain];
    [self setNeedsLayout];
}

- (CGFloat)realWidth
{
    return self.indicatorSize * self.numberOfPages + self.spacing * (self.numberOfPages - 1);
}

@end
