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

@interface RH_LotteryAPIInfoModel ()
@end ;

@implementation RH_LotteryAPIInfoModel

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
        _mLotteryInfoList = [RH_LotteryInfoModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_LOTTERYAPIINFO_GAMELIST]] ;
    }
    
    return self ;
}

//#pragma mark-
//-(void)updateLotteryInfoWithList:(NSArray*)infoList
//{
//    _mLotteryInfoList = [RH_LotteryInfoModel dataArrayWithInfoArray:ConvertToClassPointer(NSArray, infoList)] ;
//}

@end
