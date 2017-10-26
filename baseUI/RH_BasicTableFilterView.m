//
//  RH_BasicTableFilterView.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/9.
//  Copyright © 2017年 jinguihua. All rights reserved.
//
//

//----------------------------------------------------------

#import "RH_BasicTableFilterView.h"
#import "NSObject+IntervalAnimation.h"
#import "RH_ModelInfoCachePool.h"

//----------------------------------------------------------

@interface RH_BasicTableFilterView ()

//是否需要缓存数据
@property(nonatomic) BOOL needCacheDatas;
@end

//----------------------------------------------------------

@implementation RH_BasicTableFilterView
{
    BOOL _didSetupView;
    BOOL _needCacheDataWhenMoveOutWindow;
}

@synthesize tableView = _tableView;
@synthesize filterModel = _filterModel;

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.9f];

        //获取缓存数据
        NSArray<RH_BasicFilterModel *> * cachedFilterDatas = [self getInitFilterDatas];

        //存在缓存数据则开始初始化视图
        if (cachedFilterDatas.count) {
            [self _setupViewFilterDatas:cachedFilterDatas];
        }else if(![self isLocalDatas]) {  //否则开始更新数据
            [self _startUpdateFilterDatas];
        }else {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"对于本地筛选数据初始化必须返回数据"
                                         userInfo:nil];
        }
    }

    return self;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView =  [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.allowsMultipleSelection = YES;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 44.f;

        //注册复用
//        [_tableView registerCellWithClass:[RH_DefaultFilterTableViewCell class]];
    }

    return _tableView;
}


- (void)_setupViewFilterDatas:(NSArray<RH_BasicFilterModel *> *)filterDatas
{
    _didSetupView = YES;

    //初始化内容视图
    [self addSubview:self.tableView];

    //更新数据
    [self _updateFilterDatas:filterDatas];
}


- (void)dealloc
{
    //结束刷新
//    [self.refreshControl endRefreshing];
}

#pragma mark -

- (BOOL)isLocalDatas {
    return YES;
}

- (NSString *)datasKeyForCache {
    return nil;
}

- (NSArray<RH_BasicFilterModel *> *)getInitFilterDatas
{
    NSString * datasKeyForCache = [self datasKeyForCache];
    return datasKeyForCache.length ? [[RH_ModelInfoCachePool shareCachePool] getDatasWithType:datasKeyForCache forContext:nil] : nil;
}

- (void)cacheFilterDatas
{
    NSString * datasKeyForCache = [self datasKeyForCache];
    if (datasKeyForCache.length == 0) {
        return;
    }

    //缓存数据
    [[RH_ModelInfoCachePool shareCachePool] cacheDatas:self.filterDatas withType:datasKeyForCache forContext:nil];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];

    if (self.window == nil && _needCacheDataWhenMoveOutWindow) {
        _needCacheDataWhenMoveOutWindow = NO;
        [self cacheFilterDatas];
    }
}

- (void)setNeedCacheDatas
{
    if (self.window == nil) {
        [self cacheFilterDatas];
    }else {
        _needCacheDataWhenMoveOutWindow = YES;
    }
}

#pragma mark -

- (void)_refreshHandle {
    [self _startUpdateFilterDatas];
}

- (void)_startUpdateFilterDatas
{
    //取消获取数据
    [self didCancleUpdateFilterDatas];

    if (NetworkAvailable()) {


        //开始更新数据
        [self startUpdateFilterDatas];

    }else {

    }
}

- (void)startUpdateFilterDatas {
    //do nothing
}

- (void)didCancleUpdateFilterDatas {
    //do nothing
}

- (void)completedUpdateFilterDatas:(NSArray<RH_BasicFilterModel *> *)filterDatas error:(NSError *)error
{
    if (error == nil) {

        if (!_didSetupView) {
            //初始化视图
            [self _setupViewFilterDatas:filterDatas];

            //显示动画
            [self _startShowAnimatedWithDelay:0.f direction:CLMoveAnimtedDirectionLeft];
        }else {
          //更新数据
            [self _updateFilterDatas:filterDatas];
        }

        //指示需要缓存数据
        [self setNeedCacheDatas];

    }else {

        if (!_didSetupView) {
//            [self.loadingIndicateView showDefaultLoadingErrorStatus];
        }else {
//            [self.refreshControl endRefreshing];
            showErrorMessage(self, nil, @"刷新失败");
        }
    }
}


- (void)_updateFilterDatas:(NSArray<RH_BasicFilterModel *> *)filterDatas
{
    _filterDatas = filterDatas;
    [self.tableView reloadData];

    //更新筛选的选择
    [self _updateFilterSelection];
}

- (void)_updateFilterSelection
{
    if (!self.filterDatas.count) {
        return;
    }

    //获取选中的的index
    NSUInteger index = NSNotFound;
    if (_filterModel){
        index = [self.filterDatas indexOfObject:(id)_filterModel];
    }
    index = index == NSNotFound ? 0 : index;

    //更新选择的筛选模型
    _filterModel = self.filterDatas[index];

    //取消现有选中cell
    for (NSIndexPath * indexPath in self.tableView.indexPathsForSelectedRows) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    //选中cell
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillShow:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [super viewWillShow:animated duration:duration];
}

#pragma mark -

- (void)setFilterModel:(RH_BasicFilterModel *)filterModel
{
    if (_filterModel != filterModel) {
        _filterModel = filterModel;
        [self _updateFilterSelection];
    }
}

- (RH_BasicFilterModel *)filterModel {
    return _filterModel ?: [[self class] defaultFilterModel];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DefaultFilterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[RH_DefaultFilterTableViewCell defaultReuseIdentifier]];
    [cell updateCellWithInfo:nil context:self.filterDatas[indexPath.row]];

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //移除当前选中的并删除其它选中
    NSMutableArray * indexPaths =  [NSMutableArray arrayWithArray:[tableView indexPathsForSelectedRows]];
    [indexPaths removeObject:indexPath];
    for (NSIndexPath * indexPath in indexPaths) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

    //设置值
    _filterModel = self.filterDatas[indexPath.row];

    //发送选中的消息
    [self sendDidChangeFilterMsg];
}

#pragma mark -

- (CGFloat)heightForViewWithContainerSize:(CGSize)containerSize
{
    CGFloat height = ceilf(containerSize.height * 0.7f);
    return self.filterDatas.count ? MIN(self.tableView.rowHeight * self.filterDatas.count, height) : height;
}

- (NSArray *)needAnimatedViewsForShow:(BOOL)show context:(id)context {
    return [self.tableView visibleCells];
}

- (void)startShowAnimatedWithDelay:(NSTimeInterval)delay {
    [self _startShowAnimatedWithDelay:delay direction:self.showAnimtedMoveDirection];
}

- (void)_startShowAnimatedWithDelay:(NSTimeInterval)delay direction:(CLMoveAnimtedDirection)moveAnimtedDirection
{
    [self startCommitIntervalAnimatedWithDirection:moveAnimtedDirection
                                          duration:1.3
                                             delay:delay * 0.6
                                           forShow:YES
                                           context:nil
                                    completedBlock:nil];
}

- (NSTimeInterval)animationIntervalForDuration:(NSTimeInterval)duration forShow:(BOOL)show {
    return 0.1;
}



@end
