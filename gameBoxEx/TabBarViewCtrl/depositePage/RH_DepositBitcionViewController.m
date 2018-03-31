//
//  RH_DepositBitcionViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/31.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositBitcionViewController.h"
#import "RH_DepositeBitcionCell.h"
#import "coreLib.h"
#import "RH_DepositeTransferChannelModel.h"
@interface RH_DepositBitcionViewController ()<DepositeBitcionCellDelegate>
@property(nonatomic,strong)RH_DepositeTransferListModel *listModel;
@end

@implementation RH_DepositBitcionViewController
-(BOOL)isSubViewController
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"比特币支付";
    [self setupUI];
}
-(void)setupViewContext:(id)context{
    RH_DepositeTransferListModel *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.listModel = listModel;
}
#pragma mark --视图
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    self.contentTableView.separatorStyle = UITableViewRowActionStyleNormal;
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeBitcionCell class]] ;
}

#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  1 ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 750.f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositeBitcionCell *bitecionCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeBitcionCell defaultReuseIdentifier]] ;
    bitecionCell.delegate = self;
    return bitecionCell ;
}

#pragma mark --点击提交按钮
-(void)depositeBitcionCellSubmit:(NSMutableArray *)bitcoinInfo{
    
}
#pragma mark 数据请求

#pragma mark - serviceRequest
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
    //
//    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:[self.accountMuArray[0] floatValue] PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
    
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
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    
    if (type == ServiceRequestTypeV3DepositOriginSeachSale) {
        
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3DepositOriginSeachSale) {
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}

@end
