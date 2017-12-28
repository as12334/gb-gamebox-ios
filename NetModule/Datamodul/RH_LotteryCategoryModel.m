//
//  RH_LotteryCategoryModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LotteryCategoryModel.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_LotteryCategoryModel ()
@end ;

@implementation RH_LotteryCategoryModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mApiType = [info integerValueForKey:RH_GP_HOMEINFO_SITEAPIRELATION_APITYPE] ;
        _mSiteApis = [RH_LotteryAPIInfoModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_HOMEINFO_SITEAPIRELATION_SITEAPIS]] ;
    }
    
    return self ;
}


@end
