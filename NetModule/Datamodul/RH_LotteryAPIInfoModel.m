//
//  RH_LotteryAPIInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LotteryAPIInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@interface RH_LotteryAPIInfoModel ()
@end ;

@implementation RH_LotteryAPIInfoModel
@synthesize showCover = _showCover  ;
@synthesize showGameLink = _showGameLink ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mApiID = [info integerValueForKey:RH_GP_LOTTERYAPIINFO_APIID] ;
        _mApiTypeID = [info integerValueForKey:RH_GP_LOTTERYAPIINFO_APITYPEID] ;
        _mAutoPay = [info boolValueForKey:RH_GP_LOTTERYINFO_AUTOPAY] ;
        _mCover = [info stringValueForKey:RH_GP_LOTTERYAPIINFO_COVER] ;
        _mGameLink = [info stringValueForKey:RH_GP_LOTTERYAPIINFO_GAMELINK] ;
        _mGameItems = [RH_LotteryInfoModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_LOTTERYAPIINFO_GAMELIST]] ;
        _mGameMsg = [info stringValueForKey:RH_GP_LOTTERYAPIINFO_GAMEMSG] ;
        _mLocal = [info stringValueForKey:RH_GP_LOTTERYAPIINFO_LOCAL] ;
        _mName = [info stringValueForKey:RH_GP_LOTTERYAPIINFO_NAME] ;
        _mSiteID = [info integerValueForKey:RH_GP_LOTTERYAPIINFO_SITEID] ;
    }
    
    return self ;
}

-(NSString *)showCover
{
    if (!_showCover){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        _showCover = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mCover] ;
    }
    
    return _showCover ;
}


-(NSString *)showGameLink
{
    if (!_showGameLink){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        _showGameLink = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mGameLink] ;
    }
    
    return _showGameLink ;
}

@end
