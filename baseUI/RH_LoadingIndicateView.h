//
//  RH_LoadingIndicateView.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/28.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLLoadingIndicateView.h"

@interface RH_LoadingIndicateView : CLLoadingIndicateView
//用户无效
- (void)showInfoInInvalidWithTitle:(NSString *)title detailText:(NSString *)detailText;

//显示默认的加载失败状态
- (void)showDefaultLoadingErrorStatus;

//显示返回的加载失败状态
//- (void)showDefaultLoadingErrorStatus:(NSError*)error;

//显示搜索空的状态
- (void)showSearchEmptyStatus;

@end
