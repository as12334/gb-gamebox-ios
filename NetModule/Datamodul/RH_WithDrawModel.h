//
//  RH_WithDrawModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import <CoreGraphics/CoreGraphics.h>

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
@property (nonatomic , strong , readonly) NSString              *mBankUrl;
@property (nonatomic , strong , readonly) NSString              *showBankURL;


+(NSMutableArray *)dataArrayWithInfoDict:(NSDictionary *)infoDict ;

@end

@interface AuditMapModel :RH_BasicModel
@property (nonatomic , assign , readonly) CGFloat              mDeductFavorable; //优惠
@property (nonatomic , assign , readonly) CGFloat              mCounterFee; //手续费
@property (nonatomic , assign , readonly) CGFloat              mWithdrawFeeMoney;
@property (nonatomic , assign , readonly) CGFloat              mAdministrativeFee; //行政费
@property (nonatomic , assign , readonly) float                 mActualWithdraw;
@property (nonatomic , strong , readonly) NSString              * mTransactionNo;
@property (nonatomic , assign , readonly) BOOL                  mRecordList;
@property (nonatomic , assign , readonly) CGFloat             mWithdrawAmount; //最终可取

@end

@interface RH_WithDrawModel :RH_BasicModel
@property (nonatomic , strong , readonly) NSString             *mAuditLogUrl;
@property (nonatomic , strong , readonly) AuditMapModel        *mAuditMap;
@property (nonatomic , strong , readonly) NSDictionary          *mBankcardMap;
@property (nonatomic , strong , readonly) NSString              *mCurrencySign;
@property (nonatomic , assign , readonly) BOOL                   mHasBank;
@property (nonatomic , assign , readonly) BOOL                   mIsSafePassword;
@property (nonatomic , assign , readonly) BOOL                   mIsBit;
@property (nonatomic , assign , readonly) BOOL                   mIsCash;
@property (nonatomic , strong , readonly) NSString               * mToken;
@property (nonatomic , assign , readonly) CGFloat                mTotalBalance;

@end
