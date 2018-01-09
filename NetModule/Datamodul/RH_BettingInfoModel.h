//
//  RH_BettingInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface RH_BettingInfoModel : RH_BasicModel
@property(nonatomic,assign,readonly) NSInteger  mID ;
@property(nonatomic,assign,readonly) NSInteger  mApiID ;
@property(nonatomic,assign,readonly) NSInteger  mGameID ;
@property(nonatomic,strong,readonly) NSString*  mTerminal ;
@property(nonatomic,strong,readonly) NSDate*  mBettime    ;
@property(nonatomic,assign,readonly) CGFloat  mSingleAmount ;
@property(nonatomic,strong,readonly) NSString*  mOrderState ;

@end
