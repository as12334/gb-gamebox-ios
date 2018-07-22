//
//  RH_ActivityStatusModel.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ActivityStatusModel.h"
#import "coreLib.h"
#import "RH_API.h"
@implementation RH_ActivityStatusModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mDrawTimes = [info stringValueForKey:RH_GP_ACTIVITYSTATUS_DRAWTIMES];
        _mIsEnd = [info boolValueForKey:RH_GP_ACTIVITYSTATUS_ISEND];
        _mNextLotteryTime = [info stringValueForKey:RH_GP_ACTIVITYSTATUS_NEXTLOTTERYTIME];
        _mToken = [info stringValueForKey:RH_GP_ACTIVITYSTATUS_TOKEN];
    }
    return self;
}
@end
