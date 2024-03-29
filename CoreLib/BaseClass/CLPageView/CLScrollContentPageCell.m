//
//  CLScrollContentPageCell.m
//  TaskTracking
//
//  Created by jinguihua on 2017/6/8.
//  Copyright © 2017年 jinguihua. All rights reserved.
//
//-------------------------------------------------

#import "CLScrollContentPageCell.h"
#import "CLActivityIndicatorView.h"
#import "UIView+FrameSize.h"
#import "NSObject+IntervalAnimation.h"
#import "MacroDef.h"
#import "CLDocumentCachePool.h"
#import "UIScrollView+ScrollToBorder.h"
//-------------------------------------------------

@implementation CLScrollContentPageCellDefaultContxt

@synthesize needUpdateData = _needUpdateData;
@synthesize contentOffset = _contentOffset;
@synthesize extendContext = _extendContext;

- (id)initWithNeedUpdateData:(BOOL)needUpdateData contentOffset:(CGPoint)contentOffset extendContext:(id)extendContext
{
    self = [super init];
    if (self) {
        _needUpdateData = needUpdateData;
        _contentOffset = contentOffset;
        _extendContext = extendContext;
    }

    return self;
}

@end


//-------------------------------------------------


@implementation CLScrollContentPageCell
{
    CGFloat _topExtentViewHeight;
    NSMutableSet *  _needSavaDataKeys;
}

@synthesize myContentView = _myContentView;
@synthesize topExtentView = _topExtentView;
@synthesize refreshControl = _refreshControl;
@synthesize loadControl = _loadControl;
@synthesize progressIndicatorView = _progressIndicatorView;

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self reloadViews];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self reloadViews];
    }

    return self;
}

- (void)dealloc
{
    //停止刷新和加载
    [_refreshControl endRefreshing];
    [_loadControl endRefreshing];

    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (UIView *)myContentView
{
    if (!_myContentView) {
        _myContentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView insertSubview:_myContentView atIndex:0];
    }

    return _myContentView;
}


- (CGFloat)topExtentViewHeight {
    return 0.f;
}

- (void)reloadViews
{
    if (_topExtentViewHeight != [self topExtentViewHeight]) {
        _topExtentViewHeight = MAX(0, [self topExtentViewHeight]);

        [self _updateContentScrollViewInset];
        [self setNeedsLayout];
    }
}

- (UIView *)topExtentView
{
    if (!_topExtentView && [self topExtentViewHeight] >= 0) {
        _topExtentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.contentView.frameWidth, _topExtentViewHeight)];
        [self.contentView addSubview:_topExtentView];
    }

    return _topExtentView;
}

#pragma mark -

- (UIEdgeInsets)contentScorllViewInitContentInset {
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)contentScorllViewContentInset
{
    UIEdgeInsets contentInset = [self contentScorllViewInitContentInset];
    contentInset.top += _topExtentViewHeight;
    return contentInset;
}

- (UIEdgeInsets)contentScorllViewInitScorllIndicatorInsets {
    return [self contentScorllViewInitContentInset];
}

- (UIEdgeInsets)contentScorllViewScorllIndicatorInsets
{
    UIEdgeInsets scrollIndicatorInsets = [self contentScorllViewInitScorllIndicatorInsets];
    scrollIndicatorInsets.top += _topExtentViewHeight;
    return scrollIndicatorInsets;
}

- (void)setContentScrollView:(UIScrollView *)contentScrollView
{
    if (_contentScrollView != contentScrollView) {
        _contentScrollView = contentScrollView;

        if (contentScrollView) {

            if (contentScrollView.superview == nil) {

                contentScrollView.frame = self.myContentView.bounds;
                contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                [self.myContentView addSubview:contentScrollView];
            }

            //更新inset
            [self _updateContentScrollViewInset];
        }
    }
}

- (void)_updateContentScrollViewInset
{
    if (!self.contentScrollView) {
        return;
    }

    self.contentScrollView.contentInset = [self contentScorllViewContentInset];
    self.contentScrollView.scrollIndicatorInsets = [self contentScorllViewScorllIndicatorInsets];
}

#pragma mark -

- (CLRefreshControl *)refreshControl
{
    if (!_refreshControl) {

        //初始化
        _refreshControl = [[CLRefreshControl alloc] init];
        [_refreshControl addTarget:self
                            action:@selector(refreshHandle)
                  forControlEvents:UIControlEventValueChanged];
        //        _refreshControl.textColor = defaultTitleTextColor();
        //        _refreshControl.locationOffset = CGPointMake(0.f, - self.contentScorllViewInitContentInset.top);
    }

    return _refreshControl;
}

- (void)refreshHandle {
}

- (CLRefreshControl *)loadControl
{
    if (!_loadControl) {
        _loadControl = [[CLRefreshControl alloc] initWithType:CLRefreshControlTypeBottom];
        [_loadControl addTarget:self
                         action:@selector(loadHandle)
               forControlEvents:UIControlEventValueChanged];
        //        _loadControl.textColor = defaultTitleTextColor();
        //        _loadControl.locationOffset = CGPointMake(0.f, self.contentScorllViewInitContentInset.bottom);
    }

    return _loadControl;
}

