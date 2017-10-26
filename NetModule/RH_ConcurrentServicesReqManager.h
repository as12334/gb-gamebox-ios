//
//  RH_ConcurrentServicesReqManager.h
//  CoreLib
//
//  Created by jinguihua on 2016/12/1.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RH_ServiceRequest.h"

@class RH_ConcurrentServicesReqManager ;

@protocol RH_ConcurrentServicesReqManagerDelegate <NSObject>

@optional

//返回处理后的数据
- (void)concurrentServicesManager:(RH_ConcurrentServicesReqManager *)concurrentServicesManager
                   serviceRequest:(RH_ServiceRequest *)serviceRequest
                              key:(NSString *)key
                      serviceType:(ServiceRequestType)type
        didSuccessRequestWithData:(id)data;

- (void)concurrentServicesManager:(RH_ConcurrentServicesReqManager *)concurrentServicesManager
                   serviceRequest:(RH_ServiceRequest *)serviceRequest
                              key:(NSString *)key
                      serviceType:(ServiceRequestType)type
          didFailRequestWithError:(NSError *)error;

//完成所有请求的回调
- (void)concurrentServicesManager:(RH_ConcurrentServicesReqManager *)concurrentServicesManager didCompletedAllServiceWithDatas:(NSDictionary *)datas errors:(NSDictionary *)errors;

@end

//------------------------------------------------------------------

/**
 * 服务请求管理器，管理几个并行的服务请求，并在全部请求结束后回调，无需对该对象进行引用，
 *开始管理请求时会建立循环保留直至所有请求结束
 */
@interface RH_ConcurrentServicesReqManager : NSObject
//添加请求,一个key标识一个请求，不传会自动生成一个随机的key，正在请求时添加会失败
- (BOOL)addServiceRequest:(RH_ServiceRequest *)serviceRequest key:(NSString *)key;

//创建请求并加入管理
- (BOOL)createServiceRequestAddToManagerWithKey:(NSString *)key requestBlock:(void(^)(RH_ServiceRequest *serviceRequest))requestBlock;

//开始管理时会核对所有的请求是否开始有且一个和设置回调block,没有一个满足条件的请求会返回NO
- (BOOL)startManagerRequests;
- (BOOL)startManagerRequestsWithContext:(id)context;

//上下文
@property(nonatomic,strong) id context;

//是否正在请求
@property(nonatomic,readonly,getter=isRequesting) BOOL requesting;

//取消所有请求
- (void)cancleAllServices;

//代理
@property(nonatomic,weak) id<RH_ConcurrentServicesReqManagerDelegate> delegate;

//完成的回调block
@property(nonatomic,copy) void(^completedBlcok)(NSDictionary *datas,NSDictionary * errors);

@end
