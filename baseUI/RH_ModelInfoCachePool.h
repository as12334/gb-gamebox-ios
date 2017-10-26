//
//  RH_ModelInfoCachePool.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

//----------------------------------------------------------

#import <Foundation/Foundation.h>

//----------------------------------------------------------

//----------------------------------------------------------

@interface RH_ModelInfoCachePool : NSObject

+ (instancetype)shareCachePool;

//缓存数据，会覆盖原有数据
- (void)cacheDatas:(NSArray *)datas withType:(NSString *)type forContext:(id)context;
- (void)cacheData:(id)data withType:(NSString *)type forContext:(id)context;

//获取数据
- (NSArray *)getDatasWithType:(NSString *)type forContext:(id)context;
- (id)getDataWithType:(NSString *)type forContext:(id)context;

//移除数据
- (void)removeCacheDatasWithType:(NSString *)type forContext:(id)context;

//移除所有的缓存数据
- (void)removeAllCacheDatas;

@end
