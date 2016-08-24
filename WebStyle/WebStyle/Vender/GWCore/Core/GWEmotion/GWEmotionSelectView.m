//
//  GWEmotionSelectView.m
//  GewaraCore
//
//  Created by yangzexin on 13-4-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "GWEmotionSelectView.h"
#import "GWEmotionManager.h"
#import "SVEmotionView.h"
#import "SVChatEmotion.h"
#import "BudleImageCache.h"

@interface GWEmotionSelectView () <SVEmotionViewDelegate>

@property(nonatomic, retain)SVEmotionView *emotionView;

@end

@implementation GWEmotionSelectView

- (void)dealloc
{
    self.deleteBlock = nil;
    self.selectBlock = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    SVEmotionView *emotionView = [[SVEmotionView new] autorelease];
    emotionView.delegate = self;
    NSArray *emotions = [[GWEmotionManager defaultManager] allEmotions];
    NSMutableArray *tmpEmotions = [NSMutableArray array];
    
    NSInteger totalPageCount = GWEMOTIONVIEWCOLUMN*GWEMOTIONVIEWROW;
    
    for(SVChatEmotion *emo in emotions){
        NSInteger offset = tmpEmotions.count % totalPageCount;
        if(offset != 0 && offset % (totalPageCount-1) == 0){
            SVChatEmotion *deleteEmo = [[SVChatEmotion new] autorelease];
            deleteEmo.imageName = @"__delete__";
            deleteEmo.code = @"__delete__";
            [tmpEmotions addObject:deleteEmo];
        }else{
            [tmpEmotions addObject:emo];
        }
    }
    NSInteger lastPageEmotionCount = tmpEmotions.count % totalPageCount;
    if(tmpEmotions.count % totalPageCount != 0){
        for(NSInteger i = lastPageEmotionCount; i < totalPageCount-1; ++i){
            SVChatEmotion *blankEmo = [[SVChatEmotion new] autorelease];
            blankEmo.imageName = @"";
            blankEmo.code = @"";
            [tmpEmotions addObject:blankEmo];
        }
        SVChatEmotion *deleteEmo = [[SVChatEmotion new] autorelease];
        deleteEmo.imageName = @"__delete__";
        deleteEmo.code = @"__delete__";
        [tmpEmotions addObject:deleteEmo];
    }
    [emotionView setKeyCategoryValueEmotions:[NSDictionary dictionaryWithObject:tmpEmotions forKey:@"Normal"]];
    [emotionView setCategories:[NSArray arrayWithObject:@"Normal"]];
    self.emotionView = emotionView;
    [self addSubview:emotionView];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.emotionView.frame = self.bounds;
}

#pragma mark - SVEmotionViewDelegate
- (UIView *)emotionView:(SVEmotionView *)emoView viewWithImageName:(NSString *)imageName category:(NSString *)category
{
    if([imageName isEqualToString:@"__delete__"]){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[BudleImageCache imageNamed:@"wala_delete.png"] forState:UIControlStateNormal];
        return button;
    }
    UIImageView *imgView = [[UIImageView new] autorelease];
    imgView.contentMode = UIViewContentModeCenter;
    imgView.image = [[GWEmotionManager defaultManager] cachedEmotionImageWithImageName:imageName];
    return imgView;
}

- (void)emotionView:(SVEmotionView *)emoView didSelectEmotion:(SVChatEmotion *)chatEmo
{
    if([chatEmo.code isEqualToString:@"__delete__"]){
        if(self.deleteBlock){
            self.deleteBlock();
        }
    }else{
        if(self.selectBlock){
            self.selectBlock(chatEmo.code);
        }
    }
}

@end
