//
//  RH_SystemNoticeDetailModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SystemNoticeDetailModel.h"
#import "RH_API.h"
#import "coreLib.h"

@implementation RH_SystemNoticeDetailModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mID = [info stringValueForKey:RH_GP_SYSTEMNOTICEDETAIL_ID];
        _mContent = [info stringValueForKey:RH_GP_SYSTEMNOTICEDETAIL_CONTENT];
        _mLink = [info stringValueForKey:RH_GP_SYSTEMNOTICEDETAIL_LINK];
        _mPublishTime = [NSDate dateWithTimeIntervalSince1970:[info floatValueForKey:RH_GP_SYSTEMNOTICEDETAIL_PUBLISHTIME]/1000.0] ;
        _mTitle = [info stringValueForKey:RH_GP_SYSTEMNOTICEDETAIL_TITLE];
    }
    return self;
}
@end
