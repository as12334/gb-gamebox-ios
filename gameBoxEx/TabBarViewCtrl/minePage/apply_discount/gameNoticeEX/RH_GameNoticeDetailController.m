//
//  RH_GameNoticeDetailController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameNoticeDetailController.h"
#import "RH_GameNoticeDetailCell.h"
#import "RH_GameNoticeDetailModel.h"
#import "RH_GameNoticeModel.h"
@interface RH_GameNoticeDetailController ()
@property (nonatomic,strong)ListModel *noticeModel;
@end

@implementation RH_GameNoticeDetailController

-(BOOL)isSubViewController
{
    return YES;
}
-(void)setupViewContext:(id)context
{
    self.noticeModel = ConvertToClassPointer(ListModel, context);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"游戏公告";
    [self setupUI];
}
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView registerCellWithClass:[RH_GameNoticeDetailCell class]] ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
    self.needObserverTapGesture = YES ;
    [self setupPageLoadManager] ;
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
    
//    [self.serviceRequest startV3LoadSystemNoticeDetailSearchId:self.systemModel.mID];
    [self.serviceRequest startV3LoadGameNoticeDetailSearchId:self.noticeModel.mId];
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
    if (type == ServiceRequestTypeV3GameNoticeDetail){
        RH_GameNoticeDetailModel *detailModel = ConvertToClassPointer(RH_GameNoticeDetailModel, data);
        [self loadDataSuccessWithDatas:detailModel?@[detailModel]:@[]
                            totalCount:detailModel?1:0] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3GameNoticeDetail){
         showErrorMessage(nil, error, nil) ;
        [self loadDataFailWithError:error] ;
    }
}

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
        return [RH_GameNoticeDetailCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
    
    //    return 40.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_GameNoticeDetailCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_GameNoticeDetailCell defaultReuseIdentifier]] ;
        [noticeCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return noticeCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}

@end
