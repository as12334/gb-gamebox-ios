//
//  CLPageLoadContentPageCell.m
//  TaskTracking
//
//  Created by jinguihua on 2017/6/8.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLPageLoadContentPageCell.h"
#import "MacroDef.h"
//----------------------------------------------------------

@implementation CLPageLoadDatasContext

@synthesize needUpdateData = _needUpdateData;
@synthesize contentOffset = _contentOffset;
@synthesize extendContext = _extendContext;

- (id)initWithDatas:(NSArray *)datas context:(id)context
{
    return [self initWithDatas:datas
                    totalCount:datas.count
                needUpdateData:YES
                 contentOffset:CGPointZero
                       context:context];
}

- (id)initWithPageLoadManager:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager
                      context:(id)context
{
    return [self initWithDatas:pageLoadManager.allDatas
                    totalCount:pageLoadManager.totalDataCount
                needUpdateData:pageLoadManager.currentDataCount == 0 || pageLoadManager.dataLoadType == CLDataLoadTypeUpdate
                 contentOffset:pageLoadManager.contentScrollView.contentOffset
                       context:context];
}

- (id)initWithDatas:(NSArray *)datas
         totalCount:(NSUInteger)totalCount
      contentOffset:(CGPoint)contentOffset
            context:(id)context
{
    return [self initWithDatas:datas
                    totalCount:totalCount
                needUpdateData:datas.count == 0
                 contentOffset:contentOffset
                       context:context];
}

- (id)initWithDatas:(NSArray *)datas
         totalCount:(NSUInteger)totalCount
     needUpdateData:(BOOL)needUpdateData
      contentOffset:(CGPoint)contentOffset
            context:(id)context
{
    self = [super init];

    if (self) {
        _datas = datas;
        _totalCount = MAX(totalCount, datas.count);// totalCount;
        _needUpdateData = needUpdateData;
        _contentOffset = contentOffset;
        _extendContext = context;
    }

    return self;
}

@end

//----------------------------------------------------------

@implementation CLPageLoadContentPageCell
{
    NSString * _dataFilterContext;
    id _indicaterViewStatusContext;
}

#pragma mark -

- (NSUInteger)defaultPageSize {
    return [CLPageLoadManagerForTableAndCollectionView defaultPageSize];
}

- (CLPageLoadManagerForTableAndCollectionView *)createPageLoadManager
{
    //默认的创建方式
    if (self.contentTableView) {
        return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentTableView
                                                              pageLoadControllerClass:nil
                                                                             pageSize:[self defaultPageSize]
                                                                         startSection:0
                                                                             startRow:0
                                                                       segmentedCount:1];

    }else if (self.contentCollectionView) {
        return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentCollectionView
                                                              pageLoadControllerClass:nil
                                                                             pageSize:[self defaultPageSize]
                                                                         startSection:0
                                                                             startRow:0
                                                                       segmentedCount:1];
    }

    return nil;
}


- (void)configPageLoadManager:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager
{
    pageLoadManager.dataSource = self;
    pageLoadManager.topRefreshControl = self.refreshControl;
    pageLoadManager.bottomLoadControl = self.loadControl;

    pageLoadManager.autoAddRefreshControl = YES;
    pageLoadManager.autoAddLoadControl = YES;
}

- (void)setupPageLoadManagerWithdatasContext:(CLPageLoadDatasContext *)datasContext
{
    //创建分页管理器
    _pageLoadManager = [self createPageLoadManager];
    if (_pageLoadManager) {

        //配置分页管理器
        [self configPageLoadManager:_pageLoadManager];

        //更新初始化数据
        [self updateWithContext:datasContext];

        //segment改变
        [self didChangeSegmentedIndexFromIndex:NSNotFound];
    }
}

#pragma mark -

