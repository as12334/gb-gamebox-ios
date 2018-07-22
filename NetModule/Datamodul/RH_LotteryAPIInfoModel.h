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
@property(nonatomic,assign,readonly) NSInteger  mApiID ;
@property(nonatomic,assign,readonly) NSInteger  mApiTypeID ;
@property(nonatomic,assign,readonly) BOOL  mAutoPay ;
@property(nonatomic,strong,readonly) NSString  *mCover ;
@property(nonatomic,strong,readonly) NSString  *mGameLink ;
@property(nonatomic,strong,readonly) NSArray<RH_LotteryInfoModel*> *mGameItems ;
@property(nonatomic,strong,readonly) NSString  *mGameMsg ;
@property(nonatomic,strong,readonly) NSString  *mLocal ;
@property(nonatomic,strong,readonly) NSString  *mName ;
@property(nonatomic,assign,readonly) NSInteger  mSiteID ;

//extend
@property(nonatomic,strong,readonly) NSString *showCover ;
@property(nonatomic,strong,readonly) NSString *showGameLink ;

-(void)updateShowGameLink:(NSDictionary*)gameLinkDict ;
@end
