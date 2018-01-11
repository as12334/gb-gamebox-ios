//
//  RH_CapitalInfoModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalTypeModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_CapitalTypeModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mTypeId= [info stringValueForKey:@"typeKey"];
        _mTypeName = [info stringValueForKey:@"typeValue"];
//        _mTypeArray = [info arrayValueForKey:@""];
        
    }
    return self;
}

+(NSMutableArray *)dataArrayWithDictInfo:(NSDictionary *)dictInfo
{
    NSArray *keyList = dictInfo.allKeys ;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:keyList.count] ;
    for (NSString *key in keyList) {
        [array addObject:@{@"typeKey":key,
                           @"typeValue":dictInfo[key]
                           }] ;
    }
    
    return [self dataArrayWithInfoArray:array] ;
}

@end