- (void)updateViewWithContext:(id<CLScrollContentPageCellContext>)context
{
    //更新分页管理器
    if ([context isKindOfClass:[CLPageLoadDatasContext class]]) {

        [self.pageLoadManager updateWithInitDatas:[(CLPageLoadDatasContext *)context datas]
                                   totalDataCount:[(CLPageLoadDatasContext *)context totalCount]];
    }else {
        [self.pageLoadManager updateWithInitDatas:nil totalDataCount:0];
    }
}

- (void)startUpdateData {
    [self startUpdateData:YES];
}

- (id<CLScrollContentPageCellContext>)currentPageContext
{
    if (self.pageLoadManager) {
        return [[CLPageLoadDatasContext alloc] initWithPageLoadManager:self.pageLoadManager
                                                               context:self.extendContext];
    }else {
        return nil;
    }
}

#pragma mark -

- (NSUInteger)currentSegmentedIndex {
    return self.pageLoadManager.currentSegmentedIndex;
}

- (void)setCurrentSegmentedIndex:(NSUInteger)currentSegmentedIndex
{
    if (self.currentSegmentedIndex != currentSegmentedIndex) {

        if (![self willChangeSegmentedIndexToIndex:currentSegmentedIndex]) {
            return;
        }

        NSUInteger fromSegmentedIndex = self.currentSegmentedIndex;
        CGPoint contentOffset = [self contentOffsetWhenDidChangeSegmentedIndexToIndex:currentSegmentedIndex];

        [self.pageLoadManager setCurrentSegmentedIndex:currentSegmentedIndex];

        //移动到合适位置
        if ([self needChangeContentOffsetWhenDidChangeSegmentedIndexFromIndex:fromSegmentedIndex]) {
            self.pageLoadManager.contentScrollView.contentOffset = contentOffset;
        }

        //更新加载视图
        [self _changeIndicaterViewStatus:CLIndicaterViewStatusHidden context:nil];

        //开始更新数据
        if ([self needUpdateDataWhenChangeSegmentedIndexFromIndex:fromSegmentedIndex]) {
            [self startUpdateData:YES];
        }else {
            [self startShowContentAnimationWhenDidChangeSegmentedIndexFromIndex:fromSegmentedIndex];
        }

        //通知改变SegmentedIndex
        [self didChangeSegmentedIndexFromIndex:fromSegmentedIndex];
    }
}

- (CGPoint)contentOffsetWhenDidChangeSegmentedIndexToIndex:(NSUInteger)toIndex {
    return CGPointMake(0.f, - self.pageLoadManager.contentScrollView.contentInset.top);
}

//是否需要改变offset，默认为YES
- (BOOL)needChangeContentOffsetWhenDidChangeSegmentedIndexFromIndex:(NSUInteger)fromIndex {
    return YES;
}

- (BOOL)willChangeSegmentedIndexToIndex:(NSUInteger)toIndex {
    return YES;
}

- (void)didChangeSegmentedIndexFromIndex:(NSUInteger)fromIndex {
    //do nothing
}

- (BOOL)needUpdateDataWhenChangeSegmentedIndexFromIndex:(NSUInteger)fromIndex {
    return self.pageLoadManager.currentDataCount == 0;
}

- (void)startShowContentAnimationWhenDidChangeSegmentedIndexFromIndex:(NSUInteger)fromIndex
{
    //    [self startIntervalAnimationWithDirection:self.currentSegmentedIndex > fromIndex ? MyMoveAnimtedDirectionLeft : MyMoveAnimtedDirectionRight delay:0.0 completedBlock:nil];
}

#pragma mark -

- (BOOL)showIndicaterView {
    return YES;
}

- (void)_changeIndicaterViewStatus:(CLIndicaterViewStatus)status context:(id)context
{
    if (![self showIndicaterView]) {
        return;
    }

    _indicaterViewStatus = status;
    _indicaterViewStatusContext = context;
    [self setNeedUpdateIndicaterView];
}

- (void)setNeedUpdateIndicaterView
{
    [self updateIndicaterViewWithStatus:self.indicaterViewStatus
                                context:_indicaterViewStatusContext];
}

