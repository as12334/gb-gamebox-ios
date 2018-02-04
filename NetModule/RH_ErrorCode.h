//
//  RH_ErrorCode.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#ifndef RH_ErrorCode_h
#define RH_ErrorCode_h

//===========================================================
//     API错误码定义
//===========================================================

//无错误
#define RH_API_ERRORCODE_NO_ERROR                           0

//未知错误
#define RH_API_ERRORCODE_UNKNOW_ERROR                       900

//默认的无网路错误代码
#define RH_DEFAULT_NONET_ERRORCODE                          901

//返回数据非JSON错误码
#define RH_API_ERRORCODE_NO_JSON_ERROR                      902



#pragma mark -  界面处理的 特别 code
#define RH_API_ERRORCODE_SESSION_EXPIRED                      600   //session 过期
//#define RH_API_ERRORCODE_SESSION_                      606   // 被强制踢出
#define RH_API_ERRORCODE_USER_LOGOUT                          1001     //您还没有登录

#define RH_API_ERRORCODE_WITHDRAW_HASORDER                     1100   //提现 已存在取款订单
#define RH_API_ERRORCODE_WITHDRAW_NO_MONEY                     1102   //提现 取款金额最少为x元

#endif /* RH_ErrorCode_h */
