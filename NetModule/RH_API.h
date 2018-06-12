//
//  RH_API.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#ifndef RH_API_h
#define RH_API_h


//===========================================================
//通用传入参数
//===========================================================
#define RH_SP_COMMON_SITECODE                        @"code"
#define RH_SP_COMMON_SITESEC                         @"s"

//移动端信息
#define RH_SP_COMMON_OSTYPE                              @"type"
#define RH_SP_COMMON_CHECKVERSION                        @"code"

#define RH_API_NAME_APPDOWNLOADURL                        @"app/download.html"

//v3原生接口公共规范
#define RH_SP_COMMON_V3_OSTYPE                              @"terminal"
#define RH_SP_COMMON_V3_THEME                               @"theme"
#define RH_SP_COMMON_V3_RESOLUTION                          @"resolution"
#define RH_SP_COMMON_V3_VERSION                             @"version"
#define RH_SP_COMMON_V3_ISNATIVE                            @"is_native"
#define RH_SP_COMMON_V3_LOCALE                              @"locale"
#define RH_SP_COMMON_V3_VERSION_VALUE                       @"3.0"

//===========================================================
//通过返回参数
//===========================================================

//1.success,标记是否成功,BOOL类型
#define RH_GP_SUCCESS               @"state"
//2.errorCode,失败返回,错误编码,int类型
#define RH_GP_ERRORCODE             @"errorCode"
//3.message,返回的信息,Sting类型
#define RH_GP_MESSAGE               @"message"

//v3原生通用返回参数定义
#define RH_GP_V3_ERROR               @"code"   //错误数量
#define RH_GP_V3_CODE                @"code"    //状态码
#define RH_GP_V3_MESSAGE             @"message"             //消息框
#define RH_GP_V3_VERSION             @"version"         //版本信息
#define RH_GP_V3_DATA                @"data"


//checkversion model
#define RH_GP_CHECKVERSION_ID                                       @"id"
#define RH_GP_CHECKVERSION_APPNAME                                  @"appName"
#define RH_GP_CHECKVERSION_APPTYPE                                  @"appType"
#define RH_GP_CHECKVERSION_VERSIONCODE                              @"versionCode"
#define RH_GP_CHECKVERSION_VERSIONNAME                              @"versionName"
#define RH_GP_CHECKVERSION_APPURL                                   @"appUrl"
#define RH_GP_CHECKVERSION_MEMO                                     @"memo"
#define RH_GP_CHECKVERSION_UPDATETIME                               @"updateTime"
#define RH_GP_CHECKVERSION_MD5                                      @"md5"
#define RH_GP_CHECKVERSION_FORCEVERSION                             @"forceVersion"

#pragma mark- Page list
#define RH_API_PAGE_SIGNUP                                          @"/signUp/index.html"

#pragma mark-接口 API List
#define RH_API_NAME_LOGIN                                           @"passport/login.html"
#define RH_API_NAME_AUTOLOGIN                                       @"login/autoLogin.html"
#define RH_API_NAME_VERIFYCODE                                      @"captcha/code.html"
#define RH_API_NAME_DEMOLOGIN                                       @"demo/lottery.html"
#define RH_API_NAME_GETCUSTOMPATH                                   @"index/getCustomerService.html"

#pragma mark - v3 首页 banner 模型
#define RH_GP_Banner_CAROUSEL_ID                                        @"carousel_id"
#define RH_GP_Banner_COVER                                              @"cover"
#define RH_GP_Banner_ID                                                 @"id"
#define RH_GP_Banner_LANGUAGE                                           @"language"
#define RH_GP_Banner_LINK                                               @"link"
#define RH_GP_Banner_NAME                                               @"name"
#define RH_GP_Banner_ENDTIME                                            @"end_time"
#define RH_GP_Banner_STARTTIME                                          @"start_time"
#define RH_GP_Banner_ORDERNUM                                           @"order_num"
#define RH_GP_Banner_STATUS                                             @"status"
#define RH_GP_Banner_TYPE                                               @"type"


#pragma mark -系统公告模型
#define RH_GP_SYSTEMNOTICE_ID                               @"id"
#define RH_GP_SYSTEMNOTICE_CONTENT                          @"content"
#define RH_GP_SYSTEMNOTICE_PUBLISHTIME                      @"publishTime"
#define RH_GP_SYSTEMNOTICE_LINK                             @"link"
#define RH_GP_SYSTEMNOTICE_MINDATE                          @"minDate"
#define RH_GP_SYSTEMNOTICE_MAXDATE                          @"maxDate"
#define RH_GP_SYSTEMNOTICE_SEARCHID                         @"searchId"
#define RH_GP_SYSTEMNOTICE_READ                             @"read"

#pragma mark -游戏公告模型fwwwwwwwwww
#define RH_GP_GAMENOTICE_ID             @"id"
#define RH_GP_GAMENOTICE_TITLE          @"title"
#define RH_GP_GAMENOTICE_LINK           @"link"
#define RH_GP_GAMENOTICE_GAMENAME       @"gameName"
#define RH_GP_GAMENOTICE_PUBLISHTIME    @"publishTime"
#define RH_GP_GAMENOTICE_CONTEXT        @"context"
#define RH_GP_GAMENOTICE_MINDATE        @"minDate"
#define RH_GP_GAMENOTICE_MAXDATE        @"maxDate"
#define RH_GP_GAMENOTICE_APISELECT      @"apiSelect"
#define RH_GP_GAMENOTICE_APIID          @"apiId"
#define RH_GP_GAMENOTICE_APINAME        @"apiName"

#pragma mark - 游戏公告详情 模型
#define RH_GP_GAMENOTICEDETAIL_ID            @"id"
#define RH_GP_GAMENOTICEDETAIL_TITLE         @"title"
#define RH_GP_GAMENOTICEDETAIL_LINK          @"link"
#define RH_GP_GAMENOTICEDETAIL_GAMENAME      @"gameName"
#define RH_GP_GAMENOTICEDETAIL_PUBLISHTIME   @"publishTime"
#define RH_GP_GAMENOTICEDETAIL_CONTEXT       @"context"


#pragma mark - v3 首页 announcement 公告模型
#define RH_GP_ANNOUNCEMENT_TYPE                                               @"announcementType"
#define RH_GP_ANNOUNCEMENT_CODE                                               @"code"
#define RH_GP_ANNOUNCEMENT_DISPLAY                                            @"display"
#define RH_GP_ANNOUNCEMENT_ID                                                 @"id"
#define RH_GP_ANNOUNCEMENT_ISTASK                                             @"isTask"
#define RH_GP_ANNOUNCEMENT_CONTENT                                            @"content"
#define RH_GP_ANNOUNCEMENT_LANGUAGE                                           @"language"
#define RH_GP_ANNOUNCEMENT_ORDERNUM                                           @"orderNum"
#define RH_GP_ANNOUNCEMENT_PUBLISHTIME                                        @"publishTime"
#define RH_GP_ANNOUNCEMENT_TITLE                                              @"title"

#pragma mark - V3 活动图 信息 
#define RH_GP_ACTIVITY_ACTIVITYID                                               @"activityId"
#define RH_GP_ACTIVITY_DESCRTIPTION                                             @"description"
#define RH_GP_ACTIVITY_DISTANCESIDE                                             @"distanceSide"
#define RH_GP_ACTIVITY_DISTANCETOP                                              @"distanceTop"
#define RH_GP_ACTIVITY_LANGUAGE                                                 @"language"
#define RH_GP_ACTIVITY_LOCATION                                                 @"location"
#define RH_GP_ACTIVITY_NORMALEFFECT                                             @"normalEffect"

#pragma mark - V3 我的优惠信息 模型
#define RH_GP_PROMOINFO_ACTIVITYNAME                                        @"activityName"
#define RH_GP_PROMOINFO_ACTIVITYVERSION                                     @"activityVersion"
#define RH_GP_PROMOINFO_APPLYTIME                                           @"applyTime"
#define RH_GP_PROMOINFO_CHECKSTATE                                          @"checkState"
#define RH_GP_PROMOINFO_CHECKSTATENAME                                      @"checkStateName"
#define RH_GP_PROMOINFO_ID                                                  @"id"
#define RH_GP_PROMOINFO_PREFERENTIALAUDIT                                   @"preferentialAudit"
#define RH_GP_PROMOINFO_PREFERENTIALAUDITNAME                               @"preferentialAuditName"
#define RH_GP_PROMOINFO_PREFERENTIALVALUE                                   @"preferentialValue"
#define RH_GP_PROMOINFO_USERID                                              @"userId"

#pragma mark - V3 首页api 分类模型
#define RH_GP_LotteryCategory_APITYPE                                     @"apiType"
#define RH_GP_LotteryCategory_APITYPENAME                                 @"apiTypeName"
#define RH_GP_LotteryCategory_COVER                                       @"cover"
#define RH_GP_LotteryCategory_LOCALE                                      @"locale"
#define RH_GP_LotteryCategory_SITEAPIS                                    @"siteApis"

