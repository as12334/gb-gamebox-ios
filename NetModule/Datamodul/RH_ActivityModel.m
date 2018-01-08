//
//  RH_ActivityModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_ActivityModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@interface RH_ActivityModel ()
@end ;

@implementation RH_ActivityModel
@synthesize showEffectURL = _showEffectURL  ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mLanguage = [info stringValueForKey:RH_GP_ACTIVITY_LANGUAGE] ;
        _mLocation = [info stringValueForKey:RH_GP_ACTIVITY_LOCATION] ;
        _mActivityID = [info stringValueForKey:RH_GP_ACTIVITY_ACTIVITYID] ;
        _mDescription = [info stringValueForKey:RH_GP_ACTIVITY_DESCRTIPTION] ;
        _mDistanceTop = [info stringValueForKey:RH_GP_ACTIVITY_DISTANCETOP] ;
        _mDistanceSide = [info integerValueForKey:RH_GP_ACTIVITY_DISTANCESIDE] ;
        _mNormalEffect = [info stringValueForKey:RH_GP_ACTIVITY_NORMALEFFECT] ;
        _mIsEnd = [info stringValueForKey:RH_GP_ACTIVITYSTATUS_ISEND];
        _mDrawTimes = [info stringValueForKey:RH_GP_ACTIVITYSTATUS_DRAWTIMES];
        _mNextLotteryTime = [info stringValueForKey:RH_GP_ACTIVITYSTATUS_NEXTLOTTERYTIME];
        _mToken = [info stringValueForKey:RH_GP_ACTIVITYSTATUS_TOKEN];
    }
    return self ;
}

#pragma mark-
-(NSString *)showEffectURL
{
    if (!_showEffectURL){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        _showEffectURL = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mNormalEffect] ;
    }
    
    return _showEffectURL ;
}

@end
