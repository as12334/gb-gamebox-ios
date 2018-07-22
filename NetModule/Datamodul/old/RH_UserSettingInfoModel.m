//
//  RH_UserSettingInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserSettingInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_UserSettingInfoModel ()
@end ;

@implementation RH_UserSettingInfoModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mIsBit = [info boolValueForKey:RH_GP_USERSETTINGINFO_ISBIT] ;
        _mBtcNum = [info stringValueForKey:RH_GP_USERSETTINGINFO_BTCNUM] ;
        _mIsCash = [info boolValueForKey:RH_GP_USERSETTINGINFO_ISCASH] ;
        _mCurrency = [info stringValueForKey:RH_GP_USERSETTINGINFO_CURRENCY] ;
        _mUserName = [info stringValueForKey:RH_GP_USERSETTINGINFO_USERNAME] ;
        _mAvatarURL = [info stringValueForKey:RH_GP_USERSETTINGINFO_AVATARURL] ;
        _mLastLoginTime = [info stringValueForKey:RH_GP_USERSETTINGINFO_LASTLOGINTIME] ;
        _mPreferentialAmount = [info floatValueForKey:RH_GP_USERSETTINGINFO_PREFERENTIALAMOUNT] ;
    }
    
    return self ;
}

@end
