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
#define RH_GP_LOTTERYAPIINFO_ID                                     @"id"
#define RH_GP_LOTTERYAPIINFO_RELATIONID                             @"relationId"
#define RH_GP_LOTTERYAPIINFO_NAME                                   @"name"
#define RH_GP_LOTTERYAPIINFO_LANGUAGE                               @"local"
#define RH_GP_LOTTERYAPIINFO_SITEID                                 @"siteId"
#define RH_GP_LOTTERYAPIINFO_APIID                                  @"apiId"
#define RH_GP_LOTTERYAPIINFO_APITYPEID                              @"apiTypeId"
#define RH_GP_LOTTERYAPIINFO_COVER                                  @"cover"
#define RH_GP_LOTTERYAPIINFO_GAMELIST                               @"gameList"



#pragma mark - v3 彩票游戏信息模型
#define RH_GP_LOTTERYINFO_ID                              @"id"
#define RH_GP_LOTTERYINFO_GAMEID                              @"gameId"
#define RH_GP_LOTTERYINFO_SITEID                              @"siteId"
#define RH_GP_LOTTERYINFO_APIID                              @"apiId"
#define RH_GP_LOTTERYINFO_GAMETYPE                              @"gameType"
#define RH_GP_LOTTERYIINFO_VIEWS                              @"views"
#define RH_GP_LOTTERYINFO_ORDERNUM                              @"orderNum"
#define RH_GP_LOTTERYINFO_URL                              @"url"
#define RH_GP_LOTTERYINFO_STATUS                              @"status"
#define RH_GP_LOTTERYINFO_APITYPEID                              @"apiTypeId"
#define RH_GP_LOTTERYINFO_SUPPORTTERMINAL                              @"supportTerminal"
#define RH_GP_LOTTERYINFO_CODE                                   @"code"
#define RH_GP_LOTTERYINFO_NAME                              @"name"
#define RH_GP_LOTTERYINFO_COVER                              @"cover"
#define RH_GP_LOTTERYINFO_CANTRY                              @"canTry"


#pragma mark - V3 用户 

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


#endif /* RH_API_h */