#pragma mark - v3 彩票游戏API 信息模型
#define RH_GP_LOTTERYAPIINFO_APIID                                 @"apiId"
#define RH_GP_LOTTERYAPIINFO_APITYPEID                             @"apiTypeId"
#define RH_GP_LOTTERYAPIINFO_AUTOPAY                               @"autoPay"
#define RH_GP_LOTTERYAPIINFO_COVER                                 @"cover"
#define RH_GP_LOTTERYAPIINFO_GAMELINK                              @"gameLink"
#define RH_GP_LOTTERYAPIINFO_GAMELIST                              @"gameList"
#define RH_GP_LOTTERYAPIINFO_GAMEMSG                               @"gameMsg"
#define RH_GP_LOTTERYAPIINFO_LOCAL                                 @"local"
#define RH_GP_LOTTERYAPIINFO_NAME                                  @"name"
#define RH_GP_LOTTERYAPIINFO_SITEID                                @"siteId"

#pragma mark - v3 彩票游戏信息模型
#define RH_GP_LOTTERYINFO_APIID                           @"apiId"
#define RH_GP_LOTTERYINFO_APITYPEID                       @"apiTypeId"
#define RH_GP_LOTTERYINFO_AUTOPAY                         @"autoPay"
#define RH_GP_LOTTERYINFO_CODE                            @"code"
#define RH_GP_LOTTERYIINFO_COVER                          @"cover"
#define RH_GP_LOTTERYINFO_GAMEID                          @"gameId"
#define RH_GP_LOTTERYINFO_GAMELINK                        @"gameLink"
#define RH_GP_LOTTERYINFO_GAMEMSG                         @"gameMsg"
#define RH_GP_LOTTERYINFO_GAMETYPE                        @"gameType"
#define RH_GP_LOTTERYINFO_NAME                            @"name"
#define RH_GP_LOTTERYINFO_ORDERNUM                        @"orderNum"
#define RH_GP_LOTTERYINFO_SITEID                          @"siteId"
#define RH_GP_LOTTERYINFO_STATUS                          @"status"
#define RH_GP_LOTTERYINFO_SYSTEMSTATUS                    @"systemStatus"


#pragma mark - V3 用户api 总计Balance 信息模型
#define RH_GP_USERBALANCEGROUP_ASSETS                           @"assets"
#define RH_GP_USERBALANCEGROUP_BALANCE                          @"balance"
#define RH_GP_USERBALANCEGROUP_CURRSIGN                         @"currSign"
#define RH_GP_USERBALANCEGROUP_USERNAME                         @"username"
#define RH_GP_USERBALANCEGROUP_APIS                             @"apis"

#pragma mark - V3 用户api Balance 信息模型
#define RH_GP_USERAPIINFO_APIID                              @"apiId"
#define RH_GP_USERAPIINFO_APINAME                            @"apiName"
#define RH_GP_USERAPIINFO_BALANCE                            @"balance"
#define RH_GP_USERAPIINFO_STATUS                             @"status"


#pragma mark - V3 link 信息模型
#define RH_GP_LINK_CODE                             @"code"
#define RH_GP_LINK_LINK                             @"link"
#define RH_GP_LINK_NAME                             @"name"

#pragma mark - V3 银行信息模型
#define RH_GP_BANK_NAME                             @"text"
#define RH_GP_BANK_CODE                             @"value"

#pragma mark - V3 MINE 信息模型
#define RH_GP_MINEINFO_AVATARURL                               @"avatarUrl"
#define RH_GP_MINEINFO_CURRENCY                                @"currency"
#define RH_GP_MINEINFO_PREFERENTIALAMOUNT                      @"preferentialAmount"
#define RH_GP_MINEINFO_RECOMDAMOUNT                            @"recomdAmount"
#define RH_GP_MINEINFO_TOTALASSETS                             @"totalAssets"
#define RH_GP_MINEINFO_TRANSFERAMOUNT                          @"transferAmount"
#define RH_GP_MINEINFO_UNREADCOUNT                             @"unReadCount"
#define RH_GP_MINEINFO_USERNAME                                @"username"
#define RH_GP_MINEINFO_WALLETBALANCE                           @"walletBalance"
#define RH_GP_MINEINFO_WITHDRAWAMOUNT                          @"withdrawAmount"
#define RH_GP_MINEINFO_LOGINTIME                               @"lastLoginTime"
#define RH_GP_MINEINFO_ISBIT                                   @"isBit"
#define RH_GP_MINEINFO_ISCASH                                  @"isCash"
#define RH_GP_MINEINFO_BANKCARD                                @"bankcard"
#define RH_GP_MINEINFO_BTCCODE                                 @"btc"
#define RH_GP_MINEINFO_REALNAME                                @"realName"

#pragma mark - V3 投注记录 信息模型
#define RH_GP_BETTING_ID                                @"id"
#define RH_GP_BETTING_APIID                             @"apiId"
#define RH_GP_BETTING_APINAME                           @"apiName"
#define RH_GP_BETTING_GAMEID                            @"gameId"
#define RH_GP_BETTING_GAMENAME                          @"gameName"
#define RH_GP_BETTING_TERMINAL                          @"terminal"
#define RH_GP_BETTING_BETTIME                           @"betTime"
#define RH_GP_BETTING_SINGLEAMOUNT                      @"singleAmount"
#define RH_GP_BETTING_PROFITAMOUNT                      @"profitAmount"
#define RH_GP_BETTING_ORDERSTATE                        @"orderState"
#define RH_GP_BETTING_URL                               @"url"

#pragma mark - V3 用户安全码 初始化信息模型
#define RH_GP_USERSAFETY_HASREALNAME                          @"hasRealName"
#define RH_GP_USERSAFETY_HASPERMISSIONPWD                     @"hasPermissionPwd"
#define RH_GP_USERSAFETY_ISOPENCAPTCHA                        @"isOpenCaptcha"
#define RH_GP_USERSAFETY_REMINDTIMES                          @"remindTimes"
#define RH_GP_USERSAFETY_LOCKTIME                             @"lockTime"

#pragma mark - V3 投注详情 模型
#define RH_GP_BETTINGDETAIL_APIID                                 @"apiId"
#define RH_GP_BETTINGDETAIL_APINAME                              @"apiName"
#define RH_GP_BETTINGDETAIL_APITYPEID                            @"apiTypeId"
#define RH_GP_BETTINGDETAIL_BETDETAIL                            @"betDetail"
#define RH_GP_BETTINGDETAIL_BETID                                @"betId"
#define RH_GP_BETTINGDETAIL_BETTIME                              @"betTime"
#define RH_GP_BETTINGDETAIL_BETTYPENAME                          @"betTypeName"
#define RH_GP_BETTINGDETAIL_CONTRIBUTIONAMOUNT                   @"contributionAmount"
#define RH_GP_BETTINGDETAIL_EFFECTIVETRADEAMOUNT                 @"effectiveTradeAmount"
#define RH_GP_BETTINGDETAIL_GAMEID                               @"gameId"
#define RH_GP_BETTINGDETAIL_GAMENAME                             @"gameName"
#define RH_GP_BETTINGDETAIL_GAMETYPE                             @"gameType"
#define RH_GP_BETTINGDETAIL_ODDSTYPENAME                         @"oddsTypeName"
#define RH_GP_BETTINGDETAIL_ORDERSTATE                           @"orderState"
#define RH_GP_BETTINGDETAIL_PAYOUTTIME                           @"payoutTime"
#define RH_GP_BETTINGDETAIL_PROFITAMOUNT                         @"profitAmount"
#define RH_GP_BETTINGDETAIL_RESULTARRAY                          @"resultArray"
#define RH_GP_BETTINGDETAIL_SINGLEAMOUNT                         @"singleAmount"
#define RH_GP_BETTINGDETAIL_TERMINAL                             @"terminal"
#define RH_GP_BETTINGDETAIL_USERNAME                             @"userName"


#pragma mark - V3 资金记录 模型
#define RH_GP_CAPITAL_ID                                @"id"
#define RH_GP_CAPITAL_CREATETIME                        @"createTime"
#define RH_GP_CAPITAL_TRANSACTIONMONEY                  @"transactionMoney"
#define RH_GP_CAPITAL_TRANSACTIONTYPE                   @"transactionType"
#define RH_GP_CAPITAL_TRANSACTION_TYPENAME              @"transaction_typeName"
#define RH_GP_CAPITAL_STATUS                            @"status"
#define RH_GP_CAPITAL_STATUSNAME                        @"statusName"

