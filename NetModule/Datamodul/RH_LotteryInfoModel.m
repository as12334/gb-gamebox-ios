//
//  RH_LotteryInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LotteryInfoModel.h"
#import "coreLib.h"
#import "RH_APPDelegate.h"
#import "RH_API.h"

@interface RH_LotteryInfoModel ()
@end ;

@implementation RH_LotteryInfoModel
@synthesize showCover = _showCover ;
@synthesize showGameLink = _showGameLink ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mApiID = [info integerValueForKey:RH_GP_LOTTERYINFO_APIID] ;
        _mApiTypeID = [info integerValueForKey:RH_GP_LOTTERYINFO_APITYPEID] ;
        _mAutoPay = [info boolValueForKey:RH_GP_LOTTERYINFO_AUTOPAY] ;
        _mCode = [info stringValueForKey:RH_GP_LOTTERYINFO_CODE] ;
        _mCover = [info stringValueForKey:RH_GP_LOTTERYIINFO_COVER] ;
        _mGameID = [info stringValueForKey:RH_GP_LOTTERYINFO_GAMEID] ;
        _mGameLink = [info stringValueForKey:RH_GP_LOTTERYINFO_GAMELINK] ;
        _mGameMsg = [info stringValueForKey:RH_GP_LOTTERYINFO_GAMEMSG] ;
        _mGameType = [info stringValueForKey:RH_GP_LOTTERYINFO_GAMETYPE];
        _mName = [info stringValueForKey:RH_GP_LOTTERYINFO_NAME] ;
        _mOrderNum = [info integerValueForKey:RH_GP_LOTTERYINFO_ORDERNUM] ;
        _mSiteID = [info integerValueForKey:RH_GP_LOTTERYINFO_SITEID] ;
        _mStatus = [info stringValueForKey:RH_GP_LOTTERYINFO_STATUS] ;
        _mSystemStatus = [info stringValueForKey:RH_GP_LOTTERYINFO_SYSTEMSTATUS] ;
    }
    
    return self ;
}

#pragma mark-
-(NSString *)showCover
{
    if (!_showCover){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if ([_mCover containsString:@"http:"] || [_mCover containsString:@"https:"]) {
            _showCover = [NSString stringWithFormat:@"%@",_mCover] ;
        }else
        {
            _showCover = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mCover] ;
        }
        
    }
    
    return _showCover ;
}

-(NSString *)showGameLink
{
    if (!_showGameLink){
        if (!_mAutoPay && _mApiTypeID!=2 && ![_mGameLink containsString:@"mobile-api"]){
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
            if ([_mGameLink containsString:@"http:"]||[_mGameLink containsString:@"https:"]) {
                _showGameLink = [NSString stringWithFormat:@"%@",_mGameLink] ;
            }else
            {
                _showGameLink = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mGameLink] ;
            }
            
        }
    }
    
    return _showGameLink ;
}

-(void)updateShowGameLink:(NSDictionary*)gameLinkDict
{
    _showGameLink = [gameLinkDict stringValueForKey:RH_GP_GAMESLINK_LINKURL] ;
    _mGameMsg = [gameLinkDict stringValueForKey:RH_GP_GAMESLINK_MESSAGE]?:_mGameMsg ;
    
    if (_showGameLink.length==0 && _mGameMsg.length==0){
        _mGameMsg = @"游戏正在维护中..." ;
    }
}

@end
