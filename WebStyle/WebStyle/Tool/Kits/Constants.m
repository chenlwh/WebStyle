//
//  Costants.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "Constants.h"
#import "FTUtils.h"

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
    return RGBCOLOR(238, 238, 238);
}

+(UIColor*) TableViewBackColor
{
//    return [UIColor colorWithHexString:@"f6f6f6"];
    return RGBACOLORFromRGBHex(0xf6f6f6);
}
@end
