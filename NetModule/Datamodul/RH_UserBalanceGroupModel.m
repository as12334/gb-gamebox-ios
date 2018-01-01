//
//  RH_UserBalanceGroupModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserBalanceGroupModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_UserBalanceGroupModel ()
@end ;

@implementation RH_UserBalanceGroupModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mAssets = [info stringValueForKey:RH_GP_USERBALANCEGROUP_ASSETS] ;
        _mBalance = [info stringValueForKey:RH_GP_USERBALANCEGROUP_BALANCE] ;
        _mCurrSign = [info stringValueForKey:RH_GP_USERBALANCEGROUP_CURRSIGN] ;
        _mUserName = [info stringValueForKey:RH_GP_USERBALANCEGROUP_USERNAME] ;
        _mApis = [RH_UserApiBalanceModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_USERBALANCEGROUP_APIS]] ;
    }
    
    return self ;
}

@end
