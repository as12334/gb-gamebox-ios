//
//  RH_ConcurrentServicesReqManager.m
//  CoreLib
//
//  Created by jinguihua on 2016/12/1.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "RH_ConcurrentServicesReqManager.h"
#import "help.h"
#import "MacroDef.h"

@interface RH_ConcurrentServicesReqManager ()

@property(nonatomic,strong,readonly) NSMutableDictionary<NSString *,RH_ServiceRequest *> * serviceRequests;
@property(nonatomic,strong,readonly) NSMutableDictionary * resultDatas;
@property(nonatomic,strong,readonly) NSMutableDictionary * resultErrors;

@end

@implementation RH_ConcurrentServicesReqManager
@synthesize serviceRequests = _serviceRequests;
@synthesize resultDatas = _resultDatas;
@synthesize resultErrors = _resultErrors;

- (void)dealloc {
    [self cancleAllServices];
}

- (NSMutableDictionary *)serviceRequests
{
    if (!_serviceRequests) {
        _serviceRequests = [NSMutableDictionary dictionary];
    }

    return _serviceRequests;
}

- (NSMutableDictionary *)resultDatas
{
    if (!_resultDatas) {
        _resultDatas = [NSMutableDictionary dictionary];
    }

    return _resultDatas;
}

- (NSMutableDictionary *)resultErrors
{
    if (!_resultErrors) {
        _resultErrors = [NSMutableDictionary dictionary];
    }

    return _resultErrors;
}

- (BOOL)createServiceRequestAddToManagerWithKey:(NSString *)key requestBlock:(void(^)(RH_ServiceRequest *serviceRequest))requestBlock
{
    if (self.requesting) {
        return NO;
    }

    RH_ServiceRequest * serviceRequest = [[RH_ServiceRequest alloc] init];
    if (requestBlock) {
        requestBlock(serviceRequest);
    }

    return [self addServiceRequest:serviceRequest key:key];
}

- (BOOL)addServiceRequest:(RH_ServiceRequest *)serviceRequest key:(NSString *)key
{
    if (self.isRequesting && !serviceRequest) {
        return NO;
    }

    //生成随机key
    if (key.length == 0) {
        key = getUniqueID();
    }

    //保存
    [self.serviceRequests setObject:serviceRequest forKey:key];

    return YES;
}

- (BOOL)startManagerRequests {
    return [self startManagerRequestsWithContext:nil];
}

- (BOOL)startManagerRequestsWithContext:(id)context
{
    [self cancleAllServices];

    //核对请求数据
    for (NSString * key in self.serviceRequests.allKeys) {
        RH_ServiceRequest * serviceRequest = self.serviceRequests[key];

        //不等于一个请求数直接移除
        if ([serviceRequest requestsCount] != 1) {
            [self.serviceRequests removeObjectForKey:key];
        }else {

            //设置回调block(建立循环保留)
            serviceRequest.successBlock = ^(RH_ServiceRequest * serviceRequest, ServiceRequestType type, id data){
                [self _completedServiceRequest:serviceRequest type:type key:key data:data ?: [NSNull null] error:nil];
            };

            serviceRequest.failBlock = ^(RH_ServiceRequest * serviceRequest, ServiceRequestType type, NSError * error) {
                [self _completedServiceRequest:serviceRequest type:type key:key data:nil error:error];
            };
        }
    }

    if (self.serviceRequests.count) {
        _requesting = YES;
        _context = context;
        return YES;
    }

    return NO;
}

- (void)cancleAllServices
{
    if (self.isRequesting) {
        _requesting = NO;
        [self _clearAllDatas];
    }
}

- (void)_clearAllDatas
{
    _resultDatas = nil;
    _resultErrors = nil;
    _context = nil;

    //取消所有的请求
    [self.serviceRequests.allValues makeObjectsPerformSelector:@selector(cancleAllServices)];
    _serviceRequests = nil;
}

- (void)_completedServiceRequest:(RH_ServiceRequest *)serviceRequest type:(ServiceRequestType)type key:(NSString *)key data:(id)data error:(NSError *)error
{
    if (self.isRequesting && self.serviceRequests[key] == serviceRequest) {
        [self.serviceRequests removeObjectForKey:key];

        id<RH_ConcurrentServicesReqManagerDelegate> delegate = self.delegate;

        if (data != nil) {
            [self.resultDatas setObject:data forKey:key];

            //回调
            ifRespondsSelector(delegate, @selector(concurrentServicesManager:serviceRequest:key:serviceType:didSuccessRequestWithData:)) {
                [delegate concurrentServicesManager:self
                                     serviceRequest:serviceRequest
                                                key:key
                                        serviceType:type
                          didSuccessRequestWithData:data];
            }

        }else {
            [self.resultErrors setObject:error ?: [NSNull null] forKey:key];

            //回调
            ifRespondsSelector(delegate, @selector(concurrentServicesManager:serviceRequest:key:serviceType:didFailRequestWithError:)) {
                [delegate concurrentServicesManager:self
                                     serviceRequest:serviceRequest
                                                key:key
                                        serviceType:type
                            didFailRequestWithError:error];
            }

        }

        //请求完成
        if (self.serviceRequests.count == 0 && self.requesting) {
            _requesting = NO;

            //回调
            ifRespondsSelector(delegate, @selector(concurrentServicesManager:didCompletedAllServiceWithDatas:errors:)) {
                [delegate concurrentServicesManager:self didCompletedAllServiceWithDatas:self.resultDatas errors:self.resultErrors];
            }

            if (self.completedBlcok) {
                self.completedBlcok(self.resultDatas,self.resultErrors);
            }

            //清楚所有数据
            [self _clearAllDatas];
        }
    }
}

@end