#pragma mark - V3 资金详情 模型
#define RH_GP_CAPITALDETAIL_ADMINISTRATIVEFEE                    @"administrativeFee"
#define RH_GP_CAPITALDETAIL_CREATETIME                           @"createTime"
#define RH_GP_CAPITALDETAIL_DEDUCTFAVORABLE                      @"deductFavorable"
#define RH_GP_CAPITALDETAIL_FAILUREREASON                        @"failureReason"
#define RH_GP_CAPITALDETAIL_FUNDTYPE                             @"fundType"
#define RH_GP_CAPITALDETAIL_ID                                   @"id"
#define RH_GP_CAPITALDETAIL_PAYERBANKCARD                        @"payerBankcard"
#define RH_GP_CAPITALDETAIL_POUNDAGE                             @"poundage"
#define RH_GP_CAPITALDETAIL_REALNAME                             @"realName"
#define RH_GP_CAPITALDETAIL_RECHARGEADDRESS                      @"rechargeAddress"
#define RH_GP_CAPITALDETAIL_RECHARGEAMOUNT                       @"rechargeAmount"
#define RH_GP_CAPITALDETAIL_RECHARGETOTALAMOUNT                  @"rechargeTotalAmount"
#define RH_GP_CAPITALDETAIL_STATUS                                @"status"
#define RH_GP_CAPITALDETAIL_STATUSNAME                           @"statusName"
#define RH_GP_CAPITALDETAIL_TRANSACTIONMONEY                     @"transactionMoney"
#define RH_GP_CAPITALDETAIL_TRANSACTIONNO                        @"transactionNo"
#define RH_GP_CAPITALDETAIL_TRANSACTIONTYPE                      @"transactionType"
#define RH_GP_CAPITALDETAIL_TRANSACTIONWAY                       @"transactionWay"
#define RH_GP_CAPITALDETAIL_TRANSACTIONWAYNAME                   @"transactionWayName"
#define RH_GP_CAPITALDETAIL_USERNAME                             @"userName"
#define RH_GP_CAPITALDETAIL_TRANSFERINTO                         @"transferInto"
#define RH_GP_CAPITALDETAIL_TRANSFEROUT                          @"transferOut"
#define RH_GP_CAPITALDETAIL_RECHARGEAMOUNT                       @"rechargeAmount"
#define RH_GP_CAPITALDETAIL_WITHDRAWMONEY                        @"withdrawMoney"
#define RH_GP_CAPITALDETAIL_BANKCODENAME                         @"bankCodeName"
#define RH_GP_CAPITALDETAIL_BANKURL                              @"bankUrl"
#define RH_GP_CAPITALDETAIL_TXID                                 @"txId"
#define RH_GP_CAPITALDETAIL_BITCOINADRESS                        @"bitcoinAdress"
#define RH_GP_CAPITALDETAIL_RETURNTIME                           @"returnTime"
#define RH_GP_CAPITALDETAIL_BANKCODE                             @"bankCode"


#pragma mark - V3 银行卡 信息模型
#define RH_GP_BANKCARDINFO_BANKNAME                                 @"bankName"
#define RH_GP_BANKCARDINFO_BANKCODE                                 @"bankNameCode"
#define RH_GP_BANKCARDINFO_BANKCARDMASTERNAME                       @"bankcardMasterName"
#define RH_GP_BANKCARDINFO_BANKCARDNUMBER                           @"bankcardNumber"
#define RH_GP_BANKCARDINFO_BANKDEPOSIT                              @"bankDeposit"
#define RH_GP_BANKCARDINFO_BANKURL                                  @"bankUrl"

#pragma mark - V3 bit币 信息模型
#define RH_GP_BITCODEINFO_BTCNUM                                   @"btcNum"
#define RH_GP_BITCODEINFO_BTCNUMBER                                @"btcNumber"


#pragma mark - V3 添加/保存比特币 模型
#define RH_GP_ADDBTC_ID                  @"id"
#define RH_GP_ADDBTC_USERID              @"userId"
#define RH_GP_ADDBTC_BANKCARDMASTERNAME  @"bankcardMasterName"
#define RH_GP_ADDBTC_BANKCARDNUMBER      @"bankcardNumber"
#define RH_GP_ADDBTC_CREATETIME          @"createTime"
#define RH_GP_ADDBTC_USECOUNT            @"useCount"
#define RH_GP_ADDBTC_USESTAUTS           @"useStauts"
#define RH_GP_ADDBTC_ISDEFAULT           @"isDefault"
#define RH_GP_ADDBTC_BANKNAME            @"bankName"
#define RH_GP_ADDBTC_BANKDEPOSIT         @"bankDeposit"
#define RH_GP_ADDBTC_CUSTOMBANKNAME      @"customBankName"
#define RH_GP_ADDBTC_TYPE                @"type"

#pragma mark - V3 站点信息 系统信息列表 模型
#define RH_GP_SITEMESSAGE_ID            @"id"
#define RH_GP_SITEMESSAGE_CONTENT       @"content"
#define RH_GP_SITEMESSAGE_PUBLISHTIME   @"publishTime"
#define RH_GP_SITEMESSAGE_LINK          @"link"
#define RH_GP_SITEMESSAGE_TITLE         @"title"
#define RH_GP_SITEMESSAGE_READ          @"read"
#define RH_GP_SITEMESSAGE_SEARCHID      @"searchId"

#pragma mark - V3 站点信息 我的消息 模型
#define RH_GP_SITEMESSAGE_MYMESSAGE_ADVISORYCONTENT    @"advisoryContent"
#define RH_GP_SITEMESSAGE_MYMESSAGE_ADVISORYTIME       @"advisoryTime"
#define RH_GP_SITEMESSAGE_MYMESSAGE_ADVISORYTITLE      @"advisoryTitle"
#define RH_GP_SITEMESSAGE_MYMESSAGE_ID                 @"id"
#define RH_GP_SITEMESSAGE_MYMESSAGE_REPLYTITLE         @"replyTitle"
#define RH_GP_SITEMESSAGE_MYMESSAGE_READ               @"read"

#pragma mark - V3 优惠活动Tabbar2 活动模型
#define RH_GP_DISCOUNTACTIVITY_ID                      @"id"
#define RH_GP_DISCOUNTACTIVITY_ACTIVITYKEY             @"activityKey"
#define RH_GP_DISCOUNTACTIVITY_ACTIVITYTYPENAME        @"activityTypeName"
#define RH_GP_DISCOUNTACTIVITY_URL                     @"url"
#define RH_GP_DISCOUNTACTIVITY_PHOTO                   @"photo"
#define RH_GP_DISCOUNTACTIVITY_NAME                    @"name"

#pragma mark - V3 系统公告详情 模型
#define RH_GP_SYSTEMNOTICEDETAIL_ID          @"id"
#define RH_GP_SYSTEMNOTICEDETAIL_CONTENT     @"content"
#define RH_GP_SYSTEMNOTICEDETAIL_PUBLISHTIME @"publishTime"
#define RH_GP_SYSTEMNOTICEDETAIL_LINK        @"link"
#define RH_GP_SYSTEMNOTICEDETAIL_TITLE       @"title"

#pragma mark - V3 发送消息验证接口 模型
#define RH_GP_SENDMESSGAVERITY_ISOPENCAPTCHA          @"isOpenCaptcha"
#define RH_GP_SENDMESSGAVERITY_ADVISORYTYPELIST       @"advisoryTypeList"
#define RH_GP_SENDMESSGAVERITY_CAPTCHA_VALUE          @"captcha_value"
#define RH_GP_SENDMESSGAVERITY_ADVISORYTYPE           @"advisoryType"
#define RH_GP_SENDMESSGAVERITY_ADVISORYNAME           @"advisoryName"

#pragma mark -V3 发送消息返回参数
#define RH_GP_SENDMESSAGESUCCEED_MSG               @"msg"
#define RH_GP_SENDMESSAGESUCCEED_STATE             @"statue"
#define RH_GP_SENDMESSAGESUCCEED_TOKEN             @"token"


#pragma mark - V3 我的消息详情  模型
#define RH_GP_MYMESSAGEDETAIL_ADVISORYCONTENT    @"advisoryContent"
#define RH_GP_MYMESSAGEDETAIL_ADVISORYTIME       @"advisoryTime"
#define RH_GP_MYMESSAGEDETAIL_ADVISORYTITLE      @"advisoryTitle"
#define RH_GP_MYMESSAGEDETAIL_REPLYTIME          @"replyTime"
#define RH_GP_MYMESSAGEDETAIL_REPLYTITLE         @"replyTitle"
#define RH_GP_MYMESSAGEDETAIL_REPLYCONTENT       @"replyContent"
#define RH_GP_MYMESSAGEDETAIL_QUESTIONTYPE        @"questionType"

#pragma mark - V3 取款信息  模型
#define RH_GP_WITHDRAW_AUDITLOGURL                    @"auditLogUrl"
#define RH_GP_WITHDRAW_AUDITMAP                       @"auditMap"
#define RH_GP_WITHDRAW_BANKCARDMAP                    @"bankcardMap"
#define RH_GP_WITHDRAW_CURRENCYSIGN                    @"currencySign"
#define RH_GP_WITHDRAW_HASBANK                    @"hasBank"
#define RH_GP_WITHDRAW_ISBIT                    @"isBit"
#define RH_GP_WITHDRAW_ISCASH                    @"isCash"
#define RH_GP_WITHDRAW_TOKEN                    @"token"
#define RH_GP_WITHDRAW_TOTALBALANCE                    @"totalBalance"

