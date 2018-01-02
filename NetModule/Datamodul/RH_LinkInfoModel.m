//
//  RH_LinkInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LinkInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@interface RH_LinkInfoModel ()
@end ;

@implementation RH_LinkInfoModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mCode = [info stringValueForKey:RH_GP_LINK_CODE] ;
        _mLink = [info stringValueForKey:RH_GP_LINK_LINK] ;
        _mName = [info stringValueForKey:RH_GP_LINK_NAME] ;
    }
    
    return self ;
}


@end
