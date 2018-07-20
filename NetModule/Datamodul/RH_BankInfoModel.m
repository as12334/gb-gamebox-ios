//
//  RH_BankCradModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BankInfoModel.h"
#import "RH_API.h"
#import "coreLib.h"


@implementation RH_BankInfoModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mBankCode = [info stringValueForKey:RH_GP_BANK_CODE] ;
        _mBankName = [info stringValueForKey:RH_GP_BANK_NAME] ;
    }
    return self;
}

@end





