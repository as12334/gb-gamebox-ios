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
#define RH_SP_COMMON_V3_VERSION                             @"version"
#define RH_SP_COMMON_V3_THEME                               @"theme"
#define RH_SP_COMMON_V3_RESOLUTION                          @"resolution"
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
#define RH_GP_V3_ERROR               @"error"   //错误数量
#define RH_GP_V3_CODE                @"code"    //状态码
#define RH_GP_V3_MESSAGE             @"msg"             //消息框
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



#pragma mark- Page list
#define RH_API_PAGE_SIGNUP                                          @"/signUp/index.html"

#pragma mark-接口 API List
#define RH_API_NAME_LOGIN                                           @"passport/login.html"
#define RH_API_NAME_AUTOLOGIN                                       @"login/autoLogin.html"
#define RH_API_NAME_VERIFYCODE                                      @"captcha/code.html"
#define RH_API_NAME_DEMOLOGIN                                       @"demo/lottery.html"
#define RH_API_NAME_GETCUSTOMPATH                                   @"index/getCustomerService.html"

#pragma mark - v3 首页 banner 模型
#define RH_GP_Banner_CAROUSEL_ID                                      @"carousel_id"
#define RH_GP_Banner_COVER                                             @"cover"
#define RH_GP_Banner_ID                                                 @"id"
#define RH_GP_Banner_LANGUAGE                                           @"language"
#define RH_GP_Banner_LINK                                               @"link"
#define RH_GP_Banner_NAME                                               @"name"
#define RH_GP_Banner_ENDTIME                                               @"end_time"
#define RH_GP_Banner_STARTTIME                                               @"start_time"
#define RH_GP_Banner_ORDERNUM                                               @"order_num"
#define RH_GP_Banner_STATUS                                               @"status"
#define RH_GP_Banner_TYPE                                               @"type"


#pragma mark - v3 首页 announcement 公告模型
#define RH_GP_ANNOUNCEMENT_TYPE                                               @"announcementType"
#define RH_GP_ANNOUNCEMENT_CODE                                               @"code"
#define RH_GP_ANNOUNCEMENT_DISPLAY                                            @"display"
#define RH_GP_ANNOUNCEMENT_ID                                                 @"id"
#define RH_GP_ANNOUNCEMENT_ISTASK                                             @"isTask"
#define RH_GP_ANNOUNCEMENT_CONTENT                                             @"content"
#define RH_GP_ANNOUNCEMENT_LANGUAGE                                             @"language"
#define RH_GP_ANNOUNCEMENT_ORDERNUM                                             @"orderNum"
#define RH_GP_ANNOUNCEMENT_PUBLISHTIME                                          @"publishTime"
#define RH_GP_ANNOUNCEMENT_TITLE                                                @"title"

#pragma mark - V3 活动图 信息 
#define RH_GP_ACTIVITY_ACTIVITYID                                               @"activityId"
#define RH_GP_ACTIVITY_DESCRTIPTION                                             @"description"
#define RH_GP_ACTIVITY_DISTANCESIDE                                             @"distanceSide"
#define RH_GP_ACTIVITY_DISTANCETOP                                              @"distanceTop"
#define RH_GP_ACTIVITY_LANGUAGE                                                @"language"
#define RH_GP_ACTIVITY_LOCATION                                                 @"location"
#define RH_GP_ACTIVITY_NORMALEFFECT                                             @"normalEffect"


#pragma mark - V3 首页api 分类模型
#define RH_GP_LotteryCategory_APITYPE                                     @"apiType"
#define RH_GP_LotteryCategory_APITYPENAME                                     @"apiTypeName"
#define RH_GP_LotteryCategory_COVER                                     @"cover"
#define RH_GP_LotteryCategory_LOCALE                                     @"locale"
#define RH_GP_LotteryCategory_SITEAPIS                                     @"siteApis"

#pragma mark - v3 彩票游戏API 信息模型
#define RH_GP_LOTTERYAPIINFO_APIID                                     @"apiId"
#define RH_GP_LOTTERYAPIINFO_APITYPEID                             @"apiTypeId"
#define RH_GP_LOTTERYAPIINFO_AUTOPAY                                   @"autoPay"
#define RH_GP_LOTTERYAPIINFO_COVER                               @"cover"
#define RH_GP_LOTTERYAPIINFO_GAMELINK                                 @"gameLink"
#define RH_GP_LOTTERYAPIINFO_GAMELIST                                  @"gameList"
#define RH_GP_LOTTERYAPIINFO_GAMEMSG                              @"gameMsg"
#define RH_GP_LOTTERYAPIINFO_LOCAL                                  @"local"
#define RH_GP_LOTTERYAPIINFO_NAME                               @"name"
#define RH_GP_LOTTERYAPIINFO_SITEID                               @"siteId"



