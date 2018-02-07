//
//  RH_HomePageModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomePageModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_HomePageModel ()
@end ;

@implementation RH_HomePageModel
@synthesize showAnnouncementContent = _showAnnouncementContent ;
-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mActivityInfo = [[RH_ActivityModel alloc] initWithInfoDic:[info dictionaryValueForKey:RH_GP_HOMEINFO_ACTIVITY]] ;
        _mBannerList = [RH_BannelModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_HOMEINFO_BANNER]] ;
        _mAnnouncementList = [RH_AnnouncementModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_HOMEINFO_ANNOUNCEMENT]] ;
        _mLotteryCategoryList = [RH_LotteryCategoryModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_HOMEINFO_SITEAPIRELATION]] ;
        
    }
    
//    //--TEST
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1517831332754/1000.0] ;
//    NSString *strTmp = dateStringWithFormatterWithTimezone(date, @"yyyy-MM-dd HH:mm:ss", @"GMT+0800");
//    NSLog(@"%@",strTmp) ;
//    //---END TEST
    return self ;
}

-(NSString *)showAnnouncementContent
{
    if (!_showAnnouncementContent){
        NSMutableString *mutStr = [[NSMutableString alloc] init] ;
        for (int i=0; i<_mAnnouncementList.count; i++) {
            RH_AnnouncementModel *announcementModel = ConvertToClassPointer(RH_AnnouncementModel, _mAnnouncementList[i]) ;
            [mutStr appendString:announcementModel.mContent] ;
        }
        
        _showAnnouncementContent = [NSString stringWithString:mutStr] ;
    }
    
    return _showAnnouncementContent ;
}

@end
