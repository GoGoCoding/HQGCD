//
//  HQGCDSemaphore.m
//  AVFoundationDemo
//
//  Created by haoqi on 2018/8/14.
//  Copyright © 2018年 haoqi. All rights reserved.
//

#import "HQGCDSemaphore.h"

@interface HQGCDSemaphore ()
@property (strong, readwrite, nonatomic) dispatch_semaphore_t dispatchSemaphore;
@end

@implementation HQGCDSemaphore
- (instancetype)init {
    self = [super init];
    if (self) {
        self.dispatchSemaphore = dispatch_semaphore_create(0);
    }
    return self;
}


- (instancetype)initWithValue:(long)value {
    self = [super init];
    if (self) {
        self.dispatchSemaphore = dispatch_semaphore_create(value);
    }
    return self;
}


- (BOOL)signal {
    return dispatch_semaphore_signal(self.dispatchSemaphore) != 0;
}


- (void)wait {
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
}


- (BOOL)wait:(int64_t)delta {
    return dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}
@end
