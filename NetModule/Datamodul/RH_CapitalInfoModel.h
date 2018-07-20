//
//  RH_CapitalInfoModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_CapitalInfoModel : RH_BasicModel
@property(nonatomic,assign,readonly)NSInteger mId;
@property(nonatomic,strong,readonly)NSDate *mCreateTime;
@property(nonatomic,strong,readonly)NSString *mTransactionMoney;
@property(nonatomic,strong,readonly)NSString *mTransactionType;
@property(nonatomic,strong,readonly)NSString *mTransaction_typeName;
@property(nonatomic,strong,readonly)NSString *mStatus;
@property(nonatomic,strong,readonly)NSString *mStatusName;

@end
