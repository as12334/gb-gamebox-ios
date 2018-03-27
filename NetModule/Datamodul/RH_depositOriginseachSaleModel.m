//
//  RH_depositOriginseachSaleModel.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_depositOriginseachSaleModel.h"
#import "coreLib.h"
#import "RH_API.h"
@implementation RH_depositOriginseachSaleDetailsModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mId = [info integerValueForKey:RH_GP_DEPOSITESEACHSALE_ID];
        _mPreferential = [info boolValueForKey:RH_GP_DEPOSITESEACHSALE_PREFERENTIAL];
        _mActivityName = [info stringValueForKey:RH_GP_DEPOSITESEACHSALE_ACTIVITYNAME];
    }
    return self;
}
@end

@implementation RH_depositOriginseachSaleModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mMsg = [info stringValueForKey:RH_GP_DEPOSITESEACHSALE_MSG];
        _mFee = [info floatValueForKey:RH_GP_DEPOSITESEACHSALE_FEE];
        _mCounterFee = [info stringValueForKey:RH_GP_DEPOSITESEACHSALE_COUNTERFEE];
        _mFailureCount = [info integerValueForKey:RH_GP_DEPOSITESEACHSALE_FAILURECOUNT];
        _mDetailsModel = [RH_depositOriginseachSaleDetailsModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_DEPOSITESEACHSALE_SALES]];
    }
    return self;
}
@end
