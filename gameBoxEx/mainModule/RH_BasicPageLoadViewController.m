//
//  RH_BasicPageLoadViewController.m
//  TaskTracking
//
//  Created by jinguihua on 2017/3/16.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicPageLoadViewController.h"
#import "coreLib.h"


@interface RH_BasicPageLoadViewController ()
@end

@implementation RH_BasicPageLoadViewController
{
    //加载更多的次数
    NSUInteger _loadMoreCount;

    //数据筛选的上下文
    NSString * _dataFilterContext;
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
    pageLoadManager.topRefreshControl = self.updateRefreshCtrl ;
    pageLoadManager.bottomLoadControl = self.loadRefreshCtrl;

    pageLoadManager.autoAddRefreshControl = YES;
    pageLoadManager.autoAddLoadControl = YES;
}

- (void)setupPageLoadManager
{
    //创建
    _pageLoadManager = [self createPageLoadManager];
    if (_pageLoadManager) {

        //配置
        [self configPageLoadManager:_pageLoadManager];

        [self didChangeSegmentedIndexFromIndex:NSNotFound];

        //加载初始化数据
        if (![self _loadInitDatas]) {
            [self.pageLoadManager reloadContentViewData];
        }

        //需要更新或者无数据则开始更新数据
        if (self.needUpdateDataWhenSetup && [self needUpdateDataWhenChangeSegmentedIndexFromIndex:NSNotFound]) {

            //开始更新数据
            [self startUpdateData];

        }else if (self.pageLoadManager.currentDataCount == 0) { //更新指示视图
            [self pageLoadManagerCurrentDataCountDidChange:self.pageLoadManager];
        }
    }
}

#pragma mark -

- (void)updateWithInitDatas:(NSArray *)initDatas {
    [self.pageLoadManager updateWithInitDatas:initDatas];
}

- (BOOL)_loadInitDatas
{
    //加载初始化的数据
    NSArray * initDatas = [self getInitDatas];
    if (initDatas.count) {
        [self updateWithInitDatas:initDatas];
        return YES;
    }else {
        return NO;
    }
}

- (NSArray *)getInitDatas {
    return nil;
}

#pragma mark -

- (RH_LoadingIndicateView *)loadingIndicateView {
    return self.contentLoadingIndicateView;
}

- (void)startUpdateData {
    [self startUpdateData_e:YES];
}

- (void)startUpdateData_e:(BOOL)scrollToTop
{
    if ([self.pageLoadManager currentDataCount] == 0) {
        [[self loadingIndicateView] showLoadingStatusWithTitle:nil detailText:nil];
        [self.pageLoadManager startUpdateData:NO];
    }else{
        [self.pageLoadManager startUpdateData:YES scrollToTop:scrollToTop];
    }
}

- (void)startUpdateDataWithShowRefreshCtrl:(BOOL)bShowRefreshCtrl
{
    if ([self.pageLoadManager currentDataCount] == 0) {
        [[self loadingIndicateView] showLoadingStatusWithTitle:nil detailText:nil];
        [self.pageLoadManager startUpdateData:NO];
    }else{
        [self.pageLoadManager startUpdateData:bShowRefreshCtrl scrollToTop:bShowRefreshCtrl];
    }
}

- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    if (loadingIndicateView == self.loadingIndicateView) {

        //没有在更新,则开始更新
        if(self.pageLoadManager.dataLoadType != CLDataLoadTypeUpdate) {
            [self startUpdateData];
        }else {
            [loadingIndicateView showLoadingErrorStatusWithTitle:nil detailText:nil];
        }
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

        //通知改变SegmentedIndex
        [self didChangeSegmentedIndexFromIndex:fromSegmentedIndex];

        //移动到合适位置
        if ([self needChangeContentOffsetWhenDidChangeSegmentedIndexFromIndex:fromSegmentedIndex]) {
            self.pageLoadManager.contentScrollView.contentOffset = contentOffset;
        }

        //隐藏加载视图
        [[self loadingIndicateView] hiddenView];

        if ([self.pageLoadManager currentDataCount] == 0) {

            //加载初始化的数据
            [self _loadInitDatas];

            //开始更新数据
            if ([self needUpdateDataWhenChangeSegmentedIndexFromIndex:fromSegmentedIndex]) {
                [self startUpdateData];
            }

        }else if([self needAnimationWhenDidChangeSegmentedIndexFromIndex:fromSegmentedIndex]){

            //执行动画
            [self startIntervalAnimationWithDirection:currentSegmentedIndex > fromSegmentedIndex ? CLMoveAnimtedDirectionLeft : CLMoveAnimtedDirectionRight completedBlock:nil];
        }
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
    return YES;
}

