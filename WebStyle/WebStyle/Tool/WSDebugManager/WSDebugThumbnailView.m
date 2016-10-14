//
//  WSDebugThumbnailView.m
//  WebStyle
//
//  Created by liudan on 10/14/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "WSDebugThumbnailView.h"

@implementation WSDebugThumbnailView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor blueColor];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_tipsLabel];
        
        _tipsLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}
@end
