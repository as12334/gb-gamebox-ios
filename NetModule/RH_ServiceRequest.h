//
//  RH_ServiceRequest.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define GB_CURRENT_APPVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

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
    ServiceRequestTypeObtainSecurePasswordVerifyCode    ,
    ServiceRequestTypeGetCustomService  ,
    ServiceRequestTypeTestUrl           ,
    ServiceRequestTypeAPIRetrive        , //api 回收接口
    ServiceRequestTypeCollectAPPError   , //check domain 失败 上传数据接口
    
    //V3接口
    ServiceRequestTypeV3UpdateCheck     , //v3 站点升级接口
    ServiceRequestTypeV3HomeInfo        ,
    ServiceRequestTypeV3UserInfo        ,
    ServiceRequestTypeV3MineGroupInfo   ,
    ServiceRequestTypeV3APIGameList     ,
    ServiceRequestTypeV3GameLink        ,
    ServiceRequestTypeV3GameLinkForCheery, //cheery 新标准
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
    ServiceRequestTypeV3AddBitCoin      ,  //添加/保存比特币
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
    ServiceRequestTypeV3LoadGameType,          //获取游戏分类
    ServiceRequestTypeV3SafetyPasswordAutuentification ,   //取款安全密码验证
    ServiceRequestTypeWithDrawFee , //取款手续费计算
    ServiceRequestTypeTimeZoneInfo , //获取站点时区
    ServiceRequestTypeSiteMessageUnReadCount , //获取站点信息-未读消息的条数
    ServiceRequestTypeV3SharePlayerRecommend ,   // 分享
    ServiceRequestTypeV3SharePlayerRecord,//分享记录
    
    ServiceRequestTypeV3VerifyRealNameForApp ,   // 老用户验证登录
    ServiceRequestTypeV3GETUSERASSERT ,   // 获取用户资产信息
    ServiceRequestTypeV3RefreshSession ,   // 防止长时间未操作掉线
    ServiceRequestTypeV3IsOpenCodeVerifty,// 登录是否开启验证码
    ServiceRequestTypeV3RequetLoginWithGetLoadSid,// get请求登录接口获取SID
    ServiceRequestTypeV3DepositeOrigin,//请求获取存款平台相关信息
    ServiceRequestTypeV3DepositeOriginChannel,//请求获取存款平台相关信息
    ServiceRequestTypeV3RegiestInit,     //注册初始化
    ServiceRequestTypeV3RegiestCaptchaCode,     //注册验证码
    ServiceRequestTypeV3RegiestSubmit,   //注册提交
    ServiceRequestTypeV3RegiestTerm,     //注册条款
    ServiceRequestTypeV3AboutUs,     //关于我们
    ServiceRequestTypeV3FirstHelpFirstTyp,     //常见问题父级分类
    ServiceRequestTypeV3FirstHelpSecondTyp,     //常见问题二级分类
    ServiceRequestTypeV3HelpDetail,     //常见问题详情
    ServiceRequestTypeV3DepositOriginSeachSale,  //存款获取优惠
    ServiceRequestTypeV3DepositOriginBittionSeachSale,//比特币优惠
    ServiceRequestTypeLookJiHe,//查看稽核
    
    ServiceRequestTypeV3GetNoAutoTransferInfo,    // 非免转额度转换初始化
    ServiceRequestTypeV3SubmitTransfersMoney,     //非免转额度转换提交
    ServiceRequestTypeV3ReconnectTransfer,        //非免转额度转换异常再次请求
    ServiceRequestTypeV3RefreshApi,               //非免转刷新单个
    ServiceRequestTypeV3OnlinePay,               //线上支付提交存款
    ServiceRequestTypeV3ScanPay,               //扫码支付提交存款
    ServiceRequestTypeV3CompanyPay,               //网银支付提交存款
    ServiceRequestTypeV3ElectronicPay,               //电子支付提交存款
    ServiceRequestTypeV3AlipayElectronicPay,     //支付宝电子支付提交存款
    ServiceRequestTypeV3BitcoinPay,               //比特币支付提交存款
    ServiceRequestTypeV3OneStepRefresh,               //一键刷新
    ServiceRequestTypeV3CounterPay,             //柜台机存款
    ServiceRequestTypeV3GetPhoneCode,             //获取手机验证码
    ServiceRequestTypeV3CollectAppDomainError,   // 错误日志提交接口
    ServiceRequestTypeV3CustomService,          //获取客服接口
