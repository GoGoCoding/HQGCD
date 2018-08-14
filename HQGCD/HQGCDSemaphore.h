//
//  HQGCDSemaphore.h
//  AVFoundationDemo
//
//  Created by haoqi on 2018/8/14.
//  Copyright © 2018年 haoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQGCDSemaphore : NSObject
@property (strong, readonly, nonatomic) dispatch_semaphore_t dispatchSemaphore;

#pragma 初始化以及释放
- (instancetype)init;
- (instancetype)initWithValue:(long)value;


#pragma 使用方法
- (BOOL)signal;
- (void)wait;
- (BOOL)wait:(int64_t)delta;


@end