- (void)updateIndicaterViewWithStatus:(CLIndicaterViewStatus)status context:(id)context {
    //do nothing
}

#pragma mark -

- (void)startUpdateData:(BOOL)scrollToTop
{
    if ([self showIndicaterView] && [self.pageLoadManager currentDataCount] == 0) {
        [self _changeIndicaterViewStatus:CLIndicaterViewStatusLoading context:nil];
        [self.pageLoadManager startUpdateData:NO];
    }else{
        [self.pageLoadManager startUpdateData:YES scrollToTop:scrollToTop];
    }
}

- (void)    pageLoadManager:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager
     wantToLoadDataWithPage:(NSUInteger)page
                andPageSize:(NSUInteger)pageSize
{
    //bShowRefreshCtrl是否在更新数据
    BOOL isUpdateData = pageLoadManager.dataLoadType == CLDataLoadTypeUpdate;

    //通知和核对网络
    if ([self willStartLoadData:isUpdateData] &&
        [self currentNetworkAvailable:![self showIndicaterView] || self.indicaterViewStatus == CLIndicaterViewStatusHidden]) {

        //没有显示刷新控件时显示指示视图
        if (!pageLoadManager.topRefreshControl.isRefreshing &&
            self.indicaterViewStatus != CLIndicaterViewStatusHidden) {
            [self _changeIndicaterViewStatus:CLIndicaterViewStatusLoading context:nil];
        }

        //开始加载数据
        [self loadDataHandleWithPage:page andPageSize:pageSize];
        [self didStartLoadData:isUpdateData];

    }else{

        //显示无网络指示
        if (self.indicaterViewStatus != CLIndicaterViewStatusHidden) {
            [self _changeIndicaterViewStatus:CLIndicaterViewStatusNoNet context:nil];
        }

        //尝试加载数据失败
        [pageLoadManager loadDataFail];
        [self didStartLoadDataFail:isUpdateData];
    }
}

- (void)pageLoadManagerWantCancleLoadData:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager
{
    //消息通知
    [self willCancleLoadData:pageLoadManager.dataLoadType == CLDataLoadTypeUpdate];

    //显示无内容指示视图
    if(self.indicaterViewStatus != CLIndicaterViewStatusHidden) {
        [self _changeIndicaterViewStatus:CLIndicaterViewStatusNothing context:nil];
    }

    //删除筛选的上下文
    _dataFilterContext = nil;

    //取消加载操作
    [self cancelLoadDataHandle];
}

- (void)pageLoadManager:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager didCancleLoadData:(BOOL)isUpdate
{
    [self didCancleLoadData:isUpdate];
}

- (void)pageLoadManagerCurrentDataCountDidChange:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager {
    [self updateViewWhenDatasCountDidChange];
}

- (void)updateViewWhenDatasCountDidChange
{
    //显示无内容指示视图
    if (self.pageLoadManager.currentDataCount == 0) {
        [self _changeIndicaterViewStatus:CLIndicaterViewStatusNothing context:nil];
    }else {
        [self _changeIndicaterViewStatus:CLIndicaterViewStatusHidden context:nil];
    }
}