- (BOOL)needAnimationWhenDidChangeSegmentedIndexFromIndex:(NSUInteger)fromIndex {
    return YES;
}


#pragma mark -

- (void)    pageLoadManager:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager
     wantToLoadDataWithPage:(NSUInteger)page
                andPageSize:(NSUInteger)pageSize
{
    //是否在更新数据
    BOOL isUpdateData = pageLoadManager.dataLoadType == CLDataLoadTypeUpdate;

    //将要开始加载数据
    if (![self willStartLoadData:isUpdateData]) {
        return;
    }

    //核对网络
    if (CurrentNetworkAvailable([self loadingIndicateView].isHidden)) {

        //没有显示刷新控件时显示
        if (!pageLoadManager.topRefreshControl.isRefreshing && ![self loadingIndicateView].isHidden) {
            [[self loadingIndicateView] showLoadingStatusWithTitle:nil detailText:nil];
        }

        //开始加载数据
        [self didStartLoadData:isUpdateData];
        [self loadDataHandleWithPage:page andPageSize:pageSize];

    }else{

        if (![self loadingIndicateView].isHidden) {
            [[self loadingIndicateView] showNoNetworkStatus];
        }

        //尝试加载数据失败
        [self didStartLoadDataFail:isUpdateData];
        [pageLoadManager loadDataFail];
    }
}

- (void)pageLoadManagerWantCancleLoadData:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager
{
    if(![self loadingIndicateView].isHidden) {

        //显示无内容指示视图
        if (![self showNotingIndicaterView]) {
            [[self loadingIndicateView] showNothingWithTitle:[self nothingIndicateTitle]];
        }
    }

    //删除筛选的上下文
    _dataFilterContext = nil;

    //消息通知
    [self didCancleLoadData];

    //取消加载操作
    [self cancelLoadDataHandle];
}

- (void)pageLoadManagerCurrentDataCountDidChange:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager {
    [self setNeedUpdateViewWithDataCountChange];
}

- (void)setNeedUpdateViewWithDataCountChange
{
    if (self.pageLoadManager.currentDataCount == 0) {

        //显示无内容指示视图
        if (![self showNotingIndicaterView]) {
            [[self loadingIndicateView] showNothingWithTitle:[self nothingIndicateTitle]];
        }

    }else if(!self.loadingIndicateView.isHidden){
        [[self loadingIndicateView] hiddenView];
    }
}

- (BOOL)showNotingIndicaterView {
    return NO;
}

- (void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize {
    //do nothing
}

- (void)cancelLoadDataHandle {
    //do nothing
}

- (void)loadDataSuccessWithDatas:(NSArray *)datas totalCount:(NSUInteger)totalCount {
    [self loadDataSuccessWithDatas:datas totalCount:totalCount completedBlock:nil];
}

- (void)loadDataSuccessWithDatas:(NSArray *)datas
                      totalCount:(NSUInteger)totalCount
                  completedBlock:(void(^)(NSArray * filtedDatas))completedBlock
{
    if (self.pageLoadManager.dataLoadType == CLDataLoadTypeNone) {
        return;
    }

    if (self.datasFilterType == CL_DatasFilterTypeNone) {
        [self _loadDataSuccessWithDatas:datas totalCount:totalCount completedBlock:completedBlock];
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

                    [self _loadDataSuccessWithDatas:resultDatas totalCount:resultTotalCount completedBlock:completedBlock];
                }
            });
        });

    }
}

