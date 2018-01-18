//
//  RH_SiteMessageMineNoticeController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMessageMineNoticeController.h"
#import "RH_MPSiteMessageHeaderView.h"
#import "RH_SiteMineNoticeCell.h"
#import "RH_SiteMyMessageModel.h"
#import "RH_API.h"
@interface RH_SiteMessageMineNoticeController ()<MPSiteMessageHeaderViewDelegate>
@property(nonatomic,strong)RH_MPSiteMessageHeaderView *headerView;
@property(nonatomic,strong)NSMutableArray *siteModelArray;
@property(nonatomic,strong)NSMutableArray *deleteModelArray;
@end

@implementation RH_SiteMessageMineNoticeController
@synthesize headerView = _headerView;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.siteModelArray = [NSMutableArray array];
    self.deleteModelArray = [NSMutableArray array];
    [self setupUI];
    
}

#pragma mark tableView的上部分的选择模块
-(RH_MPSiteMessageHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPSiteMessageHeaderView createInstance];
        _headerView.frame = CGRectMake(0, 100, self.view.frameWidth, 40);
        _headerView.delegate=self;
    }
    return _headerView;
}
-(void)setupUI{
    
    self.contentView.frame = CGRectMake(0,0, self.view.frameWidth, self.contentView.frameHeigh);
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.frame = CGRectMake(0,0, self.view.frameWidth, self.contentView.frameHeigh);
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    //    self.contentTableView.editing = YES;
    [self.contentTableView registerCellWithClass:[RH_SiteMineNoticeCell class]] ;
    self.contentTableView.contentInset = UIEdgeInsetsMake(0, 0,0, 0);
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
    [self setupPageLoadManager] ;
}
#pragma mark-
#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_SiteMineNoticeCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        __weak RH_SiteMineNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_SiteMineNoticeCell defaultReuseIdentifier]] ;
        __weak RH_SiteMessageMineNoticeController *weakSelf = self;
        noticeCell.block = ^(){
            RH_SiteMyMessageModel *siteModel =self.siteModelArray[indexPath.item];
            if ([siteModel.number isEqual:@0]) {
                siteModel.number = @1;
                [self.deleteModelArray addObject:siteModel];
            }
            else if ([siteModel.number isEqual:@1])
            {
                siteModel.number = @0;
                [self.deleteModelArray removeObject:siteModel];
            }
            
            [weakSelf.contentTableView reloadData];
        };
        [noticeCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return noticeCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}
#pragma mark 全选，删除,标记已读代理
-(void)siteMessageHeaderViewAllChoseBtn:(BOOL)choseMark
{
    for (int i =0; i<self.siteModelArray.count; i++) {
        RH_SiteMyMessageModel *siteModel = self.siteModelArray[i];
        if (choseMark==YES) {
            siteModel.number = @1;
            [self.deleteModelArray addObject:siteModel];
        }
        else if (choseMark==NO){
            siteModel.number=@0;
            [self.deleteModelArray removeAllObjects];
        }
    }
    [self.contentTableView reloadData];
}
-(void)siteMessageHeaderViewDeleteCell:(RH_MPSiteMessageHeaderView *)view
{
    NSString *str = @"";
    for (RH_SiteMyMessageModel *siteModel in self.deleteModelArray) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d,",siteModel.mId]];
    }
    if([str length] > 0){
        str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
    }
    [self.deleteModelArray removeAllObjects];
    [self.serviceRequest startV3LoadMyMessageDeleteWithIds:str];
    [self startUpdateData] ;
}
-(void)siteMessageHeaderViewReadBtn:(RH_MPSiteMessageHeaderView *)view
{
    NSString *str = @"";
    for (RH_SiteMyMessageModel *siteModel in self.deleteModelArray) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d,",siteModel.mId]];
    }
    if([str length] > 0){
        str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
    }
    [self.deleteModelArray removeAllObjects];
    [self.serviceRequest startV3LoadMyMessageReadYesWithIds:str];
    [self startUpdateData] ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark 数据请求
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (CLPageLoadManagerForTableAndCollectionView *)createPageLoadManager
{
    return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentTableView
                                                          pageLoadControllerClass:nil
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1] ;
}

-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:ImageWithName(@"empty_searchRec_image")
                                             title:nil
                                        detailText:@"您暂无相关数据记录"] ;
    return YES ;
    
}
#pragma mark-
-(void)netStatusChangedHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}
#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3SiteMessageMyMessageWithpageNumber:page pageSize:pageSize];
}
-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}


#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3SiteMessageMyMessage){
        //刷新后将model数组清空
        [self.siteModelArray removeAllObjects];
        NSArray *array = ConvertToClassPointer(NSArray, data);
        if (array.count>0) {
            for (int i = 0; i<array.count; i++) {
                RH_SiteMyMessageModel *myModel = ConvertToClassPointer(RH_SiteMyMessageModel, array[i]);
                myModel.number = @0;
                [self loadDataSuccessWithDatas:array totalCount:i];
                [self.siteModelArray addObject:myModel];
            }
            [self.contentTableView reloadData];
        }
        else
        {
            [self loadDataSuccessWithDatas:nil totalCount:0];
            [self.contentTableView reloadData];
        }
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3SiteMessageMyMessage){
        [self loadDataFailWithError:error] ;
    }
}

@end
