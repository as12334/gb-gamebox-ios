//
//  RH_ActivityDeliveryTool.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ActivityDeliveryTool.h"

@implementation RH_ActivityDeliveryTool
static RH_ActivityDeliveryTool *tools;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tools == nil) {
            tools = [super allocWithZone:zone];
        }
    });
    return tools;
}
+(instancetype)deliveryStrTool
{
    //return _instance;
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}
@end
