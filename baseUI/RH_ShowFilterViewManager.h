//
//  RH_ShowFilterViewManager.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

//----------------------------------------------------------

#import <Foundation/Foundation.h>
#import "RH_BasicFilterView.h"
#import "coreLib.h"

//----------------------------------------------------------

@class RH_ShowFilterViewManager;
@protocol RH_ShowFilterViewManagerDelegate <NSObject>

@optional

//将要显示筛选视图
- (void)filterViewManager:(RH_ShowFilterViewManager *)showFilterViewManager
       willShowFilterView:(RH_BasicFilterView *)filterView;

//将要隐藏筛选视图
- (void)filterViewManager:(RH_ShowFilterViewManager *)showFilterViewManager
       willHideFilterView:(RH_BasicFilterView *)filterView;

//改变了筛选信息
- (void)filterViewManagerDidChangeFilterInfos:(RH_ShowFilterViewManager *)showFilterViewManager;

@end

//----------------------------------------------------------

@interface RH_ShowFilterViewManager : NSObject

- (id)initWithFilterInfosFileName:(NSString *)filterInfosFileName filterModelsCacheKey:(NSString *)filterModelsCacheKey;

//筛选信息
@property(nonatomic,strong,readonly) NSArray * filterInfos;

//筛选值
@property(nonatomic,strong,readonly) NSDictionary * filterValues;
@property(nonatomic,strong,readonly) NSMutableDictionary * filterModels;

//筛选值缓存的key
@property(nonatomic,strong,readonly) NSString * filterModelsCacheKey;

//筛选视图的容器视图（需要加入需要显示的视图里面）
@property(nonatomic,strong,readonly) CLDeclineMenuContainerView * filterContainerView;

//当前正在显示的筛选视图索引
@property(nonatomic) NSUInteger showingFilterViewIndex;

//隐藏筛选视图
- (void)hideFilterView:(BOOL)animated;

//代理
@property(nonatomic,weak) id<RH_ShowFilterViewManagerDelegate> delegate;

@end

//----------------------------------------------------------

@interface NSDictionary (RH_ShowFilterViewManager)

//筛选值的key
- (NSString *)filterValueKey;
//筛选视图key
- (Class)filterViewClass;

@end

//----------------------------------------------------------

@interface CLSectionControl (RH_ShowFilterViewManager)

+ (instancetype)createFilterSegmentedControlWithFilterViewManager:(RH_ShowFilterViewManager *)filterViewManager;

@end

