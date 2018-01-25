//
//  RH_SystemNoticeModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SystemNoticeModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_SystemNoticeModel

-(id)initWithInfoDic:(NSDictionary *)info{
    if (self = [super initWithInfoDic:info])
    {
        _mID = [info stringValueForKey:RH_GP_SYSTEMNOTICE_ID];
        _mContent = [info stringValueForKey:RH_GP_SYSTEMNOTICE_CONTENT];
        _mPublishTime = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_SYSTEMNOTICE_PUBLISHTIME]/1000.0] ;
        _mLink = [info stringValueForKey:RH_GP_SYSTEMNOTICE_LINK];
        _mPageTotal = [info integerValueForKey:RH_GP_SYSTEMNOTICE_TOTALNUM];
        _mMinDate = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_SYSTEMNOTICE_MINDATE]/1000.0] ;
        _mMaxDate = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_SYSTEMNOTICE_MAXDATE]/1000.0] ;
        _mSearchId = [info stringValueForKey:RH_GP_SYSTEMNOTICE_SEARCHID];
    }
    return self;
}

@end