- (void)loadHandle {
}

#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.myContentView.frame = self.contentView.bounds;

    if ([self topExtentViewHeight]) {
        self.topExtentView.frame = CGRectMake(0.f, self.contentScorllViewInitContentInset.top, self.contentView.frameWidth, _topExtentViewHeight);
    }
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark -

- (void)startDefaultShowIntervalAnimation
{
    [self startIntervalAnimationWithDirection:CLMoveAnimtedDirectionLeft
                                        delay:0.f
                               completedBlock:nil];
}

- (void)startIntervalAnimationWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                                      delay:(NSTimeInterval)delay
                             completedBlock:(void(^)(BOOL finished))completedBlock
{
    [self startCommitIntervalAnimatedWithDirection:moveAnimtedDirection
                                          duration:[self defaultIntervalAnimationDuration]
                                             delay:delay
                                           forShow:YES
                                           context:nil
                                    completedBlock:completedBlock];
}

- (NSTimeInterval)defaultIntervalAnimationDuration {
    return 0.8;
}

- (NSArray *)needAnimatedObjectsWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                                      forShow:(BOOL)show
                                      context:(id)context
{
    if (self.contentTableView.superview) {
        return self.contentTableView.visibleCells;
    }else if (self.contentCollectionView.superview){
        return [self.contentCollectionView needAnimatedObjectsWithDirection:moveAnimtedDirection
                                                                    forShow:show
                                                                    context:context];
    }else{
        return @[self.contentView];
    }
}

- (NSTimeInterval)animationIntervalForDuration:(NSTimeInterval)duration forShow:(BOOL)show {
    return 0.1;
}

#pragma mark -

- (MBProgressHUD *)progressIndicatorView
{
    if (!_progressIndicatorView) {

        CLActivityIndicatorView * activityIndicatorView = [[CLActivityIndicatorView alloc] initWithStyle:CLActivityIndicatorViewStyleIndeterminate];
        activityIndicatorView.bounds = CGRectMake(0.f, 0.f, 30.f, 30.f);
        [activityIndicatorView startAnimating];
        _progressIndicatorView = [[MBProgressHUD alloc] initWithView:self];
        _progressIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        _progressIndicatorView.mode = MBProgressHUDModeCustomView;
        _progressIndicatorView.customView = activityIndicatorView;
        _progressIndicatorView.removeFromSuperViewOnHide = YES;
    }

    return _progressIndicatorView;
}


- (void)showProgressIndicatorViewWithAnimated:(BOOL)animated title:(NSString *)title
{
    [self hideProgressIndicatorViewWithAnimated:NO completedBlock:nil];

    self.progressIndicatorView.labelText = title;
    self.progressIndicatorView.transform = CGAffineTransformIdentity;
    self.progressIndicatorView.animationType = MBProgressHUDAnimationFade;
    [self addSubview:self.progressIndicatorView];
    [self.progressIndicatorView show:animated];
}

- (void)hideProgressIndicatorViewWithAnimated:(BOOL)animated completedBlock:(void(^)())completedBlock
{
    if (_progressIndicatorView.superview) {
        _progressIndicatorView.animationType = MBProgressHUDAnimationZoom;
        _progressIndicatorView.completionBlock = completedBlock;
        [_progressIndicatorView hide:animated];
    }
}

#pragma mark -

- (BOOL)currentNetworkAvailable:(BOOL)showMSgWhenNoNetwork
{
    if ([self currentNetworkStatus] == NotReachable) {
        if (showMSgWhenNoNetwork) {
            showErrorMessage(nil, nil, @"网络似乎断开了连接");
        }
        return NO;
    }

    return YES;
}

- (NetworkStatus)currentNetworkStatus {
    return [CLNetReachability currentNetReachabilityStatus];
}

- (void)setNeedObserveNetworkStatusChange:(BOOL)needObserveNetworkStatusChange
{
    if (_needObserveNetworkStatusChange != needObserveNetworkStatusChange) {

        if (_needObserveNetworkStatusChange) {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:NT_NetReachabilityChangedNotification
                                                          object:nil];
        }

        _needObserveNetworkStatusChange = needObserveNetworkStatusChange;

        //添加通知
        if (_needObserveNetworkStatusChange) {

            //开始监听
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(_networkStatusChangeNotification:)
                                                         name:NT_NetReachabilityChangedNotification
                                                       object:nil];
        }
    }
}

- (void)_networkStatusChangeNotification:(NSNotification *)notification
{
    if ([NSThread isMainThread]) {
        [self networkStatusChangeHandle];
    }else{
        [self performSelectorOnMainThread:@selector(networkStatusChangeHandle)
                               withObject:nil
                            waitUntilDone:NO];
    }
}

- (void)networkStatusChangeHandle {
    //do noting
}


#pragma mark -

