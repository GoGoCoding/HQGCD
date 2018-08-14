//
//  HQGCDTimer.m
//  AVFoundationDemo
//
//  Created by haoqi on 2018/8/14.
//  Copyright © 2018年 haoqi. All rights reserved.
//

#import "HQGCDTimer.h"
#import "HQGCDQueue.h"

@interface HQGCDTimer ()
@property (strong, readwrite, nonatomic) dispatch_source_t dispatchSource;
@end

@implementation HQGCDTimer
- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    return self;
}


- (instancetype)initInQueue:(HQGCDQueue *)queue{
    
    self = [super init];
    if (self) {
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue.dispatchQueue);
    }
    return self;
}


- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval {
    
    [self event:^{
        block();
    } timeInterval:interval afterDelay:0.0f repeat:YES];
}


-(void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval afterDelay:(double)delay repeat:(BOOL)repeat{
    
    dispatch_source_set_timer(self.dispatchSource,
                              dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC),
                              interval,
                              0);
    
    __weak typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(self.dispatchSource, ^{
        __strong typeof(weakSelf)self = weakSelf;
        block();
        if (!repeat) {
            [self cancel];
        }
    });
}

- (void)start {
    dispatch_resume(self.dispatchSource);
}


- (void)cancel {
    dispatch_source_cancel(self.dispatchSource);
}

@end
