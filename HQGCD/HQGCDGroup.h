//
//  HQGCDGroup.h
//  AVFoundationDemo
//
//  Created by haoqi on 2018/8/14.
//  Copyright © 2018年 haoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQGCDGroup : NSObject
@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;


#pragma 初始化以及释放

- (instancetype)init;

#pragma 使用方法
- (void)enter;
- (void)leave;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

@end
