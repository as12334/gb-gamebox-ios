//
//  RH_ShowFilterViewManager.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//


//----------------------------------------------------------

#import "RH_ShowFilterViewManager.h"
#import "CLSectionControl.h"

//----------------------------------------------------------

@interface RH_ShowFilterViewManager () < CLDeclineMenuContainerViewDelegate,
                                         RH_FilterViewDelegate >

@end

//----------------------------------------------------------

@implementation RH_ShowFilterViewManager
{
    NSString * _filterInfosFileName;
    BOOL _needCacheFilterValues;
}

@synthesize filterInfos = _filterInfos;
@synthesize filterModels = _filterModels;
@synthesize filterContainerView = _filterContainerView;


- (id)initWithFilterInfosFileName:(NSString *)filterInfosFileName filterModelsCacheKey:(NSString *)filterModelsCacheKey
{
    self = [super init];

    if (self) {

        _filterInfosFileName = filterInfosFileName;
        _filterModelsCacheKey = filterModelsCacheKey;
        _showingFilterViewIndex = NSNotFound;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_applicationWillResignActiveNotification:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];

    }

    return self;
}

- (void)dealloc
{
    //移除通知并尝试缓存筛选值
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self _tryCacheFilterValues];
}

#pragma maek -

- (void)_applicationWillResignActiveNotification:(NSNotification *)notification {
    [self _tryCacheFilterValues];
}

- (void)_tryCacheFilterValues
{
    if (_needCacheFilterValues) {
        _needCacheFilterValues = NO;

        //缓存数据
        if (self.filterModelsCacheKey.length) {
            [[CLDocumentCachePool sharePool] cacheKeyedArchiverDataWithRootObject:self.filterModels
                                                                           forKey:self.filterModelsCacheKey
                                                                            async:YES];
        }
    }
}


#pragma maek -

- (NSArray *)filterInfos
{
    if (!_filterInfos) {
        _filterInfos = [NSArray arrayWithContentsOfFile:PlistResourceFilePath(_filterInfosFileName)];
    }

    return _filterInfos;
}

- (NSMutableDictionary *)filterModels
{
    if (!_filterModels) {

//        //读取缓存数据
//        if (self.filterModelsCacheKey.length) {
//             _filterModels = [[CLDocumentCachePool sharePool] cacheKeyedUnArchiverRootObjectForKey:self.filterModelsCacheKey expectType:[NSMutableDictionary class]];
//        }

        //生成默认的筛选值
        if (!_filterModels) {

            NSMutableDictionary * models = [NSMutableDictionary dictionaryWithCapacity:self.filterInfos.count];
            for (NSDictionary * filterInfo in self.filterInfos) {

                RH_BasicFilterModel * courseFilterModel = [[filterInfo filterViewClass] defaultFilterModel];
                if (courseFilterModel) {
                    [models setObject:courseFilterModel forKey:[filterInfo filterValueKey]];
                }
            }

            _filterModels = models;
        }
    }

    return _filterModels;
}

- (NSDictionary *)filterValues
{
    NSMutableDictionary * filterValues = [NSMutableDictionary dictionaryWithCapacity:self.filterModels.count];
    for (NSString * key in self.filterModels.allKeys) {
        id filterValue = [self.filterModels[key] filterValue];
        if (filterValue != nil) {
            [filterValues setValue:filterValue forKey:key];
        }
    }

    return filterValues;
}

#pragma mark -

- (void)setShowingFilterViewIndex:(NSUInteger)showingFilterViewIndex
{
    if (showingFilterViewIndex != _showingFilterViewIndex) {

        if (showingFilterViewIndex == NSNotFound) {
            [self _completedShowFilterView];
        }else {

            //获取筛选信息
            NSDictionary * filterInfo = self.filterInfos[showingFilterViewIndex];

            //初始化筛选视图并设置筛选值
            RH_BasicFilterView * filterView = [[filterInfo filterViewClass] createInstance];
            [filterView setFilterModel:self.filterModels[[filterInfo filterValueKey]]];

            //显示动画的方向
            filterView.showAnimtedMoveDirection = (_showingFilterViewIndex == NSNotFound || showingFilterViewIndex > _showingFilterViewIndex) ? CLMoveAnimtedDirectionLeft : CLMoveAnimtedDirectionRight;
            filterView.delegate = self;

            //通知代理
            id<RH_ShowFilterViewManagerDelegate> delegate = self.delegate;
            ifRespondsSelector(delegate, @selector(filterViewManager:willShowFilterView:)) {
                [delegate filterViewManager:self willShowFilterView:filterView];
            }

            _showingFilterViewIndex = showingFilterViewIndex;

            //显示
            [self.filterContainerView showWithView:filterView animated:!self.filterContainerView.isShowing];
        }
    }
}

