//
//  RH_UserApiBalanceModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_UserApiBalanceModel : RH_BasicModel
@property (nonatomic,assign,readonly) NSInteger mApiID      ;
@property (nonatomic,strong,readonly) NSString *mApiName    ;
@property (nonatomic,assign,readonly) float mBalance    ;
@property (nonatomic,strong,readonly) NSString *mStatus     ;
#pragma mark - 单个刷新数据
-(void)upApiMoneyWith:(RH_UserApiBalanceModel *)userBalanceModel ;
@end
