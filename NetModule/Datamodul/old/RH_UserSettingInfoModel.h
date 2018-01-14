//
//  RH_UserSettingInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface RH_UserSettingInfoModel : RH_BasicModel
@property (nonatomic,assign,readonly) BOOL mIsBit ;
@property (nonatomic,assign,readonly) BOOL mIsCash ;
@property (nonatomic,strong,readonly) NSString *mAvatarURL ;
@property (nonatomic,strong,readonly) NSString *mBtcNum ;
@property (nonatomic,strong,readonly) NSString *mCurrency ;
@property (nonatomic,strong,readonly) NSString *mLastLoginTime ;
@property (nonatomic,assign,readonly) CGFloat mPreferentialAmount ;
@property (nonatomic,strong,readonly) NSString *mUserName ;

@end

