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

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mBannerList = [RH_BannelModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_HOMEINFO_BANNER_LIST]] ;
        _mAnnouncementList = [RH_AnnouncementModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_HOMEINFO_ANNOUNCEMENT_LIST]] ;
        _mLotteryCategoryList = [RH_LotteryCategoryModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_HOMEINFO_SITEAPIRELATION]] ;
        _mCasinoMap = [info dictionaryValueForKey:RH_GP_HOMEINFO_CASINOMAP] ;
        
        NSDictionary *lotteryGames = [[info dictionaryValueForKey:RH_GP_HOMEINFO_LOTTERYGAME] dictionaryValueForKey:RH_GP_HOMEINFO_LOTTERYGAME] ;
        
        for (RH_LotteryCategoryModel *categoryModel in _mLotteryCategoryList) {
            if (categoryModel.mApiType == 4){
                //彩票站点
                for (RH_LotteryAPIInfoModel *lotteryApiInfoModel in categoryModel.mSiteApis) {
                    [lotteryApiInfoModel updateLotteryInfoWithList:
                     [lotteryGames arrayValueForKey:[NSString stringWithFormat:@"%d",lotteryApiInfoModel.mApiID]]] ;
                }
            }
        }
    }
    
    return self ;
}

@end
