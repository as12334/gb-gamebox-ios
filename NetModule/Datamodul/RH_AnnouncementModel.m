//
//  RH_AnnouncementModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_AnnouncementModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_AnnouncementModel ()
@end ;

@implementation RH_AnnouncementModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mOrderNum = [info integerValueForKey:RH_GP_ANNOUNCEMENT_ORDERNUM] ;
        _mLanguage = [info stringValueForKey:RH_GP_ANNOUNCEMENT_LANGUAGE] ;
        _mID = [info integerValueForKey:RH_GP_ANNOUNCEMENT_ID] ;
        _mCode = [info stringValueForKey:RH_GP_ANNOUNCEMENT_CODE] ;
        _mTitle = [info stringValueForKey:RH_GP_ANNOUNCEMENT_TITLE] ;
        _mIsTask = [info integerValueForKey:RH_GP_ANNOUNCEMENT_ISTASK] ;
        _mContent = [info stringValueForKey:RH_GP_ANNOUNCEMENT_CONTENT] ;
        _mDisplay = [info integerValueForKey:RH_GP_ANNOUNCEMENT_DISPLAY] ;
        _mPublishTime = [NSDate dateWithTimeIntervalSince1970:[info doubleValueForKey:RH_GP_ANNOUNCEMENT_PUBLISHTIME]/1000.0] ;
        _mAnnouncementType = [info integerValueForKey:RH_GP_ANNOUNCEMENT_TYPE] ;
    }
    
    return self ;
}


@end