//设置某一key标识的数据需要被储存
- (void)setNeedSavaDataForKey:(NSString *)key
{
    if (!_needSavaDataKeys) {
        _needSavaDataKeys = [NSMutableSet set];
    }

    if (key.length) {
        [_needSavaDataKeys addObject:key];
    }else {
        DefaultDebugLog(@"标识需要储存数据的key不能为nil");
    }
}

- (void)saveDatasIfNeeded
{
    //储存数据
    for (NSString * key in _needSavaDataKeys) {
        [self saveDataForKey:key];
    }

    [_needSavaDataKeys removeAllObjects];
}

- (void)saveDataForKey:(NSString *)key
{
    MyAssert(key.length);

    //获取需要缓存的数据
    id data = [self needSaveDataForKey:key];

    //仓库类型
    CLDataStoreType dataStoreType = [self dataStoreTypeForSavaDateWithKey:key];

    //自定义储存
    if (dataStoreType > CLDataStoreTypeNone) {
        [self saveData:data toCustomDataStore:dataStoreType withKey:key];
    }else if (dataStoreType != CLDataStoreTypeNone) {

        CLDocumentCachePool * cachePool = dataStoreType == CLDataStoreTypeTemp ? [CLDocumentCachePool shareTempCachePool] : [CLDocumentCachePool sharePool];

        if ([data conformsToProtocol:@protocol(NSCoding)]) {
            [cachePool cacheKeyedArchiverDataWithRootObject:data forKey:key async:YES];
        }else {
            [cachePool removeCacheFileForKey:key async:YES];
        }
    }
}

- (id)needSaveDataForKey:(NSString *)key {
    return nil;
}

- (CLDataStoreType)dataStoreTypeForSavaDateWithKey:(NSString *)key {
    return CLDataStoreTypeTemp;
}

- (id)getDataSavedInStore:(CLDataStoreType)dataStoreType withKey:(NSString *)key
{
    if (key.length == 0) {
        return nil;
    }

    if (dataStoreType > CLDataStoreTypeNone) {
        return [self getDataSavedInCustomStore:dataStoreType withKey:key];
    }else if (dataStoreType != CLDataStoreTypeNone) {

        CLDocumentCachePool * cachePool = dataStoreType == CLDataStoreTypeTemp ? [CLDocumentCachePool shareTempCachePool] : [CLDocumentCachePool sharePool];

        return [cachePool cacheKeyedUnArchiverRootObjectForKey:key];
    }

    return nil;
}

- (void)saveData:(id)data toCustomDataStore:(CLDataStoreType)dataStoreType withKey:(NSString *)key {
    //do nothing
}

- (id)getDataSavedInCustomStore:(CLDataStoreType)dataStoreType withKey:(NSString *)key {
    return nil;
}


#pragma mark -

- (void)updateWithContext:(id<CLScrollContentPageCellContext>)context
{
    _extendContext = [context extendContext];

    //更新视图
    [self updateViewWithContext:context];

    //更新内容偏移
    if (self.contentScrollView != nil) {

        UIEdgeInsets contentInset = self.contentScrollView.contentInset;
        CGPoint contentOffset = [self contentOffsetForContext:context];
        contentOffset.x = MAX(contentOffset.x, - contentInset.left);
        contentOffset.y = MAX(contentOffset.y, - contentInset.top);
        self.contentScrollView.contentOffset = contentOffset;
    }

    //更新数据
    if ([self needUpdateDataForContext:context]) {
        [self startUpdateData];
    }
}

- (void)updateViewWithContext:(id<CLScrollContentPageCellContext>)context {
    //do nothing
}

- (BOOL)needUpdateDataForContext:(id<CLScrollContentPageCellContext>)context {
    return context == nil || [context needUpdateData];
}

- (CGPoint)contentOffsetForContext:(id<CLScrollContentPageCellContext>)context
{
    if (context == nil || [context needUpdateData]) {
        UIEdgeInsets contentInset = self.contentScrollView.contentInset;
        return CGPointMake(- contentInset.left, - contentInset.top);
    }else {
        return [context contentOffset];
    }
}

- (void)startUpdateData {
    //do nothing
}

- (id<CLScrollContentPageCellContext>)currentPageContext
{
    return [[CLScrollContentPageCellDefaultContxt alloc] initWithNeedUpdateData:[self isUpdatingData] contentOffset:self.contentScrollView.contentOffset extendContext:self.extendContext];
}

- (void)tryRefreshData
{
    //没有在刷新数据则开始刷新数据，否则移动到最顶端
    if (![self isUpdatingData]) {
        [self startUpdateData];
    }else {
        [self.contentScrollView scrollToBoder:CLScrollBorderTop animated:YES];
    }
}

- (BOOL)isUpdatingData {
    return NO;
}

#pragma mark -

- (id)myForwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (![super respondsToSelector:aSelector]) {
        id object = [self myForwardingTargetForSelector:aSelector];
        return [object respondsToSelector:aSelector];
    }

    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    id object = [self myForwardingTargetForSelector:aSelector];
    if ([object respondsToSelector:aSelector]) {
        return object;
    }

    return [super forwardingTargetForSelector:aSelector];
}

@end
