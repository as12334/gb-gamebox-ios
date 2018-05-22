//
//  RH_BettingDetailModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_BettingDetailModel : RH_BasicModel
@property (nonatomic,assign,readonly) NSInteger mApiID ;
@property(nonatomic,strong,readonly) NSString  *mApiName ;
@property(nonatomic,assign,readonly) NSInteger  mApiTypeId ;
@property(nonatomic,strong,readonly) NSString  *mBetDetail ;
@property(nonatomic,assign,readonly) NSInteger  mBetId ;
@property(nonatomic,strong,readonly) NSDate     *mBetTime ;
@property(nonatomic,strong,readonly) NSString  *mBetTypeName ;
@property(nonatomic,strong,readonly) NSString  *mContributionAmount ;
@property(nonatomic,strong,readonly) NSString  *mEffectiveTradeAmount ;
@property(nonatomic,assign,readonly) NSInteger  mGameId ;
@property(nonatomic,strong,readonly) NSString  *mGameName ;
@property(nonatomic,strong,readonly) NSString  *mGameType ;
@property(nonatomic,strong,readonly) NSString  *mOddsTypeName ;
@property(nonatomic,strong,readonly) NSString  *mOrderState ;
@property(nonatomic,strong,readonly) NSString  *mPayoutTime ;
@property(nonatomic,strong,readonly) NSString  *mProfitAmount ;
@property(nonatomic,strong,readonly) NSString  *mResultArray ;
@property(nonatomic,assign,readonly) NSInteger  mSingleAmount ;
@property(nonatomic,assign,readonly) NSInteger  mTerminal ;
@property(nonatomic,strong,readonly) NSString  *mUserName ;


@end
