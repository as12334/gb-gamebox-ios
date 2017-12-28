//
//  RH_LotteryInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_LotteryInfoModel : RH_BasicModel
@property(nonatomic,assign,readonly) NSInteger  mID ;
@property(nonatomic,assign,readonly) NSInteger  mGameID ;
@property(nonatomic,assign,readonly) NSInteger  mSiteID ;
@property(nonatomic,assign,readonly) NSInteger  mApiID ;
@property(nonatomic,strong,readonly) NSString  *mGameType ;
@property(nonatomic,strong,readonly) NSString  *mViews ;
@property(nonatomic,assign,readonly) NSInteger  mOrderNum ;
@property(nonatomic,strong,readonly) NSString  *mUrl ;
@property(nonatomic,strong,readonly) NSString  *mStatus ;
@property(nonatomic,assign,readonly) NSInteger  mApiTypeID ;
@property(nonatomic,assign,readonly) NSInteger  mSupportTerminal ;
@property(nonatomic,strong,readonly) NSString  *mCode ;
@property(nonatomic,strong,readonly) NSString  *mName ;
@property(nonatomic,strong,readonly) NSString  *mCover ;
@property(nonatomic,strong,readonly) NSString  *mCantry ;

@end

