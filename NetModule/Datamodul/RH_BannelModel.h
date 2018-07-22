//
//  RH_BannelModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_BannerModelProtocol.h"

@interface RH_BannelModel : RH_BasicModel<RH_BannerModelProtocol>
@property(nonatomic,assign,readonly) NSInteger  mID ;
@property(nonatomic,strong,readonly) NSString  *mName ;
@property(nonatomic,assign,readonly) NSInteger  mCarouselID ;
@property(nonatomic,strong,readonly) NSString  *mCover ;
@property(nonatomic,strong,readonly) NSDate    *mStartTime ;
@property(nonatomic,strong,readonly) NSDate    *mEndTime ;
@property(nonatomic,strong,readonly) NSString  *mLanguage;
@property(nonatomic,strong,readonly) NSString  *mLink ;
@property(nonatomic,assign,readonly) NSInteger  mOrderNum ;
@property(nonatomic,assign,readonly) NSInteger  mStatus ;
@property(nonatomic,strong,readonly) NSString  *mType ;

@end
