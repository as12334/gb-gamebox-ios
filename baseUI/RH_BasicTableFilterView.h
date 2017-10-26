//
//  RH_BasicTableFilterView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/9.
//  Copyright © 2017年 jinguihua. All rights reserved.
////

//----------------------------------------------------------

#import "RH_BasicFilterView.h"
#import "RH_BasicFilterModel.h"
#import "coreLib.h"

//----------------------------------------------------------

@interface RH_BasicTableFilterView : RH_BasicFilterView < UITableViewDelegate,
                                                          UITableViewDataSource,
                                                          CLLoadingIndicateViewDelegate>

//是否是本地数据(本地数据不会出现刷新控件等等)，默认为NO
- (BOOL)isLocalDatas;

//内容table视图
@property(nonatomic,strong,readonly) UITableView * tableView;


//初始化的筛选数据
- (NSArray<RH_BasicFilterModel *> *)getInitFilterDatas;
//缓存数据(默认只会缓存到内存，子类可重载进行特定缓存)
- (void)cacheFilterDatas;
//返回用于缓存数据的key，默认缓存方式时会使用
- (NSString *)datasKeyForCache;
//指示需要缓存数据
- (void)setNeedCacheDatas;


//开始更新数据
- (void)startUpdateFilterDatas;
//取消更新数据
- (void)didCancleUpdateFilterDatas;

//完成更新筛选数据
- (void)completedUpdateFilterDatas:(NSArray<RH_BasicFilterModel *> *)filterDatas error:(NSError *)error;

//筛选数据
@property(nonatomic,strong,readonly) NSArray<RH_BasicFilterModel *> * filterDatas;


@end
