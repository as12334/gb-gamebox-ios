//
//  RH_BettingDetailModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingDetailModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@interface RH_BettingDetailModel ()
@end ;

@implementation RH_BettingDetailModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mApiID = [info integerValueForKey:RH_GP_BETTINGDETAIL_APIID];
        _mApiName = [info stringValueForKey:RH_GP_BETTINGDETAIL_APINAME];
        _mApiTypeId = [info integerValueForKey:RH_GP_BETTINGDETAIL_APITYPEID];
        _mBetDetail = [info stringValueForKey:RH_GP_BETTINGDETAIL_BETDETAIL];
        _mBetId = [info integerValueForKey:RH_GP_BETTINGDETAIL_BETID];
        _mBetTime = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_BETTINGDETAIL_BETTIME]/1000.0] ;
        _mBetTypeName = [info stringValueForKey:RH_GP_BETTINGDETAIL_BETTYPENAME];
        _mContributionAmount = [info stringValueForKey:RH_GP_BETTINGDETAIL_CONTRIBUTIONAMOUNT];
        _mEffectiveTradeAmount = [info stringValueForKey:RH_GP_BETTINGDETAIL_EFFECTIVETRADEAMOUNT];
        _mGameId = [info integerValueForKey:RH_GP_BETTINGDETAIL_GAMEID];
        _mGameName = [info stringValueForKey:RH_GP_BETTINGDETAIL_GAMENAME];
        _mGameType = [info stringValueForKey:RH_GP_BETTINGDETAIL_GAMETYPE];
        _mOddsTypeName = [info stringValueForKey:RH_GP_BETTINGDETAIL_ODDSTYPENAME];
        _mOrderState = [info stringValueForKey:RH_GP_BETTINGDETAIL_ORDERSTATE];
        _mPayoutTime = [info stringValueForKey:RH_GP_BETTINGDETAIL_PAYOUTTIME];
        _mProfitAmount = [info stringValueForKey:RH_GP_BETTINGDETAIL_PROFITAMOUNT];
        _mResultArray = [info stringValueForKey:RH_GP_BETTINGDETAIL_RESULTARRAY];
        _mSingleAmount = [info integerValueForKey:RH_GP_BETTINGDETAIL_SINGLEAMOUNT];
        _mTerminal = [info integerValueForKey:RH_GP_BETTINGDETAIL_TERMINAL];
        _mUserName = [info stringValueForKey:RH_GP_BETTINGDETAIL_USERNAME];
    }
    
    return self ;
}


@end
