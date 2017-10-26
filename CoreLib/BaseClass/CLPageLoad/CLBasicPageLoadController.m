//
//  CLBasicPageLoadController.m
//  TaskTracking
//
//  Created by jinguihua on 2017/3/16.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLBasicPageLoadController.h"
#import "MacroDef.h"

@implementation CLBasicPageLoadController

@synthesize pageSize = _pageSize;
@synthesize startSection = _startSection;
@synthesize startRow = _startRow;
@synthesize nextPage = _nextPage;
@synthesize totalDataCount = _totalDataCount;
@synthesize dataLoadType = _dataLoadType;
@synthesize delegate = _delegate;

- (id)init {
    return [self initWithPageSize:10.f startSection:0 startRow:0];
}

- (id)initWithPageSize:(NSUInteger)pageSize {
    return [self initWithPageSize:pageSize startSection:0 startRow:0];
}

- (id)initWithPageSize:(NSUInteger)pageSize startSection:(NSUInteger)startSection startRow:(NSUInteger)startRow
{
    self = [super init];
    if (self) {
        _pageSize = pageSize ?: 10.f;
        _startSection = startSection;
        _startRow = startRow;
    }

    return self;
}


#pragma mark -

- (void)startLoadDataForUpdate
{
    _dataLoadType = CLDataLoadTypeUpdate;
    [self _sendNeedLoadDataMsgWithPage:0];
}

- (void)startLoadData
{
    _dataLoadType = CLDataLoadTypeLoad;
    [self _sendNeedLoadDataMsgWithPage:self.nextPage];
}

- (void)_sendNeedLoadDataMsgWithPage:(NSUInteger)page
{
    id<CLPageLoadControllerDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(pageLoadController:wantToLoadDataWithPage:andPageSize:)){
        [delegate pageLoadController:self wantToLoadDataWithPage:page andPageSize:self.pageSize];
    }
}

#pragma mark -

- (void)updateWithInitDatas:(NSArray *)datas totalDataCount:(NSUInteger)totalDataCount
{
    if ([self updateDataStorageWithDatas:datas]) {
        _totalDataCount = totalDataCount;
        _nextPage = ceilf(datas.count / self.pageSize);

        id<CLPageLoadControllerDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(pageLoadControllerWantToReloadDataForView:)){
            [delegate pageLoadControllerWantToReloadDataForView:self];
        }

        [self _sendCompletedLoadStatusDidChangeMsg];
    }
}

- (void)endLoadDataWithDatas:(NSArray *)datas totalDataCount:(NSUInteger)totalDataCount
{
    BOOL bRet = NO;

    //筛选数据
    if (self.dataLoadType != CLDataLoadTypeNone) {

        //筛选数据
        id<CLPageLoadControllerDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(pageLoadController:willAddDatas:withCurrentDatas:)){

            //筛选数据
            NSArray * resultDatas = [delegate pageLoadController:self willAddDatas:datas withCurrentDatas:self.dataLoadType == CLDataLoadTypeUpdate ? nil : [self allDatas]];
            totalDataCount += MAX(0.f, resultDatas.count - datas.count);
            datas = resultDatas;
        }

        if (self.dataLoadType == CLDataLoadTypeUpdate) { //更新数据

            if ([self updateDataStorageWithDatas:datas]) {

                _totalDataCount = self.currentDataCount ? totalDataCount : 0;
                _nextPage = 1;

                id<CLPageLoadControllerDelegate> delegate = self.delegate;
                ifRespondsSelector(delegate, @selector(pageLoadControllerWantToReloadDataForView:)){
                    [delegate pageLoadControllerWantToReloadDataForView:self];
                }

                bRet = YES;
            }

        }else if(self.dataLoadType == CLDataLoadTypeLoad) { //加载数据

            _totalDataCount = datas.count ? totalDataCount : self.currentDataCount;
            _nextPage ++;

            NSUInteger currentDataCount = self.currentDataCount;
            id indexData = [self addDatasToDataStorage:datas];
            if ([indexData isKindOfClass:[NSArray class]]) {

                NSArray * indexPaths = (NSArray *)indexData;
                if (indexPaths.count) {

                    id<CLPageLoadControllerDelegate> delegate = self.delegate;
                    if (currentDataCount) {
                        ifRespondsSelector(delegate, @selector(pageLoadController:wantToAddDataForViewAtIndexPaths:)){
                            [delegate pageLoadController:self wantToAddDataForViewAtIndexPaths:indexPaths];
                        }
                    }else {
                        ifRespondsSelector(delegate, @selector(pageLoadControllerWantToReloadDataForView:)){
                            [delegate pageLoadControllerWantToReloadDataForView:self];
                        }
                    }
                }

                bRet = YES;

            }else if ([indexData isKindOfClass:[NSIndexSet class]]) {

                NSIndexSet * indexSet = (NSIndexSet *)indexData;
                if (indexSet.count) {

                    id<CLPageLoadControllerDelegate> delegate = self.delegate;
                    if (currentDataCount) {
                        ifRespondsSelector(delegate, @selector(pageLoadController:wantToAddDataForViewAtSections:)){
                            [delegate pageLoadController:self wantToAddDataForViewAtSections:indexSet];
                        }
                    }else {
                        ifRespondsSelector(delegate, @selector(pageLoadControllerWantToReloadDataForView:)){
                            [delegate pageLoadControllerWantToReloadDataForView:self];
                        }
                    }
                }

                bRet = YES;
            }
        }
    }

