//
//  RH_HelpCenterSecondModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_HelpCenterSecondModel.h"
#import "coreLib.h"

@implementation RH_HelpCenterSecondModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mName = [info stringValueForKey:@"name"] ;
        _mId = [info stringValueForKey:@"id"] ;
        _mIds = [info stringValueForKey:@"ids"] ;
    }
    return self ;
}
@end
