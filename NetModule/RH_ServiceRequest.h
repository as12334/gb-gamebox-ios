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
    ServiceRequestTypeV3GameLink        ,
    ServiceRequestTypeV3ActivityStatus    , //获取红包状态
    ServiceRequestTypeV3OpenActivity    ,//拆红包
    ServiceRequestTypeV3BettingList     , //投注记录 。。。
    ServiceRequestTypeV3BettingDetails  ,  //投注记录详情。。。
    ServiceRequestTypeV3DepositList     , //资金记录 。。。
    ServiceRequestTypeV3DepositListDetails     , //资金记录详情 。。。
    ServiceRequestTypeV3ModifySafetyPassword ,
    ServiceRequestTypeV3UserSafeInfo   , //用户安全码信息
    ServiceRequestTypeV3SetRealName     ,//设置真实姓名
    ServiceRequestTypeV3UpdateSafePassword,//修改安全密码
    ServiceRequestTypeV3UpdateLoginPassword,//修改登录密码
    ServiceRequestTypeV3DepositPullDownList, //资金记录下拉列表
    ServiceRequestTypeV3AddBankCard,   //添加银行卡
    ServiceRequestTypeV3SafetyObtainVerifyCode ,
    ServiceRequestTypeV3PromoList,   //优惠 list
    ServiceRequestTypeV3SystemNotice           , //系统公告
    ServiceRequestTypeV3SystemNoticeDetail     , //系统公告详情
    ServiceRequestTypeV3GameNotice           , //游戏公告
    ServiceRequestTypeV3GameNoticeDetail     , //游戏公告详情
    ServiceRequestTypeV3OneStepRecory      , //一键回收
    ServiceRequestTypeV3BankCardInfo        , //用户银行卡信息
    ServiceRequestTypeV3SaveAndAddBtc      ,  //添加/保存比特币
    ServiceRequestTypeV3SiteMessage       ,  //站点信息 系统信息
    ServiceRequestTypeV3SiteMessageDetail  ,  //站点信息 系统信息详情
    ServiceRequestTypeV3SystemMessageYes     ,  //系统信息标记为已读
    ServiceRequestTypeV3SystemMessageDelete   ,  //系统信息删除
    ServiceRequestTypeV3AddApplyDiscounts    ,  //发送消息
    ServiceRequestTypeV3AddApplyDiscountsVerify,  //发送消息验证
    ServiceRequestTypeV3PromoActivityType,  //优惠界面 类型获取
    ServiceRequestTypeV3ActivityDetailList,  //优惠界面 列表
    ServiceRequestTypeV3UserLoginOut           ,  //退出登录
    ServiceRequestTypeV3SiteMessageMyMessage   ,  //站点信息  我的消息
    ServiceRequestTypeV3SiteMessageMyMessageDetail,  //站点信息  我的消息详情
    ServiceRequestTypeV3MyMessageMyMessageReadYes   ,  //  我的消息 已读
    ServiceRequestTypeV3MyMessageMyMessageDelete   ,  // 我的消息  删除
    ServiceRequestTypeV3GetWithDrawInfo   ,  // 取款信息接口
    ServiceRequestTypeV3SubmitWithdrawInfo   ,  // 提交取款信息
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
-(void)startV3BettingList:(NSString*)startDate EndDate:(NSString*)endDate
               PageNumber:(NSInteger)pageNumber
                 PageSize:(NSInteger)pageSize ;
#pragma mark - 资金记录
-(void)startV3DepositList:(NSString*)startDate
                  EndDate:(NSString*)endDate
               SearchType:(NSString*)type
               PageNumber:(NSInteger)pageNumber
                 PageSize:(NSInteger)pageSize ;

#pragma mark - 资金记录详情 根据ID进行查询
-(void)startV3DepositListDetail:(NSString*)searchId;

#pragma mark - 用户安全码初始化信息
- (void)startV3UserSafetyInfo ;
#pragma mark - 投注记录详情
-(void)startV3BettingDetails:(NSInteger)listId;


#pragma mark - 设置真实名字
- (void)startV3SetRealName: (NSString*)name;

#pragma mark - 修改安全密码接口
- (void)startV3ModifySafePasswordWithRealName:(NSString *)realName
                               originPassword:(NSString *)originPwd
                                  newPassword:(NSString *)pwd1
                              confirmPassword:(NSString *)pwd2
                                   verifyCode:(NSString *)code;

#pragma mark - 修改登录密码
- (void)startV3UpdateLoginPassword:(NSString*)password
                       newPassword:(NSString*)newPassword
                        verifyCode:(NSString*)code ;


#pragma mark - 资金记录下拉列表
-(void)startV3DepositPulldownList;


#pragma mark - 添加银行卡

/**
 添加银行卡
 @param bankcardMasterName  卡主名
 @param bankName   银行
 @param bankcardNumber 卡号
 @param bankDeposit 开户银行
 */
-(void)startV3addBankCarkbankcardMasterName:(NSString *)bankcardMasterName
                            bankName:(NSString *)bankName
                      bankcardNumber:(NSString *)bankcardNumber
                         bankDeposit:(NSString *)bankDeposit;


