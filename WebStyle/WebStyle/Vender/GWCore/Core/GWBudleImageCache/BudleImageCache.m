//
//  BudleImageCache.m
//  GWRDice
//
//  Created by yang xueya on 11/21/11.
//  Copyright (c) 2011 gewara. All rights reserved.
//

#import "BudleImageCache.h"


@interface BudleImageCache ()
@property (nonatomic, strong) dispatch_queue_t loadQueue;
@end

@implementation BudleImageCache

static BudleImageCache *globalInstance;

+ (BudleImageCache *) sharedCache
{
    if (!globalInstance)
    {
        @synchronized(self)
        {
            globalInstance = [[BudleImageCache alloc] init];
        }
    }
    
    return globalInstance;
}

+ (void)imageNamed:(NSString *)imageName
        completion:(void (^)(UIImage*))completion
{
    [[BudleImageCache sharedCache] imageNamed:imageName
                                   completion:completion];
}

+ (UIImage*)imageNamed:(NSString *)imageName
{
    return [[BudleImageCache sharedCache] getImageNamed:imageName];
}

+ (UIImage*)imageNamed:(NSString *) imageName
          withCapInsets:(UIEdgeInsets)capInsets
{
    UIImage *image = [self imageNamed:imageName];
    return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage*)imageNamed:(NSString *)imageName
        withLeftCapWidth:(NSInteger)leftCapWidth
            topCapHeight:(NSInteger)topCapHeight
{
    UIImage *image = [self imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

- (void)imageNamed:(NSString *)imageName
        completion:(void (^)(UIImage*))completion
{
    void (^loadCompletion)(UIImage*)  = [completion copy];
    dispatch_async(_loadQueue, ^{
        UIImage* image = [BudleImageCache imageNamed:imageName];
        dispatch_async(dispatch_get_main_queue(), ^{
            loadCompletion(image);
        });
    });
}

- (UIImage*)getImageNamed:(NSString *)name
{
    return [self getLocalImageNamed:name];
}

- (UIImage*)getLocalImageNamed:(NSString*)name
{
    UIImage *result = [imageCache objectForKey:name];
    
    if (!result) {
        
        CGFloat scale = [[UIScreen mainScreen] scale];
        NSString* filePath = [[NSBundle mainBundle] pathForResource:[[self class] getScaleImageName:name scale:scale] ofType:nil];
        result = [UIImage imageWithContentsOfFile:filePath];
        
        if (!result) {
            //** 如果没有找到当前倍数图，使用2倍图
            filePath = [[NSBundle mainBundle] pathForResource:[[self class] getScaleImageName:name scale:2] ofType:nil];
            result = [UIImage imageWithContentsOfFile:filePath];
        }
        if (result) {
            [imageCache setObject:result forKey:name];
        }
    }
    
    return result;
}

+ (NSString *)getScaleImageName:(NSString *)name
                         scale:(CGFloat)scale
{
    NSString *addString = [NSString stringWithFormat:@"@%.fx.", scale];
    if ([name rangeOfString:addString].location != NSNotFound) {
        return name;
    }
    
    NSArray * imageNames=[name componentsSeparatedByString:@"."];
    NSString * typeName=@"";
    if (imageNames.count==2) {
        typeName=imageNames[1];
    }
    else
    {
        typeName=@"png";
    }
    NSString * newName=@"";
    
    if (scale==1) {
        newName=[NSString stringWithFormat:@"%@.%@",imageNames[0],typeName];
    }
    else
    {
        newName=[NSString stringWithFormat:@"%@@%.fx.%@",imageNames[0],scale,typeName];
    }
    return newName;
}


- (void)clearCache
{
    [imageCache removeAllObjects];
}


- (id)init
{
    if ((self = [super init]))
    {
        const char *identifier = [[[NSBundle mainBundle] bundleIdentifier] UTF8String];

        _loadQueue = dispatch_queue_create(identifier, NULL);
        
        imageCache = [NSMutableDictionary new];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:Nil];
    }
    
    return self;
}


- (void)dealloc
{
    [imageCache release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_release(_loadQueue);
    
    [super dealloc];
}

+ (UIImage*)account_bannerImage
{
    UIImage *image = [BudleImageCache imageNamed:@"account_banner.png"];
    
    return [image stretchableImageWithLeftCapWidth:13 topCapHeight:0];
}

+ (UIImage*)content2Image
{
    return [BudleImageCache imageNamed:@"content2.png" withLeftCapWidth:10 topCapHeight:12];
}

+ (UIImage*)content2_preImage
{
    return [BudleImageCache imageNamed:@"content2_pre.png" withLeftCapWidth:10 topCapHeight:12];
}

+ (UIImage*)btnConfirmImage
{
    UIImage *image = [BudleImageCache imageNamed:@"btn_confirm.png"];
    
    return [image stretchableImageWithLeftCapWidth:10 topCapHeight:25];
}

+ (UIImage*)btnConfirmNewImage
{
    UIImage *image = [BudleImageCache imageNamed:@"btn_orange_new.png"];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2.0 topCapHeight:0];
}

+ (UIImage*)inputboxImage
{
    UIImage *inputBox = [BudleImageCache imageNamed:@"inputbox.png"]; 
    return [inputBox stretchableImageWithLeftCapWidth:7 topCapHeight:17];

}

+ (UIImage*)btnOrangeImage
{
    return [BudleImageCache imageNamed:@"btn_orange.png" withLeftCapWidth:6 topCapHeight:14];
}

+ (UIImage*)btnGrayImage
{
    return [BudleImageCache imageNamed:@"btn_grey_big.png" withLeftCapWidth:11 topCapHeight:19];
}

+ (UIImage*)btnEnableImage
{
    return [BudleImageCache imageNamed:@"btnEnable.png" withLeftCapWidth:29 topCapHeight:13];
}

+  (UIImage*)accessoryViewImage
{
    return [BudleImageCache imageNamed:@"rightarrow.png"];
}

+ (UIImage*)foldImage
{
    UIImage *btnImage = [BudleImageCache imageNamed:@"icon_activityfold.png"];
    return btnImage;
}
+ (UIImage*)unfoldImage
{
    UIImage *btnExImage = [BudleImageCache imageNamed:@"icon_activityunfold.png"];
    return btnExImage;
}

+ (UIImage*)picShadowImage
{
    return [BudleImageCache imageNamed:@"picshadow.png" withLeftCapWidth:4 topCapHeight:4];
}


+ (UIImage*)divingImage
{
    return [BudleImageCache imageNamed:@"diving.png"];
}

@end

