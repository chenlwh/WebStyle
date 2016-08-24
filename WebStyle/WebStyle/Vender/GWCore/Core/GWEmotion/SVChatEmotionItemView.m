//
//  ChatEmotionView.m
//  TheFansBook
//
//  Created by yzx on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SVChatEmotionItemView.h"

@implementation SVChatEmotionItemView

@synthesize delegate;
@synthesize numberOfRows;
@synthesize numberOfColumns;

@synthesize itemWidth;
@synthesize itemHeight;

- (void)dealloc
{
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
    
    self.numberOfColumns = 7;
    self.numberOfRows = 3;
    
    self.itemWidth = frame.size.width / self.numberOfColumns;
    self.itemHeight = frame.size.height / self.numberOfRows;
    
    return self;
}

- (void)reloadView
{
    for(UIView *view in [self subviews]){
        [view removeFromSuperview];
    }
    
    for(NSInteger i = 0; i < self.numberOfRows; ++i){
        for(NSInteger j = 0; j < self.numberOfColumns; ++j){
            if([self.delegate respondsToSelector:@selector(chatEmotionItemView:viewAtRow:column:)]){
                UIView *view = [self.delegate chatEmotionItemView:self viewAtRow:i column:j];
                if(view){
                    [self addSubview:view];
                    view.frame = CGRectMake(j * self.itemWidth, i * self.itemHeight, self.itemWidth, self.itemHeight + 2);
                }
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.itemWidth = frame.size.width / self.numberOfColumns;
    self.itemHeight = frame.size.height / self.numberOfRows;
    [self reloadView];
}

- (void)setNumberOfColumns:(NSInteger)i
{
    numberOfColumns = i;
    
    self.itemWidth = self.frame.size.width / self.numberOfColumns;
    [self reloadView];
}

- (void)setNumberOfRows:(NSInteger)i
{
    numberOfRows = i;
    
    self.itemHeight = self.frame.size.height / self.numberOfRows;
    [self reloadView];
}

@end
