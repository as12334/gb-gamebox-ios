//
//  RH_ApplyDiscountSiteSystemCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountSiteSystemCell.h"
#import "RH_MPSiteMessageHeaderView.h"
#import "RH_MPSiteSystemNoticeCell.h"
#import "RH_SiteMessageModel.h"
#import "RH_API.h"
#import "RH_LoadingIndicateTableViewCell.h"
#import "RH_SiteSystemDetailController.h"
#import "RH_SiteMsgUnReadCountModel.h"


@interface RH_ApplyDiscountSiteSystemCell ()<MPSiteMessageHeaderViewDelegate,SiteSystemNoticeCellDelegate>
@property(nonatomic,strong)RH_MPSiteMessageHeaderView *headerView;
@property(nonatomic,strong)NSMutableArray *siteModelArray;
@property(nonatomic,strong)NSMutableArray *deleteModelArray;
@property(nonatomic,strong,readonly) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
@property(nonatomic,strong)RH_SiteMsgUnReadCountModel *unReadModel ;
@end

@implementation RH_ApplyDiscountSiteSystemCell
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
        [self.contentView addSubview:self.headerView] ;
        self.headerView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(40.0f);
        self.siteModelArray = [NSMutableArray array];
        self.deleteModelArray = [NSMutableArray array];
        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.backgroundColor = [UIColor clearColor];
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentTableView registerCellWithClass:[RH_MPSiteSystemNoticeCell class]] ;
        self.contentScrollView = self.contentTableView;
        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
        [self setupPageLoadManagerWithdatasContext:context1] ;
        self.contentTableView.whc_TopSpaceEqualViewOffset(self.headerView, 40).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0) ;
    }else {
        [self updateWithContext:context];
    }
}

#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_MPSiteSystemNoticeCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        CGFloat height = tableView.boundHeigh -  tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

#pragma mark - SiteSystemNoticeCellDelegate
-(void)siteSystemNoticeCellEditBtn:(RH_MPSiteSystemNoticeCell *)systemNoticeCell cellModel:(RH_SiteMessageModel *)cellModel
{
    if (cellModel.selectedFlag) {
        [self.deleteModelArray addObject:cellModel];
    }else{
        [self.deleteModelArray removeObject:cellModel];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_MPSiteSystemNoticeCell *systemCell = [tableView dequeueReusableCellWithIdentifier:[RH_MPSiteSystemNoticeCell defaultReuseIdentifier]] ;
        systemCell.delegate = self ;
        [systemCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return systemCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
#pragma mark 全选，删除,标记已读代理
-(void)siteMessageHeaderViewAllChoseBtn:(BOOL)choseMark
{
    for (int i =0; i<self.siteModelArray.count; i++) {
        RH_SiteMessageModel *siteModel = self.siteModelArray[i];
        if (choseMark==YES) {
            [siteModel updateSelectedFlag:YES] ;
            [self.deleteModelArray addObject:siteModel];
        }
        else if (choseMark==NO){
            [siteModel updateSelectedFlag:NO] ;
            [self.deleteModelArray removeAllObjects];
        }
    }
    [self.contentTableView reloadData];
}
-(void)siteMessageHeaderViewDeleteCell:(RH_MPSiteMessageHeaderView *)view
{
    if (self.deleteModelArray.count > 0) {
        NSString *str = @"";
        for (RH_SiteMessageModel *siteModel in self.deleteModelArray) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)siteModel.mId]];
        }
        if([str length] > 0){
            str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
        }
        [self.deleteModelArray removeAllObjects];
        [self.serviceRequest startV3LoadSystemMessageDeleteWithIds:str];
        [self.contentTableView reloadData];
    }else
    {
        showAlertView(@"提示", @"请选择消息记录");
    }
   [self.contentTableView reloadData];
}
-(void)siteMessageHeaderViewReadBtn:(RH_MPSiteMessageHeaderView *)view
{
    if (self.deleteModelArray.count > 0) {
        NSString *str = @"";
        for (RH_SiteMessageModel *siteModel in self.deleteModelArray) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)siteModel.mId]];
        }
        if([str length] > 0){
            str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
        }
        [self.deleteModelArray removeAllObjects];
        [self.serviceRequest startV3LoadSystemMessageReadYesWithIds:str];
    }else
    {
        showAlertView(@"提示", @"请选择消息记录");
    }
  [self.contentTableView reloadData];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_SiteSystemDetailController *detailVC= [RH_SiteSystemDetailController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]];
        [self showViewController:detailVC];
        [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    }
}

