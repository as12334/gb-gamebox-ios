//
//  RH_BasicPageLoadViewController.h
//  TaskTracking
//
//  Created by jinguihua on 2017/3/16.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicViewController.h"
#import "coreLib.h"
//----------------------------------------------------------

//数据筛选类型
typedef NS_ENUM(NSInteger, CL_DatasFilterType) {
    CL_DatasFilterTypeNone,      //无筛选
    CL_DatasFilterTypeEqual,     //通过是否相等筛选，如果存在相等数据则筛选掉，保证数据唯一性
    CL_DatasFilterTypeCustom     //自定义筛选方式
};

//----------------------------------------------------------

@interface RH_BasicPageLoadViewController : RH_BasicViewController <CLPageLoadManagerForTableAndCollectionViewDataSource>

#pragma mark - 管理器初始化
//-------------------------------------------------

//默认一页数据的大小
- (NSUInteger)defaultPageSize;

//初始化分页加载管理器
- (void)setupPageLoadManager;

//创建分页加载管理器，子类重载该方法创建
- (CLPageLoadManagerForTableAndCollectionView *)createPageLoadManager;
//配置加载管理器，子类重载进行特殊配置
- (void)configPageLoadManager:(CLPageLoadManagerForTableAndCollectionView *)pageLoadManager;

//管理器的引用初始化后才有效
@property(nonatomic,strong,readonly) CLPageLoadManagerForTableAndCollectionView * pageLoadManager;

#pragma mark - 数据初始化
//-------------------------------------------------

//是否需要更新数据当setup用初始化数据时，默认为YES
@property(nonatomic) BOOL needUpdateDataWhenSetup;
//获取初始化的数据，子类实现
- (NSArray *)getInitDatas;


#pragma mark - 标签切换
//-------------------------------------------------

//当前segmented的index
@property(nonatomic) NSUInteger currentSegmentedIndex;


- (BOOL)willChangeSegmentedIndexToIndex:(NSUInteger)toIndex;
- (void)didChangeSegmentedIndexFromIndex:(NSUInteger)fromIndex;

//是否需要更新视图当改变了segmented的index
- (BOOL)needUpdateDataWhenChangeSegmentedIndexFromIndex:(NSUInteger)fromIndex;
//是否需要动画当改变了segmented的index
- (BOOL)needAnimationWhenDidChangeSegmentedIndexFromIndex:(NSUInteger)fromIndex;

//改变index初始化的offset
- (CGPoint)contentOffsetWhenDidChangeSegmentedIndexToIndex:(NSUInteger)toIndex;
//是否需要改变offset，默认为YES
- (BOOL)needChangeContentOffsetWhenDidChangeSegmentedIndexFromIndex:(NSUInteger)fromIndex;

#pragma mark - 数据更新
//-------------------------------------------------

//更新初始化数据
- (void)updateWithInitDatas:(NSArray *)initData;
//开始更新数据
- (void)startUpdateData;
- (void)startUpdateData_e:(BOOL)scrollToTop;


#pragma mark - 加载数据操作和回调方法
//-------------------------------------------------

//开始加载数据
- (void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize;
//取消加载
- (void)cancelLoadDataHandle;

/**
 * 数据加载成功后的回调
 * 完成加载数据后可能需要在后台进行数据的筛选，completedBlock会在数据筛选完毕后进行回调
 */
- (void)loadDataSuccessWithDatas:(NSArray *)datas totalCount:(NSUInteger)totalCount;
- (void)loadDataSuccessWithDatas:(NSArray *)datas
                      totalCount:(NSUInteger)totalCount
                  completedBlock:(void(^)(NSArray * filtedDatas))completedBlock;
//加载数据错误
- (void)loadDataFailWithError:(NSError *)error;

//是否需要动画当成功加载数据，默认返回YES
- (BOOL)needAnimationWhenLoadDataSuccessWithDatas:(NSArray *)datas totalCount:(NSUInteger)totalCount;


#pragma mark - 加载过程的通知，子类重载进行特定操作
//-------------------------------------------------

//将要开始加载数据
- (BOOL)willStartLoadData:(BOOL)isUpdateData;
//开始加载数据失败（网络原因）
- (void)didStartLoadDataFail:(BOOL)isUpdateData;
//开始加载数据
- (void)didStartLoadData:(BOOL)isUpdateData;
//取消加载数据
- (void)didCancleLoadData;
//结束加载数据
- (void)didEndLoadData:(BOOL)isUpdateData success:(BOOL)success;


#pragma mark - 加载指示视图
//-------------------------------------------------

//加载指示器
- (RH_LoadingIndicateView *)loadingIndicateView;

//显示加载错误指示，返回NO则显示默认错误指示视图
- (BOOL)showLoadDataErrorIndicaterForError:(NSError *)error;

//无内容指示title
- (NSString *)nothingIndicateTitle;
//显示无数据指示视图，返回NO则显示默认指示视图
- (BOOL)showNotingIndicaterView;

//更新视图当数据数目改变
- (void)setNeedUpdateViewWithDataCountChange;


#pragma mark - 数据筛选
//-------------------------------------------------

//数据筛选方式
@property(nonatomic) CL_DatasFilterType datasFilterType;
//自定义筛选数据，当datasFilterType为CL_DatasFilterTypeCustom时会调用该方法进行数据筛选，默认不筛选
- (NSArray *)customFilterDatas:(NSArray *)datas baseCurrentDatas:(NSArray *)currentDatas;

//需要筛选的数据类别，返回nil则都需要筛选
- (Class)needFilterDataClass;


#pragma mark - 其他
//-------------------------------------------------

//是否是子视图控制器
- (BOOL)isSubViewController;
-(void)backBarButtonItemHandle ;
//保存图片
- (void)saveImageToPhotos:(UIImage*)savedImage ;
@end

