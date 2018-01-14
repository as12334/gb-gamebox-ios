//
//  RH_BankCradModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BankCradModel.h"
#import "RH_API.h"
#import "coreLib.h"


@implementation RH_BankCradModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mText = [info stringValueForKey:RH_GP_ADDBANKCARD_TEXT];
        _mValue = [info stringValueForKey:RH_GP_ADDBANKCARD_VALUE];
    }
    return self;
}

@end





