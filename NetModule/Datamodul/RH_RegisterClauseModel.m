//
//  RH_RegisterClauseModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegisterClauseModel.h"
#import "coreLib.h"

@implementation RH_RegisterClauseModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mDefaultValue = [info stringValueForKey:@"defaultValue"] ;
        _mValue = [info stringValueForKey:@"value"] ;
    }
    return self ;
}



@end
