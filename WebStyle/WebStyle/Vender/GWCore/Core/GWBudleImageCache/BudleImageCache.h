//
//  BudleImageCache.h
//  GWRDice
//
//  Created by yang xueya on 11/21/11.
//  Copyright (c) 2011 gewara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BudleImageCache : NSObject
{
	NSMutableDictionary *imageCache;
}


+ (BudleImageCache *) sharedCache;
+ (void)imageNamed:(NSString *)imageName
        completion:(void (^)(UIImage*))completion;
+ (UIImage *) imageNamed:(NSString *) imageName;
+ (UIImage *) imageNamed:(NSString *) imageName
           withCapInsets:(UIEdgeInsets)capInsets;


+ (UIImage *) imageNamed:(NSString *) imageName
        withLeftCapWidth:(NSInteger)leftCapWidth
            topCapHeight:(NSInteger)topCapHeight;
- (UIImage*)getLocalImageNamed:(NSString*)name;
+(UIImage*)account_bannerImage;
+(UIImage*)content2Image;
+(UIImage*)content2_preImage;
+(UIImage*)btnConfirmImage;
+(UIImage*)btnConfirmNewImage;
+(UIImage*)inputboxImage;

+(UIImage*)btnOrangeImage;
+(UIImage*)btnGrayImage;
+(UIImage*)btnEnableImage;

+(UIImage*)accessoryViewImage;

+(UIImage*)foldImage;
+(UIImage*)unfoldImage;

+(UIImage*)picShadowImage;

+(UIImage*)divingImage;


+(NSString *)getScaleImageName:(NSString *)name
                         scale:(CGFloat)scale;





@end

