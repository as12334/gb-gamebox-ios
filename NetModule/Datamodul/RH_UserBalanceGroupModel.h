//
//  RH_UserBalanceGroupModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_UserApiBalanceModel.h"

@interface RH_UserBalanceGroupModel : RH_BasicModel
@property (nonatomic,strong,readonly) NSString *mAssets     ;
@property (nonatomic,strong,readonly) NSString *mBalance    ;
@property (nonatomic,strong,readonly) NSString *mCurrSign   ;
@property (nonatomic,strong,readonly) NSString *mUserName   ;
@property (nonatomic,strong,readonly) NSArray<RH_UserApiBalanceModel*> *mApis   ;

@end
