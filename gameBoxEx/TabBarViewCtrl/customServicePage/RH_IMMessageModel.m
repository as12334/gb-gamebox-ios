//
//  RH_IMMessageModel.m
//  gameBoxEx
//
//  Created by luis on 2017/10/19.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_IMMessageModel.h"

@interface RH_IMMessageModel()
@end

@implementation RH_IMMessageModel
@synthesize mType = _mType          ;
@synthesize mUserID = _mUserID      ;
@synthesize mMessage = _mMessage    ;
@synthesize mCode = _mCode          ;
@synthesize showInfo = _showInfo    ;
@synthesize showSize = _showSize ;

-(instancetype)initWithType:(IMMessageType)type
                     UserID:(NSString*)userID
                MessageCode:(int)code
                MessageInfo:(NSString*)msg
{
    self = [super init] ;
    if (self){
        _mType = type ;
        _mCode = code ;
        _mUserID = userID ;
        _mMessage = msg ;
        _showSize = CGSizeZero ;
    }

    return self ;
}

-(NSString *)showInfo
{
    if (!_showInfo){
        switch (_mType) {
            case IMMessageType_LoginOK:
                _showInfo = _mMessage?:@"IM服务器登录/连接成功！" ;
                break;

            case IMMessageType_LoginFail:
                _showInfo = [NSString stringWithFormat:@"%@，错误代码：%d",_mMessage,_mCode] ;
                break;

            case IMMessageType_LoginClose:
                _showInfo = [NSString stringWithFormat:@"%@，错误代码：%d",_mMessage,_mCode] ;
                break;

            case IMMessageType_ReceivedUserInfo:
                _showInfo = [NSString stringWithFormat:@"%@:%@",_mUserID,_mMessage] ;
                break;

            case IMMessageType_ReceivedServeErrorInfo:
                _showInfo = [NSString stringWithFormat:@"Error:[%d]%@",_mCode,_mMessage] ;
                break;

           case IMMessageType_ReceivedQoSOK:
                _showInfo = [NSString stringWithFormat:@"收到对方已收到消息事件的通知:%@",_mMessage] ;
                break ;

            case IMMessageType_ReceivedQoSError:
                _showInfo = [NSString stringWithFormat:@"消息未成功送达]共%d条!(网络状况不佳或对方id不存在",_mCode] ;
                break ;

            default:
                break;
        }
    }

    return _showInfo ;
}

@end
