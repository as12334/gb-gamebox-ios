//
//  RH_LotteryInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LotteryInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_LotteryInfoModel ()
@end ;

@implementation RH_LotteryInfoModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mApiTypeID = [info integerValueForKey:RH_GP_LOTTERYINFO_APITYPEID] ;
        _mSiteID = [info integerValueForKey:RH_GP_LOTTERYINFO_SITEID] ;
        _mApiID = [info integerValueForKey:RH_GP_LOTTERYINFO_APIID] ;
        _mName = [info stringValueForKey:RH_GP_LOTTERYINFO_NAME] ;
        _mID = [info integerValueForKey:RH_GP_LOTTERYINFO_ID] ;
        _mName = [info stringValueForKey:RH_GP_LOTTERYINFO_NAME] ;
        _mUrl = [info stringValueForKey:RH_GP_LOTTERYINFO_URL] ;
        _mCode = [info stringValueForKey:RH_GP_LOTTERYINFO_CODE] ;
        _mCover = [info stringValueForKey:RH_GP_LOTTERYINFO_COVER] ;
        _mViews = [info stringValueForKey:RH_GP_LOTTERYIINFO_VIEWS] ;
        _mCantry = [info stringValueForKey:RH_GP_LOTTERYINFO_CANTRY] ;
        _mGameID = [info integerValueForKey:RH_GP_LOTTERYINFO_GAMEID] ;
        _mStatus = [info stringValueForKey:RH_GP_LOTTERYINFO_STATUS] ;
        _mGameType = [info stringValueForKey:RH_GP_LOTTERYINFO_GAMETYPE];
        _mOrderNum = [info integerValueForKey:RH_GP_LOTTERYINFO_ORDERNUM] ;
        
//        _mOpenDate = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_OPENCODE_TIME]] ;
    }
    
    return self ;
}


@end