//    ServiceRequestTypeV3BossSysDomain,          //获取IP和域名
    ServiceRequestTypeV3NoticePopup,            //公告弹框
    
    ServiceRequestTypeV3FindUserPhone   ,  // 判断用户是否绑定手机号
    ServiceRequestTypeV3GetUserPhone   ,  // 获取用户手机
    ServiceRequestTypeV3BindSendCode   ,  // 绑定手机的发送验证码
    ServiceRequestTypeV3BindPhone,  //绑定手机
    ServiceRequestTypeV3ForgetPswSendCode,  //忘记密码的发送验证码
    ServiceRequestTypeV3ForgetPswCheckCode, //忘记密码验证验证码
    ServiceRequestTypeV3ForgetPswFindbackPsw,   //找回密码
    ServiceRequestTypeV3ForgetPswCheckStatus,   //检查该功能是否开启

    ServiceRequestTypeV3INITAD,            //初始化广告
    ServiceRequestTypeFetchHost,        //获取动态HOST
    ServiceRequestTypeFetchH5Ip,        //获取特殊ip
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


//增加 特别 error code 的处理回调
- (void)     serviceRequest:(RH_ServiceRequest *)serviceRequest
                serviceType:(ServiceRequestType)type
             SpecifiedError:(NSError *)error;

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

-(void)startReqDomainListWithIP:(NSString*)ip Host:(NSString *)host;

/**
 * 获取站点 DOMAIN 列表
 */
-(void)startReqDomainListWithDomain:(NSString*)domain ;

/**
 * DOMAIN CHECK
 */
-(void)startCheckDomain:(NSString*)doMain WithCheckType:(NSString *)checkType;

/**
 * update CHECK
 */
-(void)startUpdateCheck ;

#pragma mark - v3 站点升级接口
-(void)startV3UpdateCheck ;

-(void)startLoginWithUserName:(NSString*)userName Password:(NSString*)password VerifyCode:(NSString*)verCode ;
-(void)startAutoLoginWithUserName:(NSString*)userName Password:(NSString*)password;

-(void)startGetVerifyCode ;

-(void)startGetSecurePasswordVerifyCode;

-(void)startDemoLogin;

-(void)startGetCustomService ;

-(void)startAPIRetrive:(NSInteger)apiID ;

-(void)startUploadAPPErrorMessge:(NSDictionary*)errorDict ;

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
                     SearchName:(NSString*)searchName
                          TagID:(NSString*)tagID;

#pragma mark - 投注记录
-(void)startV3BettingList:(NSString*)startDate EndDate:(NSString*)endDate
               PageNumber:(NSInteger)pageNumber
                 PageSize:(NSInteger)pageSize
                withIsStatistics:(BOOL)isShowStatistics;
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

#pragma mark--
#pragma mark--查看稽核
-(void)startLookJiHe;
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
-(void)startV3OneStepRecoverySearchId:(NSString *)searchId;

#pragma mark - V3 添加比特币
-(void)startV3AddBtcWithNumber:(NSString *)bitNumber;

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
-(void)startV3LoadDiscountActivityTypeListWithKey:(NSString *)mKey;

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
-(void)startV3SubmitWithdrawAmount:(float)withdrawAmount
                         SafetyPwd:(NSString *)safetyPassword
                           gbToken:(NSString *)gbToken
                          CardType:(NSInteger)cardType ; //（1：银行卡，2：比特币）

#pragma mark - 获取games link
-(void)startv3GetGamesLink:(NSInteger)apiID
                 ApiTypeID:(NSInteger)apiTypeID
                   GamesID:(NSString*)gamesID
                 GamesCode:(NSString*)gamesCode ;

#pragma mark - 获取games link for cheery
-(void)startv3GetGamesLinkForCheeryLink:(NSString*)gamelink;

#pragma mark - 获取游戏分类
-(void)startV3LoadGameTypeWithApiId:(NSInteger)apiId searchApiTypeId:(NSInteger)apiTypeId;

#pragma mark - 取款验证安全密码
-(void)startV3WithDrwaSafetyPasswordAuthentificationOriginPwd:(NSString *)originPwd;

#pragma mark - 获取手续费信息得到最终取款金额
-(void)startV3WithDrawFeeWithAmount:(CGFloat)amount ;

#pragma mark - 获取站点时区
-(void)startV3SiteTimezone ;

#pragma mark - 获取站点消息-系统消息&&我的消息 未读条数
-(void)startV3LoadMessageCenterSiteMessageUnReadCount ;

#pragma mark - 分享接口
-(void)startV3LoadSharePlayerRecommend;

#pragma mark -老用户验证登录
/**
 老用户验证登录

 @param token  登录返回的Token
 @param resultRealName 输入框真实姓名
 @param needRealName 默认传 YES
 @param resultPlayerAccount 用户名
 @param searchPlayerAccount 用户名
 @param tempPass 密码
 @param newPassword 密码
 @param passLevel 默认传 20
 */
