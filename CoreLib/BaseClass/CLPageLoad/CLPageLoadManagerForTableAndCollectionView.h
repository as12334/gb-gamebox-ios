//
//  CLPageLoadManagerForTableAndCollectionView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/3/16.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLPageLoadControllerProtocol.h"
#import "CLRefreshControl.h"


//----------------------------------------------------------

@class CLPageLoadManagerForTableAndCollectionView;

//----------------------------------------------------------

typedef NS_ENUM(NSInteger, CLPageLoadDataHandleType) {
    CLPageLoadDataHandleAnimationTypeLoadInsertSection,
    CLPageLoadDataHandleAnimationTypeLoadInsertRow,
    CLPageLoadDataHandleAnimationTypeInsertSection,
    CLPageLoadDataHandleAnimationTypeInsertRow,
    CLPageLoadDataHandleAnimationTypeRemoveSection,
    CLPageLoadDataHandleAnimationTypeRemoveRow,
    CLPageLoadDataHandleAnimationTypeReloadSection,
    CLPageLoadDataHandleAnimationTypeReloadRow
};

//----------------------------------------------------------

@protocol CLPageLoadManagerForTableAndCollectionViewDataSource <NSObject>

@optional

//page为0，则为更新
- (void)    pageLoadManager:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager
     wantToLoadDataWithPage:(NSUInteger)page
                andPageSize:(NSUInteger)pageSize;

//取消加载数据
- (void)pageLoadManagerWantCancleLoadData:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager;

//数据数目改变
- (void)pageLoadManagerCurrentDataCountDidChange:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager;

//返回数据操作的动画类型
- (UITableViewRowAnimation)pageLoadManager:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager tableViewRowAnimationForDataHandleType:(CLPageLoadDataHandleType)dataHandleType;


//筛选数据
- (NSArray *)   pageLoadManager:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager
                   willAddDatas:(NSArray *)datas
               withCurrentDatas:(NSArray *)currentDatas;

@end

//----------------------------------------------------------

//获取内容视图的block
typedef UIScrollView * (^GetContentScrollViewBlock)();

//----------------------------------------------------------

//分页加载配置
@interface CLPageLoadManagerConfigure : NSObject

//初始化
- (id)initWithContentScrollView:(UIScrollView *)scrollView pageLoadControllerClass:(Class)pageLoadControllerClass;
- (id)initWithContentScrollView:(UIScrollView *)scrollView
        pageLoadControllerClass:(Class)pageLoadControllerClass
                       pageSize:(NSUInteger)pageSize
                   startSection:(NSUInteger)startSection
                       startRow:(NSUInteger)startRow;
- (id)initWithGetContentScrollViewBlcok:(GetContentScrollViewBlock)getContentScrollViewBlock
                pageLoadControllerClass:(Class)pageLoadControllerClass;
- (id)initWithGetContentScrollViewBlcok:(GetContentScrollViewBlock)getContentScrollViewBlock
                pageLoadControllerClass:(Class)pageLoadControllerClass
                               pageSize:(NSUInteger)pageSize
                           startSection:(NSUInteger)startSection
                               startRow:(NSUInteger)startRow;


@property(nonatomic,readonly) NSUInteger pageSize;
@property(nonatomic,readonly) NSUInteger startSection;
@property(nonatomic,readonly) NSUInteger startRow;
@property(nonatomic,strong,readonly) Class pageLoadControllerClass;

@property(nonatomic,copy,readonly) GetContentScrollViewBlock getContentScrollViewBlock;
@property(nonatomic,strong,readonly) UIScrollView * contentScrollView;
@property(nonatomic,strong,readonly) UITableView * tableView;
@property(nonatomic,strong,readonly) UICollectionView * collectionView;

@end

//----------------------------------------------------------

@interface CLPageLoadManagerForTableAndCollectionView : NSObject <CLPageLoadControllerDelegate>

+ (NSUInteger)defaultPageSize;

- (id)  initWithScrollView:(UIScrollView *)scrollView
   pageLoadControllerClass:(Class)pageLoadControllerClass
                  pageSize:(NSUInteger)pageSize
              startSection:(NSUInteger)startSection
                  startRow:(NSUInteger)startRow
            segmentedCount:(NSUInteger)segmentedCount;

- (id)initWithConfigures:(NSArray<CLPageLoadManagerConfigure *> *)configures;

@property(nonatomic,readonly) NSUInteger pageSize;
@property(nonatomic,strong,readonly) UIScrollView * contentScrollView;
@property(nonatomic,strong,readonly) UITableView * tableView;
@property(nonatomic,strong,readonly) UICollectionView * collectionView;

//当前分页加载的配置
@property(nonatomic,strong,readonly) CLPageLoadManagerConfigure * currentConfigure;
- (CLPageLoadManagerConfigure *)configureAtSegmentedIndex:(NSUInteger)segmentedIndex;


//当前segmented
@property(nonatomic) NSUInteger currentSegmentedIndex;
@property(nonatomic,readonly) NSUInteger segmentedCount;

//加载控件
@property(nonatomic,strong) CLRefreshControl * topRefreshControl;
@property(nonatomic,strong) CLRefreshControl * bottomLoadControl;


//自动添加刷新控件
@property(nonatomic) BOOL autoAddRefreshControl;
//自动添加加载控件
@property(nonatomic) BOOL autoAddLoadControl;


//重新加载数据
- (void)reloadContentViewData;

//初始化更新数据
- (void)updateWithInitDatas:(NSArray *)datas;
- (void)updateWithInitDatas:(NSArray *)datas totalDataCount:(NSUInteger)totalDataCount;

//开始更新数据
- (void)startUpdateData:(BOOL)showRefreshControl;
//开始更新数据
- (void)startUpdateData:(BOOL)showRefreshControl scrollToTop:(BOOL)scrollToTop;

//开始加载数据
- (void)startLoadData:(BOOL)showLoadControl;
- (void)startLoadData:(BOOL)showLoadControl scrollToBottom:(BOOL)scrollToBottom;

//取消加载数据
- (void)cancleLoadData;

//加载的类型
@property(nonatomic,readonly) CLDataLoadType dataLoadType;

//回调
//加载数据成功
- (void)loadDataSuccessWithDatas:(NSArray *)datas totalCount:(NSUInteger)totalCount;
//加载数据错误
- (void)loadDataFail;

//总数据量
- (NSUInteger)totalDataCount;
//当前数据数量
- (NSUInteger)currentDataCount;
//开始的section
- (NSUInteger)startSection;
//开始的section
- (NSUInteger)startRow;

- (BOOL)containDataAtIndexPath:(NSIndexPath *)indexPath;

//获取数据
- (id)dataAtIndex:(NSUInteger)index;
- (id)dataAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForDataAtIndex:(NSUInteger)index;
- (NSUInteger)indexForDataAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)allDatas;
- (NSArray *)allDatasAtSegmentedIndex:(NSUInteger)segmentedIndex;
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

//数据源
@property(nonatomic,weak) id<CLPageLoadManagerForTableAndCollectionViewDataSource> dataSource;

@end

