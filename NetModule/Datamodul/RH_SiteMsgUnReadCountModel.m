//
//  RH_SiteMsgUnReadCountModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMsgUnReadCountModel.h"
#import "coreLib.h"

@implementation RH_SiteMsgUnReadCountModel
@synthesize sysMsgUnreadCount = _sysMsgUnreadCount ;
@synthesize mineMsgUnreadCount = _mineMsgUnreadCount ;
@synthesize siteMsgUnReadCount = _siteMsgUnReadCount ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _sysMsgUnreadCount = [info stringValueForKey:@"sysMessageUnReadCount"] ;
        _mineMsgUnreadCount = [info stringValueForKey:@"advisoryUnReadCount"] ;
        _siteMsgUnReadCount = [_sysMsgUnreadCount integerValue] + [_mineMsgUnreadCount integerValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isHaveNoReadSiteSysMessage_NT" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isHaveNoReadSiteMineMessage_NT" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnReadSiteMsgCount_NT" object:self];
    }
    return self ;
}

-(NSInteger)siteMsgUnReadCount
{
    if (!_siteMsgUnReadCount){
        if (_sysMsgUnreadCount || _mineMsgUnreadCount) {
            _siteMsgUnReadCount = [_sysMsgUnreadCount integerValue] + [_mineMsgUnreadCount integerValue];
        }
    }
    return _siteMsgUnReadCount;
}

@end
