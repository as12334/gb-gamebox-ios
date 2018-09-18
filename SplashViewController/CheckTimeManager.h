//
//  CheckTimeManager.h
//  gameBoxEx
//
//  Created by jun on 2018/8/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckTimeManager : NSObject
@property (nonatomic, assign) int times; //重试次数
@property (nonatomic, assign) BOOL lotteryLineCheckFail; //是否彻底检测失败

+ (instancetype)shared;

- (void)cacheLotteryHosts:(NSArray *)cacheHosts;
- (NSArray *)cacheHosts;
- (void)clearCaches;

@end
