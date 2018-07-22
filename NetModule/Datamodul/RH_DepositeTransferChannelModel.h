//
//  RH_DepositeTransferChannelModel.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/29.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
@interface RH_DepositeTransferListModel : RH_BasicModel
@property(nonatomic,assign,readonly)NSInteger mId;
@property(nonatomic,strong,readonly)NSString *mPayName;
@property(nonatomic,strong,readonly)NSString *mAccount;
@property(nonatomic,strong,readonly)NSString *mFullName;
@property(nonatomic,strong,readonly)NSString *mCode;
@property(nonatomic,strong,readonly)NSString *mType;
@property(nonatomic,strong,readonly)NSString *mAccountType;
@property(nonatomic,strong,readonly)NSString *mBankCode;
@property(nonatomic,strong,readonly)NSString *mBankName;
@property(nonatomic,assign,readonly)NSInteger mSingleDepositMin;
@property(nonatomic,assign,readonly)NSInteger mSingleDepositMax;
@property(nonatomic,strong,readonly)NSString *mOpenAcountName;
@property(nonatomic,strong,readonly)NSString *mQrCodeUrl;
@property(nonatomic,strong,readonly)NSString *mRemark;
@property(nonatomic,assign,readonly)BOOL      mRandomAmount;
@property(nonatomic,strong,readonly)NSString *mAliasName;
@property(nonatomic,strong,readonly)NSString *mCustomBankName;
@property(nonatomic,strong,readonly)NSString *mAccountInformation;
@property(nonatomic,strong,readonly)NSString *mAccountPrompt;
@property(nonatomic,strong,readonly)NSString *mRechargeType;
@property(nonatomic,strong,readonly)NSString *mDepositWay;
@property(nonatomic,strong,readonly)NSString *mPayType;
@property(nonatomic,strong,readonly)NSString *mSearchId;
@property(nonatomic,strong,readonly)NSString *mImgUrl;
@property(nonatomic,strong,readonly)NSString *mAccountImg;
@property(nonatomic,assign,readonly)bool mHide;


@property(nonatomic,strong,readonly)NSString *showCover ;
@property(nonatomic,strong,readonly)NSString *qrShowCover;
@property(nonatomic,strong,readonly)NSString *accountImgCover;

@end
@interface RH_DepositeTansferCounterModel:RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mCode;
@property (nonatomic,strong,readonly)NSString *mName;
@end
@interface RH_DepositeTransferChannelModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mCurrency;
@property(nonatomic,strong,readonly)NSString *mCustomerService;
@property(nonatomic,strong,readonly)NSArray<RH_DepositeTransferListModel *>*mArrayListModel;
@property(nonatomic,strong,readonly)NSArray<RH_DepositeTansferCounterModel *>*mAounterModel;
@property(nonatomic,strong,readonly)NSArray *mQuickMoneys;
@property(nonatomic,strong,readonly)NSString *mPayerBankcard;
@property(nonatomic,assign,readonly)bool mNewActivity;
@property(nonatomic,assign,readonly)bool mHide;
@property(nonatomic,assign,readonly)bool mMultipleAccount;
@end
