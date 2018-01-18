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
#import "RH_UserInfoManager.h"

@implementation RH_BankCardModel
@synthesize mBankName = _mBankName ;
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mBankCode = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKNAME] ;
        _mBankCardNumber = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKCARDNUMBER] ;
        _mBankCardMasterName = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKCARDMASTERNAME]?:
        [info stringValueForKey:@"realName"]?:[info stringValueForKey:@"realNme"];
        
        _mBankDeposit = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKDEPOSIT] ;
        
    }
    return self;
}

-(NSString *)mBankName
{
    if (!_mBankName){
        _mBankName =  [[RH_UserInfoManager shareUserManager] bankNameWithCode:_mBankCode] ;
    }
    
    return _mBankName ;
}

@end





