//
//  RH_CapitalInfoOverviewModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalInfoOverviewModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_CapitalInfoOverviewModel()
@end

@implementation RH_CapitalInfoOverviewModel
@synthesize showTransferSum = _showTransferSum ;
@synthesize showWithDrawSum = _showWithDrawSum ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mTransferSum = [info floatValueForKey:RH_GP_DEPOSITLIST_TRANSFERSUM] ;
        _mWithdrawSum = [info floatValueForKey:RH_GP_DEPOSITLIST_WITHDRAWSUM] ;
        _mTotalCount = [info integerValueForKey:RH_GP_DEPOSITLIST_TOTALCOUNT] ;
        _mList = [RH_CapitalInfoModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_DEPOSITLIST_LIST]] ;
    }
    
    return self;
}

///-
-(NSString *)showWithDrawSum
{
    if (!_showWithDrawSum){
        _showWithDrawSum = [NSString stringWithFormat:@"%.02f",_mWithdrawSum] ;
    }
    
    return _showWithDrawSum ;
}

-(NSString *)showTransferSum
{
    if (!_showTransferSum){
        _showTransferSum = [NSString stringWithFormat:@"%.02f",_mTransferSum] ;
    }
    
    return _showTransferSum ;
}

@end
