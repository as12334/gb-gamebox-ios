//
//  RH_DepositeTransferChannelModel.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/29.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferChannelModel.h"
#import "coreLib.h"
#import "RH_API.h"
@implementation RH_DepositeTransferListModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mId = [info integerValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_ID];
        _mPayName = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_PAYNAME];
        _mAccount = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNT];
        _mFullName = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_FULLNAME];
        _mCode = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_CODE];
        _mType = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_TYPE];
        _mAccountType = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNTTYPE];
        _mBankCode = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_BANKCODE];
        _mBankName = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_BANKNAME];
        _mSingleDepositMin = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_SINGLEDEPOSITEMIN];
        _mSingleDepositMax = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_SINGLEDEPOSITEMAX];
        _mOpenAcountName = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_OPENACOUNTNAME];
        _mQrCodeUrl = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_QRCODEURL];
        _mRemark = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_REMARK];
        _mRandomAmount = [info boolValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_RANDOMAMOUNT];
        _mAliasName = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_ALIASNAME];
        _mCustomBankName = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_CUSTOMBANKNAME];
        _mAccountInformation = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNTINFOEMATION];
        _mAccountPrompt = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNTPROMPT];
        _mRechargeType = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_RECHARGETYPE];
        _mDepositWay = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_DEPOSITWAY];
        _mPayType = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_PAYTYPE];
        _mSearchId = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_SEARCHID];
        _mImgUrl = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_IMGURL];
    }
    return self;
}
@end

@implementation RH_DepositeTransferChannelModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mCurrency = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_CURRENCY];
        _mCustomerService = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_CUSTOMERSERVICE];
        _mArrayListModel = [RH_DepositeTransferListModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_ARRAYLIST]];
        _mQuickMoneys = [info arrayValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_QUICKMONEYS];
        _mPayerBankcard = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_PAYERBANKCARD];
        _mHide = [info boolValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_HIDE];
        _mMultipleAccount = [info boolValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_MULTIPLEACCOUNT];
    }
    return self;
}


@end