- (void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize {
    //do nothing
}

- (void)cancelLoadDataHandle {
    //do nothing
}


- (void)loadDataSuccessWithDatas:(NSArray *)datas
                      totalCount:(NSUInteger)totalCount
                  completedBlock:(void(^)(NSArray * filtedDatas))completedBlock
{
    [self loadDataSuccessWithDatas:datas
                        totalCount:totalCount
             beginUpdateDatasBlock:nil
                    completedBlock:completedBlock];
}

- (void)loadDataSuccessWithDatas:(NSArray *)datas
                      totalCount:(NSUInteger)totalCount
           beginUpdateDatasBlock:(void(^)(NSArray * filtedDatas))beginUpdateDatasBlock
                  completedBlock:(void(^)(NSArray * filtedDatas))completedBlock
{
    if (self.pageLoadManager.dataLoadType == CLDataLoadTypeNone) {
        return;
    }

    if (self.datasFilterType == CLDatasFilterTypeNone) {
        [self _loadDataSuccessWithDatas:datas
                             totalCount:totalCount
                  beginUpdateDatasBlock:beginUpdateDatasBlock
                         completedBlock:completedBlock];
    }else {

        //生成当前操作的上下文,数据筛可能是一个大计算量操作，会使用异步进行筛选，筛选过程中可能加载过程被取消，用该值标记状态
        NSString * context = getUniqueID();
        _dataFilterContext = context;

        NSArray * currentDatas = self.pageLoadManager.dataLoadType == CLDataLoadTypeUpdate ? nil : self.pageLoadManager.allDatas;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            //筛选数据
            NSArray * resultDatas = [self _filterDatas:datas baseCurrentDatas:currentDatas];
            NSUInteger resultTotalCount = totalCount + MAX(0.f, resultDatas.count - datas.count);

            dispatch_async(dispatch_get_main_queue(), ^{

                //没有被取消
                if ([_dataFilterContext isEqualToString:context]) {
                    _dataFilterContext = nil;

                    [self _loadDataSuccessWithDatas:resultDatas
                                         totalCount:resultTotalCount
                              beginUpdateDatasBlock:beginUpdateDatasBlock
                                     completedBlock:completedBlock];
                }
            });
        });

    }
}

- (void)_loadDataSuccessWithDatas:(NSArray *)datas
                       totalCount:(NSUInteger)totalCount
            beginUpdateDatasBlock:(void(^)(NSArray * filtedDatas))beginUpdateDatasBlock
                   completedBlock:(void(^)(NSArray * filtedDatas))completedBlock
{
    if (beginUpdateDatasBlock) {
        beginUpdateDatasBlock(datas);
    }

    BOOL isUpdateData = self.pageLoadManager.dataLoadType == CLDataLoadTypeUpdate;

    //是否需要动画
    BOOL needAnimation = NO;
    if([self showIndicaterView] &&
       self.indicaterViewStatus != CLIndicaterViewStatusHidden) {
        needAnimation = datas.count != 0;
    }

    [self.pageLoadManager loadDataSuccessWithDatas:datas totalCount:totalCount];

    //动画
    if (needAnimation) {
        [self startShowContentAnimationWhenLoadDataSuccessWithDatas:datas totalCount:totalCount];
    }

    //通知完成加载数据
    [self didEndLoadData:isUpdateData success:YES];

    //回调
    if (completedBlock) {
        completedBlock(datas);
    }
}

- (void)startShowContentAnimationWhenLoadDataSuccessWithDatas:(NSArray *)datas totalCount:(NSUInteger)totalCount
{
    NSArray * visiblePageLoadCells = self.visiblePageLoadCells;
    for (UIView * cell in visiblePageLoadCells) {
        cell.alpha = 0.f;
    }

    [UIView animateWithDuration:1.0 animations:^{
        for (UIView * cell in visiblePageLoadCells) {
            cell.alpha = 1.f;
        }
    }];
}

- (void)loadDataFailWithError:(NSError *)error
{
    if (self.pageLoadManager.dataLoadType == CLDataLoadTypeNone) {
        return;
    }


    BOOL isUpdateData = self.pageLoadManager.dataLoadType == CLDataLoadTypeUpdate;

    //显示错误指示视图
    if ([self showIndicaterView] &&
        self.indicaterViewStatus != CLIndicaterViewStatusHidden) {

#if DEBUG
        showErrorMessage(self.window, error, @"获取数据失败");
#endif

        [self _changeIndicaterViewStatus:CLIndicaterViewStatusError context:error];
    }else {
        showErrorMessage(self.window, error, @"获取数据失败");
    }
    _lastLoadingError = error ;
    [self.pageLoadManager loadDataFail];

    //通知
    [self didEndLoadData:isUpdateData success:NO];
}

