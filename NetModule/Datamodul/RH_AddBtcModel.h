//
//  RH_AddBtcModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_AddBtcModel : RH_BasicModel
@property(nonatomic,assign,readonly)NSInteger mID;
@property(nonatomic,assign,readonly)NSInteger mUserID;
@property(nonatomic,strong,readonly)NSString *mBankcardMasterName;
@property(nonatomic,strong,readonly)NSString *mBankcardNumber;
@property(nonatomic,strong,readonly)NSDate *mCreateTime;
@property(nonatomic,assign,readonly)NSInteger mUseCount;
@property(nonatomic,assign,readonly)BOOL mUseStauts;
@property(nonatomic,assign,readonly)BOOL mIsDefault;
@property(nonatomic,strong,readonly)NSString *mBankName;
@property(nonatomic,strong,readonly)NSString *mBankDeposit;
@property(nonatomic,strong,readonly)NSString *mCustomBankName;
@property(nonatomic,assign,readonly)NSInteger mType;
@end
