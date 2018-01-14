//
//  RH_BankCradModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BankCardModel.h"
#import "RH_API.h"
#import "coreLib.h"


@implementation RH_BankCardModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mBankName = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKNAME] ;
        _mBankCardNumber = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKCARDNUMBER] ;
        _mBankCardMasterName = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKCARDMASTERNAME] ;
    }
    return self;
}

@end





