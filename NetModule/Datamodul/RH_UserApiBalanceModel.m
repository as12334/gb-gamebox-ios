//
//  RH_UserApiBalanceModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserApiBalanceModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_UserApiBalanceModel ()
@end ;

@implementation RH_UserApiBalanceModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mApiID = [info integerValueForKey:RH_GP_USERAPIINFO_APIID] ;
        _mApiName = [info stringValueForKey:RH_GP_USERAPIINFO_APINAME] ;
        _mBalance = [info floatValueForKey:RH_GP_USERAPIINFO_BALANCE] ;
        _mStatus = [info stringValueForKey:RH_GP_USERAPIINFO_STATUS] ;
    }
    
    return self ;
}

-(void)upApiMoneyWith:(RH_UserApiBalanceModel *)userBalanceModel
{
    if (_mApiID == userBalanceModel.mApiID ) {
        _mBalance = userBalanceModel.mBalance ;
    }
}

@end
