//
//  RH_ShareRecordModel.h
//  gameBoxEx
//
//  Created by lewis on 2018/6/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
@interface RH_ShareRecordDetailModel:RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mRecommendUserName;
@property(nonatomic,strong,readonly)NSString *mCreateTime;
@property(nonatomic,strong,readonly)NSString *mStatus;
@property(nonatomic,strong,readonly)NSString *mRewardAmount;
@end
@interface RH_ShareRecordModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSArray<RH_ShareRecordDetailModel *>*mCommand;
@end

