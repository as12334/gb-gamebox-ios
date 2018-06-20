//
//  RH_OpenActivityModel.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_OpenActivityModel : RH_BasicModel
@property(nonatomic,strong,readonly) NSString  *mNextLotteryTime;
@property(nonatomic,strong,readonly) NSString  *mToken;
@property(nonatomic,strong,readonly) NSString  *mAward;
@property(nonatomic,strong,readonly) NSString  *mGameNum;
@property(nonatomic,strong,readonly) NSString  *mApplyId;
@property(nonatomic,strong,readonly) NSString  *mRecordId;
@property(nonatomic,strong,readonly) NSString  *mId;
@end
