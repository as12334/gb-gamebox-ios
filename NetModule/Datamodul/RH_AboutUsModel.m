//
//  RH_AboutUsModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_AboutUsModel.h"
#import "coreLib.h"

@implementation RH_AboutUsModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mTitle = [info stringValueForKey:@"title"] ;
        _mContent = [info stringValueForKey:@"content"] ;
        _mContentDefault = [info stringValueForKey:@"contentDefault"] ;
    }
    return self ;
}

@end
