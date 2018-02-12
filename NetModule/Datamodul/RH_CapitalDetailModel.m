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
@synthesize showBankURL = _showBankURL ;
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mAdministrativeFee = [info stringValueForKey:RH_GP_CAPITALDETAIL_ADMINISTRATIVEFEE];
        _mCreateTime = [NSDate dateWithTimeIntervalSince1970:[info doubleValueForKey:RH_GP_CAPITALDETAIL_CREATETIME]/1000.0] ;
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
        _mTransactionMoney = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONMONEY];
        _mStatusName = [info stringValueForKey:RH_GP_CAPITALDETAIL_STATUSNAME];
        _mTransactionNo = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONNO];
        _mTransactionType = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONTYPE];
        _mTransactionWay = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONWAY];
        _mTransactionWayName = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSACTIONWAYNAME];
        _mUsername = [info stringValueForKey:RH_GP_CAPITALDETAIL_USERNAME];
        _mTransferInto = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSFERINTO];
        _mTransferOut = [info stringValueForKey:RH_GP_CAPITALDETAIL_TRANSFEROUT];
        _mRechargeAmount = [info stringValueForKey:RH_GP_CAPITALDETAIL_RECHARGEAMOUNT];
        _mWithdrawMoney = [info stringValueForKey:RH_GP_CAPITALDETAIL_WITHDRAWMONEY];
        _mBankCodeName = [info stringValueForKey:RH_GP_CAPITALDETAIL_BANKCODENAME];
        _mBankUrl = [info stringValueForKey:RH_GP_CAPITALDETAIL_BANKURL];
        _mTxId = [info stringValueForKey:RH_GP_CAPITALDETAIL_TXID];
        _mBitcoinAdress = [info stringValueForKey:RH_GP_CAPITALDETAIL_BITCOINADRESS];
        _mReturnTime = [NSDate dateWithTimeIntervalSince1970:[info doubleValueForKey:RH_GP_CAPITALDETAIL_RETURNTIME]/1000.0] ;
        _mBankCode = [info stringValueForKey:RH_GP_CAPITALDETAIL_BANKCODE] ;
    }
    return self;
}

-(NSString *)showBankURL
{
    if (!_showBankURL){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if (_mBankUrl.length){
            if ([[_mBankUrl substringToIndex:1] isEqualToString:@"/"]){
                _showBankURL = [NSString stringWithFormat:@"%@%@",appDelegate.domain,_mBankUrl] ;
            }else {
                _showBankURL = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mBankUrl] ;
            }
        }
    }
    
    return _showBankURL ;
}
@end
