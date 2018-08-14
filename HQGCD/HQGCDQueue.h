//
//  HQGCD.h
//  AVFoundationDemo
//
//  Created by haoqi on 2018/8/14.
//  Copyright © 2018年 haoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HQGCDGroup;

@interface HQGCDQueue : NSObject
@property (strong, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (HQGCDQueue *)mainQueue;
+ (HQGCDQueue *)globalQueue;
+ (HQGCDQueue *)highPriorityGlobalQueue;
+ (HQGCDQueue *)lowPriorityGlobalQueue;
+ (HQGCDQueue *)backgroundPriorityGlobalQueue;

#pragma 初始化以及释放
- (instancetype)init;
- (instancetype)initSerial;
- (instancetype)initConcurrent;


#pragma 使用方法
- (void)execute:(dispatch_block_t)block;
- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta;

- (void)waitExecute:(dispatch_block_t)block;

- (void)apply:(__attribute__((__noescape__)) void (^)(size_t index))block;

- (void)barrierExecute:(dispatch_block_t)block;
- (void)waitBarrierExecute:(dispatch_block_t)block;

- (void)suspend;
- (void)resume;


#pragma 与GCDGroup相关
- (void)execute:(dispatch_block_t)block inGroup:(HQGCDGroup *)group;
- (void)notify:(dispatch_block_t)block inGroup:(HQGCDGroup *)group;


#pragma 便利的构造方法

+ (void)executeInMainQueue:(dispatch_block_t)block;
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

+ (void)executeInGlobalQueue:(dispatch_block_t)block;
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

+ (void)applyInGlobalQueue:(__attribute__((__noescape__)) void (^)(size_t))block;


@end
