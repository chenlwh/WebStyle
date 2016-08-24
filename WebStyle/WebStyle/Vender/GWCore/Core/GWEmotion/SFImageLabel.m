//
//  MsgLabel.m
//  Quartz2d_Learning
//
//  Created by yangzexin on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SFImageLabel.h"
#import "BudleImageCache.h"

NSString *kImageLabelDefaultImageLeftMatchingText = @"{IMG";
NSString *kImageLabelDefaultImageRightMatchingText = @"}";

@interface SVDrawBlock : NSObject

@property(nonatomic, assign)CGFloat x;
@property(nonatomic, assign)CGFloat y;
@property(nonatomic, retain)NSString *text;

@end

@implementation SVDrawBlock

- (void)dealloc
{
    self.text = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%f, %f, %@", self.x, self.y, self.text];
}

@end

@interface SFImageLabel ()

@property(nonatomic, assign)CGFloat realHeight;
@property(nonatomic, retain)NSMutableArray *addInSubviews;
@property(nonatomic, retain)NSMutableArray *textBlocks;

@end

@implementation SFImageLabel

- (void)dealloc
{
    self.text = nil;
    self.font = nil;
    self.textColor = nil;
    self.viewGetter = nil;
    self.imageGetter = nil;
    self.addInSubviews = nil;
    self.textBlocks = nil;
    [super dealloc];
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (void)initialize
{
    self.imageLeftMatchingText = kImageLabelDefaultImageLeftMatchingText;
    self.imageRightMatchingText = kImageLabelDefaultImageRightMatchingText;
    
    self.font = [UIFont systemFontOfSize:13.0f];
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
    
    self.addInSubviews = [NSMutableArray array];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    [self initialize];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self initialize];
    
    return self;
}

- (UIView *)viewForImageName:(NSString *)imageName
{
    if(self.viewGetter){
        UIView *view = self.viewGetter(imageName);
        return view;
    }
    return nil;
}

- (void)drawRect:(CGRect)rect
{
    for(UIView *view in self.addInSubviews){
        [view removeFromSuperview];
    }
    [self drawTextWithRect:rect fakeDraw:NO];
}

