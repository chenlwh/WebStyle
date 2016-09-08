//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

+ (UIImage*)imageFromURL:(NSString*)urlString;

- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)scale:(CGFloat)percent;
- (UIImage*)fitToSize:(CGSize)size;
- (UIImage*)cropToRect:(CGRect)rect;

- (UIImage*)flipHorizontal;
- (UIImage*)rotateToOrientation:(UIImageOrientation)orient;
- (UIImage*)rotateImage:(UIImage*)img byOrientationFlag:(UIImageOrientation)orient;
- (UIImage*)withFixedOrientation;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize ;


/*裁切*/
- (UIImage *)cropImageWithRect:(CGRect)rect;

//裁切需要的UIView
+ (UIImage *)cropImageWithView:(UIView *)currentView ;

//全屏截图
+(UIImage *)fullScreenshots;

//生成模糊图片
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

//翻转
- (UIImage *)rotateWithOrientation:(UIImageOrientation)imageOrientation;
@end
