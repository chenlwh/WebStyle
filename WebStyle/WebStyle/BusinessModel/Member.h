//
//  Member.h
//  WebStyle
//
//  Created by liudan on 9/8/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property (nonatomic, copy) NSString* memberid;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* sex;
@property (nonatomic, copy) NSString* headpic;
@property (nonatomic, retain)NSString *birthday;
@end
