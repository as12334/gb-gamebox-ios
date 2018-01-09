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
@synthesize showName = _showName ;
@synthesize showStatus = _showStatus ;
@synthesize showBettingDate = _showBettingDate ;
@synthesize showSingleAmount = _showSingleAmount ;
@synthesize showProfitAmount = _showProfitAmount ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mID = [info integerValueForKey:RH_GP_BETTING_ID] ;
        _mApiID = [info integerValueForKey:RH_GP_BETTING_APIID] ;
        _mApiName = [info stringValueForKey:RH_GP_BETTING_APINAME] ;
        _mGameID = [info integerValueForKey:RH_GP_BETTING_GAMEID] ;
        _mGameName = [info stringValueForKey:RH_GP_BETTING_GAMENAME] ;
        _mBettime = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_BETTING_BETTIME]] ;
        _mTerminal = [info stringValueForKey:RH_GP_BETTING_TERMINAL] ;
        _mOrderState = [info stringValueForKey:RH_GP_BETTING_ORDERSTATE] ;
    }
    
    return self ;
}

-(NSString *)showName
{
    if (!_showName){
        _showName = [NSString stringWithFormat:@"%@\n%@",_mApiName,_mGameName] ;
    }
    
    return _showName ;
}

-(NSString *)showBettingDate
{
    if (!_showBettingDate){
        _showBettingDate = dateStringWithFormatter(_mBettime, @"yyyy-MM-dd \n HH:mm:ss") ;
    }
    
    return _showBettingDate ;
}

-(NSString *)showStatus
{
    if (!_showStatus){
        if ([_mOrderState isEqualToString:@"pending_settle"]){
            _showStatus = @"未结算" ;
        }else if ([_mOrderState isEqualToString:@"settle"]){
            _showStatus = @"已结算" ;
        }else{
            _showStatus = @"取消订单" ;
        }
    }
    
    return _showStatus ;
}

-(NSString *)showSingleAmount
{
    if (!_showSingleAmount){
        _showSingleAmount = [NSString stringWithFormat:@"%.02f",_mSingleAmount] ;
    }
    
    return _showSingleAmount ;
}

//-(NSString *)showProfitAmount
//{
//    if (!_showProfitAmount){
//        if (_m)
//    }
//
//    return _showProfitAmount ;
//}

@end
