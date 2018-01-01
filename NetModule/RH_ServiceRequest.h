//
//  RH_ServiceRequest.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//------------------------------------------------------------------

/**
 * 业务服务类型
 */
typedef NS_ENUM(NSInteger, ServiceRequestType) {
    ServiceRequestTypeDomainList = 0    ,
    ServiceRequestTypeDomainCheck       ,
    ServiceRequestTypeUpdateCheck       ,
    ServiceRequestTypeUserLogin         ,
    ServiceRequestTypeUserAutoLogin     ,
    ServiceRequestTypeDemoLogin         ,
    ServiceRequestTypeObtainVerifyCode     ,
    ServiceRequestTypeGetCustomService  ,
    ServiceRequestTypeTestUrl           ,
    
    //V3接口
    ServiceRequestTypeV3HomeInfo        ,
    ServiceRequestTypeV3UserInfo        ,
    ServiceRequestTypeV3MineLinkInfo    ,
};


@class RH_ServiceRequest;
@protocol  RH_ServiceRequestDelegate <NSObject>

@optional

/**
 * 请求服务成功
 * @param serviceRequest serviceRequest为服务请求对象
 * @param type           type为服务类型
 * @param data           data为得到的数据对象
 */
- (void)       serviceRequest:(RH_ServiceRequest *)serviceRequest
                  serviceType:(ServiceRequestType)type
    didSuccessRequestWithData:(id)data;

/**
 * 请求服务成功失败
 * @param serviceRequest serviceRequest为服务请求对象
 * @param type           type为服务类型
 * @param error          error为失败的错误
 */
- (void)     serviceRequest:(RH_ServiceRequest *)serviceRequest
                serviceType:(ServiceRequestType)type
    didFailRequestWithError:(NSError *)error;

@end

//------------------------------------------------------------------

/** 获取成功的block */
typedef void (^ServiceRequestSuccessBlock)(RH_ServiceRequest * serviceRequest, ServiceRequestType type, id data);

/** 获取失败的block */
typedef void (^ServiceRequestFailBlock)(RH_ServiceRequest * serviceRequest, ServiceRequestType type, NSError * error);


//------------------------------------------------------------------


#pragma mark-ServiceRequest
@interface RH_ServiceRequest : NSObject

#pragma mark-接口定义
/**
 * 获取站点 DOMAIN 列表
 */
-(void)startReqDomainList ;

/**
 * DOMAIN CHECK
 */
-(void)startCheckDomain:(NSString*)doMain;

/**
 * update CHECK
 */
-(void)startUpdateCheck ;

-(void)startLoginWithUserName:(NSString*)userName Password:(NSString*)password VerifyCode:(NSString*)verCode ;
-(void)startAutoLoginWithUserName:(NSString*)userName Password:(NSString*)password;

-(void)startGetVerifyCode ;

-(void)startDemoLogin;

-(void)startGetCustomService ;

-(void)startTestUrl:(NSString*)testURL ;

#pragma mark - v3 接口定义
#pragma mark  - 首页接口 
-(void)startV3HomeInfo ;
#pragma mark - 用户信息
-(void)startV3UserInfo ;
#pragma mark - 我的 link info
-(void)startV3MineLinkInfo ;

#pragma mark -
/**
 * 取消所有服务
 */
- (void)cancleAllServices;

/**
 * 取消特定的服务
 */
- (void)cancleServiceWithType:(ServiceRequestType)serivceType;

//是否正在请求
- (BOOL)isRequesting;
- (BOOL)isRequestingWithType:(ServiceRequestType)serivceType;

//请求数目
- (NSUInteger)requestsCount;


/**
 * 代理
 */
@property(nonatomic,weak) id<RH_ServiceRequestDelegate> delegate;

/**
 * 成功的block
 */
@property(nonatomic,copy) ServiceRequestSuccessBlock successBlock;

/**
 * 失败的block
 */
@property(nonatomic,copy) ServiceRequestFailBlock   failBlock;


/*
 *timeout 时间设定
 */
@property(nonatomic,assign) NSTimeInterval timeOutInterval ;
//------------------------------------------------------------------

//设置上下文,服务结束后自动移除上下文
- (void)setContext:(id)context forType:(ServiceRequestType)serivceType;

//获取上下文
- (id)contextForType:(ServiceRequestType)serivceType;

//移除上下文
- (void)removeContextForType:(ServiceRequestType)serivceType;
@end
