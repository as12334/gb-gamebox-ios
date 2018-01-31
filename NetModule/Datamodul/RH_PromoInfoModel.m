//
//  RH_PromoInfoModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PromoInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_PromoInfoModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mID = [info integerValueForKey:RH_GP_PROMOINFO_ID] ;
        _mUserID = [info integerValueForKey:RH_GP_PROMOINFO_USERID] ;
        _mApplyTime = [NSDate dateWithTimeIntervalSince1970:[info floatValueForKey:RH_GP_PROMOINFO_APPLYTIME]/1000.0] ;
        _mCheckState = [info integerValueForKey:RH_GP_PROMOINFO_CHECKSTATE] ;
        _mActivityName = [info stringValueForKey:RH_GP_PROMOINFO_ACTIVITYNAME] ;
        _mActivityVersion = [info stringValueForKey:RH_GP_PROMOINFO_ACTIVITYVERSION] ;
        _mPreferentialAudit = [info boolValueForKey:RH_GP_PROMOINFO_PREFERENTIALAUDIT] ;
        _mPreferentialAuditName = [info stringValueForKey:RH_GP_PROMOINFO_PREFERENTIALAUDITNAME] ;
        _mPreferentialValue = [info floatValueForKey:RH_GP_PROMOINFO_PREFERENTIALVALUE] ;
        _mCheckStateName = [info stringValueForKey:RH_GP_PROMOINFO_CHECKSTATENAME] ;
    }
    return self;
}


-(NSString *)showApplyTime
{
    if (!_showApplyTime){
        _showApplyTime = dateStringWithFormatter(_mApplyTime, @"yyyy年MM月dd日") ;
    }
    
    return _showApplyTime ;
}

-(NSString *)showPreferentialValue
{
    if (!_showPreferentialValue){
        _showPreferentialValue = [NSString stringWithFormat:@"¥%.02f",_mPreferentialValue] ;
    }
    
    return _showPreferentialValue ;
}

@end
