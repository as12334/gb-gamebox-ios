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
@interface RH_ApplyDiscountSiteMineCell ()<MPSiteMessageHeaderViewDelegate ,SiteMineNoticeCellDelegate>
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
        [self.contentView addSubview:self.headerView] ;
        self.headerView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(40.0f);
        self.siteModelArray = [NSMutableArray array];
        self.deleteModelArray = [NSMutableArray array];
        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.backgroundColor = [UIColor clearColor];
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentTableView registerCellWithClass:[RH_SiteMineNoticeCell class]] ;
        self.contentScrollView = self.contentTableView;
        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
        [self setupPageLoadManagerWithdatasContext:context1] ;
        self.contentTableView.whc_TopSpaceEqualViewOffset(self.headerView, 40).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
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
#pragma mark - 选择按钮点击 SiteMineNoticeCellDelegate
-(void)siteMineNoticeCellTouchEditBtn:(RH_SiteMineNoticeCell *)siteMineNoticeCell CellModel:(RH_SiteMyMessageModel *)cellMoel
{
    if (cellMoel.selectedFlag) {
        [self.deleteModelArray addObject:cellMoel];
    }else{
        [self.deleteModelArray removeObject:cellMoel];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
       RH_SiteMineNoticeCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:[RH_SiteMineNoticeCell defaultReuseIdentifier]] ;
        noticeCell.delegate = self ;
        [noticeCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return noticeCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
#pragma mark 全选，删除,标记已读代理
-(void)siteMessageHeaderViewAllChoseBtn:(BOOL)choseMark
{
    for (int i =0; i<self.siteModelArray.count; i++) {
        RH_SiteMyMessageModel *siteModel = self.siteModelArray[i];
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
    if (self.deleteModelArray.count>0) {
        NSString *str = @"";
        for (RH_SiteMyMessageModel *siteModel in self.deleteModelArray) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",siteModel.mId]];
        }
        if([str length] > 0){
            str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
        }
        [self.deleteModelArray removeAllObjects];
        [self.serviceRequest cancleAllServices];
        [self.serviceRequest startV3LoadMyMessageDeleteWithIds:str];
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
       showAlertView(@"提示", @"请选择消息记录");
    }
    [self.contentTableView reloadData];
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
    if (page==1) {
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
//    [self startUpdateData] ;
    [self showNoRefreshLoadData] ;
}


#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3SiteMessageMyMessage){
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data)  ;
        if ([dictTmp arrayValueForKey:@"dataList"].count>0) {
            for (int i = 0; i<[dictTmp arrayValueForKey:@"dataList"].count; i++) {
                RH_SiteMyMessageModel *myModel = ConvertToClassPointer(RH_SiteMyMessageModel, [dictTmp arrayValueForKey:@"dataList"][i]);
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
         [self.contentTableView reloadData];
    }
    else if (type==ServiceRequestTypeV3MyMessageMyMessageDelete) {
//        [self startUpdateData] ;
        [self showNoRefreshLoadData] ;
        self.headerView.statusMark = YES;
        [self.contentTableView reloadData];
        showMessage(self, nil, @"消息删除成功") ;
    }
    else if (type==ServiceRequestTypeV3MyMessageMyMessageReadYes) {
//        [self startUpdateData];
        [self showNoRefreshLoadData] ;
        [self.contentTableView reloadData];
        self.headerView.statusMark = YES;
    }
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
    if (type == ServiceRequestTypeV3SiteMessageMyMessage){
        [self loadDataFailWithError:error] ;
    }
    else if (type==ServiceRequestTypeV3MyMessageMyMessageDelete) {
        [self loadDataFailWithError:error] ;
    }
    else if (type==ServiceRequestTypeV3MyMessageMyMessageReadYes) {
        [self loadDataFailWithError:error] ;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

@end