#if DEBUG
    else{
        NSLog(@"需先调用startLoadDataForUpdate或startLoadData后才能调用endLoadDataWithDatas:totalDataCount:");
    }
#endif

    if (_dataLoadType != CLDataLoadTypeNone && bRet) {
        [self _sendCompletedLoadStatusDidChangeMsg];
    }

    _dataLoadType = CLDataLoadTypeNone;
}

- (void)loadDataFail {
    _dataLoadType = CLDataLoadTypeNone;
}

- (void)_sendCompletedLoadStatusDidChangeMsg
{
    id<CLPageLoadControllerDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(pageLoadController:completedLoadStatusDidChange:)){
        [delegate pageLoadController:self completedLoadStatusDidChange:self.hadCompletedLoad];
    }
}

#pragma mark -

- (NSUInteger)currentDataCount {
    return 0;
}

- (BOOL)hadCompletedLoad {
    return self.currentDataCount >= self.totalDataCount;
}

- (NSUInteger)sectionCount {
    return 0;
}

- (NSUInteger)dataCountAtSection:(NSUInteger)section {
    return 0;
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (id)dataAtIndex:(NSUInteger)index {
    return nil;
}

- (NSIndexPath *)indexPathForDataAtIndex:(NSUInteger)index {
    return nil;
}

- (NSUInteger)indexForDataAtIndexPath:(NSIndexPath *)indexPath {
    return NSNotFound;
}

- (BOOL)containDataAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSArray *)allDatas {
    return nil;
}

- (NSIndexPath *)indexPathForData:(id)data {
    return nil;
}

#pragma mark -

//子类实现
- (BOOL)updateDataStorageWithDatas:(NSArray *)datas {
    return NO;
}

- (NSArray *)addDatasToDataStorage:(NSArray *)datas {
    return nil;
}

- (NSArray *)removeDatasFromDataStorageWithIndexPath:(NSArray *)indexPaths {
    return nil;
}

- (NSIndexSet *)removeDatasFromDataStorageWithSections:(NSIndexSet *)sections {
    return nil;
}

- (NSArray *)insertDatas:(NSArray *)datas toDataStorageWithIndexPath:(NSArray *)indexPaths {
    return nil;
}

- (NSIndexSet *)insertDatas:(NSArray *)datas toDataStorageWithSections:(NSIndexSet *)sections {
    return nil;
}

- (NSArray *)replayDatasInDataStorageWithIndexPath:(NSArray *)indexPaths withDatas:(NSArray *)datas {
    return nil;
}

- (NSIndexSet *)replayDatasInDataStorageWithSections:(NSIndexSet *)sections withDatas:(NSArray *)datas {
    return nil;
}

#pragma mark -

