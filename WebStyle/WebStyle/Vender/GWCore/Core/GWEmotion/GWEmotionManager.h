//
//  GWEmotionManager.h
//  GewaraCore
//
//  Created by yangzexin on 13-4-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVChatEmotion.h"
#import <UIKit/UIKit.h>


#define kLeftMatching   @"["
#define kRightMatching  @"]"

@class SFImageLabel;

@interface GWEmotionManager : NSObject

/**
 *  这个用于检索字符串里表情用
 */
@property(nonatomic, readonly, retain)NSArray *emotionCodeSetsArray;//表情代码[01]等,这个是顺序的，

/**
 *  这个为了表情键盘用
 */
@property(nonatomic, readonly, retain)NSArray *allEmotions;//成员对象是SVChatEmotion

/**
 *  这个快速查找用
 */
@property(nonatomic, readonly, retain)NSDictionary *emotionsDictionary;//key 是code object是SVChatEmotion


@property(nonatomic, readonly, retain)NSDictionary *emotionsCodeImagePathDictionary;//key 是code object是imagePath

@property(nonatomic, readonly, retain)NSDictionary *emotionsCodeImageDictionary;

+ (id)defaultManager;

/**
 *  表情管理器
 *
 *  @param bundleName      表情bundle
 *  @param plistName       表情对应表
 *  @param imageFolderName 表情图片文件夹
 *
 *  @return GWEmotionManager
 */
- (id)initWithBundleName:(NSString*)bundleName
               plistName:(NSString*)plistName
         imageFolderName:(NSString*)imageFolderName;

- (NSBundle*)emotionBundle;
- (NSString*)emotionPlistPath;
- (NSString*)emotionImageFolderPath;


- (NSData *)imageDataWithEmotionImageName:(NSString *)imageName;
- (UIImage *)emotionImageWithEmotionCode:(NSString *)code;


//这个暂时还有效，建议用 emotionImageWithEmotionImageName
- (UIImage *)cachedEmotionImageWithImageName:(NSString *)imageName;
@end


/**
 *  关于UI的，明天拉出来
 */
@interface GWEmotionManager (UIRelated)

- (UIView *)viewForEmotionCode:(NSString *)code;
- (SFImageLabel *)newEmotionLabel;
//- (NSString *)generateEmotionableHTMLString:(NSString *)string;
+ (void)deleteLastEmotionFromTextView:(UITextView *)textView;

@end

