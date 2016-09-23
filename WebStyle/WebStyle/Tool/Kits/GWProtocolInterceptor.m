//
//  GWProtocolInterceptor.m
//  GWMovie
//
//  Created by wushengtao on 15/3/17.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import <objc/runtime.h>
#import "GWProtocolInterceptor.h"

static inline BOOL selector_belongsToProtocol(SEL selector, Protocol * protocol);

@implementation GWProtocolInterceptor
- (id)forwardingTargetForSelector:(SEL)selector
{
//    D_Log(@"%@, forwardingTargetForSelector: %@", self, NSStringFromSelector(selector));
    BOOL middleManFlag = ([_middleMan respondsToSelector:selector]
                          && [self isSelectorContainedInInterceptedProtocols:selector]);
    BOOL receiverFlag = [_receiver respondsToSelector:selector];
    
    if(receiverFlag && middleManFlag)
        return nil;
    
    if(middleManFlag)
        return _middleMan;
    
    if(receiverFlag)
        return _receiver;
    
    return [super forwardingTargetForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)selector
{
    if([_middleMan respondsToSelector:selector]
       && [self isSelectorContainedInInterceptedProtocols:selector])
        return YES;
    
    if([_receiver respondsToSelector:selector])
        return YES;
    
    return [super respondsToSelector:selector];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
//    D_Log(@"%@, methodSignatureForSelector: %@", self, NSStringFromSelector(selector));
    NSMethodSignature *sig;
    sig = [_middleMan methodSignatureForSelector:selector];
    if (sig)
        return sig;
    sig = [_receiver methodSignatureForSelector:selector];
    return sig;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if([_middleMan respondsToSelector:[invocation selector]])
        [invocation invokeWithTarget:_receiver];
    if([_receiver respondsToSelector:[invocation selector]])
        [invocation invokeWithTarget:_middleMan];
}


- (instancetype)initWithInterceptedProtocol:(Protocol*)interceptedProtocol
{
    if (self = [super init])
    {
        _interceptedProtocols = @[interceptedProtocol];
    }
    return self;
}

- (instancetype)initWithInterceptedProtocols:(Protocol*)firstInterceptedProtocol, ...;
{
    if (self = [super init])
    {
        NSMutableArray * mutableProtocols = [NSMutableArray array];
        Protocol * eachInterceptedProtocol;
        va_list argumentList;
        if (firstInterceptedProtocol)
        {
            [mutableProtocols addObject:firstInterceptedProtocol];
            va_start(argumentList, firstInterceptedProtocol);
            while ((eachInterceptedProtocol = va_arg(argumentList, id))) {
                [mutableProtocols addObject:eachInterceptedProtocol];
            }
            va_end(argumentList);
        }
        _interceptedProtocols = [mutableProtocols copy];
    }
    return self;
}

- (instancetype)initWithArrayOfInterceptedProtocols:(NSArray *)arrayOfInterceptedProtocols
{
    if (self = [super init])
    {
        _interceptedProtocols = [arrayOfInterceptedProtocols copy];
    }
    return self;
}

- (void)dealloc
{
    _interceptedProtocols = nil;
}

- (BOOL)isSelectorContainedInInterceptedProtocols:(SEL)selector
{
    __block BOOL isSelectorContainedInInterceptedProtocols = NO;
    [self.interceptedProtocols enumerateObjectsUsingBlock:^(Protocol * protocol, NSUInteger idx, BOOL *stop) {
        isSelectorContainedInInterceptedProtocols = selector_belongsToProtocol(selector, protocol);
        *stop = isSelectorContainedInInterceptedProtocols;
    }];
    return isSelectorContainedInInterceptedProtocols;
}

@end

BOOL selector_belongsToProtocol(SEL selector, Protocol * protocol)
{
    for (int optionbits = 0; optionbits < (1 << 2); optionbits++)
    {
        BOOL required = optionbits & 1;
        BOOL instance = !(optionbits & (1 << 1));
        
        struct objc_method_description hasMethod = protocol_getMethodDescription(protocol, selector, required, instance);
        if (hasMethod.name || hasMethod.types)
        {
            return YES;
        }
    }
    
    return NO;
}
