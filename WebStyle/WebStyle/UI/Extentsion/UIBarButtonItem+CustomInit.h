//
//  UIBarButtonItem+CustomInit.h
//  WebStyle
//
//  Created by liudan on 8/23/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomInit)

-(UIBarButtonItem *) initWithImageName:(NSString*)imgName HighlightedImageName:(NSString*)highlImageName Target:(id)target Action:(SEL)sel;
@end
