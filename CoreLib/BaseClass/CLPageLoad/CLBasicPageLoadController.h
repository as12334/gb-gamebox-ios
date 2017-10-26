//
//  CLBasicPageLoadController.h
//  TaskTracking
//
//  Created by jinguihua on 2017/3/16.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLPageLoadControllerProtocol.h"

@interface CLBasicPageLoadController : NSObject <CLPageLoadControllerProtocol>

- (id)initWithPageSize:(NSUInteger)pageSize
          startSection:(NSUInteger)startSection
              startRow:(NSUInteger)startRow NS_DESIGNATED_INITIALIZER;

//子类实现
- (BOOL)updateDataStorageWithDatas:(NSArray *)datas;
- (id)addDatasToDataStorage:(NSArray *)datas;

- (NSArray *)removeDatasFromDataStorageWithIndexPath:(NSArray *)indexPaths;
- (NSIndexSet *)removeDatasFromDataStorageWithSections:(NSIndexSet *)sections;

- (NSArray *)insertDatas:(NSArray *)datas toDataStorageWithIndexPath:(NSArray *)indexPaths;
- (NSIndexSet *)insertDatas:(NSArray *)datas toDataStorageWithSections:(NSIndexSet *)sections;

- (NSArray *)replayDatasInDataStorageWithIndexPath:(NSArray *)indexPaths withDatas:(NSArray *)datas;
- (NSIndexSet *)replayDatasInDataStorageWithSections:(NSIndexSet *)sections withDatas:(NSArray *)datas;

@end
