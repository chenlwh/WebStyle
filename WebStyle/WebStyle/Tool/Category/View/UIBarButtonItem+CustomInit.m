//
//  UIBarButtonItem+CustomInit.m
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "UIBarButtonItem+CustomInit.h"

@implementation UIBarButtonItem (CustomInit)

-(UIBarButtonItem *) initWithImageName:(NSString*)imgName HighlightedImageName:(NSString*)highlImageName Target:(id)target Action:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlImageName] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 50, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return [self initWithCustomView:button];
}
@end
