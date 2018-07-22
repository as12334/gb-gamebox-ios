//
//  RH_ShareRecordModel.m
//  gameBoxEx
//
//  Created by lewis on 2018/6/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareRecordModel.h"
#import "RH_API.h"
#import "coreLib.h"
@implementation RH_ShareRecordModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mCommand = [RH_ShareRecordDetailModel dataArrayWithInfoArray:[info objectForKey:RH_GP_GETPLAYERRECOMMENDRECORD_COMMAND]]  ;
    }
    return self ;
}
@end
@implementation RH_ShareRecordDetailModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mRecommendUserName = [info stringValueForKey:RH_GP_GETPLAYERRECOMMENDRECORD_RECOMMENDUSERNAME]  ;
        _mCreateTime = [info stringValueForKey:RH_GP_GETPLAYERRECOMMENDRECORD_CREATETIME] ;
        _mStatus = [info stringValueForKey:RH_GP_GETPLAYERRECOMMENDRECORD_STATUS] ;
        _mRewardAmount = [info stringValueForKey:RH_GP_GETPLAYERRECOMMENDRECORD_REWARDAMOUNT] ;
    }
    return self ;
}
@end
