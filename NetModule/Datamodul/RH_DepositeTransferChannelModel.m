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
#import "RH_APPDelegate.h"
@implementation RH_DepositeTransferListModel
@synthesize showCover = _showCover ;
@synthesize qrShowCover = _qrShowCover;
@synthesize accountImgCover = _accountImgCover;
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
        _mSingleDepositMin = [info integerValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_SINGLEDEPOSITEMIN];
        _mSingleDepositMax = [info integerValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_SINGLEDEPOSITEMAX];
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
        _mAccountImg = [info stringValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_ACCOUNTIMG];
    }
    return self;
}

-(NSString *)showCover
{
    if (!_showCover){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if ([_mImgUrl containsString:@"http"] || [_mImgUrl containsString:@"https:"]) {
            _showCover = [NSString stringWithFormat:@"%@",_mImgUrl] ;
        }else
        {
            _showCover = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mImgUrl] ;
        }
    }
    
    return _showCover ;
}
-(NSString *)qrShowCover
{
    if (!_qrShowCover){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if ([_mQrCodeUrl containsString:@"http"] || [_mQrCodeUrl containsString:@"https:"]) {
            _qrShowCover = [NSString stringWithFormat:@"%@",_mQrCodeUrl] ;
        }else
        {
            _qrShowCover = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mQrCodeUrl] ;
        }
    }
    return _qrShowCover;
}
-(NSString *)accountImgCover
{
    if (!_accountImgCover){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if ([_mAccountImg containsString:@"http"] || [_mAccountImg containsString:@"https:"]) {
            _qrShowCover = [NSString stringWithFormat:@"%@",_mAccountImg] ;
        }else
        {
            _accountImgCover = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mAccountImg] ;
        }
    }
    return _accountImgCover;
}
@end
@implementation RH_DepositeTansferCounterModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mCode = [info stringValueForKey:RH_GP_DEPOSITECOUNTER_CODE];
        _mName = [info stringValueForKey:RH_GP_DEPOSITECOUNTER_NAME];
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
        if (![[info objectForKey:RH_GP_DEPOSITEORIGINCHANNEL_COUNTERRECHARGETYPES] isKindOfClass:[NSNull class]]) {
            _mAounterModel = [RH_DepositeTansferCounterModel dataArrayWithInfoArray:[info adaptationValueForKey:RH_GP_DEPOSITEORIGINCHANNEL_COUNTERRECHARGETYPES]];
        }
    }
    return self;
}


@end
