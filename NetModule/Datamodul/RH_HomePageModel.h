//
//  RH_HomePageModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_BannelModel.h"
#import "RH_AnnouncementModel.h"
#import "RH_LotteryInfoModel.h"
#import "RH_LotteryCategoryModel.h"
#import "RH_LotteryInfoModel.h"

@interface RH_HomePageModel : RH_BasicModel
@property (nonatomic,strong,readonly) NSArray<RH_BannelModel*> *mBannerList ;
@property (nonatomic,strong,readonly) NSArray<RH_AnnouncementModel*> *mAnnouncementList ;
@property (nonatomic,strong,readonly) NSArray<RH_LotteryCategoryModel*> *mLotteryCategoryList ;

#pragma mark-
@property (nonatomic,strong,readonly) NSString *showAnnouncementContent ;
@end
