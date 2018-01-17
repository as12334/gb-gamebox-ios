//
//  RH_WithDrawIModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface BankcardMapModel :RH_BasicModel
@property (nonatomic , assign , readonly) NSInteger              mId;
@property (nonatomic , strong , readonly) NSString              * mBankName;
@property (nonatomic , assign , readonly) NSInteger              mUseCount;
@property (nonatomic , assign , readonly) BOOL                   mUseStauts;
@property (nonatomic , strong , readonly) NSString              * mBankcardMasterName;
@property (nonatomic , assign , readonly) BOOL                   mIsDefault;
@property (nonatomic , assign , readonly) NSInteger              mUserId;
@property (nonatomic , assign , readonly) NSDate                * mCreateTime;
@property (nonatomic , strong , readonly) NSString              * mBankDeposit;
@property (nonatomic , strong , readonly) NSString              * mType;
@property (nonatomic , strong , readonly) NSString              * mCustomBankName;
@property (nonatomic , strong , readonly) NSString              * mBankcardNumber;

+(NSMutableArray *)dataArrayWithInfoDict:(NSDictionary *)infoDict ;

@end

@interface AuditMapModel :RH_BasicModel
@property (nonatomic , assign , readonly) float                  mDeductFavorable;
@property (nonatomic , strong , readonly) NSString              * mCounterFee;
@property (nonatomic , assign , readonly) NSInteger              mWithdrawFeeMoney;
@property (nonatomic , assign , readonly) NSInteger              mAdministrativeFee;
@property (nonatomic , assign , readonly) float                 mActualWithdraw;
@property (nonatomic , strong , readonly) NSString              * mTransactionNo;
@property (nonatomic , assign , readonly) BOOL                  mRecordList;
@property (nonatomic , assign , readonly) NSInteger             mWithdrawAmount;

@end

@interface RH_WithDrawIModel :RH_BasicModel
@property (nonatomic , assign , readonly) BOOL                               mIsCash;
@property (nonatomic , strong , readonly) NSArray<BankcardMapModel *>        * mBankcardMapModel;
@property (nonatomic , strong , readonly) NSString                            * mAuditLogUrl;
@property (nonatomic , assign , readonly) BOOL                                mHasBank;
@property (nonatomic , strong , readonly) NSString                           * mCurrencySign;
@property (nonatomic , assign , readonly) NSInteger                           mTotalBalance;
@property (nonatomic , strong , readonly) NSString                           * mToken;
@property (nonatomic , assign , readonly) BOOL                                mIsBit;
@property (nonatomic , strong , readonly) NSArray<AuditMapModel *>           * mAuditMapModel;




@end
