//
//  RH_DiscountActivityModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DiscountActivityModel.h"
#import "coreLib.h"
#import "RH_API.h"


@implementation RH_DiscountActivityModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mPhoto = [info stringValueForKey:RH_GP_DISCOUNTACTIVITY_PHOTO];
        _mUrl = [info stringValueForKey:RH_GP_DISCOUNTACTIVITY_URL];
    }
    return self;
}
@end
