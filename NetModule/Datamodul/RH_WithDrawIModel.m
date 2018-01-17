//
//  RH_WithDrawIModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithDrawIModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation BankcardMapModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mId = [info integerValueForKey:RH_GP_WITHDRAW_ID];
        _mBankName = [info stringValueForKey:RH_GP_WITHDRAW_BANKNAME];
        _mUseCount = [info integerValueForKey:RH_GP_WITHDRAW_USECOUNT];
        _mUseStauts = [info boolValueForKey:RH_GP_WITHDRAW_USESTAUTS];
        _mBankcardMasterName = [info stringValueForKey:RH_GP_WITHDRAW_BANKCARDMASTERNAME];
        _mIsDefault = [info boolValueForKey:RH_GP_WITHDRAW_ISDEFAULT];
         _mUserId = [info boolValueForKey:RH_GP_WITHDRAW_USERID];
         _mCreateTime = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_WITHDRAW_CREATETIME]/1000.0];
         _mBankDeposit = [info stringValueForKey:RH_GP_WITHDRAW_BANKDEPOSIT];
         _mType = [info stringValueForKey:RH_GP_WITHDRAW_TYPE];
         _mCustomBankName = [info stringValueForKey:RH_GP_WITHDRAW_CUSTOMBANKNAME];
         _mBankcardNumber = [info stringValueForKey:RH_GP_WITHDRAW_BANKCARDNUMBER];
    }
    return self;
}
+(NSMutableArray *)dataArrayWithInfoDict:(NSDictionary *)infoDict
{
    NSMutableArray *tmpArray = [NSMutableArray array] ;
    NSArray *keys = infoDict.allKeys ;
    for (id key in keys) {
        NSDictionary *dict = [infoDict objectForKey:key] ;
        [tmpArray addObject:dict] ;
    }
    
    return [self dataArrayWithInfoArray:tmpArray] ;
}
@end

@implementation AuditMapModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mDeductFavorable= [info floatValueForKey:RH_GP_WITHDRAW_DEDUCTFAVORABLE];
        _mCounterFee= [info stringValueForKey:RH_GP_WITHDRAW_COUNTERFEE];
        _mWithdrawFeeMoney= [info integerValueForKey:RH_GP_WITHDRAW_WITHDRAWFEEMONEY];
        _mAdministrativeFee= [info integerValueForKey:RH_GP_WITHDRAW_ADMINISTRATIVEFEE];
        _mActualWithdraw= [info floatValueForKey:RH_GP_WITHDRAW_ACTUALWITHDRAW];
        _mTransactionNo= [info stringValueForKey:RH_GP_WITHDRAW_TRANSACTIONNO];
        _mRecordList = [info boolValueForKey:RH_GP_WITHDRAW_RECORDLIST];
        _mWithdrawAmount= [info integerValueForKey:RH_GP_WITHDRAW_WITHDRAWAMOUNT];
    }
    return self;
}
@end

@implementation RH_WithDrawIModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
         _mIsCash = [info boolValueForKey:RH_GP_WITHDRAW_ISCASH];
        _mAuditLogUrl = [info stringValueForKey:RH_GP_WITHDRAW_AUDITLOGURL];
        _mHasBank = [info boolValueForKey:RH_GP_WITHDRAW_HASBANK];
        _mCurrencySign = [info stringValueForKey:RH_GP_WITHDRAW_CURRENCYSIGN];
        _mTotalBalance = [info integerValueForKey:RH_GP_WITHDRAW_TOTALBALANCE];
        _mToken = [info stringValueForKey:RH_GP_WITHDRAW_TOKEN];
        _mIsBit = [info boolValueForKey:RH_GP_WITHDRAW_ISBIT];
        _mAuditMapModel =[AuditMapModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_WITHDRAW_AUDITMAP]] ;
        _mBankcardMapModel = [BankcardMapModel dataArrayWithInfoDict:[info dictionaryValueForKey:RH_GP_WITHDRAW_BANKCARDMAP]];
    }
    return self;
}



@end
