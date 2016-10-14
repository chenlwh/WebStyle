//
//  WSDebugManager.m
//  WebStyle
//
//  Created by liudan on 10/13/16.
//  Copyright © 2016 liudan. All rights reserved.
//

#import "WSDebugManager.h"
#import <mach/mach.h>
#import "WSDebugThumbnailView.h"
#import "GWProviderManager.h"
#import "GWDebugDBManager.h"
#import "YYWeakProxy.h"
#import "SDWebImageManager.h"
#import "GWDebugRootViewController.h"
#import "UIView+Gewara.h"

#define kProviderArrayKey @"providerArray"
long memory_usage()
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo,
                                         &infoCount);
    if(kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1048576;
}

float cpu_usage()
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS)
    {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS)
    {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS)
        {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE))
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}


static WSDebugManager* debugmanager = nil;
@interface WSDebugManager()
{
    CGPoint _startTouch;
    NSTimer* _timer;
    NSUInteger _count;
    NSTimeInterval _lastTime;
}
@property (nonatomic, strong) WSDebugThumbnailView *thumbnailView;
@property (nonatomic,strong) CADisplayLink         *displayLink;
@property (nonatomic,assign) CGFloat             averageFPS;
@end
@implementation WSDebugManager
+ (WSDebugManager*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!debugmanager)
            debugmanager = [[WSDebugManager alloc] init];
    });
    
    return debugmanager;
}

- (void)dealloc
{
    [[GWProviderManager instance] removeObserver:self forKeyPath:kProviderArrayKey];
}

- (id)init
{
    if(self = [super init])
    {
        [[GWProviderManager instance] addObserver:self
                                       forKeyPath:kProviderArrayKey
                                          options:NSKeyValueObservingOptionNew
                                          context:nil];
        
        _debugSettingInfo = [GWDebugSettingInfo createDebugSettingInfoIfEmpty];
        [[GWDebugDBManager shareDBManager] openDBAndCreateTable];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(fpsUpdate:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    
    return self;
}

- (void)fpsUpdate:(CADisplayLink *)displayLink{
    
    
    if (_lastTime == 0) {
        _lastTime = displayLink.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = displayLink.timestamp - _lastTime;
    
    if (delta < 1.0000) return;
    
    _lastTime = displayLink.timestamp;
    float fps = _count / delta;
    self.averageFPS = fps;
    _count = 0;
    
}


- (void)resetNotification
{
    NSArray     *imageOperations    = [[SDWebImageManager sharedManager] valueForKey:@"runningOperations"];  //缓存＋下载
    NSArray     *downloadOperations = ((NSOperationQueue*)[[SDWebImageDownloader sharedDownloader] valueForKey:@"downloadQueue"]).operations;
    NSString    *thumbString = [NSString stringWithFormat:@" req:%ld\n img:%ld/%ld",
                                (long)[[[GWProviderManager instance] allProviders] count],
                                (long)[imageOperations count], (long)[downloadOperations count]];
    
    
    
    if(_debugSettingInfo.debugMainBarMinimize)
    {
        _thumbnailView.tipsLabel.text = thumbString;
    }
    else
    {
        NSString* tips = [NSString stringWithFormat:@"%@\n cpu:%.2f%%\n mem:%ldM \nfps:%d",
                          thumbString,
                          cpu_usage(),
                          memory_usage(),
                          (int)round(self.averageFPS)];
        _thumbnailView.tipsLabel.text = tips;
    }
    
    UINavigationController* naviController = (id)_notificationWindow.rootViewController;
    GWDebugRootViewController* rootController = (id)[naviController.viewControllers firstObject];
    rootController.imageOperations = imageOperations;
    [rootController reloadDisplay];
}

- (void)displayDebugView
{
    if(!_notificationWindow)
    {
        _notificationWindow = [[WSDebugWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _notificationWindow.backgroundColor = [UIColor clearColor];
        _notificationWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _notificationWindow.windowLevel = UIWindowLevelStatusBar;
        [_notificationWindow makeKeyAndVisible];
    }
    
    if(!_thumbnailView)
    {
        _thumbnailView = [[WSDebugThumbnailView alloc] initWithFrame:CGRectZero];
        _thumbnailView.clipsToBounds = YES;
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paningGestureReceive:)];
        pan.delegate = self;
        [_thumbnailView addGestureRecognizer:pan];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapingGestureReceive:)];
        //        tap.delegate = self;
        [_thumbnailView addGestureRecognizer:tap];
        
        [pan requireGestureRecognizerToFail:tap];
        
        [self mainBarSizeChangedIfNeed];
    }
    [_thumbnailView sizeToFit];
    _thumbnailView.left = _notificationWindow.width - _thumbnailView.width * 2;
    _thumbnailView.top = _thumbnailView.height;
    [_notificationWindow addSubview:_thumbnailView];
    
    [self startTimer];
    
}

- (void)startTimer
{
    [self stopTimer];
    _timer = [NSTimer timerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(resetNotification)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)displayFullDebugController:(BOOL)show
{
    if(show)
    {
        GWDebugRootViewController* controller = [[GWDebugRootViewController alloc] init];
        _notificationWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.view.clipsToBounds = YES;
    }
    else
    {
        _notificationWindow.rootViewController = nil;
    }
}


#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if([kProviderArrayKey isEqualToString:keyPath])
    {
        [self resetNotification];
    }
}

#pragma mark GestureRecognizer
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint touchPoint = [recoginzer locationInView:_thumbnailView];
    if (recoginzer.state == UIGestureRecognizerStateBegan)
    {
        _startTouch = touchPoint;
    }
    else if (recoginzer.state == UIGestureRecognizerStateEnded)
    {
    }
    else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
    }
    else if(UIGestureRecognizerStateChanged == recoginzer.state)
    {
        _thumbnailView.left = _thumbnailView.left + (touchPoint.x - _startTouch.x);
        _thumbnailView.top = _thumbnailView.top + (touchPoint.y - _startTouch.y);
    }
}

- (void)tapingGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    [self displayFullDebugController:YES];
}

#pragma mark view changed

- (void)mainBarSizeChangedIfNeed
{
    CGRect thumbnailRect = _thumbnailView.frame;
    if(!_debugSettingInfo.debugMainBarMinimize)
    {
        thumbnailRect.size = CGSizeMake(80, 80);
    }
    else
    {
        thumbnailRect.size = CGSizeMake(50, 70);
    }
    
    _thumbnailView.frame = thumbnailRect;
}

@end