- (void)removeDatas:(NSArray *)datas {
    //do nothing
}

- (void)removeDataAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) {
        return;
    }

    NSArray * indexPathsDidRemoved = [self removeDatasFromDataStorageWithIndexPath:indexPaths];
    if (indexPathsDidRemoved.count) {

        id<CLPageLoadControllerDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(pageLoadController:wantToRemoveDataForViewAtIndexPaths:)){
            [delegate pageLoadController:self wantToRemoveDataForViewAtIndexPaths:indexPathsDidRemoved];
        }

        _totalDataCount -= indexPathsDidRemoved.count;
        [self _sendCompletedLoadStatusDidChangeMsg];
    }
}

- (void)removeDataAtSections:(NSIndexSet *)sections
{
    if (sections.count == 0) {
        return;
    }

    NSIndexSet * sectionsDidRemoved = [self removeDatasFromDataStorageWithSections:sections];
    if (sectionsDidRemoved.count) {

        id<CLPageLoadControllerDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(pageLoadController:wantToRemoveDataForViewAtSections:)){
            [delegate pageLoadController:self wantToRemoveDataForViewAtSections:sectionsDidRemoved];
        }

        _totalDataCount -= sectionsDidRemoved.count;
        [self _sendCompletedLoadStatusDidChangeMsg];
    }
}

//插入数据
- (void)insertDatas:(NSArray *)datas atIndexPaths:(NSArray *)indexPaths
{
    if (datas.count != indexPaths.count) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"插入的数据数目应该等于其索引的数目"
                                     userInfo:nil];
    }

    NSArray * indexPathsDidInsert = [self insertDatas:datas toDataStorageWithIndexPath:indexPaths];
    if (indexPathsDidInsert.count) {

        id<CLPageLoadControllerDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(pageLoadController:wantToAddDataForViewAtIndexPaths:)){
            [delegate pageLoadController:self wantToAddDataForViewAtIndexPaths:indexPathsDidInsert];
        }

        _totalDataCount += indexPathsDidInsert.count;
        [self _sendCompletedLoadStatusDidChangeMsg];
    }
}

- (void)insertDatas:(NSArray *)datas atSections:(NSIndexSet *)sections
{
    if (datas.count != sections.count) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"插入的数据数目应该等于其索引的数目"
                                     userInfo:nil];
    }

    NSIndexSet * sectionsDidInsert = [self insertDatas:datas toDataStorageWithSections:sections];
    if (sectionsDidInsert.count) {

        id<CLPageLoadControllerDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(pageLoadController:wantToAddDataForViewAtSections:)){
            [delegate pageLoadController:self wantToAddDataForViewAtSections:sectionsDidInsert];
        }

        _totalDataCount += sectionsDidInsert.count;
        [self _sendCompletedLoadStatusDidChangeMsg];
    }
}


//替换数据
- (void)replaceDatas:(NSArray *)datas atIndexPaths:(NSArray *)indexPaths
{
    if (datas.count != indexPaths.count) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"替换的数据数目应该等于其索引的数目"
                                     userInfo:nil];
    }

    NSArray * indexPathsDidReplace = [self replayDatasInDataStorageWithIndexPath:indexPaths withDatas:datas];
    if (indexPathsDidReplace.count) {
        id<CLPageLoadControllerDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(pageLoadController:wantToReloadDataForViewAtIndexPaths:)){
            [delegate pageLoadController:self wantToReloadDataForViewAtIndexPaths:indexPathsDidReplace];
        }
    }
}


//替换数据
- (void)replaceDatas:(NSArray *)datas atSections:(NSIndexSet *)sections
{
    if (datas.count != sections.count) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"替换的数据数目应该等于其索引的数目"
                                     userInfo:nil];
    }

    NSIndexSet * sectionsDidReplace = [self replayDatasInDataStorageWithSections:sections withDatas:datas];
    if (sectionsDidReplace.count) {
        id<CLPageLoadControllerDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(pageLoadController:wantToRemoveDataForViewAtSections:)){
            [delegate pageLoadController:self wantToReloadDataForViewAtSections:sectionsDidReplace];
        }
    }
}

@end

