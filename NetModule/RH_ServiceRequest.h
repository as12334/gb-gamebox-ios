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
    ServiceRequestTypeAPIRetrive        , //api 回收接口
    
    //V3接口
    ServiceRequestTypeV3HomeInfo        ,
    ServiceRequestTypeV3UserInfo        ,
    ServiceRequestTypeV3MineGroupInfo   ,
    ServiceRequestTypeV3APIGameList     ,
    ServiceRequestTypeV3ActivityStatus    , //获取红包状态
    ServiceRequestTypeV3OpenActivity    ,//拆红包
    ServiceRequestTypeV3BettingList     , //投注记录 。。。
    ServiceRequestTypeV3BettingDetails  ,  //投注记录详情。。。
    ServiceRequestTypeV3DepositList     , //资金记录 。。。
    ServiceRequestTypeV3DepositListDetails     , //资金记录详情 。。。
    ServiceRequestTypeV3ModifyPassword  , //修改密码
    ServiceRequestTypeV3ModifySafetyPassword ,
    ServiceRequestTypeV3UserSafeInfo   , //用户安全码信息
    ServiceRequestTypeV3SetRealName     ,//设置真实姓名
    ServiceRequestTypeV3UpdateSafePassword,//修改安全密码
    ServiceRequestTypeV3UpdateLoginPassword,//修改登录密码
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

-(void)startAPIRetrive:(NSInteger)apiID ;

-(void)startTestUrl:(NSString*)testURL ;

#pragma mark - v3 接口定义
#pragma mark  - 首页接口 
-(void)startV3HomeInfo ;
#pragma mark - 用户信息
-(void)startV3UserInfo ;
#pragma mark - 我的 link info
-(void)startV3MineLinkInfo ;
#pragma mark - 红包状态
-(void)startV3ActivityStaus:(NSString*)activityID ;

#pragma mark  - V3 拆红包
-(void)startV3OpenActivity:(NSString *)activityID
                andGBtoken:(NSString *)gbtoken ;

#pragma mark - 电子游戏list
-(void)startV3GameListWithApiID:(NSInteger)apiID
                      ApiTypeID:(NSInteger)apiTypeID
                     PageNumber:(NSInteger)pageNumber
                       PageSize:(NSInteger)pageSize
                     SearchName:(NSString*)searchName ;

#pragma mark - 投注记录
-(void)startV3BettingList:(NSString*)startDate EndDate:(NSString*)endDate ;

-(void)startV3BettingList:(NSString*)startDate EndDate:(NSString*)endDate
               PageNumber:(NSInteger)pageNumber
                 PageSize:(NSInteger)pageSize ;
#pragma mark - 资金记录
-(void)startV3DepositList:(NSString*)startDate EndDate:(NSString*)endDate ;

#pragma mark - 资金记录详情 根据ID进行查询
-(void)startV3DepositListDetail:(NSString*)searchId;

#pragma mark - 修改密码
- (void)startV3ChangePasswordWith:(NSString *)currentPwd and:(NSString *)newPwd;
#pragma mark - 修改安全密码
- (void)startV3ChangeSaftyPasswordMainPage;

#pragma mark - 用户安全码初始化信息
- (void)startV3UserSafetyInfo ;
#pragma mark - 投注记录详情
-(void)startV3BettingDetails:(NSInteger)listId;

#pragma mark - 设置真实名字
- (void)startV3SetRealName: (NSString*)name;

#pragma mark - 修改安全密码接口
- (void)startV3UpdateSafePassword:(BOOL)needCaptcha
                             name:(nullable NSString *)realName
                   originPassword:(nullable NSString *)originPwd
                      newPassword:(nullable NSString *)pwd1
                  confirmPassword:(nullable NSString *)pwd2
                       verifyCode:(nullable NSString *)code;

#pragma mark - 修改登录密码
- (void)startV3UpdateLoginPassword:(NSString *)password
                       newPassword:(NSString *)newPassword
                        verifyCode:(NSString *)code;


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