-(void)startV3verifyRealNameForAppWithToken:(NSString *)token
                             resultRealName:(NSString *)resultRealName
                               needRealName:(BOOL)needRealName
                        resultPlayerAccount:(NSString *)resultPlayerAccount
                        searchPlayerAccount:(NSString *)searchPlayerAccount
                                   tempPass:(NSString *)tempPass
                                newPassword:(NSString *)newPassword
                                  passLevel:(NSInteger)passLevel;

#pragma mark - 获取用户资产信息
-(void)startV3GetUserAssertInfo ;

#pragma mark - 防止用户掉线
-(void)startV3RereshUserSessin ;
#pragma mark - 用户登录是否开启验证码
-(void)startV3IsOpenCodeVerifty;
#pragma mark - 通过GET请求登录接口获取SID
-(void)startV3RequsetLoginWithGetLoadSid;
#pragma mark - 获取存款平台的接口
-(void)startV3RequestDepositOrigin;
#pragma mark - 注册初始化
-(void)startV3RegisetInit;
#pragma mark - 注册验证码
-(void)startV3RegisetCaptchaCode;

#pragma mark - 注册提交
/**
 注册提交
 @param birth 生日
 @param sex 性别
 @param permissionPwd 安全密码
 @param defaultTimezone 时区
 @param defaultLocale  默认语言
 @param phone 手机号
 @param realName 真实姓名
 @param defaultCurrency 货币
 @param password 密码
 @param question1 问题
 @param email 邮箱
 @param qq qq
 @param weixinValue 微信
 @param userName 用户名
 @param captchaCode 验证码
 */
-(void)startV3RegisetSubmitWithBirthday:(NSString *)birth
                                    sex:(NSString *)sex
                          permissionPwd:(NSString *)permissionPwd
                        defaultTimezone:(NSString *)defaultTimezone
                          defaultLocale:(NSString *)defaultLocale
                      phonecontactValue:(NSString *)phone
                               realName:(NSString *)realName
                        defaultCurrency:(NSString *)defaultCurrency
                               password:(NSString *)password
                              question1:(NSString *)question1
                             emailValue:(NSString *)email
                                qqValue:(NSString *)qq
                            weixinValue:(NSString *)weixinValue
                               userName:(NSString *)userName
                            captchaCode:(NSString *)captchaCode
                  recommendRegisterCode:(NSString *)recommendRegisterCode
                               editType:(NSString *)editType
                 recommendUserInputCode:(NSString *)recommendUserInputCode
                        confirmPassword:(NSString *)confirmPassword
                   confirmPermissionPwd:(NSString *)confirmPermissionPwd
                                answer1:(NSString *)answer1
                         termsOfService:(NSString *)termsOfService
                           requiredJson:(NSArray<NSString *> *)requiredJson
                              phoneCode:(NSString *)phoneCode
                             checkPhone:(NSString *)checkPhone;
#pragma mark - 注册条款
-(void)startV3RegisetTerm;

#pragma mark - V3  关于我们
-(void)startV3AboutUs;

#pragma mark - V3  常见问题父级分类
-(void)startV3HelpFirstType;

#pragma mark - V3  常见问题二级分类
-(void)startV3HelpSecondTypeWithSearchId:(NSString *)searchId ;

#pragma mark - V3  常见问题详情
-(void)startV3HelpDetailTypeWithSearchId:(NSString *)searchId ;

#pragma mark 存款获取优惠
-(void)startV3DepositOriginSeachSaleRechargeAmount:(NSString *)rechargeAmount PayAccountDepositWay:(NSString *)payAccountDepositWay PayAccountID:(NSString *)payAccountID;
#pragma mark 比特币存款获取优惠
-(void)startV3DepositOriginSeachSaleBittionRechargeAmount:(CGFloat)rechargeAmount PayAccountDepositWay:(NSString *)payAccountDepositWay bittionTxid:(NSInteger )bankOrder PayAccountID:(NSString *)payAccountID;

#pragma mark - V3  非免转额度转换初始化
-(void)startV3GetNoAutoTransferInfoInit ;


#pragma mark - V3  非免转额度转换提交
-(void)startV3SubitTransfersMoneyToken:(NSString *)token
                           transferOut:(NSString *)transferOut
                          transferInto:(NSString *)transferInto
                        transferAmount:(float)transferAmount ;


#pragma mark - V3  非免转额度转换异常再次请求
-(void)startV3ReconnectTransferWithTransactionNo:(NSString *)transactionNo
                                       withToken:(NSString *)token ;


#pragma mark - V3  非免转刷新单个
-(void)startV3RefreshApiWithApiId:(NSString *)apiId ;

