//
//  RH_MineInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@interface RH_MineInfoModel ()
@end ;

@implementation RH_MineInfoModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mCurrency = [info stringValueForKey:RH_GP_MINEINFO_CURRENCY] ;
        _mUserName = [info stringValueForKey:RH_GP_MINEINFO_USERNAME] ;
        _mAvatalUrl = [info stringValueForKey:RH_GP_MINEINFO_AVATARURL] ;
        _mTotalAssets = [info floatValueForKey:RH_GP_MINEINFO_TOTALASSETS] ;
        _mUnReadCount = [info floatValueForKey:RH_GP_MINEINFO_UNREADCOUNT] ;
        _mRecomdAmount = [info stringValueForKey:RH_GP_MINEINFO_RECOMDAMOUNT] ;
        _mWalletBalance = [info floatValueForKey:RH_GP_MINEINFO_WALLETBALANCE] ;
        _mTransferAmount = [info floatValueForKey:RH_GP_MINEINFO_TRANSFERAMOUNT] ;
        _mWithdrawAmount = [info floatValueForKey:RH_GP_MINEINFO_WITHDRAWAMOUNT] ;
        _mPreferentialAmount = [info stringValueForKey:RH_GP_MINEINFO_PREFERENTIALAMOUNT] ;
        _mLoginTime = [info stringValueForKey:RH_GP_MINEINFO_LOGINTIME] ;
        _mIsBit = [info boolValueForKey:RH_GP_MINEINFO_ISBIT] ;
        _mIsCash = [info boolValueForKey:RH_GP_MINEINFO_ISCASH] ;
    }
    
    return self ;
}


@end
