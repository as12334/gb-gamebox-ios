//
//  CLPageLoadControllerProtocol.h
//  TaskTracking
//
//  Created by jinguihua on 2017/3/16.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>

//----------------------------------------------------------

typedef NS_ENUM(NSInteger,CLDataLoadType) {
    CLDataLoadTypeNone,
    CLDataLoadTypeUpdate,   //更新
    CLDataLoadTypeLoad      //加载
};

//----------------------------------------------------------

@protocol CLPageLoadControllerDelegate;

//----------------------------------------------------------

@protocol CLPageLoadControllerProtocol

- (id)initWithPageSize:(NSUInteger)pageSize;
- (id)initWithPageSize:(NSUInteger)pageSize startSection:(NSUInteger)startSection startRow:(NSUInteger)startRow;

//页面大小
@property(nonatomic,readonly) NSUInteger pageSize;
//开始的section
@property(nonatomic,readonly) NSUInteger startSection;
//开始的row
@property(nonatomic,readonly) NSUInteger startRow;

//下一个页面
@property(nonatomic,readonly) NSUInteger nextPage;

//总数
@property(nonatomic,readonly) NSUInteger totalDataCount;
//当前数量
@property(nonatomic,readonly) NSUInteger currentDataCount;
//是否完成加载
@property(nonatomic,readonly) BOOL hadCompletedLoad;

//更新初始化数据
- (void)updateWithInitDatas:(NSArray *)datas totalDataCount:(NSUInteger)totalDataCount;

//开始更新数据,会调用代理方法
- (void)startLoadDataForUpdate;
//开始加载数据,会调用代理方法
- (void)startLoadData;

//数据加载类型
@property(nonatomic,readonly) CLDataLoadType dataLoadType;

//结束
- (void)endLoadDataWithDatas:(NSArray *)datas totalDataCount:(NSUInteger)totalDataCount;
- (void)loadDataFail;


//是否包含indexpath的数据
- (BOOL)containDataAtIndexPath:(NSIndexPath *)indexPath;

//返回索引上的数据
- (id)dataAtIndexPath:(NSIndexPath *)indexPath;
- (id)dataAtIndex:(NSUInteger)index;

//返回索引对应的indexPath
- (NSIndexPath *)indexPathForDataAtIndex:(NSUInteger)index;
- (NSUInteger)indexForDataAtIndexPath:(NSIndexPath *)indexPath;
//返回所有的数据
- (NSArray *)allDatas;
//查找数据的索引
- (NSIndexPath *)indexPathForData:(id)data;

- (NSUInteger)sectionCount;
- (NSUInteger)dataCountAtSection:(NSUInteger)section;

//插入数据
- (void)insertDatas:(NSArray *)datas atIndexPaths:(NSArray *)indexPaths;
- (void)insertDatas:(NSArray *)datas atSections:(NSIndexSet *)sections;

//替换数据
- (void)replaceDatas:(NSArray *)datas atIndexPaths:(NSArray *)indexPaths;
- (void)replaceDatas:(NSArray *)datas atSections:(NSIndexSet *)sections;

//删除数据
- (void)removeDataAtIndexPaths:(NSArray *)indexPaths;
- (void)removeDataAtSections:(NSIndexSet *)sections;
- (void)removeDatas:(NSArray *)datas;

//代理
@property(nonatomic,weak) id<CLPageLoadControllerDelegate> delegate;

@end

//----------------------------------------------------------

@protocol CLPageLoadControllerDelegate <NSObject>

@optional

//page为0，则为更新
- (void)pageLoadController:(id<CLPageLoadControllerProtocol>)pageLoadController
    wantToLoadDataWithPage:(NSUInteger)page
               andPageSize:(NSUInteger)pageSize;

//更新视图
- (void)pageLoadControllerWantToReloadDataForView:(id<CLPageLoadControllerProtocol>)pageLoadController;

//添加数据
- (void)pageLoadController:(id<CLPageLoadControllerProtocol>)pageLoadController wantToAddDataForViewAtIndexPaths:(NSArray *)indexPaths;
//删除数据
- (void)pageLoadController:(id<CLPageLoadControllerProtocol>)pageLoadController wantToRemoveDataForViewAtIndexPaths:(NSArray *)indexPaths;
//重新加载
- (void)pageLoadController:(id<CLPageLoadControllerProtocol>)pageLoadController wantToReloadDataForViewAtIndexPaths:(NSArray *)indexPaths;


//添加section
- (void)pageLoadController:(id<CLPageLoadControllerProtocol>)pageLoadController wantToAddDataForViewAtSections:(NSIndexSet *)sections;
//删除section
- (void)pageLoadController:(id<CLPageLoadControllerProtocol>)pageLoadController wantToRemoveDataForViewAtSections:(NSIndexSet *)sections;
//重新加载section
- (void)pageLoadController:(id<CLPageLoadControllerProtocol>)pageLoadController wantToReloadDataForViewAtSections:(NSIndexSet *)sections;

//完成加载的状态改变
- (void)pageLoadController:(id<CLPageLoadControllerProtocol>)pageLoadController completedLoadStatusDidChange:(BOOL)completedLoad;

//将要加入数据时调用，返回筛选后的数据
- (NSArray *)pageLoadController:(id<CLPageLoadControllerProtocol>)pageLoadController
                   willAddDatas:(NSArray *)datas
               withCurrentDatas:(NSArray *)currentDatas;

@end