#pragma mark - V3 取款信息-AuditMap模型
#define RH_GP_WITHDRAWAUDITMAP_ACTUALWITHDRAW                @"actualWithdraw"
#define RH_GP_WITHDRAWAUDITMAP_ADMINISTRATIVEFEE             @"administrativeFee"
#define RH_GP_WITHDRAWAUDITMAP_COUNTERFEE                    @"counterFee"
#define RH_GP_WITHDRAWAUDITMAP_DEDUCTFAVORABLE               @"deductFavorable"
#define RH_GP_WITHDRAWAUDITMAP_RECORDLIST                    @"recordList"
#define RH_GP_WITHDRAWAUDITMAP_TRANSACTIONNO                 @"transactionNo"
#define RH_GP_WITHDRAWAUDITMAP_WITHDRAWAMOUNT                @"withdrawAmount"
#define RH_GP_WITHDRAWAUDITMAP_WITHDRAWFEEM                  @"withdrawFeeMoney"

#pragma mark - V3 取款信息-Bankcard模型
#define RH_GP_WITHDRAWBANKCARD_ID                           @"id"
#define RH_GP_WITHDRAWBANKCARD_BANKDEPOSIT                  @"bankDeposit"
#define RH_GP_WITHDRAWBANKCARD_BANKNAME                     @"bankName"
#define RH_GP_WITHDRAWBANKCARD_BANKCARDMASTERNAME           @"bankcardMasterName"
#define RH_GP_WITHDRAWBANKCARD_BANKCARDNUMBER               @"bankcardNumber"
#define RH_GP_WITHDRAWBANKCARD_CUSTOMBANKNAME                   @"customBankName"
#define RH_GP_WITHDRAWBANKCARD_TYPE                             @"type"
#define RH_GP_WITHDRAWBANKCARD_USECOUNT                         @"useCount"
#define RH_GP_WITHDRAWBANKCARD_BANKURL                         @"bankUrl"

#pragma mark - V3 站点信息-系统消息详情-SiteMsgSysMsg模型
#define RH_GP_SITEMSGSYSMSG_CONTENT         @"content"
#define RH_GP_SITEMSGSYSMSG_ID              @"id"
#define RH_GP_SITEMSGSYSMSG_LINK            @"link"
#define RH_GP_SITEMSGSYSMSG_PUBLISHTIME     @"publishTime"
#define RH_GP_SITEMSGSYSMSG_READ            @"read"
#define RH_GP_SITEMSGSYSMSG_SEARCHID        @"searchId"
#define RH_GP_SITEMSGSYSMSG_TITLE           @"title"


#pragma mark -
#pragma mark - 回收接口
//api的路径
#define RH_API_NAME_APIRETRIVE                        @"transfer/auto/recovery.html"
//请求参数
#define RH_SP_APIRETRIVE_APIID                        @"search.apiId"

#pragma mark - 域名 check失败，上传接口
//api的路径
#define RH_API_NAME_COLLECTAPPERROR                        @"facade/collectAppDomainError.html"
//请求参数
#define RH_SP_COLLECTAPPERROR_MARK                       @"mark"
#define RH_SP_COLLECTAPPERROR_SITEID                       @"siteId"
#define RH_SP_COLLECTAPPERROR_USERNAME                     @"username"
#define RH_SP_COLLECTAPPERROR_LASTLOGINTIME                @"lastLoginTime"
#define RH_SP_COLLECTAPPERROR_DOMAIN                       @"domain"
#define RH_SP_COLLECTAPPERROR_IP                          @"ip"
#define RH_SP_COLLECTAPPERROR_ERRORMESSAGE                @"errorMessage"
#define RH_SP_COLLECTAPPERROR_CODE                        @"code"
#define RH_SP_COLLECTAPPERROR_MARK                        @"mark"
#define RH_SP_COLLECTAPPERROR_TYPE                         @"type"
#define RH_SP_COLLECTAPPERROR_VERSIONNAME                 @"versionName"
#define RH_SP_COLLECTAPPERROR_CHANNEL                       @"channel"
#define RH_SP_COLLECTAPPERROR_SYSCODE                       @"sysCode"
#define RH_SP_COLLECTAPPERROR_BRANDS                        @"brands"
#define RH_SP_COLLECTAPPERROR_MODEL                         @"model"


#pragma mark - V3
//===========================================================
//v3接口定义
//===========================================================
#pragma mark- v3 首页入口
//api的路径
#define RH_API_NAME_HOMEINFO                        @"mobile-api/origin/mainIndex.html"
//请求参数 无

//返回参数
#define RH_GP_HOMEINFO_ACTIVITY                        @"activity"
#define RH_GP_HOMEINFO_ANNOUNCEMENT                      @"announcement"
#define RH_GP_HOMEINFO_BANNER                            @"banner"
#define RH_GP_HOMEINFO_SITEAPIRELATION                        @"siteApiRelation"

#pragma mark- v3 用户信息 接口
//api的路径
#define RH_API_NAME_USERINFO                        @"mobile-api/userInfoOrigin/getUserInfo.html"
//请求参数 无

#pragma mark- v3 我的 接口
//api的路径
#define RH_API_NAME_MINEGROUPINFO                        @"mobile-api/mineOrigin/getLink.html"
//请求参数 无
//返回参数
#define RH_GP_MINEGROUPINFO_ISBIT                          @"isBit"
#define RH_GP_MINEGROUPINFO_ISCASH                         @"isCash"
#define RH_GP_MINEGROUPINFO_LINK                           @"link"
#define RH_GP_MINEGROUPINFO_USER                           @"user"

#pragma mark - V3  浮动图抢红包次数
//api的路径
#define RH_API_NAME_ACTIVITYSTATUS                        @"mobile-api/activityOrigin/countDrawTimes.html"
//请求参数
#define RH_SP_ACTIVITYSTATUS_MESSAGEID                    @"activityMessageId"
//返回参数
#define RH_GP_ACTIVITYSTATUS_ISEND                        @"isEnd"
#define RH_GP_ACTIVITYSTATUS_DRAWTIMES                    @"drawTimes"
#define RH_GP_ACTIVITYSTATUS_NEXTLOTTERYTIME              @"nextLotteryTime"
#define RH_GP_ACTIVITYSTATUS_TOKEN                        @"token"

#pragma mark - V3 拆红包
/**
 api的路径
 */
#define RH_API_NAME_OPENACTIVITY                        @"mobile-api/activityOrigin/getPacket.html"
//请求参数
#define RH_SP_OPENACTIVITY_MESSAGEID                    @"activityMessageId"
#define RH_SP_OPENACTIVITY_TOKEN                        @"gb.token"
//返回参数
#define RH_GP_OPENACTIVITY_AWARD                        @"award"
#define RH_GP_OPENACTIVITY_GAMENUM                      @"gameNum"
#define RH_GP_OPENACTIVITY_NEXTLOTTERYTIME              @"nextLotteryTime"
#define RH_GP_OPENACTIVITY_TOKEN                        @"token"
#define RH_GP_OPENACTIVITY_ID                           @"id"
#define RH_GP_OPENACTIVITY_APPLYID                      @"applyId"
#define RH_GP_OPENACTIVITY_RECORDID                     @"recordId"

#pragma mark - V3 电子游戏清单 接口
//api的路径
#define RH_API_NAME_APIGAMELIST                        @"mobile-api/origin/getCasinoGame.html"
//请求参数 无
#define RH_SP_APIGAMELIST_APIID                          @"search.apiId"
#define RH_SP_APIGAMELIST_APITYPEID                      @"search.apiTypeId"
#define RH_SP_APIGAMELIST_PAGENUMBER                     @"paging.pageNumber"
#define RH_SP_APIGAMELIST_PAGESIZE                       @"paging.pageSize"
#define RH_SP_APIGAMELIST_NAME                           @"search.name"
#define RH_SP_APIGAMELIST_TAGID                           @"tagId"
//返回参数
#define RH_GP_APIGAMELIST_LIST                           @"casinoGames"
//#define RH_GP_APIGAMELIST_TOTALCOUNT                           @"totalCount"
#define RH_GP_APIGAMELIST_TOTALCOUNT                           @"pageTotal"

#pragma mark -v3 投注记录 清单
//api的路径
#define RH_API_NAME_BETTINGLIST                        @"mobile-api/mineOrigin/getBettingList.html"
//请求参数 无
#define RH_SP_BETTINGLIST_STARTDATE                          @"search.beginBetTime"
#define RH_SP_BETTINGLIST_ENDDATE                            @"search.endBetTime"
#define RH_SP_BETTINGLIST_PAGENUMBER                         @"paging.pageNumber"
#define RH_SP_BETTINGLIST_PAGESIZE                           @"paging.pageSize"
#define RH_SP_BETTINGLIST_ISSHOWSTATISTICS                   @"isShowStatistics"

//返回参数
#define RH_GP_BETTINGLIST_LIST                              @"list"
#define RH_GP_BETTINGLIST_TOTALCOUNT                        @"totalSize"
#define RH_GP_BETTINGLIST_TOTALSINGLEAMOUN                  @"singleAmount"
#define RH_GP_BETTINGLIST_TOTALPROFIT                       @"profit"
#define RH_GP_BETTINGLIST_STATISTICSDATA                   @"statisticsData"
#define RH_GP_BETTINGLIST_STATISTICSDATA_EFFECTIVE          @"effective"
#define RH_GP_BETTINGLIST_STATISTICSDATA_PROFIT            @"profit"
#define RH_GP_BETTINGLIST_TOTALSINGLE                      @"single"


