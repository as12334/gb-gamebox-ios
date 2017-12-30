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

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mID = [info integerValueForKey:RH_GP_LOTTERYAPIINFO_ID] ;
        _mName = [info stringValueForKey:RH_GP_LOTTERYAPIINFO_NAME] ;
        _mApiID = [info integerValueForKey:RH_GP_LOTTERYAPIINFO_APIID] ;
        _mLocal = [info stringValueForKey:RH_GP_LOTTERYAPIINFO_LANGUAGE] ;
        _mSiteID = [info integerValueForKey:RH_GP_LOTTERYAPIINFO_SITEID] ;
        _mApiTypeID = [info integerValueForKey:RH_GP_LOTTERYAPIINFO_APITYPEID] ;
        _mRelationID = [info integerValueForKey:RH_GP_LOTTERYAPIINFO_RELATIONID] ;
        _mCover = [info stringValueForKey:RH_GP_LOTTERYAPIINFO_COVER] ;
        _mGameItems = [RH_LotteryInfoModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_LOTTERYAPIINFO_GAMELIST]] ;
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

@end
