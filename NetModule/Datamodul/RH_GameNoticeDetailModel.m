//
//  RH_GameNoticeDetailModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameNoticeDetailModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_GameNoticeDetailModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mID = [info integerValueForKey:RH_GP_GAMENOTICEDETAIL_ID];
        _mTitle = [info stringValueForKey:RH_GP_GAMENOTICEDETAIL_TITLE];
        _mLink = [info stringValueForKey:RH_GP_GAMENOTICEDETAIL_LINK];
        _mGameName = [info stringValueForKey:RH_GP_GAMENOTICEDETAIL_GAMENAME];
        _mPublishTime = [info integerValueForKey:RH_GP_GAMENOTICEDETAIL_PUBLISHTIME];
        _mContext = [info stringValueForKey:RH_GP_GAMENOTICEDETAIL_CONTEXT];
    }
    return self;
}

@end
