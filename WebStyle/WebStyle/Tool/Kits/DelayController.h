

#import <Foundation/Foundation.h>

@class DelayController;

@protocol DelayControllerDelegate <NSObject>

@optional
- (void)delayControllerDidFinishedDelay:(DelayController *)controller;

@end

@interface DelayController : NSObject {
    NSTimeInterval delayTime;

}

@property(nonatomic, weak)NSObject<DelayControllerDelegate> *delegate;
@property(nonatomic, readonly)NSTimeInterval delayTime;

- (id)initWithInterval:(NSTimeInterval)interval;
- (void)cancel;
- (void)start;

@end