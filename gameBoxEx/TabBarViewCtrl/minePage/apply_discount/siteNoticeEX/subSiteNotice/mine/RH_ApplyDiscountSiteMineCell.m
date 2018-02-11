//
//  RH_ApplyDiscountSiteMineCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountSiteMineCell.h"
#import "RH_MPSiteMessageHeaderView.h"
#import "RH_SiteMineNoticeCell.h"
#import "RH_SiteMyMessageModel.h"
#import "RH_API.h"
#import "RH_LoadingIndicateTableViewCell.h"
#import "RH_SiteMineNoticeDetailController.h"
@interface RH_ApplyDiscountSiteMineCell ()<MPSiteMessageHeaderViewDelegate>
@property(nonatomic,strong)RH_MPSiteMessageHeaderView *headerView;
@property(nonatomic,strong)NSMutableArray *siteModelArray;
@property(nonatomic,strong)NSMutableArray *deleteModelArray;
@property(nonatomic,strong,readonly) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
@end

@implementation RH_ApplyDiscountSiteMineCell
@synthesize headerView = _headerView;
@synthesize loadingIndicateTableViewCell = _loadingIndicateTableViewCell ;

#pragma mark tableView的上部分的选择模块
-(RH_MPSiteMessageHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPSiteMessageHeaderView createInstance];
        _headerView.frame = CGRectMake(0, 100, self.frameWidth, 40);
        _headerView.delegate=self;
    }
    return _headerView;
}

-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    if (self.contentTableView == nil) {
        self.siteModelArray = [NSMutableArray array];
        self.deleteModelArray = [NSMutableArray array];
        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.sectionFooterHeight = 10.0f;
        self.contentTableView.sectionHeaderHeight = 10.0f ;
        self.contentTableView.backgroundColor = [UIColor clearColor];
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        [self.contentTableView registerCellWithClass:[RH_SiteMineNoticeCell class]] ;
        self.contentScrollView = self.contentTableView;
        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
        [self setupPageLoadManagerWithdatasContext:context1] ;
        //通知
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedMineMessage) name:@"noti1" object:nil];
    }else {
        [self updateWithContext:context];
    }
}
- (void)changedMineMessage{
    [self startUpdateData];
}
#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_SiteMineNoticeCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        CGFloat height = tableView.boundHeigh -  tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        __weak RH_SiteMineNoticeCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:[RH_SiteMineNoticeCell defaultReuseIdentifier]] ;
        __weak RH_ApplyDiscountSiteMineCell *weakSelf = self;
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
    return 40.f;
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
    if (self.deleteModelArray.count>0) {
        NSString *str = @"";
        for (RH_SiteMyMessageModel *siteModel in self.deleteModelArray) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",siteModel.mId]];
        }
        if([str length] > 0){
            str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
        }
        [self.deleteModelArray removeAllObjects];
        [self.serviceRequest startV3LoadMyMessageDeleteWithIds:str];
    }else
    {
        showAlertView(@"提示", @"请选择你要删除的消息");
    }
    
}
-(void)siteMessageHeaderViewReadBtn:(RH_MPSiteMessageHeaderView *)view
{
    if (self.deleteModelArray.count > 0) {
        NSString *str = @"";
        for (RH_SiteMyMessageModel *siteModel in self.deleteModelArray) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)siteModel.mId]];
        }
        if([str length] > 0){
            str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
        }
        [self.deleteModelArray removeAllObjects];
        [self.serviceRequest startV3LoadMyMessageReadYesWithIds:str];
    }else
    {
       showAlertView(@"提示", @"请标记你要删除的消息");
    }
   

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_SiteMineNoticeDetailController *detailVC= [RH_SiteMineNoticeDetailController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]];
        [self showViewController:detailVC];
        [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    }
}

#pragma mark -
-(RH_LoadingIndicateTableViewCell*)loadingIndicateTableViewCell
{
    if (!_loadingIndicateTableViewCell){
        _loadingIndicateTableViewCell = [[RH_LoadingIndicateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _loadingIndicateTableViewCell.backgroundColor = [UIColor whiteColor];
        _loadingIndicateTableViewCell.loadingIndicateView.delegate = self;
    }
    return _loadingIndicateTableViewCell ;
}

-(RH_LoadingIndicateView*)loadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}

#pragma mark 数据请求
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
                                        detailText:@"您暂无我的消息记录"] ;
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
    if (page==0) {
        //刷新后将model数组清空
        [self.siteModelArray removeAllObjects];
    }
    [self.serviceRequest startV3SiteMessageMyMessageWithpageNumber:page+1 pageSize:pageSize];
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
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data)  ;
        if ([dictTmp arrayValueForKey:@"dataList"].count>0) {
            for (int i = 0; i<[dictTmp arrayValueForKey:@"dataList"].count; i++) {
                RH_SiteMyMessageModel *myModel = ConvertToClassPointer(RH_SiteMyMessageModel, [dictTmp arrayValueForKey:@"dataList"][i]);
                myModel.number = @0;
                [self.siteModelArray addObject:myModel];
            }
            NSUInteger totalNumber = [dictTmp[@"pageTotal"] integerValue] ;
            
            [self loadDataSuccessWithDatas:[dictTmp arrayValueForKey:@"dataList"]
                                totalCount:totalNumber
                            completedBlock:nil];
            self.headerView.allChoseBtn.userInteractionEnabled = YES;
        }else
        {
            self.headerView.allChoseBtn.userInteractionEnabled = NO;
            [self loadDataSuccessWithDatas:nil totalCount:0 completedBlock:nil];
        }
    }
    else if (type==ServiceRequestTypeV3MyMessageMyMessageDelete) {
        [self startUpdateData] ;
        self.headerView.statusMark = YES;
    }
    else if (type==ServiceRequestTypeV3MyMessageMyMessageReadYes) {
        [self startUpdateData];
        self.headerView.statusMark = YES;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3SiteMessageMyMessage){
         showErrorMessage(nil, error, nil) ;
        [self loadDataFailWithError:error] ;
    }
    else if (type==ServiceRequestTypeV3MyMessageMyMessageDelete) {
        showErrorMessage(nil, error, nil) ;
        [self loadDataFailWithError:error] ;
    }
    else if (type==ServiceRequestTypeV3MyMessageMyMessageReadYes) {
        [self loadDataFailWithError:error] ;
    }
}

@end
