//
//  ChatEmotionSelectView.h
//  Test
//
//  Created by yzx on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVChatEmotionSelectView;

@protocol SVChatEmotionSelectViewDelegate <NSObject>

@optional
- (void)chatEmotionSelectView:(SVChatEmotionSelectView *)chatEmoSelectView didSelectEmotionAtIndex:(NSInteger)index;
- (void)chatEmotionSelectView:(SVChatEmotionSelectView *)chatEmoSelectView didChangeToPageIndex:(NSInteger)pageIndex;
- (UIView *)chatEmotionSelectView:(SVChatEmotionSelectView *)chatEmoSelectView viewWithImageName:(NSString *)imageName;
- (UIImage *)chatEmotionSelectView:(SVChatEmotionSelectView *)chatEmoSelectView imageForImageName:(NSString *)imageName;

@end

@interface SVChatEmotionSelectView : UIView 

@property(nonatomic, assign)id<SVChatEmotionSelectViewDelegate> delegate;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, assign)BOOL isTextEmotion;
@property(nonatomic, retain)NSArray *emotionList;
@property(nonatomic, assign)NSInteger numberOfRows;
@property(nonatomic, assign)NSInteger numberOfColumns;
@property(nonatomic, readonly)NSInteger pageSize;
@property(nonatomic, readonly)NSInteger pageIndex;

- (void)scrollToFirstPage;

@end
