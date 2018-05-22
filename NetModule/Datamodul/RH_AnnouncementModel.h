//
//  RH_AnnouncementModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_AnnouncementModel : RH_BasicModel
@property(nonatomic,assign,readonly) NSInteger  mID ;
@property(nonatomic,assign,readonly) NSInteger  mAnnouncementType ;
@property(nonatomic,strong,readonly) NSString  *mCode ;
@property(nonatomic,strong,readonly) NSString  *mContent ;
@property(nonatomic,assign,readonly) NSInteger  mDisplay ;
@property(nonatomic,assign,readonly) NSInteger  mIsTask ;
@property(nonatomic,strong,readonly) NSString  *mLanguage ;
@property(nonatomic,assign,readonly) NSInteger  mOrderNum ;
@property(nonatomic,strong,readonly) NSDate    *mPublishTime ;
@property(nonatomic,strong,readonly) NSString  *mTitle ;

@end