-(RH_LoadingIndicateTableViewCell*)loadingIndicateTableViewCell
{
    if (!_loadingIndicateTableViewCell){
        _loadingIndicateTableViewCell = [[RH_LoadingIndicateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_loadingIndicateTableViewCell whc_HeightEqualView] ;
        _loadingIndicateTableViewCell.backgroundColor = [UIColor whiteColor];
        _loadingIndicateTableViewCell.loadingIndicateView.delegate = self;
    }
    
    return _loadingIndicateTableViewCell ;
}
#pragma mark 数据请求
-(RH_LoadingIndicateView*)loadingIndicateView
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
#pragma mark - 当有数据的时候，隐藏下拉动画
-(void)showNoRefreshLoadData
{
    if ([self.pageLoadManager currentDataCount]){
        [self showProgressIndicatorViewWithAnimated:YES title:nil] ;
    }
    [self startUpdateData:NO] ;
}
-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:ImageWithName(@"empty_searchRec_image")
                                             title:nil
                                        detailText:@"您暂无系统消息记录"] ;
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
    if (page==1) {
        [self.siteModelArray removeAllObjects];
    }
    [self.serviceRequest startV3LoadSystemMessageWithpageNumber:page+1 pageSize:pageSize];
    [self.serviceRequest startV3LoadMessageCenterSiteMessageUnReadCount] ;
}
-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
//    [self startUpdateData] ;
    [self showNoRefreshLoadData] ;
}

#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3SiteMessage){
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
        NSInteger totalInter = [dictTmp integerValueForKey:RH_GP_SYSTEMNOTICE_TOTALNUM];
        NSArray *dataArr = [dictTmp objectForKey:@"list"];
        if (dataArr.count > 0) {
            [self loadDataSuccessWithDatas:[dictTmp arrayValueForKey:RH_GP_SYSTEMNOTICE_LIST]
                                totalCount:totalInter completedBlock:nil] ;
            //获取model
            for (RH_SiteMessageModel *model in [dictTmp objectForKey:@"list"]) {
                RH_SiteMessageModel *siteModel = ConvertToClassPointer(RH_SiteMessageModel, model);
                [self.siteModelArray addObject:siteModel];
            }
            self.headerView.allChoseBtn.userInteractionEnabled = YES;
        }
        else
        {
            self.headerView.allChoseBtn.userInteractionEnabled = NO;
            [self loadDataSuccessWithDatas:nil totalCount:0 completedBlock:nil];
        }
  
    }
    else if (type==ServiceRequestTypeV3SystemMessageDelete) {
//        [self startUpdateData] ;
        [self showNoRefreshLoadData];
        self.headerView.statusMark =YES;
    }
    else if (type == ServiceRequestTypeV3SystemMessageYes){
//        [self startUpdateData];
        [self showNoRefreshLoadData];
        self.headerView.statusMark =YES;
    }else if (type == ServiceRequestTypeSiteMessageUnReadCount)
    {
    }
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
    if (type == ServiceRequestTypeV3SiteMessage){
        [self loadDataFailWithError:error] ;
    }
    else if (type==ServiceRequestTypeV3SystemMessageDelete) {
        [self loadDataFailWithError:error] ;
    }
    else if (type == ServiceRequestTypeV3SystemMessageYes){
        [self loadDataFailWithError:error] ;
    }else if (type == ServiceRequestTypeSiteMessageUnReadCount)
    {
        [self loadDataFailWithError:error] ;
    }
}

@end
