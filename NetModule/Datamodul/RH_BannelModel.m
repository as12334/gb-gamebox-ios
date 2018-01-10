//
//  RH_BannelModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BannelModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@interface RH_BannelModel ()
@end ;

@implementation RH_BannelModel
@synthesize thumbURL = _thumbURL ;
@synthesize contentURL = _contentURL ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mID = [info integerValueForKey:RH_GP_Banner_ID] ;
        _mLink = [info stringValueForKey:RH_GP_Banner_LINK] ;
        _mName = [info stringValueForKey:RH_GP_Banner_NAME] ;
        _mType = [info stringValueForKey:RH_GP_Banner_TYPE] ;
        _mCover = [info stringValueForKey:RH_GP_Banner_COVER] ;
        _mStatus = [info integerValueForKey:RH_GP_Banner_STATUS] ;
        _mEndTime = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_Banner_ENDTIME]/1000.0] ;
        _mStartTime = [NSDate dateWithTimeIntervalSince1970:[info integerValueForKey:RH_GP_Banner_STARTTIME]/1000.0] ;
        _mLanguage = [info stringValueForKey:RH_GP_Banner_LANGUAGE] ;
        _mOrderNum = [info integerValueForKey:RH_GP_Banner_ORDERNUM] ;
        _mCarouselID = [info integerValueForKey:RH_GP_Banner_CAROUSEL_ID] ;
    }
    
    return self ;
}

#pragma mark-
-(NSString *)thumbURL
{
    if (!_thumbURL){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        _thumbURL = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mCover] ;
    }
    
    return _thumbURL ;
}

-(NSString *)contentURL
{
    if (!_contentURL){
        _contentURL = _mLink ;
    }
    
    return _contentURL ;
}

-(NSString *)id
{
    return _mName ;
}
@end
