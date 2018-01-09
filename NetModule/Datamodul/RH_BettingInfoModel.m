//
//  RH_BettingInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@interface RH_BettingInfoModel ()
@end ;

@implementation RH_BettingInfoModel


-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mID = [info integerValueForKey:RH_GP_BETTING_ID] ;
        _mApiID = [info integerValueForKey:RH_GP_BETTING_APIID] ;
        _mGameID = [info integerValueForKey:RH_GP_BETTING_GAMEID] ;
        _mBettime = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_BETTING_BETTIME]] ;
        _mTerminal = [info stringValueForKey:RH_GP_BETTING_TERMINAL] ;
        _mOrderState = [info stringValueForKey:RH_GP_BETTING_ORDERSTATE] ;
    }
    
    return self ;
}


@end
