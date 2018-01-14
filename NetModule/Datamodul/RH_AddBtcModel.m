//
//  RH_AddBtcModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_AddBtcModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_AddBtcModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mID = [info integerValueForKey:RH_GP_ADDBTC_ID];
        _mUserID = [info integerValueForKey:RH_GP_ADDBTC_ID];
        _mBankcardMasterName = [info stringValueForKey:RH_GP_ADDBTC_BANKCARDMASTERNAME];
        _mBankcardNumber = [info stringValueForKey:RH_GP_ADDBTC_BANKCARDNUMBER];
        _mCreateTime = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_ADDBTC_CREATETIME]/1000.0] ;
        _mUseCount = [info integerValueForKey:RH_GP_ADDBTC_USECOUNT];
        _mUseStauts = [info boolValueForKey:RH_GP_ADDBTC_USESTAUTS];
        _mIsDefault = [info boolValueForKey:RH_GP_ADDBTC_ISDEFAULT];
        _mBankName = [info stringValueForKey:RH_GP_ADDBTC_BANKNAME];
        _mBankDeposit = [info stringValueForKey:RH_GP_ADDBTC_BANKDEPOSIT];
        _mCustomBankName = [info stringValueForKey:RH_GP_ADDBTC_CUSTOMBANKNAME];
        _mType = [info integerValueForKey:RH_GP_ADDBTC_TYPE];
    }
    return self;
}

@end
