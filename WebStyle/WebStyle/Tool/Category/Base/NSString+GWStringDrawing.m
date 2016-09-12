//
//  NSString+GWStringDrawing.m
//  GWMovie
//
//  Created by sheen on 15/2/2.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "NSString+GWStringDrawing.h"

@implementation NSString (GWStringDrawing)
- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (void)drawAtPoint:(CGPoint)point
           withFont:(UIFont *)font
          withColor:(UIColor*)fontColor
{
    [self drawAtPoint:point
       withAttributes:@{
                        NSFontAttributeName : font,
                        NSForegroundColorAttributeName : fontColor ? fontColor : [UIColor blackColor]
                        }];
}

- (void)drawInRect:(CGRect)rect
    withAttributes:(NSDictionary *)attrs
     lineBreakMode:(NSLineBreakMode)lineBreakMode
         alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionaryWithDictionary:attrs];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [self drawInRect:rect withAttributes:attributes];
}


- (void)drawAtPoint:(CGPoint)point
           forWidth:(CGFloat)width
     withAttributes:(NSDictionary *)attrs
      lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
//    paragraphStyle.alignment = NSTextAlignmentRight;
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionaryWithDictionary:attrs];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    [self drawAtPoint:point withAttributes:attributes];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
//    paragraphStyle.alignment = NSTextAlignmentRight;
    NSDictionary* attributes = @{NSFontAttributeName : font,
                                NSParagraphStyleAttributeName : paragraphStyle};
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    return [self boundingRectWithSize:size
                              options:options
                           attributes:attributes
                              context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    NSDictionary* attributes = @{NSFontAttributeName : font};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    return [self boundingRectWithSize:size
                              options:options
                           attributes:attributes
                              context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    //    paragraphStyle.alignment = NSTextAlignmentRight;
    NSDictionary* attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:options
                           attributes:attributes
                              context:nil].size;
}
@end
