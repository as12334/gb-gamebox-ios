//
//  RH_OpenActivityModel.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_OpenActivityModel.h"
#import "coreLib.h"
#import "RH_API.h"
@implementation RH_OpenActivityModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mAward = [info stringValueForKey:RH_GP_OPENACTIVITY_AWARD] ;
        _mGameNum = [info stringValueForKey:RH_GP_OPENACTIVITY_GAMENUM] ;
        _mNextLotteryTime = [info stringValueForKey:RH_GP_OPENACTIVITY_NEXTLOTTERYTIME];
        _mToken = [info stringValueForKey:RH_GP_OPENACTIVITY_TOKEN];
        _mApplyId = [info stringValueForKey:RH_GP_OPENACTIVITY_APPLYID];
        _mRecordId = [info stringValueForKey:RH_GP_OPENACTIVITY_RECORDID];
        _mId = [info stringValueForKey:RH_GP_OPENACTIVITY_ID];
    }
    return self ;
}
@end
