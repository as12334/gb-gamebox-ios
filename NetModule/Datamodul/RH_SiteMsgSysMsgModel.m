//
//  RH_SiteMsgSysMsgModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMsgSysMsgModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_SiteMsgSysMsgModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mContent = [info stringValueForKey:RH_GP_SITEMSGSYSMSG_CONTENT];
        _mId = [info integerValueForKey:RH_GP_SITEMSGSYSMSG_ID];
        _mLink = [info stringValueForKey:RH_GP_SITEMSGSYSMSG_LINK];
        _mPublishTime = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_SITEMSGSYSMSG_PUBLISHTIME]/1000.0] ;
        _mRead = [info boolValueForKey:RH_GP_SITEMSGSYSMSG_READ];
        _mTitle = [info stringValueForKey:RH_GP_SITEMSGSYSMSG_TITLE];
        
    }
    return self;
}

@end
