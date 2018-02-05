//
//  RH_CapitalDetailModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import <CoreGraphics/CoreGraphics.h>
@interface RH_CapitalDetailModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mAdministrativeFee;
@property(nonatomic,strong,readonly)NSDate   *mCreateTime;
@property(nonatomic,strong,readonly)NSString *mDeductFavorable;
@property(nonatomic,strong,readonly)NSString *mFailureReason;
@property(nonatomic,strong,readonly)NSString *mFundType;
@property(nonatomic,strong,readonly)NSString *mId;
@property(nonatomic,strong,readonly)NSString *mPayerBankcard;
@property(nonatomic,strong,readonly)NSString *mPoundage;
@property(nonatomic,strong,readonly)NSString *mRealName;
@property(nonatomic,strong,readonly)NSString *mRechargeAddress;
@property(nonatomic,strong,readonly)NSString *mRechargeTotalAmount;
@property(nonatomic,strong,readonly)NSString *mStatus;
@property(nonatomic,strong,readonly)NSString *mStatusName;
@property(nonatomic,assign,readonly)CGFloat   mTransactionMoney;
@property(nonatomic,strong,readonly)NSString *mTransactionNo;
@property(nonatomic,strong,readonly)NSString *mTransactionType;
@property(nonatomic,strong,readonly)NSString *mTransactionWay;
@property(nonatomic,strong,readonly)NSString *mTransactionWayName;
@property(nonatomic,strong,readonly)NSString *mUsername;
@property(nonatomic,strong,readonly)NSString *mTransferInto;
@property(nonatomic,strong,readonly)NSString *mTransferOut;


//extend
@property(nonatomic,strong,readonly)NSString *showTransactionMoney;
@end