- (void)drawTextWithRect:(CGRect)rect fakeDraw:(BOOL)fakeDraw
{
    NSString *text = self.text;
    if(!self.text){
        self.realHeight = [self.font lineHeight];
        return;
    }
    
    if(!fakeDraw){
        self.textBlocks = [NSMutableArray array];
    }else{
        self.textBlocks = nil;
    }
    
    NSMutableArray *textBlock = [NSMutableArray array];
    CGFloat blockPositionX = 0.0f;
    CGFloat blockPositionY = 0.0f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(!fakeDraw){
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillRect(context, rect);
        CGContextSetFillColorWithColor(context, self.textColor.CGColor);
    }
    
    NSString *imageLeftMatching = self.imageLeftMatchingText;
    NSString *firstCh = [imageLeftMatching substringToIndex:1];
    NSString *imageRightMatching = self.imageRightMatchingText;
    CGFloat tmpX = 0.0f;
    CGFloat tmpY = 0.0f;
    CGFloat tmpLineHeight = self.font.lineHeight;
    for(NSInteger i = 0; i < text.length;){
        NSRange charRange = [text rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *ch = [text substringWithRange:charRange];
        if([ch isEqualToString:firstCh]){
            if(i + imageLeftMatching.length < text.length){
                NSString *pp = [text substringWithRange:NSMakeRange(i, imageLeftMatching.length)];
                if([pp isEqualToString:imageLeftMatching]){
                    NSRange tmpRange = [text rangeOfString:imageRightMatching options:NSCaseInsensitiveSearch range:NSMakeRange(i, text.length - i)];
                    if(tmpRange.location != NSNotFound){
                        NSString *imageName = [text substringWithRange:NSMakeRange(i + imageLeftMatching.length, tmpRange.location - i - imageLeftMatching.length)];
                        
                        UIView *view = [self viewForImageName:imageName];
                        if(view){
                            if(!fakeDraw){
                                [self.addInSubviews addObject:view];
                            }
                            CGRect tmpRect = view.frame;
                            if(tmpX + tmpRect.size.width >= rect.size.width){
                                tmpY += tmpLineHeight;
                                tmpX = 0;
                            }
                            tmpRect.origin.x = tmpX;
                            tmpRect.origin.y = tmpY;
                            view.frame = tmpRect;
                            if(!fakeDraw){
                                [self addSubview:view];
                                [self closeTextBlock:textBlock positionX:blockPositionX positionY:blockPositionY];
                            }
                            
                            tmpX += tmpRect.size.width;
                            blockPositionX = tmpX;
                            blockPositionY = tmpY;
                            tmpLineHeight = tmpRect.size.height > tmpLineHeight ? tmpRect.size.height : tmpLineHeight;
                            
                            i = tmpRange.location + 1;
                            continue;
                        }else{
                            UIImage *img = nil;
                            if(self.imageGetter){
                                img = self.imageGetter(imageName);
                            }else{
                                img = [BudleImageCache imageNamed:imageName];
                            }
                            if(img){
                                if(tmpX + img.size.width >= rect.size.width){
                                    tmpY += tmpLineHeight;
                                    tmpX = 0;
                                }
                                if(!fakeDraw){
                                    [img drawAtPoint:CGPointMake(tmpX, tmpY)];
                                    [self closeTextBlock:textBlock positionX:blockPositionX positionY:blockPositionY];
                                    blockPositionX = tmpX;
                                }
                                tmpX += img.size.width;
                                blockPositionX = tmpX;
                                blockPositionY = tmpY;
                                tmpLineHeight = img.size.height > tmpLineHeight ? img.size.height : tmpLineHeight;
                                
                                i = tmpRange.location + 1;
                                continue;
                            }
                        }
                    }
                }
            }
        }
        CGFloat strWidth = [ch sizeWithFont:self.font].width;
        if(tmpX + strWidth >= rect.size.width){
            [self closeTextBlock:textBlock positionX:blockPositionX positionY:blockPositionY];
            tmpX = 0;
            tmpY += tmpLineHeight;
            blockPositionX = tmpX;
            blockPositionY = tmpY;
            tmpLineHeight = self.font.lineHeight;
        }
        if(!fakeDraw){
            //            [ch drawAtPoint:CGPointMake(tmpX, tmpY) withFont:self.font];
            [self appendCharToTextBlock:textBlock ch:ch];
        }
        tmpX += strWidth;
        
        i = charRange.location + charRange.length;
    }
    [self closeTextBlock:textBlock positionX:blockPositionX positionY:tmpY];
    
    if(!fakeDraw){
        for(SVDrawBlock *block in self.textBlocks){
            NSString *text = block.text;
            [text drawAtPoint:CGPointMake(block.x, block.y) withFont:self.font];
        }
    }
    
    self.realHeight = tmpY + tmpLineHeight;
}

- (void)appendCharToTextBlock:(NSMutableArray *)textBlock ch:(NSString *)ch
{
    [textBlock addObject:ch];
}

- (SVDrawBlock *)closeTextBlock:(NSMutableArray *)textBlock positionX:(CGFloat)positionX positionY:(CGFloat)positionY
{
    NSMutableString *string = [NSMutableString string];
    for(NSString *ch in textBlock){
        [string appendString:ch];
    }
    [textBlock removeAllObjects];
    if(string.length != 0){
        return [self encounterBlockWithPositionX:positionX poisitionY:positionY text:string];
    }
    return nil;
}

- (SVDrawBlock *)encounterBlockWithPositionX:(CGFloat)positionX poisitionY:(CGFloat)positionY text:(NSString *)text
{
    SVDrawBlock *block = [[SVDrawBlock new] autorelease];
    block.x = positionX;
    block.y = positionY;
    block.text = text;
    
    [self.textBlocks addObject:block];
    return block;
}

- (void)setText:(NSString *)m
{
    if(_text != m){
        [_text release];
        _text = [m copy];
    }
    [self setNeedsDisplay];
}

- (void)resizeToSuitableHeight
{
    [self drawTextWithRect:self.bounds fakeDraw:YES];
    CGRect rect = self.frame;
    rect.size.height = self.realHeight;
    self.frame = rect;
}

@end
