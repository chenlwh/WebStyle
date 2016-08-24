//
//  GWEmotionManager.m
//  GewaraCore
//
//  Created by yangzexin on 13-4-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "GWEmotionManager.h"

#import "SFImageLabel.h"
#import "NSString+JavaLikeStringHandle.h"

#define kLeftMatching   @"["
#define kRightMatching  @"]"

#define EMRELEASEOBJ(o)  {if(o){[o release]; o = nil;}}


/**
 *  default manager 的参数
 */
static GWEmotionManager *instance = nil;
static NSString     *s_emotionSourceBundleName = @"emotions";
static NSString     *s_emotionPlistName = @"emotions";
static NSString     *s_emotionImageFolderName = @"images";



@interface GWEmotionManager ()

@property(nonatomic, retain)NSArray *emotions;


@property(nonatomic, copy)NSString *emotionSourceBundleName;
@property(nonatomic, copy)NSString *emotionPlistName;
@property(nonatomic, copy)NSString *emotionImageFolderName;



@end






@implementation GWEmotionManager

+ (id)defaultManager
{
    @synchronized(self.class){
        if(instance == nil){
            instance = [self.class new];
            instance.emotionSourceBundleName = s_emotionSourceBundleName;
            instance.emotionPlistName = s_emotionPlistName;
            instance.emotionImageFolderName = s_emotionImageFolderName;
            [instance prepareImageCache];
        }
    }
    return instance;
}


- (id)initWithBundleName:(NSString*)bundleName
               plistName:(NSString*)plistName
         imageFolderName:(NSString*)imageFolderName
{
    self = [super init];
    
    self.emotionSourceBundleName = s_emotionSourceBundleName;
    self.emotionPlistName = s_emotionPlistName;
    self.emotionImageFolderName = s_emotionImageFolderName;
    [self prepareImageCache];

    return self;
}

- (void)dealloc
{
    EMRELEASEOBJ(_emotionCodeSetsArray);
    EMRELEASEOBJ(_emotionsDictionary);
    EMRELEASEOBJ(_emotionsCodeImagePathDictionary);
    
    EMRELEASEOBJ(_emotionSourceBundleName);
    EMRELEASEOBJ(_emotionPlistName);
    EMRELEASEOBJ(_emotionImageFolderName);
    
    [super dealloc];
}

- (NSArray *)allEmotions
{
    if (self.emotions.count == 0) {
        [self prepareImageCache];
    }
    return self.emotions;
}

#pragma mark - 一些方法
- (NSBundle*)emotionBundle
{
    NSBundle *emotionBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle]
                                                        pathForResource:self.emotionSourceBundleName
                                                        ofType:@"bundle"]];
    return emotionBundle;
}

- (NSString*)emotionPlistPath
{
    NSString *filePath = [self.emotionBundle pathForResource:self.emotionPlistName
                                                      ofType:@"plist"];
    return filePath;
}
- (NSString*)emotionImageFolderPath
{
    NSString *imageFolderPath = [self.emotionBundle pathForResource:self.emotionImageFolderName
                                                             ofType:nil];
    return imageFolderPath;
}

#pragma mark - 获取图片

- (NSData *)imageDataWithEmotionImageName:(NSString *)imageName
{
    NSString *imageFolderPath = [self emotionImageFolderPath];
    return [NSData dataWithContentsOfFile:[imageFolderPath stringByAppendingPathComponent:imageName]];
}

- (UIImage *)emotionImageWithEmotionCode:(NSString *)code
{
//    NSString *imageFilePath = [self.emotionsCodeImagePathDictionary valueForKey:code];;
//    UIImage *img = [UIImage imageWithContentsOfFile:imageFilePath];
//    return img;
    return [self.emotionsCodeImageDictionary valueForKey:code];
}
- (UIImage *)emotionImageWithEmotionImageName:(NSString *)imageName
{
    NSString *imageFolderPath = [self emotionImageFolderPath];
    NSString *imageFilePath = [imageFolderPath stringByAppendingPathComponent:imageName];
    
    UIImage *img = [UIImage imageWithContentsOfFile:imageFilePath];
    
    return img;
}

- (UIImage *)cachedEmotionImageWithImageName:(NSString *)imageName
{
    return [self emotionImageWithEmotionImageName:imageName];
}

#pragma mark 初始化函数
- (void)prepareImageCache
{
    if (self.emotions.count == 0) {
        NSMutableArray *codeSetsArray = [NSMutableArray array];
        NSMutableArray *tmpEmotions = [NSMutableArray array];
        NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *codeImagePathDict = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *codeImageDic = [NSMutableDictionary dictionary];
        
        //        NSBundle *emotionBundle = [self emotionBundle];
        NSString *filePath = [self emotionPlistPath];
        NSString *imageFolderPath = [self emotionImageFolderPath];
        
        NSArray *emotionDictionaryArray = [NSArray arrayWithContentsOfFile:filePath];
        
        
        for(NSDictionary *tmpEmotionDictionary in emotionDictionaryArray){
            //创建 SVChatEmotion 对象
            SVChatEmotion *tmpEmo = [[SVChatEmotion new] autorelease];
            tmpEmo.code = [tmpEmotionDictionary objectForKey:@"code"];
            tmpEmo.imageName= [tmpEmotionDictionary objectForKey:@"image"];
            
            //
            [tmpEmotions addObject:tmpEmo];
            
            //
            [codeSetsArray addObject:[[tmpEmo.code copy] autorelease]];
            
            //
            [codeDict setValue:tmpEmo forKey:tmpEmo.code];
            
            //
            NSString *imageFilePath = [imageFolderPath stringByAppendingPathComponent:tmpEmo.imageName];
            [codeImagePathDict setValue:imageFilePath forKey:tmpEmo.code];
            UIImage *tmpImage = [UIImage imageWithContentsOfFile:imageFilePath];
            [codeImageDic setValue:tmpImage forKey:tmpEmo.code];
            
        }
        self.emotions = tmpEmotions;
        
        _emotionCodeSetsArray = [codeSetsArray retain];
        _emotionsDictionary = [codeDict retain];
        _emotionsCodeImagePathDictionary = [codeImagePathDict retain];
        _emotionsCodeImageDictionary = [codeImageDic retain];
        
    }
    
}




