//
//  RH_depositOriginseachSaleModel.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
@interface RH_DepositOriginseachSaleDetailsModel:RH_BasicModel
@property(nonatomic,assign,readonly)NSInteger mId;
@property(nonatomic,assign,readonly)bool mPreferential;
@property(nonatomic,strong,readonly)NSString *mActivityName;
@end
@interface RH_DepositOriginseachSaleModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mMsg;
@property(nonatomic,assign,readonly)float   mFee;
@property(nonatomic,strong,readonly)NSString *mCounterFee;
@property(nonatomic,assign,readonly)NSInteger mFailureCount;
@property(nonatomic,strong,readonly)NSArray<RH_DepositOriginseachSaleDetailsModel*>*mDetailsModel;
@end