#pragma mark -

- (BOOL)willStartLoadData:(BOOL)isUpdateData {
    return YES;
}
- (void)didStartLoadDataFail:(BOOL)isUpdateData {
    //do nothing
}

- (void)didStartLoadData:(BOOL)isUpdateData {
    //do nothing
}

- (void)willCancleLoadData:(BOOL)isUpdateData {
    //do nothing
}

- (void)didCancleLoadData:(BOOL)isUpdateData {
    //do nothing
}

- (void)didEndLoadData:(BOOL)isUpdateData success:(BOOL)success {
    //do nothing
}

#pragma mark -

- (Class)needFilterDataClass {
    return nil;
}

- (NSArray *)_filterDatas:(NSArray *)datas baseCurrentDatas:(NSArray *)currentDatas
{
    if (self.datasFilterType == CLDatasFilterTypeEqual) {

        if (currentDatas.count && datas.count) {

            NSMutableArray * resultDatas = [NSMutableArray arrayWithCapacity:datas.count];
            Class needFilterDataClass = [self needFilterDataClass];

            for (id data in datas) {

                //不是需要筛选的数据或不存在则加入数据
                if ((needFilterDataClass && ![data isKindOfClass:needFilterDataClass]) || ![currentDatas containsObject:data]) {
                    [resultDatas addObject:data];
                }
            }

            if (datas.count != resultDatas.count) {
                DefaultDebugLog(@"筛选掉%i个重复的数据",(int)(datas.count - resultDatas.count));
                datas = resultDatas;
            }
        }
    }else {
        datas = [self customFilterDatas:datas baseCurrentDatas:currentDatas];
    }

    return datas;
}

- (NSArray *)customFilterDatas:(NSArray *)datas baseCurrentDatas:(NSArray *)currentDatas {
    return datas;
}

#pragma mark -

- (NSArray *)needAnimatedObjectsWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection forShow:(BOOL)show context:(id)context
{
    return self.visiblePageLoadCells;
}

- (NSArray *)visiblePageLoadCells
{
    UITableView * contentTableView = self.pageLoadManager.tableView;
    if (contentTableView) {

        NSArray * visibleCells = contentTableView.visibleCells;
        NSMutableArray * tempVisibleCells = [NSMutableArray arrayWithCapacity:visibleCells.count];
        for (UITableViewCell * cell in visibleCells) {
            if ([self.pageLoadManager containDataAtIndexPath:[contentTableView indexPathForCell:cell]]) {
                [tempVisibleCells addObject:cell];
            }
        }

        return tempVisibleCells;

    }else {

        UICollectionView * contentCollectionView = self.pageLoadManager.collectionView;
        if (contentCollectionView) {
            NSArray * visibleCells = contentCollectionView.visibleCells;

            NSMutableArray * tempVisibleCells = [NSMutableArray arrayWithCapacity:visibleCells.count];
            for (UICollectionViewCell * cell in visibleCells) {
                if ([self.pageLoadManager containDataAtIndexPath:[contentCollectionView indexPathForCell:cell]]) {
                    [tempVisibleCells addObject:cell];
                }
            }

            return tempVisibleCells;
        }
    }

    return nil;
}


#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.pageLoadManager.contentScrollView == tableView) {
        return self.pageLoadManager.sectionCount;
    }else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.pageLoadManager.contentScrollView == tableView) {
        return [self.pageLoadManager dataCountAtSection:section];
    }else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.pageLoadManager.contentScrollView == collectionView) {
        return self.pageLoadManager.sectionCount;
    }else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.pageLoadManager.contentScrollView == collectionView) {
        return self.pageLoadManager.sectionCount;
    }else {
        return 0;
    }
}

#pragma mark -

- (BOOL)isUpdatingData {
    return self.pageLoadManager.dataLoadType == CLDataLoadTypeUpdate;
}


@end

