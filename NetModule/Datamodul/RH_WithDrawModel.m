//
//  RH_WithDrawModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithDrawModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"
#import "RH_ModifySafetyPasswordController.h"

@implementation BankcardMapModel
@synthesize showBankURL =_showBankURL;
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mId = [info integerValueForKey:RH_GP_WITHDRAWBANKCARD_ID];
        _mBankName = [info stringValueForKey:RH_GP_WITHDRAWBANKCARD_BANKNAME];
        _mUseCount = [info integerValueForKey:RH_GP_WITHDRAWBANKCARD_USECOUNT];
        _mUseStauts = [info boolValueForKey:RH_GP_WITHDRAWBANKCARD_USECOUNT];
        _mBankcardMasterName = [info stringValueForKey:RH_GP_WITHDRAWBANKCARD_BANKCARDMASTERNAME];
        _mIsDefault = [info boolValueForKey:@"isDefault"];
         _mUserId = [info boolValueForKey:@"userId"];
         _mCreateTime = [NSDate dateWithTimeIntervalSince1970:[info floatValueForKey:@"createTime"]/1000.0];
         _mBankDeposit = [info stringValueForKey:RH_GP_WITHDRAWBANKCARD_BANKDEPOSIT];
         _mType = [info stringValueForKey:RH_GP_WITHDRAWBANKCARD_TYPE];
         _mCustomBankName = [info stringValueForKey:RH_GP_WITHDRAWBANKCARD_CUSTOMBANKNAME];
         _mBankcardNumber = [info stringValueForKey:RH_GP_WITHDRAWBANKCARD_BANKCARDNUMBER];
        _mBankUrl = [info stringValueForKey:RH_GP_WITHDRAWBANKCARD_BANKURL];
    }
    return self;
}

-(NSString *)showBankURL
{
    if (!_showBankURL){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if (_mBankUrl.length){
            if ([[_mBankUrl substringToIndex:1] isEqualToString:@"/"]){
                _showBankURL = [NSString stringWithFormat:@"%@%@",appDelegate.domain,_mBankUrl] ;
            }else {
                _showBankURL = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mBankUrl] ;
            }
        }
    }
    
    return _showBankURL ;
}

+(NSMutableArray *)dataArrayWithInfoDict:(NSDictionary *)infoDict
{
    NSMutableArray *tmpArray = [NSMutableArray array] ;
    NSArray *keys = infoDict.allKeys ;
    for (id key in keys) {
        NSDictionary *dict = [infoDict objectForKey:key] ;
        [tmpArray addObject:dict] ;
    }
    
    return [self dataArrayWithInfoArray:tmpArray] ;
}
@end

@implementation AuditMapModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mDeductFavorable= [info floatValueForKey:RH_GP_WITHDRAWAUDITMAP_DEDUCTFAVORABLE];
        _mCounterFee= [info floatValueForKey:RH_GP_WITHDRAWAUDITMAP_COUNTERFEE];
        _mWithdrawFeeMoney= [info integerValueForKey:RH_GP_WITHDRAWAUDITMAP_WITHDRAWFEEM];
        _mAdministrativeFee= [info floatValueForKey:RH_GP_WITHDRAWAUDITMAP_ADMINISTRATIVEFEE];
        _mActualWithdraw= [info floatValueForKey:RH_GP_WITHDRAWAUDITMAP_ACTUALWITHDRAW];
        _mTransactionNo= [info stringValueForKey:RH_GP_WITHDRAWAUDITMAP_TRANSACTIONNO];
        _mRecordList = [info boolValueForKey:RH_GP_WITHDRAWAUDITMAP_RECORDLIST];
        _mWithdrawAmount= [info floatValueForKey:RH_GP_WITHDRAWAUDITMAP_WITHDRAWAMOUNT];
    }
    return self;
}
@end

@implementation RH_WithDrawModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mIsBit = [info boolValueForKey:RH_GP_WITHDRAW_ISBIT] ;
        _mToken = [info stringValueForKey:RH_GP_WITHDRAW_TOKEN] ;
        _mIsCash = [info boolValueForKey:RH_GP_WITHDRAW_ISCASH] ;
        _mHasBank = [info boolValueForKey:RH_GP_WITHDRAW_HASBANK] ;
        _mIsSafePassword = [info boolValueForKey:@"isSafePassword"] ;
        _mAuditMap = [[AuditMapModel alloc] initWithInfoDic:[info dictionaryValueForKey:RH_GP_WITHDRAW_AUDITMAP]] ;
        _mAuditLogUrl = [info stringValueForKey:RH_GP_WITHDRAW_AUDITLOGURL] ;
        NSDictionary *tmpDict  = [info dictionaryValueForKey:RH_GP_WITHDRAW_BANKCARDMAP] ;
        NSArray *keys = tmpDict.allKeys ;
        NSMutableDictionary *dictMutable = [NSMutableDictionary dictionary] ;
        for (id key in keys) {
            BankcardMapModel *bankcard = [[BankcardMapModel alloc] initWithInfoDic:[tmpDict dictionaryValueForKey:key]] ;
            if (bankcard){
                [dictMutable setValue:bankcard forKey:[NSString stringWithFormat:@"%@",key]] ;
            }
        }
        _mBankcardMap = dictMutable ;
        _mCurrencySign = [info stringValueForKey:RH_GP_WITHDRAW_CURRENCYSIGN];
        _mTotalBalance = [info integerValueForKey:RH_GP_WITHDRAW_TOTALBALANCE];
        _mWithdrawMinNum = [[info dictionaryValueForKey:@"rank"] floatValueForKey:@"withdrawMinNum"] ;
        _mWithdrawMaxNum = [[info dictionaryValueForKey:@"rank"] floatValueForKey:@"withdrawMaxNum"] ;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)
                                                     name:RHNT_AlreadySucfullSettingSafetyPassword
                                                   object:nil]   ;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:RHNT_AlreadySucfullSettingSafetyPassword]){
        _mIsSafePassword = YES ;
     }
}

-(void)updateToken:(NSString *)tokenStr
{
    if (tokenStr.length){
        _mToken  = tokenStr ;
    }
}
@end
