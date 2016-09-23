//
//  GWProtocolInterceptor.h
//  GWMovie
//
//  Created by wushengtao on 15/3/17.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  协议拦截转发器，规则：当receiver和middleMan实现了协议里的方法，则方法被调用，同时实现了则同时被调用
 */
@interface GWProtocolInterceptor : NSObject
@property (nonatomic, readonly, copy) NSArray* interceptedProtocols;
@property (nonatomic, weak) id receiver;   //原delegate
@property (nonatomic, weak) id middleMan;  //拦截delegate

- (instancetype)initWithInterceptedProtocol:(Protocol *)interceptedProtocol;
- (instancetype)initWithInterceptedProtocols:(Protocol *)firstInterceptedProtocol, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithArrayOfInterceptedProtocols:(NSArray *)arrayOfInterceptedProtocols;
@end