#pragma mark - V3 线上支付提交存款
-(void)startV3OnlinePayWithRechargeAmount:(NSString *)amount
                             rechargeType:(NSString *)rechargeType
                             payAccountId:(NSString *)payAccountId
                               activityId:(NSString *)activityId
                            bankNameCode:(NSString *)bankNameCode;

#pragma mark - V3 扫码支付提交存款
-(void)startV3ScanPayWithRechargeAmount:(NSString *)amount
                           rechargeType:(NSString *)rechargeType
                           payAccountId:(NSInteger)payAccountId
                          payerBankcard:(NSInteger)payerBankcard
                             activityId:(NSInteger)activityId
                               account:(NSString *)account;

//#pragma mark - V3 易收付
//-(void)startV3EasyWithRechargeAmount:(NSString *)amount
//                           cid:(NSString *)cid
//                           uid:(NSString *)uid
//                          time:(NSString *)time
//                             order_id:(NSString *)order_id
//                                ip:(NSString *)ip
//                                sign:(NSString *)sign;

#pragma mark -  V3 网银支付提交存款
-(void)startV3CompanyPayWithRechargeAmount:(NSString *)amount
                              rechargeType:(NSString *)rechargeType
                              payAccountId:(NSString *)payAccountId
                                 payerName:(NSString *)payerName
                                activityId:(NSInteger)activityId ;

#pragma mark -  V3 柜台机支付提交存款
-(void)startV3CounterPayWithRechargeAmount:(NSString *)amount
                              rechargeType:(NSString *)rechargeType
                              payAccountId:(NSString *)payAccountId
                                 payerName:(NSString *)payerName
                           rechargeAddress:(NSString *)rechargeAddress
                                activityId:(NSInteger)activityId ;
#pragma mark - V3 电子支付提交存款
-(void)startV3ElectronicPayWithRechargeAmount:(NSString *)amount
                                 rechargeType:(NSString *)rechargeType
                                 payAccountId:(NSString *)payAccountId
                                    bankOrder:(NSString *)bankOrder
                                    payerName:(NSString *)payerName
                              payerBankcard:(NSString *)payerBankcard
                                   activityId:(NSInteger)activityId ;

#pragma mark - V3 支付宝电子支付提交存款
-(void)startV3AlipayElectronicPayWithRechargeAmount:(NSString *)amount
                                 rechargeType:(NSString *)rechargeType
                                 payAccountId:(NSString *)payAccountId
                                    bankOrder:(NSString *)bankOrder
                                    payerName:(NSString *)payerName
                                payerBankcard:(NSString *)payerBankcard
                                   activityId:(NSInteger)activityId ;

#pragma mark - V3 比特币支付提交存款
-(void)startV3BitcoinPayWithRechargeType:(NSString *)rechargeType
                              payAccountId:(NSString *)payAccountId
                              activityId:(NSInteger)activityId
                              returnTime:(NSString *)returnTime
                           payerBankcard:(NSString *)payerBankcard
                               bitAmount:(float)bitAmount
                           bankOrderTxID:(NSString *)bankOrder;

#pragma mark - V3 一键刷新
-(void)startV3OneStepRefresh ;
#pragma mark -v3 存款渠道初始化
-(void)startV3RequestDepositOriginChannel:(NSString *)httpCode;

#pragma mark - 获取手机验证码
-(void)startV3GetPhoneCodeWithPhoneNumber:(NSString *)phoneNumber ;
#pragma mark ==============获取客服接口================
-(void)startV3GetCustomService;
#pragma mark ==============获得消息公告弹窗================
-(void)startV3NoticePopup;
#pragma mark ==============分享好友记录================
-(void)startV3SharePlayerRecordStartTime:(NSString *)startTime endTime:(NSString *)endTime pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize;

#pragma mark ==============初始化广告================
-(void)startV3InitAd;

#pragma mark - V3忘记密码
- (void)findUserPhone:(NSString *)username;
- (void)forgetPswSendCode:(NSString *)encryptedId;
- (void)forgetPswCheckCode:(NSString *)code;
- (void)finbackLoginPsw:(NSString *)username psw:(NSString *)psw;
- (void)checkForgetPswStatus;

#pragma mark - V3绑定手机
- (void)getUserPhone;
- (void)bindPhoneSendCode:(NSString *)phone;
- (void)bindPhone:(NSString *)phone originalPhone:(NSString *)originalPhone code:(NSString *)code;

#pragma mark - 动态获取HOST
- (void)fetchHost:(NSString *)url;
#pragma mark--
#pragma mark--获取H5ip
-(void)fetchH5ip;

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