#pragma mark -v3    投注记录明细
//api路径
#define RH_API_NAME_BETTINGDETAILS                     @"mobile-api/mineOrigin/getBettingDetails.html"
//请求参数
#define RH_SP_BETTINGDETAILS_LISTID                     @"id"
//返回参数

#pragma mark -V3 资金记录 清单
//api的路径
#define RH_API_NAME_DEPOSITLIST                        @"mobile-api/mineOrigin/getFundRecord.html"
//请求参数
#define RH_SP_DEPOSITLIST_STARTDATE                     @"search.beginCreateTime"
#define RH_SP_DEPOSITLIST_ENDDATE                       @"search.endCreateTime"
#define RH_SP_DEPOSITLIST_TYPE                          @"search.transactionType"
#define RH_SP_DEPOSITLIST_PAGENUMBER                    @"paging.pageNumber"
#define RH_SP_DEPOSITLIST_PAGESIZE                      @"paging.pageSize"
//返回参数
#define RH_GP_DEPOSITLIST_LIST               @"fundListApps"
#define RH_GP_DEPOSITLIST_TRANSFERSUM            @"transferSum"
#define RH_GP_DEPOSITLIST_WITHDRAWSUM            @"withdrawSum"
#define RH_GP_DEPOSITLIST_TOTALCOUNT            @"totalCount"
#define RH_GP_DEPOSITLIST_SUMPLAYERMAP            @"sumPlayerMap"
#define RH_GP_DEPOSITLIST_SUMPLAYERMAP_FAVORABLE            @"favorable"
#define RH_GP_DEPOSITLIST_SUMPLAYERMAP_REKEBACK            @"rakeback"
#define RH_GP_DEPOSITLIST_SUMPLAYERMAP_RECHARGE            @"recharge"
#define RH_GP_DEPOSITLIST_SUMPLAYERMAP_WITHDRAW            @"withdraw"

/**
    资金记录下拉列表
 */
#pragma mark 资金记录下拉列表
//api路径
#define RH_API_NAME_DEPOSITPULLDOWNLIST                 @"mobile-api/mineOrigin/getTransactionType.html"
//请求参数
//返回参数

/**资金详情*/
#pragma mark -V3  资金记录详情
//api路径
#define RH_API_NAME_DEPOSITLISTDETAILS               @"mobile-api/mineOrigin/getFundRecordDetails.html"
//请求参数
#define RH_SP_DEPOSITLISTDETAILS_SEARCHID            @"searchId"


#pragma mark -V3 用户安全码初始化信息
//api的路径
#define RH_API_NAME_USERSAFEINFO                        @"mobile-api/mineOrigin/initSafePassword.html"
//请求参数 无
#pragma mark -V3 设置真实姓名
//API的路径
#define RH_API_NAME_SETREALNAME                         @"mobile-api/mineOrigin/setRealName.html"
//请求参数
#pragma mark -V3 修改安全密码接口
//api路径
#define RH_API_NAME_UPDATESAFEPASSWORD                    @"mobile-api/mineOrigin/updateSafePassword.html"
//请求参数
#define RH_SP_UPDATESAFEPASSWORD_REALNAME                     @"realName"
#define RH_SP_UPDATESAFEPASSWORD_ORIGINPWD                     @"originPwd"
#define RH_SP_UPDATESAFEPASSWORD_NEWPWD                       @"pwd1"
#define RH_SP_UPDATESAFEPASSWORD_CONFIRMPWD                       @"pwd2"
#define RH_SP_UPDATESAFEPASSWORD_VERIFYCODE                       @"code"

//返回参数
#define RH_GP_UPDATESAFEPASSWORD_ISOPENCAPTCHA              @"isOpenCaptcha"
#define RH_GP_UPDATESAFEPASSWORD_REMAINTIMES                @"remainTimes"

#pragma mark - V3 修改用户密码
#define RH_API_NAME_MINEMODIFYPASSWORD                   @"mobile-api/mineOrigin/updateLoginPassword.html"
//请求参数
#define RH_SP_MINEMODIFYPASSWORD_OLDPASSWORD                     @"password"
#define RH_SP_MINEMODIFYPASSWORD_NEWPASSWORD                     @"newPassword"
#define RH_SP_MINEMODIFYPASSWORD_PASSWORDCODE                     @"code"

//返回参数
#define RH_GP_MINEMODIFYPASSWORD_ISOPENCAPTCHA              @"isOpenCaptcha"
#define RH_GP_MINEMODIFYPASSWORD_REMAINTIMES                @"remainTimes"

#pragma mark - V3 添加银行卡
#define RH_API_NAME_ADDBANKCARD             @"mobile-api/userInfoOrigin/submitBankCard.html"
//请求参数
#define RH_SP_BANKCARDMASTERNAME        @"result.bankcardMasterName"
#define RH_SP_BANKNAME                  @"result.bankName"
#define RH_SP_BANKCARDNUMBER            @"result.bankcardNumber"
#define RH_SP_BANKDEPOSIT               @"result.bankDeposit"

//返回参数-无

#pragma mark - V3 获取安全密码验证码
#define RH_API_NAME_SAFETYCAPCHA             @"captcha/securityPwd.html"
//请求参数 -无

#pragma mark - V3 优惠记录列表
#define RH_API_NAME_PROMOLIST             @"mobile-api/mineOrigin/getMyPromo.html"
//请求参数
#define RH_SP_PROMOLIST_PAGESIZE                     @"paging.pageSize"
#define RH_SP_PROMOLIST_PAGENUMBER                     @"paging.pageNumber"
//返回参数
#define RH_GP_PROMOLIST_LIST              @"list"
#define RH_GP_PROMOLIST_TOTALCOUNT        @"totalCount"

#pragma mark - V3 系统公告
#define RH_API_NAME_SYSTEMNOTICE        @"mobile-api/mineOrigin/getSysNotice.html"
//请求参数
#define RH_SP_SYSTEMNOTICE_STARTTIME    @"search.startTime"
#define RH_SP_SYSTEMNOTICE_ENDTIME      @"search.endTime"
#define RH_SP_SYSTEMNOTICE_PAGENUMBER   @"paging.pageNumber"
#define RH_SP_SYSTEMNOTICE_PAGESIZE     @"paging.pageSize"

//返回参数
#define RH_GP_SYSTEMNOTICE_LIST        @"list"
#define RH_GP_SYSTEMNOTICE_TOTALNUM    @"pageTotal"

#pragma mark - V3 系统公告详情
#define RH_API_NAME_SYSTEMNOTICEDETAIL       @"mobile-api/mineOrigin/getSysNoticeDetail.html"
//请求参数
#define RH_SP_SYSTEMNOTICEDETAIL_SEARCHID    @"searchId"


#pragma mark - V3 游戏公告
#define RH_API_NAME_GAMENOTICE           @"mobile-api/mineOrigin/getGameNotice.html"
//请求参数
#define RH_SP_GAMENOTICE_STARTTIME    @"search.startTime"
#define RH_SP_GAMENOTICE_ENDTIME      @"search.endTime"
#define RH_SP_GAMENOTICE_APIID        @"search.apiId"
#define RH_SP_GAMENOTICE_PAGENUMBER   @"paging.pageNumber"
#define RH_SP_GAMENOTICE_PAGESIZE     @"paging.pageSize"


//返回参数
#define RH_GP_GAMENOTICE_LIST        @"list"
#define RH_GP_GAMENOTICE_PAGETOTAL   @"pageTotal"


#pragma mark - V3 游戏公告详情
#define RH_API_NAME_GAMENOTICEDETAIL           @"mobile-api/mineOrigin/getGameNoticeDetail.html"
//请求参数
#define RH_SP_GAMENOTICEDETAIL_SEARCHID    @"searchId"

//返回参数
#define RH_GP_GAMENOTICEDETAIL_PAGETOTAL   @"pageTotal"


#pragma mark - V3 一键回收
#define RH_API_NAME_ONESTEPRECOVERY          @"mobile-api/mineOrigin/recovery.html"
//请求参数
#define RH_SP_ONESTEPRECOVERY_SEARCHAPIID         @"search.apiId"

#pragma mark - V3 添加比特币
#define RH_API_NAME_ADDBTC                  @"mobile-api/userInfoOrigin/submitBtc.html"
//请求参数
#define RH_SP_ADDBTC_BANKCARDNUMBER          @"result.bankcardNumber"
//返回bit 模型

#pragma mark - V3 站点信息 系统信息列表
#define RH_API_NAME_SITEMESSAGE              @"mobile-api/mineOrigin/getSiteSysNotice.html"
//请求参数
#define RH_SP_SITEMESSAGE_PAGINGPAGENUMBER   @"paging.pageNumber"
#define RH_SP_SITEMESSAGE_PAGINGPAGESIZE   @"paging.pageSize"
//返回参数
#define RH_GP_SITEMESSAGE_PAGETOTALNUM   @"pageTotal"


#pragma mark - V3 站点信息 系统信息列表详情
#define RH_API_NAME_SITEMESSAGEDETAIL               @"mobile-api/mineOrigin/getSiteSysNoticeDetail.html"
//请求参数
#define RH_SP_SITEMESSAGEDETAIL_SEARCHID   @"searchId"


