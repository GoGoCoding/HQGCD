//
//  HQGCD.m
//  AVFoundationDemo
//
//  Created by haoqi on 2018/8/14.
//  Copyright © 2018年 haoqi. All rights reserved.
//

#import "HQGCDQueue.h"
#import "HQGCDGroup.h"

static HQGCDQueue *mainQueue;

static HQGCDQueue *globalQueue;

static HQGCDQueue *highPriorityGlobalQueue;

static HQGCDQueue *lowPriorityGlobalQueue;

static HQGCDQueue *backgroundPriorityGlobalQueue;

@interface HQGCDQueue()

@property (strong, readwrite, nonatomic) dispatch_queue_t dispatchQueue;

@end

@implementation HQGCDQueue

#pragma mark ----------类方法----------
+ (HQGCDQueue *)mainQueue {
    return mainQueue;
}


+ (HQGCDQueue *)globalQueue {
    return globalQueue;
}


+ (HQGCDQueue *)highPriorityGlobalQueue {
    return highPriorityGlobalQueue;
}


+ (HQGCDQueue *)lowPriorityGlobalQueue {
    return lowPriorityGlobalQueue;
}


+ (HQGCDQueue *)backgroundPriorityGlobalQueue {
    return backgroundPriorityGlobalQueue;
}


+ (void)initialize {
    
    /**
     Initializes the class before it receives its first message.
     
     1. The runtime sends the initialize message to classes in a
     
     thread-safe manner.
     
     2. initialize is invoked only once per class. If you want to
     
     perform independent initialization for the class and for
     
     categories of the class, you should implement load methods.
     
     */
    
    if (self == [HQGCDQueue self])  {
        
        mainQueue = [HQGCDQueue new];
        mainQueue.dispatchQueue = dispatch_get_main_queue();
        
        globalQueue = [HQGCDQueue new];
        globalQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        highPriorityGlobalQueue = [HQGCDQueue new];
        highPriorityGlobalQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        
        lowPriorityGlobalQueue = [HQGCDQueue new];
        lowPriorityGlobalQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

        backgroundPriorityGlobalQueue = [HQGCDQueue new];
        backgroundPriorityGlobalQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
}



#pragma mark - 便利的构造方法
//MainQueue
+ (void)executeInMainQueue:(dispatch_block_t)block {
    if (!block) {
        return;
    }
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    if (!block) {
        return;
    }
    
    [[HQGCDQueue mainQueue] execute:^{
        block();
    } afterDelay:NSEC_PER_SEC * sec];
}


//GlobalQueue
+ (void)executeInGlobalQueue:(dispatch_block_t)block {
    if (!block) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}


+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    if (!block) {
        return;
    }
    
    [[HQGCDQueue globalQueue] execute:^{
        block();
    } afterDelay:NSEC_PER_SEC * sec];
}



//highPriorityGlobalQueue
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block {
    if (!block) {
        return;
    }
    
    [[HQGCDQueue highPriorityGlobalQueue] execute:^{
        block();
    }];
}


+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    if (!block) {
        return;
    }
    
    [[HQGCDQueue highPriorityGlobalQueue] execute:^{
        block();
    } afterDelay:NSEC_PER_SEC * sec];
    
}


//lowPriorityGlobalQueue
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    if (!block) {
        return;
    }
    
    [[HQGCDQueue lowPriorityGlobalQueue] execute:^{
        block();
    } afterDelay:NSEC_PER_SEC * sec];
    
}


+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block {
    if (!block) {
        return;
    }
    
    [[HQGCDQueue lowPriorityGlobalQueue] execute:^{
        block();
    }];
}


//backgroundPriorityGlobalQueue
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block {
    if (!block) {
        return;
    }
    
    [[HQGCDQueue backgroundPriorityGlobalQueue] execute:^{
        block();
    }];
}


+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    if (!block) {
        return;
    }
    
    [[HQGCDQueue backgroundPriorityGlobalQueue] execute:^{
        block();
    } afterDelay:NSEC_PER_SEC * sec];
}


+(void)applyInGlobalQueue:(void (^)(size_t))block{
    if (!block) {
        return;
    }
    
    [[HQGCDQueue globalQueue] apply:^(size_t index) {
        block(index);
    }];
}



//dispatchGroup
- (void)execute:(dispatch_block_t)block inGroup:(HQGCDGroup *)group {
    dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block);
}


- (void)notify:(dispatch_block_t)block inGroup:(HQGCDGroup *)group {
    dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block);
}

#pragma mark ----------实例方法----------
- (instancetype)init {
    return [self initSerial];
}


- (instancetype)initSerial {
    self = [super init];
    if (self){
        self.dispatchQueue = dispatch_queue_create("serial_queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


- (instancetype)initConcurrent {
    self = [super init];
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create("concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


- (void)execute:(dispatch_block_t)block {
    dispatch_async(self.dispatchQueue, block);
}


- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta {
    // NSEC_PER_SEC
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), self.dispatchQueue, block);
}


- (void)waitExecute:(dispatch_block_t)block {
    
    /*
     As an optimization, this function invokes the block on
     the current thread when possible.
     
     作为一个建议,这种方法尽量在当前线程池中调用.
     */
    
    dispatch_sync(self.dispatchQueue, block);
}


-(void)apply:(void (^)(size_t index))block{
    dispatch_apply(5, self.dispatchQueue, ^(size_t i) {
        block(i);
    });
}


/**
 The queue you specify should be a concurrent queue that you
 create yourself using the dispatch_queue_create function.
 
 If the queue you pass to this function is a serial queue or
 one of the global concurrent queues, this function behaves
 like the dispatch_async function.
 使用的线程池应该是你自己创建的并发线程池.假设你传进来的參数为串行线程池
 或者是系统的并发线程池中的某一个,这种方法就会被当做一个普通的async操作

 @param block 需要执行代码的block
 */
- (void)barrierExecute:(dispatch_block_t)block {
    dispatch_barrier_async(self.dispatchQueue, block);
}


/**
 The queue you specify should be a concurrent queue that you
 create yourself using the dispatch_queue_create function.
 If the queue you pass to this function is a serial queue or
 one of the global concurrent queues, this function behaves
 like the dispatch_sync function.
 
 使用的线程池应该是你自己创建的并发线程池.假设你传进来的參数为串行线程池
 或者是系统的并发线程池中的某一个,这种方法就会被当做一个普通的sync操作
 
 As an optimization, this function invokes the barrier block
 on the current thread when possible.

 作为一个建议,这种方法尽量在当前线程池中调用.

 @param block 需要执行代码的block
 */

- (void)waitBarrierExecute:(dispatch_block_t)block {
    dispatch_barrier_sync(self.dispatchQueue, block);
}


- (void)suspend {
    dispatch_suspend(self.dispatchQueue);
}


- (void)resume {
    dispatch_resume(self.dispatchQueue);
}

@end
