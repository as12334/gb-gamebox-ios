//
//  RH_GameNoticeModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameNoticeModel.h"
#import "coreLib.h"
#import "RH_API.h"


@implementation  ListModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mId = [info stringValueForKey:RH_GP_GAMENOTICE_ID];
        _mTitle = [info stringValueForKey:RH_GP_GAMENOTICE_TITLE];
        _mGameName = [info stringValueForKey:RH_GP_GAMENOTICE_GAMENAME];
//        _mPublishTime = [info integerValueForKey:RH_GP_GAMENOTICE_PUBLISHTIME];
        _mPublishTime = [NSDate dateWithTimeIntervalSince1970:[info floatValueForKey:RH_GP_GAMENOTICE_PUBLISHTIME]/1000.0] ;
        
        _mContext = [info stringValueForKey:RH_GP_GAMENOTICE_CONTEXT];
        _mLink = [info stringValueForKey:RH_GP_GAMENOTICE_LINK];
    }
    return self;
}

@end

@implementation  ApiSelectModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mApiId = [info integerValueForKey:RH_GP_GAMENOTICE_APIID];
        _mApiName = [info stringValueForKey:RH_GP_GAMENOTICE_APINAME];
    }
    return self;
}

@end
@implementation RH_GameNoticeModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mMinDate = [info integerValueForKey:RH_GP_GAMENOTICE_MINDATE];
        _mMaxDate = [info integerValueForKey:RH_GP_GAMENOTICE_MAXDATE];
        _mListModel = [ListModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_GAMENOTICE_LIST]] ;
        _mApiSelectModel = [ApiSelectModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_GAMENOTICE_APISELECT]] ;
        _mPageTotal = [info integerValueForKey:RH_GP_GAMENOTICE_PAGETOTAL];
        
    }
    return self;
}


@end
