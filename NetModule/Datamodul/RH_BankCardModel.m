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
#import "RH_APPDelegate.h"

@implementation RH_BankCardModel
@synthesize mBankName = _mBankName ;
@synthesize showBankURL = _showBankURL ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mBankCode = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKNAME] ;
        _mBankCardNumber = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKCARDNUMBER] ;
        _mBankCardMasterName = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKCARDMASTERNAME]?:
        [info stringValueForKey:@"realName"]?:[info stringValueForKey:@"realNme"];
        
        _mBankDeposit = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKDEPOSIT] ;
        _mbankUrl = [info stringValueForKey:RH_GP_BANKCARDINFO_BANKURL];
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


-(NSString *)showBankURL
{
    if (!_showBankURL){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if (_mbankUrl.length){
            if ([[_mbankUrl substringToIndex:1] isEqualToString:@"/"]){
                _showBankURL = [NSString stringWithFormat:@"%@%@",appDelegate.domain,_mbankUrl] ;
            }else {
                _showBankURL = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mbankUrl] ;
            }
        }
    }
    
    return _showBankURL ;
}
@end





