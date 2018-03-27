//
//  RH_DepositePayAccountModel.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_DepositePayAccountModel : RH_BasicModel
@property(nonatomic,assign,readonly)NSInteger mId;
@property(nonatomic,assign,readonly)NSInteger mSingleDepositMax;
@property(nonatomic,strong,readonly)NSString *mQrCodeUrl;
@property(nonatomic,strong,readonly)NSString *mAccountInformation;
@property(nonatomic,strong,readonly)NSString *mRechargeType;
@property(nonatomic,strong,readonly)NSString *mType;
@property(nonatomic,strong,readonly)NSString *mAccountType;
@property(nonatomic,strong,readonly)NSString *mBankCode;
@property(nonatomic,assign,readonly)NSInteger mSingleDepositMin;
@property(nonatomic,strong,readonly)NSString *mFullName;
@property(nonatomic,strong,readonly)NSString *mRemark;
@property(nonatomic,strong,readonly)NSString *mAccountPrompt;
@property(nonatomic,strong,readonly)NSString *mPayName;
@property(nonatomic,strong,readonly)NSString *mCustomBankName;
@property(nonatomic,strong,readonly)NSString *mAccount;
@property(nonatomic,strong,readonly)NSString *mOpenAcountName;
@property(nonatomic,strong,readonly)NSString *mAliasName;
@property(nonatomic,strong,readonly)NSString *mRandomAmount;
@property(nonatomic,strong,readonly)NSString *mBankName;
@property(nonatomic,strong,readonly)NSString *mDepositWay;
@end
