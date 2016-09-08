//
//  GWMessageView.m
//  GWV2
//
//  Created by yangxueya on 10/14/13.
//
//

#import "GWMessageView.h"
#import "FTUtils.h"
//#import "BudleImageCache.h"
//#import "GWMovieTheme.h"
//#import "Masonry.h"
#import "UIView+Gewara.h"

#define  GWINWIDTH  [[UIScreen mainScreen] bounds].size.width
#define  GWINHEIGHT [[UIScreen mainScreen] bounds].size.height


@interface GWMessageView()
@property (nonatomic, assign) BOOL removeFromSuperViewOnHide;
@property (nonatomic, strong) UIView *messageview;
@property (nonatomic, strong) UIImage *logoImage;
@end

@implementation GWMessageView

- (void)dealloc{
    self.text = nil;
    self.messageview = nil;
    self.logoImage = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.messageview = [[UIView alloc] init];
        [self setBackgroundColor:RGBACOLORFromRGBHex(0xf0efef)];
        [_messageview setBackgroundColor:[UIColor clearColor]];
        
        [_messageview setFrame:self.bounds];//CGRectMake(0.0f,0.0f,GWINWIDTH,GWINHEIGHT)];
        [_messageview setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self addSubview:_messageview];
        
        self.logoImage = [UIImage imageNamed:@"icon_noactivity"];
        self.logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _logoImage.size.width, _logoImage.size.height)];
        [_logoImgView setImage:_logoImage];
        [_messageview addSubview:_logoImgView];
        
        self.msLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GWINWIDTH, 30)] ;
        _msLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _msLabel.backgroundColor = [UIColor clearColor];
        _msLabel.numberOfLines = 2;
        _msLabel.textAlignment = NSTextAlignmentCenter;
        _msLabel.textColor = RGBACOLORFromRGBHex(0x5f5f5f);
        
        [self.messageview addSubview:_msLabel];
        
        
        self.retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryButton.frame = self.bounds;
        [_messageview addSubview:_retryButton];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _retryButton.hidden = YES;
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    return self;
}

- (void)retryButtonClick:(id)sender
{
    if(self.retryBlock)
    {
        self.retryBlock();
    }
    
    if (self.removeFromSuperViewOnRetryButtonClicked) {
        [self removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateMessageFrameByViewFrame:self.bounds];
}

-(void)updateMessageFrameByViewFrame:(CGRect)frame
{
    UIImage* image = self.logoImage;
    CGFloat top = frame.size.height / 2 - image.size.height;
    [_logoImgView setHidden:(top < 0)];
    if(top < 0)
    {
        _msLabel.centerY = frame.size.height / 2;
    }
    else
    {
        _logoImgView.bottom = frame.size.height / 2;
        _msLabel.top = _logoImgView.bottom + 15;
    }
    
    _logoImgView.centerX = _msLabel.centerX = frame.size.width / 2;
}

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    _logoImgView.image = logoImage;
    [_logoImgView sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setText:(NSString *)aText
{
    _msLabel.text = aText;
    _msLabel.width = self.width;
    [_msLabel sizeToFit];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - class method
+ (GWMessageView *)showMSGAddedTo:(UIView *)view animated:(BOOL)animated {
	GWMessageView *msgView = [[GWMessageView alloc] init] ;
	[view addSubview:msgView];
	[msgView show:animated];
	return msgView;
}

+ (GWMessageView *)showMSGAddedTo:(UIView *)view text:(NSString*)text animated:(BOOL)animated{
    GWMessageView *msgView = [[GWMessageView alloc] initWithFrame:view.bounds];
    msgView.text =text;
	[view addSubview:msgView];
	[msgView show:animated];
	return msgView;
}
+ (GWMessageView *)showMSGAddedTo:(UIView *)view
                             text:(NSString*)text
                          xOffset:(float)xoffset
                          yOffset:(float)yoffset
                         animated:(BOOL)animated{
    
    GWMessageView *msgView = [[GWMessageView alloc] initWithFrame:view.bounds];
    msgView.text = text;
    msgView.left += xoffset;
    msgView.top += yoffset;
    [view addSubview:msgView];
	[msgView show:animated];
	return msgView;
}


+ (void)hideMSGForView:(UIView *)view animated:(BOOL)animated {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[GWMessageView class]]) {
            GWMessageView *msgView  = (id)subView;
            msgView.removeFromSuperViewOnHide = YES;
            [msgView hide:YES];
        }
    }
}

+ (GWMessageView *)show404MSGAddedTo:(UIView *)view
                            animated:(BOOL)animated
{
    GWMessageView *msgView = [[GWMessageView alloc] initWithFrame:view.bounds];
    msgView.retryButton.hidden = NO;
    //msgView.top = -100;
    msgView.text = @"没有网了，看不了了\n点击刷新再试试看";
    msgView.logoImage = [UIImage imageNamed:@"icon_404"];
    [view addSubview:msgView];
    [msgView show:animated];
    return msgView;
}

+ (GWMessageView *)showEmptyMsgAddedTo:(UIView *)view
                              withText:(NSString*)emptyText
                              animated:(BOOL)animated
{
    GWMessageView *msgView = [[GWMessageView alloc] initWithFrame:view.bounds];
    msgView.retryButton.hidden = NO;
    msgView.text = [emptyText length] ? emptyText : @"最近很空，没有内容";
    msgView.logoImage = [UIImage imageNamed:@"icon_noactivity"];
    [view addSubview:msgView];
    [msgView show:animated];
    return msgView;
}

+ (GWMessageView *)showNoConnectMsgAddedTo:(UIView *)view
                              withText:(NSString*)emptyText
                                  animated:(BOOL)animated
{
    GWMessageView *msgView = [[GWMessageView alloc] initWithFrame:view.bounds];
    msgView.retryButton.hidden = NO;
    msgView.text = [emptyText length] ? emptyText : @"没有网了，看不了了\n点击刷新再试试看";
    msgView.logoImage = [UIImage imageNamed:@"icon_404"];
    [view addSubview:msgView];
    [msgView show:animated];
    return msgView;
}

+ (GWMessageView *)showErrorMsgAddedTo:(UIView *)view
                         withErrorText:(NSString*)errorText
                              animated:(BOOL)animated
                            retryBlock:(void (^)())aRetryBlock
{
    GWMessageView *msgView = [[GWMessageView alloc] initWithFrame:view.bounds];
    msgView.removeFromSuperViewOnRetryButtonClicked = YES;
    NSString *msgText = errorText;
    if (aRetryBlock) {
//        msgText = [msgText stringByAppendingString:@"\n点击刷新再试试看"];
        msgText = @"点击刷新再试试看";
        msgView.retryBlock = aRetryBlock;
        msgView.retryButton.hidden = NO;
    }else{
        msgView.retryButton.hidden = YES;
    }
    
    
    msgView.text = msgText;
    msgView.logoImage = [UIImage imageNamed:@"icon_404"];
    [view addSubview:msgView];
    [msgView show:animated];
    return msgView;
}


#pragma mark - function
- (void)show:(BOOL)animated
{
    self.alpha = 0.0f;
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
    }
    
    self.alpha = 1.0f;
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)hide:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
    }
    
    self.alpha = 0.0f;
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.40];
}



@end
