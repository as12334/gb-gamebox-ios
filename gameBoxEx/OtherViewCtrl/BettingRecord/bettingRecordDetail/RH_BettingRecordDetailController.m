//
//  RH_BettingRecordDetailController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BettingRecordDetailController.h"
#import "RH_BettingRecordDetailCell.h"
#import "RH_BettingInfoModel.h"

@interface RH_BettingRecordDetailController ()

@end

@implementation RH_BettingRecordDetailController
{
    RH_BettingInfoModel *_bettingInfoModel ;
}

-(void)setupViewContext:(id)context
{
    _bettingInfoModel = ConvertToClassPointer(RH_BettingInfoModel, context) ;
}

-(BOOL)isSubViewController
{
    return YES ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投注记录详情";
    [self createUI];
    
}

-(void)createUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    [self.contentTableView registerCellWithClass:[RH_BettingRecordDetailCell class]] ;
    [self.contentView addSubview:self.contentTableView] ;
    
    self.contentTableView.backgroundColor = RH_View_DefaultBackgroundColor ;
    [self setupPageLoadManager] ;
}
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

//    [self.serviceRequest startV3BettingDetails:4866637] ;
    [self.serviceRequest startV3BettingDetails:_bettingInfoModel.mID] ;
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
    if (type == ServiceRequestTypeV3BettingDetails){
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
        
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3BettingDetails){
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
//    return MAX(1, self.pageLoadManager.currentDataCount) ;
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.pageLoadManager.currentDataCount){
//        return [RH_BettingRecordDetailCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
//    }else{
//        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
//        return height ;
//    }
    
    return 40.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.pageLoadManager.currentDataCount){
        RH_BettingRecordDetailCell *bettingRecordCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_BettingRecordDetailCell defaultReuseIdentifier]] ;
        [bettingRecordCell updateCellWithInfo:nil context:nil] ;
        return bettingRecordCell ;
//    }else{
//        return self.loadingIndicateTableViewCell ;
//    }
}

@end
