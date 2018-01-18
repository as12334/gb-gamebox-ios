//
//  RH_BankCardModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_BankCardModel :RH_BasicModel
@property (nonatomic,strong,readonly) NSString *mBankCode;
@property (nonatomic,strong,readonly) NSString *mBankName; //从bankList取
@property (nonatomic,strong,readonly) NSString *mBankCardMasterName; //卡姓名
@property (nonatomic,strong,readonly) NSString *mBankCardNumber ;
@property (nonatomic,strong,readonly) NSString *mBankDeposit ; //开户行

@end





