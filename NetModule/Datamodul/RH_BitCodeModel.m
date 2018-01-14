//
//  RH_BitCodeModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BitCodeModel.h"
#import "RH_API.h"
#import "coreLib.h"


@implementation RH_BitCodeModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mBtcNum = [info stringValueForKey:RH_GP_BITCODEINFO_BTCNUM] ;
        _mBtcNumber = [info stringValueForKey:RH_GP_BITCODEINFO_BTCNUMBER] ;
    }
    return self;
}

@end





