//
//  RH_DiscountActivityTypeModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DiscountActivityTypeModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_DiscountActivityTypeModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mID = [info integerValueForKey:RH_GP_DISCOUNTACTIVITY_ID];
        _mActivityKey = [info stringValueForKey:RH_GP_DISCOUNTACTIVITY_ACTIVITYKEY];
        _mActivityTypeName = [info stringValueForKey:RH_GP_DISCOUNTACTIVITY_ACTIVITYTYPENAME];
    }
    return self;
}
@end
