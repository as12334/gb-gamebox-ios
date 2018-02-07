//
//  RH_SiteMessageModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMessageModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_SiteMessageModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mId = [info integerValueForKey:RH_GP_SITEMESSAGE_ID];
        _mContent = [info stringValueForKey:RH_GP_SITEMESSAGE_CONTENT];
        _mPublishTime = [NSDate dateWithTimeIntervalSince1970:[info doubleValueForKey:RH_GP_SITEMESSAGE_PUBLISHTIME]/1000.0] ;
        _mLink = [info stringValueForKey:RH_GP_SITEMESSAGE_LINK];
        _mTitle = [info stringValueForKey:RH_GP_SITEMESSAGE_TITLE];
        _mRead = [info boolValueForKey:RH_GP_SITEMESSAGE_READ];
        _mSearchId = [info stringValueForKey:RH_GP_SITEMESSAGE_SEARCHID];
       
    }
    return self;
}
-(NSInteger)ID
{
    return _mId ;
}

-(void)updataReadStatus:(BOOL)bflag
{
    if (_mRead != bflag) {
        _mRead = bflag  ;
        [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_AlreadyReadStatusChangeNotification object:self] ;
    }
}
@end
