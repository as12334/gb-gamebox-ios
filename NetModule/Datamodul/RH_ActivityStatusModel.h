//
//  RH_ActivityStatusModel.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_ActivityStatusModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mDrawTimes;
@property(nonatomic,assign,readonly)BOOL  mIsEnd;
@property(nonatomic,strong,readonly)NSString *mNextLotteryTime;
@property(nonatomic,strong,readonly)NSString *mToken;
@end
