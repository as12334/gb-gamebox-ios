//
//  RH_UserSafetyCodeModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_UserApiBalanceModel.h"

@interface RH_UserSafetyCodeModel : RH_BasicModel
@property (nonatomic,assign,readonly) BOOL mHasRealName ;
@property (nonatomic,assign,readonly) BOOL mHasPersimmionPwd ;
@property (nonatomic,assign,readonly) BOOL mIsOpenCaptch ;
@property (nonatomic,assign,readonly) NSInteger mRemindTime ;
@property (nonatomic,strong,readonly) NSString *mLockTime ;
@end