#pragma mark - V3 站点信息 系统信息标记为已读

#define RH_API_NAME_SITEMESSAGEREDAYES   @"mobile-api/mineOrigin/setSiteSysNoticeStatus.html"
//请求参数
#define RH_SP_SITEMESSAGEREDAYES_IDS   @"ids"


#pragma mark - V3 站点信息 系统信息删除
#define RH_API_NAME_SITEMESSAGEDELETE   @"mobile-api/mineOrigin/deleteSiteSysNotice.html"
//请求参数
#define RH_SP_SITEMESSAGEDELETE_IDS   @"ids"

#pragma mark - V3 站点消息  发送消息验证
#define RH_API_NAME_ADDAPPLYDISCOUNTSVERIFY     @"mobile-api/mineOrigin/getNoticeSiteType.html"

#pragma mark - V3 站点消息  发送消息
#define RH_API_NAME_ADDAPPLYDISCOUNTS           @"mobile-api/mineOrigin/addNoticeSite.html"
//请求参数
#define RH_SP_ADDAPPLYDISCOUNTS_RESULTADVISORYTYPE      @"result.advisoryType"
#define RH_SP_ADDAPPLYDISCOUNTS_RESULTADVISORYTITLE     @"result.advisoryTitle"
#define RH_SP_ADDAPPLYDISCOUNTS_RESULTADVISORYCONTENT   @"result.advisoryContent"
#define RH_SP_ADDAPPLYDISCOUNTS_CODE                    @"code"

#pragma mark - V3 站点信息  我的消息
#define RH_API_NAME_SITEMESSAGE_MYMESSAGE   @"mobile-api/mineOrigin/advisoryMessage.html"
//请求参数
#define RH_SP_SITEMESSAGE_MYMESSAGE_PAGENUMBER  @"paging.pageNumber"
#define RH_SP_SITEMESSAGE_MYMESSAGE_PAGESIZE    @"paging.pageSize"

#pragma mark - V3 站点信息  我的消息详情
#define RH_API_NAME_SITEMESSAGE_MYMESSAGEDETAIL  @"mobile-api/mineOrigin/advisoryMessageDetail.html"
//请求参数
#define RH_SP_SITEMESSAGE_MYMESSAGEDETAIL_ID       @"id"

#pragma mark - V3 站点信息 我的信息标记为已读

#define RH_API_NAME_MYMESSAGEREDAYES     @"mobile-api/mineOrigin/getSelectAdvisoryMessageIds.html"
//请求参数
#define RH_SP_MYMESSAGEREDAYES_IDS   @"ids"


#pragma mark - V3 站点信息 我的信息删除
#define RH_API_NAME_MYMESSAGEDELETE   @"mobile-api/mineOrigin/deleteAdvisoryMessage.html"
//请求参数
#define RH_SP_MYMESSAGEDELETE_IDS   @"ids"


#pragma mark - V3 Tabbar 优惠主页面 优惠活动类型
#define RH_API_NAME_TABBAR2_GETACTIVITYTYPE_DISCOUNTS   @"mobile-api/discountsOrigin/getActivityType.html"

#pragma mark - V3 Tabbar 优惠主页面 优惠活动类别
#define RH_API_NAME_ACTIVITYDATALIST        @"mobile-api/discountsOrigin/getActivityTypeList.html"
//请求参数
#define RH_SP_ACTIVITYDATALIST_SEARCHKEY          @"search.activityClassifyKey"
#define RH_SP_ACTIVITYDATALIST_PAGENUMBER         @"paging.pageNumber"
#define RH_SP_ACTIVITYDATALIST_PAGESIZE           @"paging.pageSize"
//返回参数
#define RH_GP_ACTIVITYDATALIST_LIST                 @"list"
#define RH_GP_ACTIVITYDATALIST_TOTALNUMBER           @"total"

#pragma mark - V3 首页 获取游戏 link url
#define RH_API_NAME_GAMESLINK                    @"mobile-api/origin/getGameLink.html"
//请求参数
#define RH_SP_GAMESLINK_APIID                   @"apiId"
#define RH_SP_GAMESLINK_APITYPEID              @"apiTypeId"
#define RH_SP_GAMESLINK_GAMEID                @"gameId"
#define RH_SP_GAMESLINK_GAMECODE                @"gameCode"
//返回参数
#define RH_GP_GAMESLINK_LINKURL                 @"gameLink"
#define RH_GP_GAMESLINK_MESSAGE                 @"gameMsg"

#pragma mark - V3 退出登录
#define RH_API_NAME_LOGINOUT                @"mobile-api/mineOrigin/logout.html"

#pragma mark -V3 获取取款用户信息
#define RH_API_NAME_GETWITHDRAWUSERINFO         @"mobile-api/withdrawOrigin/getWithDraw.html"

#pragma mark -V3 提交取款信息
#define RH_API_NAME_SUBMITWITHDRAWINFO          @"mobile-api/withdrawOrigin/submitWithdraw.html"

//请求参数
#define RH_SP_SUBMITWITHDRAWINFO_WITHDRAWAMOUNT     @"withdrawAmount"
#define RH_SP_SUBMITWITHDRAWINFO_GBTOKEN            @"gb.token"
#define RH_SP_SUBMITWITHDRAWINFO_REMITTANCEWAY       @"remittanceWay"
#define RH_SP_SUBMITWITHDRAWINFO_ORIGINPWD           @"originPwd"


#pragma mark -V3 获取游戏分类
#define RH_API_NAME_LOADGAMETYPE                @"mobile-api/origin/getGameTag.html"
//请求参数
#define RH_SP_LOADGAMETYPE_SEARCH_APIID          @"search.apiId"
#define RH_SP_LOADGAMETYPE_SEARCH_APITYPEID      @"search.apiTypeId"
//返回参数
#define RH_GP_LOADGAMETYPE_KEY                  @"key"
#define RH_GP_LOADGAMETYPE_VALUE                @"value"

#pragma mark -V3 取款安全密码验证
#define RH_API_NAME_WITHDRWASAFETYPASSWORDAUTH                   @"mobile-api/mineOrigin/checkSafePassword.html"
// 请求参数
#define RH_GP_WITHDRWASAFETYPASSWORDAUTH_SAFETYPASSWORD           @"originPwd"

#pragma mark - V3 获取手续费信息得到最终取款金额
#define RH_API_NAME_WITHDRWAFEE                   @"mobile-api/withdrawOrigin/withdrawFee.html"
//请求参数
#define RH_SP_WITHDRWAFEE_AMOUNT                  @"withdrawAmount"

#pragma mark - V3 获取站点时区接口
#define RH_API_NAME_TIMEZONEINFO                   @"mobile-api/origin/getTimeZone.html"

#pragma mark -- V3 获取消息中心-站点信息未读消息条数
#define RH_API_NAME_SITEMESSAGUNREADCOUNT        @"mobile-api/mineOrigin/getUnReadCount.html"

#pragma mark -- V3 分享
#define RH_API_NAME_SHAREPLAYERRECOMMEND          @"mobile-api/mineOrigin/getUserPlayerRecommend.html"

//返回参数
#define RH_GP_SHAREPLAYERRECOMMEND_REWARD              @"reward"
#define RH_GP_SHAREPLAYERRECOMMEND_SIGN                @"sign"
#define RH_GP_SHAREPLAYERRECOMMEND_RECOMMEND           @"recommend"
#define RH_GP_SHAREPLAYERRECOMMEND_COUNT               @"count"
#define RH_GP_SHAREPLAYERRECOMMEND_USER                @"user"
#define RH_GP_SHAREPLAYERRECOMMEND_BOUNDS              @"bonus"
#define RH_GP_SHAREPLAYERRECOMMEND_SINGLE              @"single"
#define RH_GP_SHAREPLAYERRECOMMEND_CODE                @"code"
#define RH_GP_SHAREPLAYERRECOMMEND_THEWAY              @"theWay"
#define RH_GP_SHAREPLAYERRECOMMEND_MONEY               @"money"
#define RH_GP_SHAREPLAYERRECOMMEND_WITCHWITHDRAW       @"witchWithdraw"
#define RH_GP_SHAREPLAYERRECOMMEND_THEWAY              @"theWay"
#define RH_GP_SHAREPLAYERRECOMMEND_ISBOUNDS            @"isBonus"
#define RH_GP_SHAREPLAYERRECOMMEND_GRADIENTTEMPARRAYLIST      @"gradientTempArrayList"
#define RH_GP_SHAREPLAYERRECOMMEND_ID                   @"id"
#define RH_GP_SHAREPLAYERRECOMMEND_PROPORTION           @"proportion"
#define RH_GP_SHAREPLAYERRECOMMEND_PLAYERNUM            @"playerNum"
#define RH_GP_SHAREPLAYERRECOMMEND_ACTIVITYRULES        @"activityRules"

