//
//  RH_LotteryAPIInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_LotteryInfoModel.h"

@interface RH_LotteryAPIInfoModel : RH_BasicModel
@property(nonatomic,assign,readonly) NSInteger  mID ;
@property(nonatomic,assign,readonly) NSInteger  mRelationID ;
@property(nonatomic,strong,readonly) NSString  *mName ;
@property(nonatomic,strong,readonly) NSString  *mLocal ;
@property(nonatomic,assign,readonly) NSInteger  mSiteID ;
@property(nonatomic,assign,readonly) NSInteger  mApiID ;
@property(nonatomic,assign,readonly) NSInteger  mApiTypeID ;
@property(nonatomic,assign,readonly) NSArray<RH_LotteryInfoModel*> *mLotteryInfoList ;
-(void)updateLotteryInfoWithList:(NSArray*)infoList ;

@end
