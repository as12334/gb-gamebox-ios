
//
//  RH_SharePlayerRecommendModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SharePlayerRecommendModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_RemmendModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mCount = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_COUNT] ;
        _mUser = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_USER] ;
    }
    return self;
}
@end

@implementation RH_SharePlayerRecommendModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mReward = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_REWARD] ;
        _mSigin = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_SIGN] ;
        _mRemmendModel = [[RH_RemmendModel alloc] initWithInfoDic:[info objectForKey:RH_GP_SHAREPLAYERRECOMMEND_RECOMMEND]];
        _mCode = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_CODE] ;
        _mMoney = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_MONEY] ;
        _mBonus = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_BONUS] ;
    }
    return self;
}
@end