#pragma mark ==============分享好友记录================
#define RH_API_NAME_GETPLAYERRECOMMENDRECORD          @"mobile-api/mineOrigin/getPlayerRecommendRecord.html"
//请求参数
#define RH_SP_GETPLAYERRECOMMENDRECORD_STARTTIME           @"search.startTime"
#define RH_SP_GETPLAYERRECOMMENDRECORD_ENDTIME             @"search.endTime"
#define RH_SP_GETPLAYERRECOMMENDRECORD_PAGENUMBER          @"paging.pageNumber"
#define RH_SP_GETPLAYERRECOMMENDRECORD_PAGESIZE            @"paging.pageSize"
//返回参数
#define RH_GP_GETPLAYERRECOMMENDRECORD_COMMAND              @"command"
#define RH_GP_GETPLAYERRECOMMENDRECORD_RECOMMENDUSERNAME    @"recommendUserName"
#define RH_GP_GETPLAYERRECOMMENDRECORD_CREATETIME           @"createTime"
#define RH_GP_GETPLAYERRECOMMENDRECORD_STATUS               @"status"
#define RH_GP_GETPLAYERRECOMMENDRECORD_REWARDAMOUNT         @"rewardAmount"



#pragma mark - V3 老用户登录验证
#define RH_API_NAME_OLDUSERVERIFYREALNAMEFORAPP        @"mobile-api/userInfoOrigin/verifyRealNameForApp.html"
//请求参数
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_TOKEN                           @"gb.token"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_RESULTREALNAME                  @"result.realName"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_NEEDREALNAME                    @"needRealName"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_RESULTPLAYERACCOUNT             @"result.playerAccount"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_SEARCHACCOUNT                   @"search.playerAccount"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_TEMPPASS                        @"tempPass"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_NEWPASSWORD                     @"newPassword"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_PASSLEVEL                       @"passLevel"

#pragma mark - V3 获取用户资产信息接口 
#define RH_API_NAME_GETUSERASSERT  @"mobile-api/userInfoOrigin/getUserAssert.html"

#pragma mark - V3 刷新session 防掉线
#define RH_API_NAME_REFRESHLOGINSTATUS  @"/mobile-api/mineOrigin/alwaysRequest.html"

#pragma mark - V3 用户进入登录页面验证码是否开启
#define RH_API_NAME_ISOPENCODEVERIFTY         @"mobile-api/mineOrigin/loginIsOpenVerify.html"

#pragma mark - V3 注册初始化
#define RH_API_NAME_REGISESTINIT        @"mobile-api/registerOrigin/getRegisterInfo.html"

#pragma mark - v3 注册验证码
#define RH_API_NAME_REGISESTCAPTCHACODE        @"captcha/pmregister.html"


#pragma mark - V3 注册提交
#define RH_API_NAME_REGISESTSUBMIT        @"mobile-api/registerOrigin/save.html"
//请求参数
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_BIRTHDAY                           @"sysUser.birthday"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_SEX                                @"sysUser.sex"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_PERMISSIONPWD                      @"sysUser.permissionPwd"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_DEFAULTTIMEZONE                    @"sysUser.defaultTimezone"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_DEFAULTLOCALE                      @"sysUser.defaultLocale"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_PHONECONTACTVALUE                  @"phone.contactValue"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_REALNAME                           @"sysUser.realName"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_DEFAULTCURRENCY                    @"sysUser.defaultCurrency"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_PASSWORD                           @"sysUser.password"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_QUESTION                           @"sysUserProtection.question1"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_EMAILCONTACTVALUE                  @"email.contactValue"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_QQCONTACTVALUE                     @"qq.contactValue"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_WEIXINCONTACTVALUE                 @"weixin.contactValue"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_USERNAME                           @"sysUser.username"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_CAPCHACODE                         @"captchaCode"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_RECOMMENDREGISTERCODE              @"recommendRegisterCode"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_EDITTYPE                           @"editType"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_RECOMMENDUSERINPUTCODE             @"recommendUserInputCode"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_CONFIRMPASSWORD                    @"confirmPassword"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_CONFIRMPERMISSIONPWD               @"confirmPermissionPwd"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_SYSUSERPROTECTIONANSWER            @"sysUserProtection.answer1"
#define RH_SP_OLDUSERVERIFYREALNAMEFORAPP_TERMOFSERVICE                      @"termsOfService"

#pragma mark - V3 注册条款
#define RH_API_NAME_REGISESTTERMS        @"mobile-api/origin/terms.html"

#pragma mark - V3  关于我们
#define RH_API_NAME_ABOUTUS        @"mobile-api/origin/about.html"

#pragma mark - V3  常见问题父级分类
#define RH_API_NAME_HELPFIRSTTYPE        @"mobile-api/origin/helpFirstType.html"

#pragma mark - V3  常见问题二级分类
#define RH_API_NAME_HELPSECONDTYPE        @"mobile-api/origin/secondType.html"
//请求参数
#define RH_SP_HELPSECONDTYPE_SEARCHID     @"searchId"

#pragma mark - V3 存款
#define RH_API_DEPOSITE_DEPOSITEORIGIN   @"mobile-api/depositOrigin/index.html"
//返回参数
#define RH_GP_DEPOSITEORIGIN_CODE                   @"code"
#define RH_GP_DEPOSITEORIGIN_NAME                   @"name"
#define RH_GP_DEPOSITEORIGIN_ICOURL                 @"iconUrl"

//存款渠道初始化
#pragma mark --V3 存款渠道初始化
#define RH_API_DEPOSITE_DEPOSITEORIGINCHANNEL       @"mobile-api/depositOrigin/"
//返回参数
#define RH_GP_DEPOSITEORIGINCHANNEL_CURRENCY            @"currency"
#define RH_GP_DEPOSITEORIGINCHANNEL_CUSTOMERSERVICE     @"customerService"
#define RH_GP_DEPOSITEORIGINCHANNEL_ARRAYLIST           @"arrayList"
#define RH_GP_DEPOSITEORIGINCHANNEL_COUNTERRECHARGETYPES    @"counterRechargeTypes"
#define RH_GP_DEPOSITEORIGINCHANNEL_ID                  @"id"
#define RH_GP_DEPOSITEORIGINCHANNEL_PAYNAME             @"payName"
#define RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNT             @"account"
#define RH_GP_DEPOSITEORIGINCHANNEL_FULLNAME            @"fullName"
#define RH_GP_DEPOSITEORIGINCHANNEL_CODE                @"code"
#define RH_GP_DEPOSITEORIGINCHANNEL_TYPE                @"type"
#define RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNTTYPE         @"accountType"
#define RH_GP_DEPOSITEORIGINCHANNEL_BANKCODE            @"bankCode"
#define RH_GP_DEPOSITEORIGINCHANNEL_BANKNAME            @"bankName"
#define RH_GP_DEPOSITEORIGINCHANNEL_SINGLEDEPOSITEMIN   @"singleDepositMin"
#define RH_GP_DEPOSITEORIGINCHANNEL_SINGLEDEPOSITEMAX   @"singleDepositMax"
#define RH_GP_DEPOSITEORIGINCHANNEL_OPENACOUNTNAME      @"openAcountName"
#define RH_GP_DEPOSITEORIGINCHANNEL_QRCODEURL           @"qrCodeUrl"
#define RH_GP_DEPOSITEORIGINCHANNEL_REMARK              @"remark"
#define RH_GP_DEPOSITEORIGINCHANNEL_RANDOMAMOUNT        @"randomAmount"
#define RH_GP_DEPOSITEORIGINCHANNEL_ALIASNAME           @"aliasName"
#define RH_GP_DEPOSITEORIGINCHANNEL_CUSTOMBANKNAME      @"customBankName"
#define RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNTINFOEMATION  @"accountInformation"
#define RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNTPROMPT       @"accountPrompt"
#define RH_GP_DEPOSITEORIGINCHANNEL_RECHARGETYPE        @"rechargeType"
#define RH_GP_DEPOSITEORIGINCHANNEL_DEPOSITWAY          @"depositWay"
#define RH_GP_DEPOSITEORIGINCHANNEL_PAYTYPE             @"payType"
#define RH_GP_DEPOSITEORIGINCHANNEL_SEARCHID            @"searchId"
#define RH_GP_DEPOSITEORIGINCHANNEL_IMGURL              @"imgUrl"
#define RH_GP_DEPOSITEORIGINCHANNEL_QUICKMONEYS         @"quickMoneys"
#define RH_GP_DEPOSITEORIGINCHANNEL_PAYERBANKCARD       @"payerBankcard"
#define RH_GP_DEPOSITEORIGINCHANNEL_HIDE                @"hide"
#define RH_GP_DEPOSITEORIGINCHANNEL_MULTIPLEACCOUNT     @"multipleAccount"
#define RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNTIMG          @"accountImg"
#define RH_GP_DEPOSITEORIGINCHANNEL_NEWACTIVITY         @"newActivity"

#define RH_GP_DEPOSITECOUNTER_CODE                      @"code"
#define RH_GP_DEPOSITECOUNTER_NAME                      @"name"


#pragma mark - V3  常见问题详情
#define RH_API_NAME_HELPDETAIL        @"mobile-api/origin/helpDetail.html"

