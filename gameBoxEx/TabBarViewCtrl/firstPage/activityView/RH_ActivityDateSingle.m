//
//  RH_ActivityDateSingle.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ActivityDateSingle.h"
@interface RH_ActivityDateSingle()<NSCopying,NSMutableCopying>
@end
@implementation RH_ActivityDateSingle

static RH_ActivityDateSingle* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
        //不是使用alloc方法，而是调用[[super allocWithZone:NULL] init]
        //已经重载allocWithZone基本的对象分配方法，所以要借用父类（NSObject）的功能来帮助出处理底层内存分配的杂物
    }) ;
    
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [RH_ActivityDateSingle shareInstance] ;
}

-(id) copyWithZone:(NSZone *)zone
{
    return [RH_ActivityDateSingle shareInstance] ;//return _instance;
}

-(id) mutablecopyWithZone:(NSZone *)zone
{
    return [RH_ActivityDateSingle shareInstance] ;
}
@end
