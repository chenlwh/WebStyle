//
//  GWEmotionSelectView.h
//  GewaraCore
//
//  Created by yangzexin on 13-4-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GWEmotionSelectView : UIView

@property(nonatomic, copy)void(^deleteBlock)();
@property(nonatomic, copy)void(^selectBlock)(NSString *selectedEmo);

@end
