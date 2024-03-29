//
//  RH_MineInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_BankCardModel.h"
#import "RH_BitCodeModel.h"
#import "RH_UserApiBalanceModel.h"

@interface RH_MineInfoModel : RH_BasicModel
@property(nonatomic,strong,readonly) NSString  *mAvatalUrl ;
@property(nonatomic,strong,readonly) NSString  *mCurrency ;
@property(nonatomic,strong,readonly) NSString  *mPreferentialAmount ;
@property(nonatomic,strong,readonly) NSString  *mLoginTime ;
@property(nonatomic,strong,readonly) NSString  *mRecomdAmount ;
@property(nonatomic,assign,readonly) float  mTotalAssets ;
@property(nonatomic,assign,readonly) float  mTransferAmount ;
@property(nonatomic,assign,readonly) float  mUnReadCount ;
@property(nonatomic,strong,readonly) NSString  *mUserName ;
@property(nonatomic,assign,readonly) float  mWalletBalance ;
@property(nonatomic,assign,readonly) float  mWithdrawAmount ;
@property(nonatomic,assign,readonly) BOOL  mIsBit ;
@property(nonatomic,assign,readonly) BOOL  mIsCash ;
@property(nonatomic,assign,readonly) BOOL  mIsAutoPay ;
@property(nonatomic,strong,readonly) RH_BankCardModel *mBankCard ;
@property(nonatomic,strong,readonly) RH_BitCodeModel *mBitCode  ;
@property(nonatomic,strong,readonly) NSString  *mRealName ;
//cherry 调整---
@property (nonatomic,strong,readonly) NSArray<RH_UserApiBalanceModel*> *mApisBalanceList   ;


//extend
@property (nonatomic,strong,readonly) NSString *showAvatalURL ;
@property(nonatomic,strong,readonly) NSString *showTotalAssets ;
@property(nonatomic,strong,readonly) NSString *showWalletBalance ;

-(void)updateUserBalanceInfo:(NSDictionary*)info ;
-(void)updateBankCard:(RH_BankCardModel*)bankCardInfo ;
-(void)updateBitCode:(RH_BitCodeModel*)bitCodeInfo ;

@end

