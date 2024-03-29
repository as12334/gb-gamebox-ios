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

/**
 创建实际
 */
@property(nonatomic,strong,readonly)NSDate   *mCreateTime;

/**
 扣除优惠（银行卡里的信息）
 */
@property(nonatomic,strong,readonly)NSString *mDeductFavorable;

/**
 失败原因
 */
@property(nonatomic,strong,readonly)NSString *mFailureReason;
@property(nonatomic,strong,readonly)NSString *mFundType;
@property(nonatomic,strong,readonly)NSString *mId;
@property(nonatomic,strong,readonly)NSString *mPayerBankcard;

/**
 手续费
 */
@property(nonatomic,strong,readonly)NSString *mPoundage;

/**
 真实姓名
 */
@property(nonatomic,strong,readonly)NSString *mRealName;

/**
 交易地址
 */
@property(nonatomic,strong,readonly)NSString *mRechargeAddress;

/**
 存款金额
 */
@property(nonatomic,strong,readonly)NSString *mRechargeAmount;
/**
 实际到账
 */
@property(nonatomic,strong,readonly)NSString *mRechargeTotalAmount;

/**
 状态
 */
@property(nonatomic,strong,readonly)NSString *mStatus;

/**
 状态名称
 */
@property(nonatomic,strong,readonly)NSString *mStatusName;

/**
 转账金额
 */
@property(nonatomic,strong,readonly)NSString *mTransactionMoney;

/**
 交易号
 */
@property(nonatomic,strong,readonly)NSString *mTransactionNo;
@property(nonatomic,strong,readonly)NSString *mTransactionType;
@property(nonatomic,strong,readonly)NSString *mTransactionWay;
@property(nonatomic,strong,readonly)NSString *mWithdrawMoney;

/**
 描述
 */
@property(nonatomic,strong,readonly)NSString *mTransactionWayName;
@property(nonatomic,strong,readonly)NSString *mUsername;

/**
 转入
 */
@property(nonatomic,strong,readonly)NSString *mTransferInto;

/**
 转出
 */
@property(nonatomic,strong,readonly)NSString *mTransferOut;


/**
 其它方式
 */
@property(nonatomic,strong,readonly)NSString *mBankCodeName;

/**
 银行卡url
 */
@property(nonatomic,strong,readonly)NSString *mBankUrl;


/**
 银行类型
 */
@property(nonatomic,strong,readonly)NSString *mBankCode;
/**
 txId
 */
@property(nonatomic,strong,readonly)NSString *mTxId;

/**
 比特币地址
 */
@property(nonatomic,strong,readonly)NSString *mBitcoinAdress;
/**
  比特币交易时间
 */
@property(nonatomic,strong,readonly)NSDate *mReturnTime;
//extend
@property(nonatomic,strong,readonly)NSString *showBankURL;

@end
