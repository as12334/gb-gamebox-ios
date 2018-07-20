//
//  RH_GetNoAutoTransferInfoModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface SelectModel : RH_BasicModel
@property (nonatomic , strong , readonly) NSString              * mValue;
@property (nonatomic , strong , readonly) NSString              * mText;
@end

@interface RH_GetNoAutoTransferInfoModel : RH_BasicModel
@property (nonatomic , assign , readonly) float              mTransferPendingAmount;
@property (nonatomic , strong , readonly) NSString              * mCurrency;
@property (nonatomic , strong , readonly) NSString              * mToken;
@property (nonatomic , strong , readonly) NSArray<SelectModel *>              * selectModel;
@end
