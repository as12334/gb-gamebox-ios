//
//  RH_CapitalDetailModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalDetailModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@implementation RH_CapitalDetailModel
@synthesize  showTransactionMoney = _showTransactionMoney;
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mAdministrativeFee = [info stringValueForKey:RH_GP_CAPITALDETAIL_ADMINISTRATIVEFEE];
        _mCreateTime = [NSDate dateWithTimeIntervalSince1970:[info floatValueForKey:RH_GP_CAPITALDETAIL_CREATETIME]/1000.0] ;
        _mDeductFavorable = [info stringValueForKey:RH_GP_CAPITALDETAIL_DEDUCTFAVORABLE];
        _mFailureReason = [info stringValueForKey:RH_GP_CAPITALDETAIL_FAILUREREASON];
        _mFundType = [info stringValueForKey:RH_GP_CAPITALDETAIL_FUNDTYPE];
        _mId = [info stringValueForKey:RH_GP_CAPITALDETAIL_ID];
        _mPayerBankcard = [info stringValueForKey:RH_GP_CAPITALDETAIL_PAYERBANKCARD];
        _mPoundage = [info stringValueForKey:RH_GP_CAPITALDETAIL_POUNDAGE];
        _mRealName = [info stringValueForKey:RH_GP_CAPITALDETAIL_REALNAME];
        _mRechargeAddress = [info stringValueForKey:RH_GP_CAPITALDETAIL_RECHARGEADDRESS];
        _mRechargeTotalAmount = [info stringValueForKey:RH_GP_CAPITALDETAIL_RECHARGETOTALAMOUNT];
        _mStatus = [info stringValueForKey:RH_GP_CAPITALDETAIL_STATUS];
        _mTransactionMoney = [info floatValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONMONEY];
        _mStatusName = [info stringValueForKey:RH_GP_CAPITALDETAIL_STATUSNAME];
        _mTransactionNo = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONNO];
        _mTransactionType = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONTYPE];
        _mTransactionWay = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONWAY];
        _mTransactionWayName = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONWAYNAME];
        _mUsername = [info stringValueForKey:RH_GP_CAPITALDETAIL_USERNAME];
    }
    return self;
}
-(NSString *)showTransactionMoney
{
    if (!_showTransactionMoney){
        if (_mTransactionMoney==0){
            _showTransactionMoney = @"--" ;
        }else{
            _showTransactionMoney = [NSString stringWithFormat:@"%.02f",_mTransactionMoney] ;
        }
    }
    
    return _showTransactionMoney ;
}
@end
