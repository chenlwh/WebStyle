
#import "DelayController.h"


@implementation DelayController

@synthesize delayTime;
@synthesize delegate = _delegate;

- (id)initWithInterval:(NSTimeInterval)interval
{
    self = [super init];
    
    delayTime = interval;
    
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    
    
}

- (void)notifyFinished
{
    if(_delegate && [_delegate respondsToSelector:@selector(delayControllerDidFinishedDelay:)]){
        [_delegate delayControllerDidFinishedDelay:self];
    }
}

- (void)run
{
    @autoreleasepool {
        [NSThread sleepForTimeInterval:delayTime];
        [self performSelectorOnMainThread:@selector(notifyFinished) withObject:nil waitUntilDone:YES];
    }
}

- (void)start
{
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

- (void)cancel
{
    _delegate = nil;
}

@end