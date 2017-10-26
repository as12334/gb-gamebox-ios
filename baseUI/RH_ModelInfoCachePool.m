//
//  RH_ModelInfoCachePool.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

//----------------------------------------------------------

#import "RH_ModelInfoCachePool.h"
#import <UIKit/UIKit.h>
#import "MacroDef.h"

//----------------------------------------------------------

@interface RH_ModelInfoCachePool ()

@property(nonatomic,strong,readonly) NSCache * cache;

@end

//----------------------------------------------------------

@implementation RH_ModelInfoCachePool

@synthesize cache = _cache;

+ (instancetype)shareCachePool
{
    static RH_ModelInfoCachePool * shareCachePool;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCachePool = [[super allocWithZone:nil] init];

        //内存警告时清空缓冲池
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          [shareCachePool removeAllCacheDatas];
                                                      }];

    });

    return shareCachePool;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return nil;
}

#pragma mark -

- (NSCache *)cache
{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }

    return _cache;
}

- (NSString *)_keyForCacheWithType:(NSString *)type forContext:(id)context {
    return context == nil ? type : [NSString stringWithFormat:@"%@_%@",type,context];
}

- (void)cacheDatas:(NSArray *)datas withType:(NSString *)type forContext:(id)context;
{
    if (datas.count) {
        [self cacheData:datas withType:type forContext:context];
    }else {
        [self removeCacheDatasWithType:type forContext:context];
    }
}

- (void)cacheData:(id)data withType:(NSString *)type forContext:(id)context
{
    if (data && type.length) {
        [self.cache setObject:data forKey:[self _keyForCacheWithType:type forContext:context]];
    }else {
        [self removeCacheDatasWithType:type forContext:context];
    }
}

- (NSArray *)getDatasWithType:(NSString *)type forContext:(id)context;
{
    id data = [self getDataWithType:type forContext:context];
    return ConvertToClassPointer(NSArray, data);
}

- (id)getDataWithType:(NSString *)type forContext:(id)context {
    return type.length ? [self.cache objectForKey:[self _keyForCacheWithType:type forContext:context]] : nil;
}

- (void)removeCacheDatasWithType:(NSString *)type forContext:(id)context
{
    if (type.length) {
        [self.cache removeObjectForKey:[self _keyForCacheWithType:type forContext:context]];
    }
}

- (void)removeAllCacheDatas {
    [self.cache removeAllObjects];
}


@end
