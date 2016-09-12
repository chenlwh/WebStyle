//
//  GWDoubleFadeView.m
//  GWMovie
//
//  Created by Chenyao Cai on 15/3/18.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWDoubleFadeView.h"
#import "UIView+Gewara.h"
//#import "BudleImageCache+GWMovie.h"

@interface GWDoubleFadeView ()

@property (nonatomic,strong) UIImageView *imageViewA;
@property (nonatomic,strong) UIImageView *imageViewB;

@property (nonatomic,assign) NSInteger  currentNumber;
@property (nonatomic,strong) NSTimer *animationTime;
@property (nonatomic,weak) UIImageView *upImage;
@property (nonatomic,weak) UIImageView *downImage;
@end
@implementation GWDoubleFadeView
-(void)dealloc
{
    [self.animationTime invalidate];
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.currentNumber = 0;
        
        _imageViewA = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageViewA setBackgroundColor:[UIColor clearColor]];
        [_imageViewA setImage:[self getImage:self.currentNumber]];
        [self addSubview:_imageViewA];
        self.currentNumber += 1;
        
        _imageViewB = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageViewB setBackgroundColor:[UIColor clearColor]];
        [_imageViewB setImage:[self getImage:self.currentNumber]];
        [self addSubview:_imageViewB];
        
        self.downImage = _imageViewB;
        self.upImage = _imageViewA;
        [self bringSubviewToFront:self.upImage];
        [self fadeAnimation];
        
        self.animationTime = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(fadeAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.animationTime forMode:NSRunLoopCommonModes];
    }
    return self;
}
-(void)layoutSubviews
{
    self.imageViewA.frame = self.bounds;
    self.imageViewB.frame = self.bounds;
}
-(void)fadeAnimation
{
    [self.downImage setAlpha:1.0f];
    [self.upImage setAlpha:1.0f];
    [UIView animateWithDuration:4.0f animations:^{
        [self.upImage setAlpha:0.0f];
    }completion:^(BOOL finish){
        if (finish) {
            self.currentNumber += 1;
            [self checkImageView:self.imageViewA];
            [self checkImageView:self.imageViewB];
        }
    }];
}
-(UIImage*)getImage:(NSInteger)number
{
    NSInteger imageNumber = self.currentNumber % 3;
    NSString *string = [NSString stringWithFormat:@"bk_login%ld",(long)(imageNumber + 1)];
    
    UIImage* image = [UIImage imageNamed:string];
    return image;
}
-(void)checkImageView:(UIImageView*)imageView
{
    if (imageView.alpha == 0.0f) {
        self.downImage = imageView;
        [imageView setImage:[self getImage:self.currentNumber]];
    }
    if (imageView.alpha == 1.0f) {
        self.upImage = imageView;
    }
    [self bringSubviewToFront:self.upImage];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
