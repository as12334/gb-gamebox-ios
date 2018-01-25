//
//  RH_CapitalRecordDetailsController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalRecordDetailsController.h"
#import "RH_CapitalRecordDetailsCell.h"
#import "coreLib.h"
#import "RH_CapitalDetailModel.h"
#import "RH_CapitalInfoModel.h"
@interface RH_CapitalRecordDetailsController ()
@property(nonatomic,strong)RH_CapitalInfoModel *infoModel;
@end

@implementation RH_CapitalRecordDetailsController
-(BOOL)isSubViewController
{
    return YES ;
}
-(void)setupViewContext:(id)context
{
    _infoModel = ConvertToClassPointer(RH_CapitalInfoModel, context);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资金记录详情";
//    if ([self.infoModel.mTransactionType isEqualToString:@"transfers"]) {
        [self createUI:[RH_CapitalRecordDetailsCell class]];
//    }
    
}
-(void)createUI:(id)cell{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    [self.contentTableView registerCellWithClass:cell] ;
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
    [self.serviceRequest startV3DepositListDetail:[NSString stringWithFormat:@"%d",self.infoModel.mId]] ;
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
    if (type == ServiceRequestTypeV3DepositListDetails){
        
        RH_CapitalDetailModel *detailModel = ConvertToClassPointer(RH_CapitalDetailModel, data);
        [self loadDataSuccessWithDatas:detailModel?@[detailModel]:@[]
                            totalCount:detailModel?1:0] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3DepositListDetails){
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
        return 1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (self.pageLoadManager.currentDataCount){
            return [RH_CapitalRecordDetailsCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
        }else{
            CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
            return height ;
        }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
    RH_CapitalRecordDetailsCell *bettingRecordCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_CapitalRecordDetailsCell defaultReuseIdentifier]] ;
    [bettingRecordCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    return bettingRecordCell ;
        }else{
            return self.loadingIndicateTableViewCell ;
        }
}
@end
