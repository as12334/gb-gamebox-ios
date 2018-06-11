//
//  RH_InitAdModel.m
//  gameBoxEx
//
//  Created by sam on 2018/6/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_InitAdModel.h"
#import "NSDictionary+CLCategory.h"
#import "RH_API.h"

@implementation RH_InitAdModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mInitAppAd = [info stringValueForKey:RH_GP_INITAD_APPAD]  ;
    }
    return self ;
}
@end
