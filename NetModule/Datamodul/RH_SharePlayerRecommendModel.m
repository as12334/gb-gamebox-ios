
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

@implementation RH_CommendModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        
    }
    return self ;
}
@end




@implementation RH_RemmendModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mCount = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_COUNT];
        _mUser = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_USER];
        _mSingle = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_SINGLE];
        _mBonus = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_BOUNDS];
    }
    return self;
}
@end

@implementation RH_GradientTempArrayListModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mId = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_ID] ;
        _mPlayerNum = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_PLAYERNUM] ;
        _mProportion = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_PROPORTION] ;
    }
    return self ;
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
        _mIsBonus = [info boolValueForKey:RH_GP_SHAREPLAYERRECOMMEND_ISBOUNDS] ;
        _mWitchWithdraw = [info stringValueForKey:RH_GP_SHAREPLAYERRECOMMEND_WITCHWITHDRAW] ;
        _mGradientListModel = [RH_GradientTempArrayListModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_SHAREPLAYERRECOMMEND_GRADIENTTEMPARRAYLIST]] ;
        _mCommendModel = [RH_CommendModel dataArrayWithInfoArray:[info arrayValueForKey:@"command"]] ;
        _mActivityRules = [info stringValueForKey:@"activityRules"];
    }
    return self;
}

@end
