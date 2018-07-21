//
//  RH_UserGroupInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_LinkInfoModel.h"
#import "RH_MineInfoModel.h"
#import "RH_BankInfoModel.h"

@interface RH_UserGroupInfoModel : RH_BasicModel
@property (nonatomic,strong,readonly) NSArray <RH_LinkInfoModel*> *mLinkList ;
@property (nonatomic,strong,readonly) RH_MineInfoModel *mUserSetting ;
@property (nonatomic,strong,readonly) NSArray<RH_BankInfoModel*> *mBankList ;
@end

