//
//  RH_IMMessageModel.h
//  gameBoxEx
//
//  Created by luis on 2017/10/19.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, IMMessageType) {
    IMMessageType_LoginOK   = 1,
    IMMessageType_LoginFail ,
    IMMessageType_LoginClose,
    IMMessageType_ReceivedUserInfo,
    IMMessageType_ReceivedServeErrorInfo,
    IMMessageType_ReceivedQoSError,
    IMMessageType_ReceivedQoSOK,
};

@interface RH_IMMessageModel : RH_BasicModel
@property(nonatomic,readonly,assign) IMMessageType  mType ;
@property(nonatomic,readonly,strong) NSString *mUserID    ;
@property(nonatomic,readonly,assign) int mCode   ;
@property(nonatomic,readonly,strong) NSString *mMessage   ;


//other extend
@property(nonatomic,readonly,strong) NSString *showInfo ;
@property(nonatomic,assign) CGSize showSize ;

-(instancetype)initWithType:(IMMessageType)type
                     UserID:(NSString*)userID
                MessageCode:(int)code
                MessageInfo:(NSString*)msg ;


@end
