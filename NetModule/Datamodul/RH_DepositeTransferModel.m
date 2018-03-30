//
//  RH_DepositeTransferModel.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferModel.h"
#import "coreLib.h"
#import "RH_API.h"
@implementation RH_DepositeTransferModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mCode = [info stringValueForKey:RH_GP_DEPOSITEORIGIN_CODE];
        _mName =[info stringValueForKey:RH_GP_DEPOSITEORIGIN_NAME];
        _mIconUrl = [info stringValueForKey:RH_GP_DEPOSITEORIGIN_ICOURL];
    }
    return self;
}
@end

