//
//  UpdateStatusCacheManager.h
//  gameBoxEx
//
//  Created by shin on 2018/6/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GBSkipUpdateShow)(void);

@interface UpdateStatusCacheManager : NSObject

+ (instancetype)sharedManager;

//缓存的提示更新状态是否还有效
// YES 有效 则不提示
// NO 失效 则提示
- (BOOL)isUpdateStatusValid;

//更新提示更新状态
//YES 已经提示过
//NO 需要提示
- (void)refreshUpdateStatus:(BOOL)status;

//展示提示更新的提示框
- (void)showUpdateAlert:(GBSkipUpdateShow)skip;

@end
