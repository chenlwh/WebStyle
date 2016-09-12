//
//  NSString+GWStringDrawing.h
//  GWMovie
//
//  Created by sheen on 15/2/2.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (GWStringDrawing)

- (CGSize)sizeWithFont:(UIFont *)font;

- (void)drawAtPoint:(CGPoint)point
           withFont:(UIFont *)font
          withColor:(UIColor*)fontColor;

- (void)drawInRect:(CGRect)rect
    withAttributes:(NSDictionary *)attrs
     lineBreakMode:(NSLineBreakMode)lineBreakMode
         alignment:(NSTextAlignment)alignment;

- (void)drawAtPoint:(CGPoint)point
           forWidth:(CGFloat)width
     withAttributes:(NSDictionary *)attrs
      lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