#pragma mark - UI 相关
- (SFImageLabel *)newEmotionLabel
{
    SFImageLabel *labelContent = [[SFImageLabel new] autorelease];
    labelContent.imageLeftMatchingText = kLeftMatching;
    labelContent.imageRightMatchingText = kRightMatching;
    [labelContent setViewGetter:^UIView *(NSString *imageName) {
        return [self viewForEmotionCode:imageName];
    }];
    labelContent.font = [UIFont systemFontOfSize:14.0f];
    
    return labelContent;
}

- (UIView *)viewForEmotionCode:(NSString *)code
{
    code = [NSString stringWithFormat:@"[%@]", code];
    NSString *imageName = nil;
    for(SVChatEmotion *tmpEmo in self.emotions){
        if([tmpEmo.code isEqualToString:code]){
            imageName = tmpEmo.imageName;
            break;
        }
    }
    UIImageView *imgView = [[[UIImageView alloc] initWithImage:[self cachedEmotionImageWithImageName:imageName]] autorelease];
    
    imgView.frame = CGRectMake(0, 0, 15, 15);
    
    return imgView;
}

- (NSURL *)URLForImageData:(NSData *)imageData imageName:(NSString *)imageName
{
    NSString *tempPath = [NSString stringWithFormat:@"%@/tmp/", NSHomeDirectory()];
    NSString *imagePath = [tempPath stringByAppendingPathComponent:imageName];
    [imageData writeToFile:imagePath atomically:NO];
    return [NSURL fileURLWithPath:imagePath];
}

//- (NSString *)generateEmotionableHTMLString:(NSString *)string
//{
//    NSMutableString *replacedString = [NSMutableString string];
//    NSInteger beginIndex = 0;
//    NSInteger endIndex = 0;
//    while((beginIndex = [string find:kLeftMatching fromIndex:endIndex]) != -1){
//        [replacedString appendString:[string substringWithBeginIndex:endIndex endIndex:beginIndex]];
//        endIndex = [string find:kRightMatching fromIndex:beginIndex];
//        NSString *code = [string substringWithBeginIndex:beginIndex + 1 endIndex:endIndex];
//        NSData *imageData = [self emotionDataWithCode:code];
//        if(imageData){
////            UIImage *image = [UIImage imageWithData:imageData scale:1.0f];
//            NSString *imgHTML = [NSString stringWithFormat:@"<img src=\"%@\" width=\"%.0f\" height=\"%.0f\" align=\"top\" />",
//                                 [[self URLForImageData:imageData imageName:code] absoluteString],
//                                 15.0f,
//                                 15.0f];
//            [replacedString appendString:imgHTML];
//        }else{
//            [replacedString appendString:[string substringWithBeginIndex:beginIndex endIndex:endIndex + 1]];
//        }
//        ++endIndex;
//    }
//    if(endIndex != string.length){
//        [replacedString appendString:[string substringWithBeginIndex:endIndex endIndex:string.length]];
//    }
//    return replacedString;
//}


+ (void)deleteLastEmotionFromTextView:(UITextView *)textView
{
    NSString *text = textView.text;
    if(text.length != 0){
        NSInteger leftEdgeIndex = -1;
        NSString *lastChar = [text substringWithBeginIndex:textView.selectedRange.location - 1 endIndex:textView.selectedRange.location];
        if([lastChar isEqualToString:@"]"]){
            leftEdgeIndex = [text find:@"[" fromIndex:text.length - 1 reverse:YES];
            if(leftEdgeIndex != -1){
                ++leftEdgeIndex;
                //                NSString *innerText = [text substringWithBeginIndex:leftEdgeIndex endIndex:text.length - 1];
                //                NSInteger intInnerText = [innerText integerValue];
                //
                //                if(intInnerText == 0){
                //                    leftEdgeIndex = -1;
                //                }
            }
        }
        if([UIDevice currentDevice].systemVersion.floatValue < 5.0f){
            
            if(leftEdgeIndex != -1){
                textView.text = [textView.text substringToIndex:leftEdgeIndex - 1];
            }else{
                textView.text = [textView.text substringToIndex:textView.text.length - 1];
            }
        }else{
            if(leftEdgeIndex != -1){
                NSInteger numOfBackwards = text.length - leftEdgeIndex + 1;
                NSInteger i = 0;
                while(i++ < numOfBackwards){
                    [textView deleteBackward];
                }
            }else{
                [textView deleteBackward];
            }
        }
    }
    if([textView.delegate respondsToSelector:@selector(textViewDidChange:)]){
        [textView.delegate textViewDidChange:textView];
    }
}

- (oneway void)release
{
    
}

- (id)autorelease
{
    return self;
}

@end
