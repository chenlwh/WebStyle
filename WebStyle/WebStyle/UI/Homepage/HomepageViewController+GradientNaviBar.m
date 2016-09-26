//
//  HomepageViewController+GradientNaviBar.m
//  WebStyle
//
//  Created by 刘丹 on 16/8/30.
//  Copyright © 2016年 liudan. All rights reserved.
//

#import "HomepageViewController+GradientNaviBar.h"

@implementation HomepageViewController (GradientNaviBar)

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if(!([self appRootViewController] == self))
//    {
//        return;
//    }
    // offset 0 ~ 125
    CGFloat fHeightDenominator = [self headView].height - kNaviHeight - 20 - 25;
    CGFloat fHeightNumerator = scrollView.contentOffset.y;
    
    CGFloat fVal = fHeightNumerator * (1- fThreshold) / fHeightDenominator + fThreshold;
    if(fVal > 1)
    {
        fVal = 1;
//        [self.customNaviView setNaviBarAlpha:1];;
    }
    else if (fVal < fThreshold)
    {
        fVal = fThreshold;
//        [self.customNaviView setNaviBarAlpha:fThreshold];
    }
    
    if(fVal == fThreshold)
    {
        [self setGradientColorBarLight:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    }
    else
    {
        [self setGradientColorBarLight:RGBACOLOR(0xeb, 0x61, 0x1f, fVal)];
    }
    
    [self.customNaviView setNaviBarAlpha:fVal];
    
    
//    D_Log(@"scrollView %f fHeight %f", scrollView.contentOffset.y, fHeightDenominator);
}
@end
