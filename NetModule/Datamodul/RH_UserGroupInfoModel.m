//
//  RH_UserGroupInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserGroupInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_UserGroupInfoModel ()
@end ;

@implementation RH_UserGroupInfoModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mLinkList = [RH_LinkInfoModel dataArrayWithInfoArray:[info arrayValueForKey:@"link"]] ;
        _mUserSetting = [[RH_MineInfoModel alloc] initWithInfoDic:[info dictionaryValueForKey:@"user"]] ;
        _mBankList = [RH_BankInfoModel dataArrayWithInfoArray:[info arrayValueForKey:@"bankList"]] ;
    }
    
    return self ;
}

@end
