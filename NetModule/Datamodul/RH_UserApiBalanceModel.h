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
@property (nonatomic,assign) NSInteger Index      ;//用于cell是否设置背景颜色 1代表是
#pragma mark - 单个刷新数据
-(void)upApiMoneyWith:(RH_UserApiBalanceModel *)userBalanceModel ;
-(void)setIndex:(NSInteger)Index;
@end
