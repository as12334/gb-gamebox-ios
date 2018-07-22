//
//  RH_UserSafetyCodeModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserSafetyCodeModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_UserSafetyCodeModel ()
@end ;

@implementation RH_UserSafetyCodeModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mLockTime = [info stringValueForKey:RH_GP_USERSAFETY_LOCKTIME] ;
        _mRemindTime = [info integerValueForKey:RH_GP_USERSAFETY_REMINDTIMES] ;
        _mHasRealName = [info boolValueForKey:RH_GP_USERSAFETY_HASREALNAME] ;
        _mIsOpenCaptch = [info boolValueForKey:RH_GP_USERSAFETY_ISOPENCAPTCHA] ;
        _mHasPersimmionPwd = [info boolValueForKey:RH_GP_USERSAFETY_HASPERMISSIONPWD] ;
    }
    
    return self ;
}

-(void)updateHasRealName:(BOOL)bFlag
{
    _mHasRealName = bFlag ;
}
-(void)updateHasPersimmionPwd:(BOOL)bFlag
{
    _mHasPersimmionPwd = bFlag ;
}

-(void)updateOpenCaptch:(BOOL)bFlag
{
    _mIsOpenCaptch = bFlag ;
}
-(void)updateRemindTime:(NSInteger)remindTime
{
    _mRemindTime = remindTime ;
}

-(void)updateLockTime:(NSString*)lockTime
{
    _mLockTime = lockTime ;
}

@end
