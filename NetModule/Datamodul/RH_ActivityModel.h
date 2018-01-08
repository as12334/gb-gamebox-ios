//
//  RH_ActivityModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_ActivityModel : RH_BasicModel
@property(nonatomic,strong,readonly) NSString  *mActivityID ;
@property(nonatomic,strong,readonly) NSString  *mDescription ;
@property(nonatomic,assign,readonly) NSInteger  mDistanceSide ;
@property(nonatomic,strong,readonly) NSString  *mDistanceTop ;
@property(nonatomic,strong,readonly) NSString  *mLanguage ;
@property(nonatomic,strong,readonly) NSString  *mLocation ;
@property(nonatomic,strong,readonly) NSString  *mNormalEffect ;
@property(nonatomic,strong,readonly) NSString  *mIsEnd;
@property(nonatomic,strong,readonly) NSString  *mDrawTimes;
@property(nonatomic,strong,readonly) NSString  *mNextLotteryTime;
@property(nonatomic,strong,readonly) NSString  *mToken;

//extend
@property(nonatomic,strong,readonly) NSString  *showEffectURL ;
@end
