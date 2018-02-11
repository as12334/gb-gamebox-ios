//
//  RH_SiteMyMessageModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMyMessageModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_SiteMyMessageModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mAdvisoryContent = [info stringValueForKey:RH_GP_SITEMESSAGE_MYMESSAGE_ADVISORYCONTENT];
        _mAdvisoryTime = [NSDate dateWithTimeIntervalSince1970:[info doubleValueForKey:RH_GP_SITEMESSAGE_MYMESSAGE_ADVISORYTIME]/1000.0];
        _mAdvisoryTitle = [info stringValueForKey:RH_GP_SITEMESSAGE_MYMESSAGE_ADVISORYTITLE];
        _mId = [info integerValueForKey:RH_GP_SITEMESSAGE_MYMESSAGE_ID];
        _mReplyTitle = [info stringValueForKey:RH_GP_SITEMESSAGE_MYMESSAGE_REPLYTITLE];
        _mIsRead = [info boolValueForKey:RH_GP_SITEMESSAGE_MYMESSAGE_READ];
    }
    return self;
}


-(void)updataReadStatus:(BOOL)bflag
{
    if (_mIsRead != bflag) {
        _mIsRead = bflag  ;
        [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_AlreadyReadStatusChangeNotificationSiteMineMessage object:self] ;
    }
}
@end