#pragma mark -- 系统公告
/**
 系统公告API接口
 @param startTime 开始时间
 @param endTime 结束时间
 @param pageNumber 第几页
 @param pageSize 一页展示多少条默认20
 */
-(void)startV3LoadSystemNoticeStartTime:(NSString *)startTime
                                endTime:(NSString *)endTime
                             pageNumber:(NSInteger)pageNumber
                               pageSize:(NSInteger)pageSize;

#pragma mark -- 系统公告详情

/**
  系统公告详情

 @param searchId 公告id
 */
-(void)startV3LoadSystemNoticeDetailSearchId:(NSString *)searchId;

#pragma mark -  游戏公告
/**
 游戏公告

 @param startTime 开始时间
 @param endTime 结束时间
 @param pageNumber 第几页
 @param pageSize 一页展示多少条默认20
 @param apiId 游戏类型
 */
-(void)startV3LoadGameNoticeStartTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                           pageNumber:(NSInteger)pageNumber
                             pageSize:(NSInteger)pageSize
                                apiId:(NSInteger)apiId;
#pragma mark -  游戏公告详情
/**
 游戏公告详情

 @param searchId Id
 */
-(void)startV3LoadGameNoticeDetailSearchId:(NSString *)searchId;

#pragma mark - 生成安全验证码
-(void)startV3GetSafetyVerifyCode ;

#pragma mark - 优惠列表
-(void)startV3PromoList:(NSInteger)pageNumber
               PageSize:(NSInteger)pageSize ;

#pragma mark -  一键回收
//请求参数  无
-(void)startV3OneStepRecovery;

#pragma mark - V3 添加/保存比特币
-(void)startV3SaveAndAddBtcWithBankcardNumber:(NSString *)bankcardNumber;

#pragma mark - 站点信息 - 系统消息
-(void)startV3LoadSystemMessageWithpageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize;

#pragma mark - 站点信息 - 系统消息详情
-(void)startV3LoadSystemMessageDetailWithSearchId:(NSString *)searchId;

#pragma mark - 站点信息 - 系统消息标记已读
-(void)startV3LoadSystemMessageReadYesWithIds:(NSString *)ids;
#pragma mark - 站点信息 - 系统消息删除
-(void)startV3LoadSystemMessageDeleteWithIds:(NSString *)ids;

#pragma mark - 发送消息验证
-(void)startV3AddApplyDiscountsVerify;

#pragma mark - 发送消息
-(void)startV3AddApplyDiscountsWithAdvisoryType:(NSString *)advisoryType
                                  advisoryTitle:(NSString *)advisoryTitle
                                advisoryContent:(NSString *)advisoryContent
                                           code:(NSString *)code;

#pragma mark - tabbar2 优惠活动主界面类型
-(void)startV3LoadDiscountActivityType;

#pragma mark - tabbar2 优惠活动主界面列表
-(void)startV3LoadDiscountActivityTypeListWithKey:(NSString *)mKey
                                       PageNumber:(NSInteger)pageNumber
                                         pageSize:(NSInteger)pageSize;

#pragma mark - 退出登录
-(void)startV3UserLoginOut;

/**
 我的消息

 @return return value description
 */
#pragma mark - 站点信息  我的消息
-(void)startV3SiteMessageMyMessageWithpageNumber:(NSInteger)pageNumber
                                        pageSize:(NSInteger)pageSize;

#pragma mark - 站点信息  我的消息详情

/**
 我的消息详情
 @param mId list ID
 */
-(void)startV3SiteMessageMyMessageDetailWithID:(NSString *)mId;
#pragma mark - 站点信息 - 我的消息标记已读
-(void)startV3LoadMyMessageReadYesWithIds:(NSString *)ids;
#pragma mark - 站点信息 - 我的消息删除
-(void)startV3LoadMyMessageDeleteWithIds:(NSString *)ids;

#pragma mark - 获取取款接口
-(void)startV3GetWithDraw;

#pragma mark - 提交取款信息
/**
 提交取款信息
 @param noBank 是否有银行卡  N
 @param noBtc 是否有比特币   N
 @param remittanceWay 银行卡类型（1：银行卡，2：比特币）  N
 @param walletBalance 钱包金额  N
 @param withdrawAmount 取款金额  Y
 @param poundageHide 符号  N
 @param withdrawFee 手续费  N
 @param actualWithdraw 实际取款金额 Y
 @param gbToken 防重验证  Y
 */
-(void)startV3SubmitWithdrawWithNoBank:(BOOL)noBank
                                 noBtc:(BOOL)noBtc
                         remittanceWay:(NSInteger)remittanceWay
                         walletBalance:(float)walletBalance
                        withdrawAmount:(float)withdrawAmount
                          poundageHide:(NSString *)poundageHide
                           withdrawFee:(float)withdrawFee
                        actualWithdraw:(float)actualWithdraw
                               gbToken:(NSString *)gbToken;

#pragma mark - 获取games link
-(void)startv3GetGamesLink:(NSInteger)apiID
                 ApiTypeID:(NSInteger)apiTypeID
                   GamesID:(NSString*)gamesID
                 GamesCode:(NSString*)gamesCode ;
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
