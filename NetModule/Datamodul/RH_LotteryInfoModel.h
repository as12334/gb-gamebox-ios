//
//  RH_LotteryInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_LotteryInfoModel : RH_BasicModel
@property(nonatomic,assign,readonly) NSInteger  mApiID ;
@property(nonatomic,assign,readonly) NSInteger  mApiTypeID ;
@property(nonatomic,assign,readonly) NSInteger  mAutoPay ;
@property(nonatomic,strong,readonly) NSString  *mCode ;
@property(nonatomic,strong,readonly) NSString  *mCover ;
@property(nonatomic,assign,readonly) NSInteger  mGameID ;
@property(nonatomic,strong,readonly) NSString  *mGameLink ;
@property(nonatomic,strong,readonly) NSString  *mGameMsg ;
@property(nonatomic,strong,readonly) NSString  *mGameType ;
@property(nonatomic,strong,readonly) NSString  *mName ;
@property(nonatomic,assign,readonly) NSInteger  mOrderNum ;
@property(nonatomic,assign,readonly) NSInteger  mSiteID ;
@property(nonatomic,strong,readonly) NSString  *mStatus ;
@property(nonatomic,strong,readonly) NSString  *mSystemStatus ;

//-extent
@property(nonatomic,strong,readonly) NSString *showCover ;
@property(nonnull,strong,readonly) NSString *showGameLink ;

@end