- (void)_loadDataSuccessWithDatas:(NSArray *)datas
                       totalCount:(NSUInteger)totalCount
                   completedBlock:(void(^)(NSArray * filtedDatas))completedBlock
{
    BOOL isUpdateData = self.pageLoadManager.dataLoadType == CLDataLoadTypeUpdate;

    //通知完成加载数据
    [self didEndLoadData:isUpdateData success:YES];

    //是否需要动画
    BOOL needAnimation = NO;
    if([self needAnimationWhenLoadDataSuccessWithDatas:datas totalCount:totalCount] &&
       ![self loadingIndicateView].isHidden){
        needAnimation = datas.count != 0;
    }

    [self.pageLoadManager loadDataSuccessWithDatas:datas totalCount:totalCount];

    if (needAnimation) {
        [self startDefaultShowIntervalAnimation];
    }

    //统计
    if (isUpdateData) {
        _loadMoreCount = 1;

    }else {
        ++ _loadMoreCount;
    }

    //回调
    if (completedBlock) {
        completedBlock(datas);
    }
}

- (BOOL)needAnimationWhenLoadDataSuccessWithDatas:(NSArray *)datas totalCount:(NSUInteger)totalCount {
    return YES;
}

- (void)loadDataFailWithError:(NSError *)error
{
    if (self.pageLoadManager.dataLoadType == CLDataLoadTypeNone) {
        return;
    }

    //通知
    [self didEndLoadData:self.pageLoadManager.dataLoadType == CLDataLoadTypeUpdate success:NO];

    //显示错误视图
    if (![self showLoadDataErrorIndicaterForError:error]) {

        if (![self loadingIndicateView].isHidden) {
            if ([SITE_TYPE isEqualToString:@"integratedv3oc"])
            {
                [[self loadingIndicateView] showDefaultLoadingErrorStatus:error];
            }else{
                [[self loadingIndicateView] showDefaultLoadingErrorStatus];
            }
        }else{
            showErrorMessage(self.view, error, @"获取数据失败");
        }
    }

    [self.pageLoadManager loadDataFail];
}

- (BOOL)showLoadDataErrorIndicaterForError:(NSError *)error {
    return NO;
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

- (void)didCancleLoadData {
    //do nothing
}
- (void)didEndLoadData:(BOOL)isUpdateData success:(BOOL)success {
    //do nothing
}


#pragma mark -

- (NSString *)nothingIndicateTitle {
    return @"没有获取到任何数据" ;
}

#pragma mark -

- (BOOL)isSubViewController {
    return NO;
}

- (BOOL)fullScreenModeIncludeTabBar {
    return ![self isSubViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self isSubViewController]) {
        self.hiddenTabBar = YES ;
        self.navigationBarItem.leftBarButtonItem = self.backButtonItem ;
        self.navigationBarItem.rightBarButtonItems = nil ;
//        self.navigationBarItem.titleView = self.subNavigationBarView ;
    }

    self.needUpdateDataWhenSetup = YES;
}

#pragma mark-
-(void)backBarButtonItemHandle
{
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title] ;
    if ([self isSubViewController]){
    }
}

#pragma mark -

- (Class)needFilterDataClass {
    return nil;
}

- (NSArray *)_filterDatas:(NSArray *)datas baseCurrentDatas:(NSArray *)currentDatas
{
    if (self.datasFilterType == CL_DatasFilterTypeEqual) {

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.pageLoadManager.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pageLoadManager dataCountAtSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.pageLoadManager.sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.pageLoadManager dataCountAtSection:section];
}

#pragma mark -

- (NSArray *)needAnimatedObjectsWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection forShow:(BOOL)show context:(id)context
{
    UITableView * contentTableView = self.pageLoadManager.tableView;
    if (contentTableView) {

        NSArray * visibleCells = [contentTableView needAnimatedObjectsWithDirection:moveAnimtedDirection
                                                                            forShow:show
                                                                            context:context];

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
            NSArray * visibleCells =  [contentCollectionView needAnimatedObjectsWithDirection:moveAnimtedDirection
                                                                                      forShow:show
                                                                                      context:context];

            NSMutableArray * tempVisibleCells = [NSMutableArray arrayWithCapacity:visibleCells.count];
            for (UICollectionViewCell * cell in visibleCells) {
                if ([self.pageLoadManager containDataAtIndexPath:[contentCollectionView indexPathForCell:cell]]) {
                    [tempVisibleCells addObject:cell];
                }
            }

            return tempVisibleCells;
        }
    }

    return [super needAnimatedObjectsWithDirection:moveAnimtedDirection forShow:show context:context];
}


@end

