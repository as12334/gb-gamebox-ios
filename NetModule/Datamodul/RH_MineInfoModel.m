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
@synthesize showAvatalURL = _showAvatalURL ;
@synthesize showTotalAssets = _showTotalAssets ;
@synthesize showWalletBalance = _showWalletBalance ;

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
        _mBankCard = [[RH_BankCardModel alloc] initWithInfoDic:[info dictionaryValueForKey:RH_GP_MINEINFO_BANKCARD]] ;
        _mBitCode = [[RH_BitCodeModel alloc] initWithInfoDic:[info dictionaryValueForKey:RH_GP_MINEINFO_BTCCODE]] ;
        _mRealName = [info stringValueForKey:RH_GP_MINEINFO_REALNAME] ;
        _mApisBalanceList = [RH_UserApiBalanceModel dataArrayWithInfoArray:[info arrayValueForKey:@"apis"]] ;
    }
    
    return self ;
}


-(NSString *)showAvatalURL
{
    if (!_showAvatalURL){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if (_mAvatalUrl.length){
            if ([[_mAvatalUrl substringToIndex:1] isEqualToString:@"/"]){
                _showAvatalURL = [NSString stringWithFormat:@"%@%@",appDelegate.domain,_mAvatalUrl] ;
            }else{
                _showAvatalURL = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mAvatalUrl] ;
            }
        }
    }
    
    return _showAvatalURL ;
}

#pragma mark -
-(void)updateUserBalanceInfo:(NSDictionary*)info
{
    /*
     assets = "1733.0";
     balance = "1733.0";
     currSign = "\Uffe5";
     username = haha123;
     */
    _mApisBalanceList = [RH_UserApiBalanceModel dataArrayWithInfoArray:[info arrayValueForKey:@"apis"]] ;
    _mCurrency = [info objectForKey:@"currSign"] ;
    _mUserName = [info objectForKey:@"username"] ;
    _mTotalAssets = [info floatValueForKey:@"assets"] ;
    _mWalletBalance = [info floatValueForKey:@"balance"] ;
}

-(void)updateBankCard:(RH_BankCardModel*)bankCardInfo
{
    if (bankCardInfo){
        _mBankCard = bankCardInfo ;
    }
}

-(void)updateBitCode:(RH_BitCodeModel*)bitCodeInfo
{
    if (bitCodeInfo){
        _mBitCode = bitCodeInfo ;
    }
}

#pragma mark-
-(NSString *)showTotalAssets
{
    if (!_showTotalAssets){
        _showTotalAssets = [NSString stringWithFormat:@"%.02f",_mTotalAssets] ;
    }

    return _showTotalAssets ;
}

-(NSString *)showWalletBalance
{
    if (!_showWalletBalance){
        _showWalletBalance = [NSString stringWithFormat:@"%.02f",_mWalletBalance] ;
    }
    return _showWalletBalance ;
}

@end
