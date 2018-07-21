//
//  RH_CapitalInfoModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_CapitalInfoModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mId = [info integerValueForKey:RH_GP_CAPITAL_ID];
        _mCreateTime =  [NSDate dateWithTimeIntervalSince1970:[info doubleValueForKey:RH_GP_CAPITAL_CREATETIME]/1000.0];
        _mTransactionMoney = [info stringValueForKey:RH_GP_CAPITAL_TRANSACTIONMONEY];
        _mTransactionType = [info stringValueForKey:RH_GP_CAPITAL_TRANSACTIONTYPE];
        _mTransaction_typeName = [info stringValueForKey:RH_GP_CAPITAL_TRANSACTION_TYPENAME];
        _mStatus = [info stringValueForKey:RH_GP_CAPITAL_STATUS];
        _mStatusName = [info stringValueForKey:RH_GP_CAPITAL_STATUSNAME];
    }
    return self;
}


@end
