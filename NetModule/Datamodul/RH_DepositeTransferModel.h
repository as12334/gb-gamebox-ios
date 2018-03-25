//
//  RH_DepositeTransferModel.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_DepositePaydataModel:RH_BasicModel
@property(nonatomic,strong,readonly)NSArray *mQuickMoneys;
@property(nonatomic,assign,readonly)BOOL  mLotterySite;
@property(nonatomic,strong,readonly)NSString *mIsFastRecharge;
@property(nonatomic,assign,readonly)BOOL  mIsMultipleAccount;
@end

@interface RH_DepositePayModel:RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mName;
@property(nonatomic,strong,readonly)NSString *mCode;
@property(nonatomic,strong,readonly)NSArray *mQayAccounts;
@end


@interface RH_DepositeTransferModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSArray *mPay;
@property(nonatomic,strong,readonly)RH_DepositePaydataModel *payModel;
@end