#pragma mark - v3 彩票游戏信息模型
#define RH_GP_LOTTERYINFO_APIID                              @"apiId"
#define RH_GP_LOTTERYINFO_APITYPEID                              @"apiTypeId"
#define RH_GP_LOTTERYINFO_AUTOPAY                               @"autoPay"
#define RH_GP_LOTTERYINFO_CODE                            @"code"
#define RH_GP_LOTTERYIINFO_COVER                              @"cover"
#define RH_GP_LOTTERYINFO_GAMEID                            @"gameId"
#define RH_GP_LOTTERYINFO_GAMELINK                                @"gameLink"
#define RH_GP_LOTTERYINFO_GAMEMSG                                @"gameMsg"
#define RH_GP_LOTTERYINFO_GAMETYPE                             @"gameType"
#define RH_GP_LOTTERYINFO_NAME                              @"name"
#define RH_GP_LOTTERYINFO_ORDERNUM                                   @"orderNum"
#define RH_GP_LOTTERYINFO_SITEID                              @"siteId"
#define RH_GP_LOTTERYINFO_STATUS                              @"status"
#define RH_GP_LOTTERYINFO_SYSTEMSTATUS                              @"systemStatus"


#pragma mark - V3 用户api 总计Balance 信息模型
#define RH_GP_USERBALANCEGROUP_ASSETS                          @"assets"
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

#pragma mark - V3 MINE 信息模型
#define RH_GP_MINEINFO_AVATARURL                             @"avatarUrl"
#define RH_GP_MINEINFO_CURRENCY                             @"currency"
#define RH_GP_MINEINFO_PREFERENTIALAMOUNT                    @"preferentialAmount"
#define RH_GP_MINEINFO_RECOMDAMOUNT                             @"recomdAmount"
#define RH_GP_MINEINFO_TOTALASSETS                             @"totalAssets"
#define RH_GP_MINEINFO_TRANSFERAMOUNT                             @"transferAmount"
#define RH_GP_MINEINFO_UNREADCOUNT                             @"unReadCount"
#define RH_GP_MINEINFO_USERNAME                             @"username"
#define RH_GP_MINEINFO_WALLETBALANCE                             @"walletBalance"
#define RH_GP_MINEINFO_WITHDRAWAMOUNT                             @"withdrawAmount"
#define RH_GP_MINEINFO_LOGINTIME                               @"loginTime"

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

#pragma mark - V3 用户安全码 初始化信息模型
#define RH_GP_USERSAFETY_HASREALNAME                                @"hasRealName"
#define RH_GP_USERSAFETY_HASPERMISSIONPWD                             @"hasPermissionPwd"
#define RH_GP_USERSAFETY_ISOPENCAPTCHA                            @"isOpenCaptcha"
#define RH_GP_USERSAFETY_REMINDTIMES                          @"remindTimes"
#define RH_GP_USERSAFETY_LOCKTIME                             @"lockTime"



#pragma mark -
#pragma mark - 回收接口
//api的路径
#define RH_API_NAME_APIRETRIVE                        @"transfer/auto/recovery.html"
//请求参数
#define RH_SP_APIRETRIVE_APIID                        @"search.apiId"


#pragma mark - V3
//===========================================================
//v3接口定义
//===========================================================
#pragma mark- v3 首页入口
//api的路径
#define RH_API_NAME_HOMEINFO                        @"origin/mainIndex.html"
//请求参数 无

//返回参数
#define RH_GP_HOMEINFO_ACTIVITY                        @"activity"
#define RH_GP_HOMEINFO_ANNOUNCEMENT                      @"announcement"
#define RH_GP_HOMEINFO_BANNER                            @"banner"
#define RH_GP_HOMEINFO_SITEAPIRELATION                        @"siteApiRelation"

#pragma mark- v3 用户信息 接口
//api的路径
#define RH_API_NAME_USERINFO                        @"mineOrigin/getUserInfo.html"
//请求参数 无

