//
//  RH_DepositeTransferModel.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferModel.h"
#import "coreLib.h"
#import "RH_API.h"
@implementation RH_DepositeTransferModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mPayModel = [RH_DepositePayModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_DEPOSITEORIGIN_PAY]];
        _mPaydataModel = [[RH_DepositePaydataModel alloc]initWithInfoDic:[info dictionaryValueForKey:RH_GP_DEPOSITEORIGIN_PAYDATA]];
    }
    return self;
}
@end
@implementation RH_DepositePaydataModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self=[super initWithInfoDic:info]) {
        _mQuickMoneys = [info arrayValueForKey:RH_GP_DEPOSITEORIGIN_QUICKMONEYS];
        _mLotterySite = [info boolValueForKey:RH_GP_DEPOSITEORIGIN_LOTTERYSITE];
        _mIsFastRecharge = [info stringValueForKey:RH_GP_DEPOSITEORIGIN_ISFASTRECHARGE];
        _mIsMultipleAccount = [info boolValueForKey:RH_GP_DEPOSITEORIGIN_ISMULTIPLEACCOUNT];
    }
    return self;
}
@end
@implementation RH_DepositePayModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self=[super initWithInfoDic:info]) {
        _mCode = [info stringValueForKey:RH_GP_DEPOSITEORIGIN_CODE];
        _mName = [info stringValueForKey:RH_GP_DEPOSITEORIGIN_NAME];
//        _mPayAccounts = [[RH_DepositePayAccountModel alloc]initWithInfoDic:[info dictionaryValueForKey:RH_GP_DEPOSITEORIGIN_PAYACCOUNTS]];
        _mPayAccounts = [RH_DepositePayAccountModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_DEPOSITEORIGIN_PAYACCOUNTS]];
    }
    return self;
}
@end