#pragma mark - V3 存款获取优惠
#define RH_API_NAME_DEPOSITESEACHSALE               @"mobile-api/depositOrigin/seachSale.html"
//请求参数
#define RH_SP_DEPOSITESEACHSALE_RECHARGEAMOUNT      @"result.rechargeAmount"
#define RH_SP_DEPOSITESEACHSALE_DEPOSITEWAY         @"depositWay"
#define RH_SP_DEPOSITESEACHSALE_PAYACCOUNTID        @"account"
#define RH_SP_DEPOSITESEACHSALE_RESULTBANKORDER     @"result.bankOrder"
#define RH_SP_DEPOSITESEACHSALE_RESULTBITAMOUNT     @"result.bitAmount"
//返回参数
#define RH_GP_DEPOSITESEACHSALE_MSG                 @"msg"
#define RH_GP_DEPOSITESEACHSALE_FEE                 @"fee"
#define RH_GP_DEPOSITESEACHSALE_COUNTERFEE          @"counterFee"
#define RH_GP_DEPOSITESEACHSALE_FAILURECOUNT        @"failureCount"

#define RH_GP_DEPOSITESEACHSALE_SALES                    @"sales"
#define RH_GP_DEPOSITESEACHSALE_ID                  @"id"
#define RH_GP_DEPOSITESEACHSALE_PREFERENTIAL        @"preferential"
#define RH_GP_DEPOSITESEACHSALE_ACTIVITYNAME        @"activityName"
#pragma mark - V3  非免转额度转换初始化
#define RH_API_NAME_GETNOAUTOTRANSFERINFO        @"mobile-api/userInfoOrigin/getNoAutoTransferInfo.html"

#pragma mark - V3  非免转额度转换提交
#define RH_API_NAME_SUBTRANSFERMONEY       @"mobile-api/userInfoOrigin/transfersMoney.html"
//请求参数
#define RH_SP_SUBTRANSFERMONEY_TOKEN                                 @"gb.token"
#define RH_SP_SUBTRANSFERMONEY_TRANSFEROUT                           @"transferOut"
#define RH_SP_SUBTRANSFERMONEY_TRANSFERINTO                          @"transferInto"
#define RH_SP_SUBTRANSFERMONEY_TRANSFERAMOUNT                        @"result.transferAmount"

#pragma mark - V3  非免转额度转换异常再次请求
#define RH_API_NAME_RECONNECTTRANSFER        @"mobile-api/userInfoOrigin/reconnectTransfer.html"
//请求参数
#define RH_SP_SUBTRANSFERMONEY_TRANSACTIONNO                  @"search.transactionNo" //失败的orderId
#define RH_SP_SUBTRANSFERMONEY_TOKEN                           @"gb.token" //token

#pragma mark - V3  非免转刷新单个
#define RH_API_NAME_REFRESHAPI        @"mobile-api/userInfoOrigin/refreshApi.html"
//请求参数
#define RH_SP_REFRESHAPI_APIID                 @"search.apiId"  //apiId

#pragma mark - V3 线上支付提交存款
#define RH_API_NAME_ONLINEPAY        @"mobile-api/depositOrigin/onlinePay.html"
//请求参数
#define RH_SP_ONLINEPAY_RECHARGEAMOUNT               @"result.rechargeAmount"  //存款金额
#define RH_SP_ONLINEPAY_RECHARGETYPE                 @"result.rechargeType"  //充值类型
#define RH_SP_ONLINEPAY_PAYACCOUNTID                 @"account"  //存款渠道ID
#define RH_SP_ONLINEPAY_ACTIVITYID                   @"activityId"           //优惠ID
#define RH_SP_ONLINEPAY_PAYERBANK                     @"result.payerBank"

#pragma mark - V3 扫码支付提交存款
#define RH_API_NAME_SCANPAY  @"mobile-api/depositOrigin/scanPay.html"
//请求参数
#define RH_SP_SCANPAY_RECHARGEAMOUNT               @"result.rechargeAmount"  //存款金额
#define RH_SP_SCANPAY_RECHARGETYPE                 @"result.rechargeType"  //充值类型
#define RH_SP_SCANPAY_PAYACCOUNTID                 @"account"  //存款渠道ID
#define RH_SP_SCANPAY_PAYERBANKCARD                @"Result.payerBankcard"  //授权码（只针对反扫）
#define RH_SP_SCANPAY_ACTIVITYID                   @"activityId"           //优惠ID


#pragma mark -  V3 网银支付提交存款
#define RH_API_NAME_COMPANYPAY  @"mobile-api/depositOrigin/companyPay.html"
//请求参数
#define RH_SP_COMPANYPAY_RECHARGEAMOUNT               @"result.rechargeAmount"  //存款金额
#define RH_SP_COMPANYPAY_RECHARGETYPE                 @"result.rechargeType"  //充值类型
#define RH_SP_COMPANYPAY_PAYACCOUNTID                 @"account"  //存款渠道ID
#define RH_SP_COMPANYPAY_PAYERNAME                    @"result.payerName"  //存款人姓名
#define RH_SP_COMPANYPAY_RECHARGEADDRESS              @"result.rechargeAddress"  //存款地址
#define RH_SP_COMPANYPAY_ACTIVITYID                   @"activityId"           //优惠ID


#pragma mark - V3 电子支付提交存款
#define RH_API_NAME_ELECTRONICPAY  @"mobile-api/depositOrigin/electronicPay.html"
//请求参数
#define RH_SP_ELECTRONICPAY_RECHARGEAMOUNT               @"result.rechargeAmount"  //存款金额
#define RH_SP_ELECTRONICPAY_RECHARGETYPE                 @"result.rechargeType"  //充值类型
#define RH_SP_ELECTRONICPAY_PAYACCOUNTID                 @"account"  //存款渠道ID
#define RH_SP_ELECTRONICPAY_BANKORDER                    @"result.bankOrder"   //订单后5位
#define RH_SP_ELECTRONICPAY_PAYERNAME                    @"result.payerName"  //支付户名(只针对支付宝电子支付)
#define RH_SP_ELECTRONICPAY_PAYERBANKCARD                @"result.payerBankcard"  //支付账号
#define RH_SP_ELECTRONICPAY_ACTIVITYID                   @"activityId"           //优惠ID

#pragma mark - V3 比特币支付提交存款
#define RH_API_NAME_BITCOINPAY  @"mobile-api/depositOrigin/bitcoinPay.html"
//请求参数
#define RH_SP_BITCOINPAY_RECHARGETYPE                 @"result.rechargeType"  //充值类型
#define RH_SP_BITCOINPAY_PAYACCOUNTID                 @"account"  //存款渠道ID
#define RH_SP_BITCOINPAY_ACTIVITYID                   @"activityId"           //优惠ID
#define RH_SP_BITCOINPAY_RETURNTIME                   @"result.returnTime"     //交易时间
#define RH_SP_BITCOINPAY_PAYERBANKCARD                @"result.payerBankcard"     //比特币钱包地址  long　(26-34位)
#define RH_SP_BITCOINPAY_BITAMOUNT                    @"result.bitAmount"    //比特币数量  浮点(Min=0.00010001,Max=８位)
#define RH_SP_BITCOINPAY_BANKORDER                    @"result.bankOrder"    //　比特币TxId


#pragma mark - V3 一键刷新
#define RH_API_NAME_ONESTEPREFRESH   @"mobile-api/userInfoOrigin/refresh.html"

#pragma mark - V3 获取SID
#define RH_API_NAME_LOADSIDSTR   @"mobile-api/origin/getHttpCookie.html"

#pragma mark - v3 获取客服接口
#define RH_API_NAME_CUSTOMSERVICE       @"mobile-api/origin/getCustomerService.html"

#pragma mark -v3  获取IP和域名

#define RH_API_NAME_BOSSSYSDOMAIN       @"/app/line.html"


#pragma mark -v3  初始化广告

#define RH_API_NAME_INITAD       @"mobile-api/origin/getIntoAppAd.html"
//返回参数
#define RH_GP_INITAD_APPAD                 @"initAppAd"


#pragma mark ==============消息公告弹窗================
#define RH_API_NAME_WEBSOCKETMDCETER    @"/mdcenter/websocket/msite?localeType=zh_CN"

#pragma mark - v3 找回密码
#define RH_API_ForgetPsw_FINDPHONE         @"mobile-api/findPasswordOrigin/findUserPhone.html" //查询用户是否绑定了手机号
#define RH_API_ForgetPsw_SendCode         @"mobile-api/origin/sendFindPasswordPhone.html" //找回密码发送验证码
#define RH_API_ForgetPsw_CheckCode         @"mobile-api/findPasswordOrigin/checkPhoneCode.html" //找回密码验证验证码
#define RH_API_ForgetPsw_FindbackPsw         @"mobile-api/findPasswordOrigin/findLoginPassword.html" //设置新密码

#pragma mark - v3 绑定手机
#define RH_API_BINDPHONE_GETPHONE         @"mobile-api/mineOrigin/getUserPhone.html" //获取用户手机号
#define RH_API_BINDPHONE_UPDATEUSERPHONE         @"mobile-api/mineOrigin/updateUserPhone.html" //绑定用户手机号
#define RH_API_BINDPHONE_SENDCODE         @"mobile-api/origin/sendPhoneCode.html" //发送验证码
#define RH_API_BINDPHONE_BINDPHONE         @"mobile-api/mineOrigin/updateUserPhone.html" //绑定手机


#endif /* RH_API_h */

