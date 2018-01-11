//
//  RH_CapitalInfoOverviewModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_CapitalInfoModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface RH_CapitalInfoOverviewModel : RH_BasicModel
@property (nonatomic,assign,readonly) CGFloat mWithdrawSum ;
@property (nonatomic,assign,readonly) CGFloat mTransferSum ;
@property (nonatomic,strong,readonly) NSArray<RH_CapitalInfoModel*> *mList ;
@end