- (void)hideFilterView:(BOOL)animated
{
    [_filterContainerView hideWithAnimated:animated];
    _showingFilterViewIndex = NSNotFound;
}

#pragma mark -

- (CLDeclineMenuContainerView *)filterContainerView
{
    if (!_filterContainerView) {
        _filterContainerView = [[CLDeclineMenuContainerView alloc] init];
        _filterContainerView.delegate = self;
    }

    return _filterContainerView;
}

- (void)declineMenuContainerViewDidHidden:(CLDeclineMenuContainerView *)declineMenuContainerView
{
    if (_filterContainerView == declineMenuContainerView) {
        [self _completedShowFilterView];
    }
}

- (void)filterViewDidChangeFilter:(RH_BasicFilterView *)filterView
{
    if (_filterContainerView.declineMenuContentView == filterView) {
        [self _completedShowFilterView];
    }
}

- (void)_completedShowFilterView
{
    if (self.showingFilterViewIndex == NSNotFound) {
        return;
    }

    //获取当前显示的筛选视图
    RH_BasicFilterView * filterView = (id)self.filterContainerView.declineMenuContentView;
    filterView.delegate = nil;

    NSString * key = [self.filterInfos[self.showingFilterViewIndex] filterValueKey];

    //判断是否需要更新了数据
    id originValue = [self.filterModels[key] filterValue];
    id newValue = [filterView.filterModel filterValue];
    BOOL didUpdateValue = originValue != newValue && ![originValue isEqual:newValue];

    //更新值
    [self.filterModels setObject:filterView.filterModel forKey:key];

    //通知代理
    id<RH_ShowFilterViewManagerDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(filterViewManager:willHideFilterView:)) {
        [delegate filterViewManager:self willHideFilterView:filterView];
    }

    _showingFilterViewIndex = NSNotFound;

    //隐藏并更新值
    [self.filterContainerView hideWithAnimated:YES];

    //通知代理
    if (didUpdateValue) {
        _needCacheFilterValues = YES;
        ifRespondsSelector(delegate, @selector(filterViewManagerDidChangeFilterInfos:)) {
            [delegate filterViewManagerDidChangeFilterInfos:self];
        }
    }
}

@end

//----------------------------------------------------------

@implementation NSDictionary (RH_ShowFilterViewManager)

- (NSString *)filterValueKey {
    return [self stringValueForKey:@"key"];
}

- (Class)filterViewClass
{
    Class filterViewClass = NSClassFromString([self stringValueForKey:@"filterViewClass"]);
    return [filterViewClass isSubclassOfClass:[RH_BasicFilterView class]] ? filterViewClass : nil;
}

@end


@implementation CLSectionControl (RH_ShowFilterViewManager)

+ (instancetype)createFilterSegmentedControlWithFilterViewManager:(RH_ShowFilterViewManager *)filterViewManager
{
    UIImage * downArrowImage = ImageWithName(@"ic_down_arrow");
    UIImage * upArrowImage = [UIImage imageWithCGImage:downArrowImage.CGImage scale:downArrowImage.scale orientation:UIImageOrientationDown];

    NSMutableArray * titles = [NSMutableArray arrayWithCapacity:filterViewManager.filterInfos.count];
    NSMutableArray * images = [NSMutableArray arrayWithCapacity:filterViewManager.filterInfos.count];
    NSMutableArray * selectedImages = [NSMutableArray arrayWithCapacity:filterViewManager.filterInfos.count];

    for (NSDictionary * courseFilterInfo in filterViewManager.filterInfos) {
        RH_BasicFilterModel * courseFilterModel = filterViewManager.filterModels[[courseFilterInfo filterValueKey]];
        [titles addObject:[courseFilterModel showingTitle] ?: @""];
        [images addObject:downArrowImage];
        [selectedImages addObject:upArrowImage];
    }

    CLSectionControl *  filterSegmentedControl = [CLSectionControl createLightStyleSegmentedControlWithTitles:titles images:images selectedImages:selectedImages showSelectedIndicatorLine:NO];
    filterSegmentedControl.sectionLayout = CLSectionControlSectionLayoutImageRight;
    filterSegmentedControl.allowDeselected = YES;

    return filterSegmentedControl;
}

@end
