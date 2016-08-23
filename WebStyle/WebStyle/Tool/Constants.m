//
//  Costants.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "Constants.h"

@implementation Constants
+(CGFloat) NaviHeight
{
    return 64;
}

+(CGFloat) AppWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+(CGFloat) AppHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+(CGRect) MainBounds
{
    return [UIScreen mainScreen].bounds;
}

+(UIFont*) SDNavItemFont
{
    return [UIFont systemFontOfSize:16];
}

+(UIFont*) SDNavTitleFont
{
    return [UIFont systemFontOfSize:17.0f];
}

+(UIColor*) SDBackgroundColor
{
    return [UIColor whiteColor];
}
@end