#pragma mark- v3 我的 接口
//api的路径
#define RH_API_NAME_MINEGROUPINFO                        @"mineOrigin/getLink.html"
#define RH_API_NAME_MINEMODIFYPASSWORD                   @"origin/updateLoginPassword.html"
#define RH_API_NAME_MINEMODIFYSAFETYPASSWORD             @"mineOrigin/updateSafePassword.html"
//请求参数 无
//返回参数
#define RH_GP_MINEGROUPINFO_ISBIT                          @"isBit"
#define RH_GP_MINEGROUPINFO_ISCASH                         @"isCash"
#define RH_GP_MINEGROUPINFO_LINK                           @"link"
#define RH_GP_MINEGROUPINFO_USER                           @"user"

#pragma mark - V3  浮动图抢红包次数
//api的路径
#define RH_API_NAME_ACTIVITYSTATUS                        @"origin/countDrawTimes.html"
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
#define RH_API_NAME_OPENACTIVITY                        @"origin/getPacket.html"
//请求参数
#define RH_SP_OPENACTIVITY_MESSAGEID                    @"activityMessageId"
#define RH_SP_OPENACTIVITY_TOKEN                        @"gb.token"
//返回参数

#pragma mark - V3 电子游戏清单 接口
//api的路径
#define RH_API_NAME_APIGAMELIST                        @"origin/getCasinoGame.html"
//请求参数 无
#define RH_SP_APIGAMELIST_APIID                          @"search.apiId"
#define RH_SP_APIGAMELIST_APITYPEID                      @"search.apiTypeId"
#define RH_SP_APIGAMELIST_PAGENUMBER                     @"paging.pageNumber"
#define RH_SP_APIGAMELIST_PAGESIZE                       @"paging.pageSize"
#define RH_SP_APIGAMELIST_NAME                           @"search.name"
//返回参数
#define RH_GP_APIGAMELIST_LIST                           @"casinoGames"
#define RH_GP_APIGAMELIST_TOTALCOUNT                           @"totalCount"

#pragma mark -v3 投注记录 清单
//api的路径
#define RH_API_NAME_BETTINGLIST                        @"mineOrigin/getBettingList.html"
//请求参数 无
#define RH_SP_BETTINGLIST_STARTDATE                          @"search.beginBetTime"
#define RH_SP_BETTINGLIST_ENDDATE                            @"search.endBetTime"
#define RH_SP_BETTINGLIST_PAGENUMBER                         @"paging.currentIndex"
#define RH_SP_BETTINGLIST_PAGESIZE                           @"paging.pageSize"
//返回参数
#define RH_GP_BETTINGLIST_LIST                              @"list"
#define RH_GP_BETTINGLIST_TOTALCOUNT                        @"totalamount"
#define RH_GP_BETTINGLIST_TOTALSINGLEAMOUN                  @"singleAmount"
#define RH_GP_BETTINGLIST_TOTALPROFIT                       @"profit"

#pragma mark -v3    投注记录明细
//api路径
#define RH_API_NAME_BETTINGDETAILS                     @"mineOrigin/getBettingDetails.html"
//请求参数
#define RH_SP_BETTINGDETAILS_LISTID                     @"id"
//返回参数
#define RH_GP_BETTINGDETAILS_

#pragma mark -V3 资金记录 清单
//api的路径
#define RH_API_NAME_DEPOSITLIST                        @"mineOrigin/getFundRecord.html"

#pragma mark -V3 资金记录 清单详情
//api的路径
#define RH_API_NAME_DEPOSITLISTDETAILS                        @"mineOrigin/getFundRecordDetails.html"


//请求参数 无
#define RH_SP_DEPOSITLIST_STARTDATE                          @"beginBetTime"
#define RH_SP_DEPOSITLIST_ENDDATE                            @"endBetTime"

#pragma mark -V3 用户安全码初始化信息
//api的路径
#define RH_API_NAME_USERSAFEINFO                        @"mineOrigin/initSafePassword.html"
//请求参数 无
#pragma mark -V3 设置真实姓名
//API的路径
#define RH_API_NAME_SETREALNAME                         @"mineOrigin/setRealName.html"
//请求参数
#pragma mark -V3 修改安全密码接口
//api路径
#define RH_API_NAME_UPDATESAFEPASSWORD                    @"mineOrigin/updateSafePassword.html"
//请求参数 无
#pragma mark -V3 修改登录密码
#define RH_API_NAME_UPDATE_LOGINPASSWORD                    @"mineOrigin/updateLoginPassword.html"

#endif /* RH_API_h */

