//
//  RH_PageCellProtocol.h
//  TaskTracking
//
//  Created by jinguihua on 2017/6/8.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLPageLoadContentPageCell.h"
#import "RH_LoadingIndicateView.h"
#import "RH_ServiceRequest.h"


@protocol RH_PageCellProtocol < RH_ServiceRequestDelegate,CLLoadingIndicateViewDelegate >

//网络服务请求
@property(nonatomic,strong,readonly) RH_ServiceRequest * serviceRequest;

//加载指示视图
@property(nonatomic,strong,readonly) RH_LoadingIndicateView * loadingIndicateView;

//配置内容加载视图，初始化是会调用该方法，默认不做任何事
- (void)configureContentLoadingIndicateView:(RH_LoadingIndicateView *)loadingIndicateView;

//返回存储在内存中数据的上下文，默认为nil
- (id)contextForDataSaveInMemoryWithKey:(NSString *)key;

@end

