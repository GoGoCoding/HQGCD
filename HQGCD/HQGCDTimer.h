//
//  HQGCDTimer.h
//  AVFoundationDemo
//
//  Created by haoqi on 2018/8/14.
//  Copyright © 2018年 haoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HQGCDQueue;

@interface HQGCDTimer : NSObject

@property (strong, readonly, nonatomic) dispatch_source_t dispatchSource;

#pragma 初始化以及释放
- (instancetype)init;  //global_queue
- (instancetype)initInQueue:(HQGCDQueue *)queue; //自定义queue

#pragma 使用方法
- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval;
- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval afterDelay:(double)delay repeat:(BOOL)repeat;
- (void)start;
- (void)cancel;

@end
