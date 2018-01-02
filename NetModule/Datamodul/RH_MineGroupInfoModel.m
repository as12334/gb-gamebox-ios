//
//  RH_MineGroupInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineGroupInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@interface RH_MineGroupInfoModel ()
@end ;

@implementation RH_MineGroupInfoModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mLink = [RH_LinkInfoModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_MINEGROUPINFO_LINK]] ;
        _mIsBit = [info boolValueForKey:RH_GP_MINEGROUPINFO_ISBIT] ;
        _mIsCash = [info boolValueForKey:RH_GP_MINEGROUPINFO_ISCASH] ;
        _mUserInfo = [[RH_MineInfoModel alloc] initWithInfoDic:[info dictionaryValueForKey:RH_GP_MINEGROUPINFO_USER]] ;
    }
    
    return self ;
}


@end
