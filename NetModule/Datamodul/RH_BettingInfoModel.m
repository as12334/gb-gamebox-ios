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
@synthesize showDetailUrl = _showDetailUrl;

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mID = [info stringValueForKey:RH_GP_BETTING_ID] ;
        _mApiID = [info integerValueForKey:RH_GP_BETTING_APIID] ;
        _mApiName = [info stringValueForKey:RH_GP_BETTING_APINAME] ;
        _mGameID = [info integerValueForKey:RH_GP_BETTING_GAMEID] ;
        _mGameName = [info stringValueForKey:RH_GP_BETTING_GAMENAME] ;
        _mBettime = [NSDate dateWithTimeIntervalSince1970:[info floatValueForKey:RH_GP_BETTING_BETTIME]/1000.0] ;
        _mTerminal = [info stringValueForKey:RH_GP_BETTING_TERMINAL] ;
        _mProfitAmount = [info floatValueForKey:RH_GP_BETTING_PROFITAMOUNT] ;
        _mOrderState = [info stringValueForKey:RH_GP_BETTING_ORDERSTATE] ;
        _mSingleAmount = [info floatValueForKey:RH_GP_BETTING_SINGLEAMOUNT];
        _mURL = [info stringValueForKey:RH_GP_BETTING_URL] ;
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

-(NSString *)showProfitAmount
{
    if (!_showProfitAmount){
        if (_mProfitAmount==0){
            _showProfitAmount = @"--" ;
        }else{
            _showProfitAmount = [NSString stringWithFormat:@"%.02f",_mProfitAmount] ;
        }
    }

    return _showProfitAmount ;
}

-(NSString *)showDetailUrl
{
    if (!_showDetailUrl){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if (_mURL.length){
            if ([[_mURL substringToIndex:1] isEqualToString:@"/"]){
                _showDetailUrl = [NSString stringWithFormat:@"%@%@",appDelegate.domain,_mURL] ;
            }else {
                _showDetailUrl = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mURL] ;
            }
        }
    }
    return _showDetailUrl ;
    
}

@end
