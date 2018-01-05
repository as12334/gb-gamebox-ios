//
//  RH_CapitalRecordViewController.m
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalRecordViewController.h"
#import "RH_CapitalTableHeaderView.h"
#import "RH_CapitalRecordHeaderView.h"
#import "RH_CapitalRecordBottomView.h"


@interface RH_CapitalRecordViewController ()
@property(nonatomic,strong,readonly) RH_CapitalRecordHeaderView *capitalRecordHeaderView ;
@property(nonatomic,strong,readonly) RH_CapitalTableHeaderView *capitalTableHeaderView ;
@property(nonatomic,strong,readonly) RH_CapitalRecordBottomView *capitalBottomView ;

@end

@implementation RH_CapitalRecordViewController
@synthesize capitalRecordHeaderView = _capitalRecordHeaderView ;
@synthesize capitalTableHeaderView = _capitalTableHeaderView     ;
@synthesize capitalBottomView = _capitalBottomView               ;

-(BOOL)isSubViewController
{
    return YES ;
}
-(BOOL)hasTopView
{
    return TRUE ;
}

-(CGFloat)topViewHeight
{
    return 50.0f ;
}

-(BOOL)hasBottomView
{
    return YES ;
}

-(CGFloat)bottomViewHeight
{
    return 50.0f ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"资金记录";
    [self setupUI] ;
}

#pragma mark-
-(void)setupUI
{
    [self.topView addSubview:self.capitalRecordHeaderView] ;
    self.topView.backgroundColor = [UIColor greenColor];
    [self.bottomView addSubview:self.capitalBottomView] ;
    self.bottomView.borderMask = CLBorderMarkTop ;
    self.bottomView.borderColor = RH_Line_DefaultColor ;
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
//    self.contentTableView.tableHeaderView = self.capitalTableHeaderView ;
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
-(RH_CapitalRecordHeaderView *)capitalRecordHeaderView
{
    if (!_capitalRecordHeaderView){
        _capitalRecordHeaderView = [RH_CapitalRecordHeaderView createInstance] ;
        _capitalRecordHeaderView.frame = self.topView.bounds ;
        _capitalRecordHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
    }
    
    return _capitalRecordHeaderView ;
    
}

#pragma mark-sort table header view
-(RH_CapitalTableHeaderView *)capitalTableHeaderView
{
    if (!_capitalTableHeaderView){
        _capitalTableHeaderView = [[RH_CapitalTableHeaderView alloc] initWithFrame:CGRectMake(0, 50, self.contentTableView.frameWidth, 50.0f)] ;
//        _capitalTableHeaderView.backgroundColor = colorWithRGB(240, 240, 240) ;
    }
    
    return _capitalTableHeaderView ;
    
}




#pragma mark-sort bottom view
-(RH_CapitalRecordBottomView *)capitalBottomView
{
    if (!_capitalBottomView){
        _capitalBottomView = [RH_CapitalRecordBottomView createInstance] ;
        _capitalBottomView.frame = self.bottomView.bounds ;
        _capitalBottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
    }
    
    return _capitalBottomView ;
    
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
#if 0
    //    [self.serviceRequest startGetOpenCode:nil isHistory:NO] ;
#else
    [self loadDataSuccessWithDatas:nil  totalCount:0] ;
#endif
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
    //    if (type == ServiceRequestTypeStaticOpenCode){
    //        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
    //        [self loadDataSuccessWithDatas:dictTmp.allValues totalCount:dictTmp.allValues.count] ;
    //    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    //    if (type == ServiceRequestTypeStaticOpenCode){
    //        [self loadDataFailWithError:error] ;
    //    }
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
        //        return [RH_LotteryRecordCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
    
    return 0.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
//                RH_LotteryRecordCell *lotteryRecordCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_LotteryRecordCell defaultReuseIdentifier]] ;
        //        [lotteryRecordCell updateCellWithInfo:nil context:indexPath];
        //        return lotteryRecordCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
    
    return nil ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.capitalTableHeaderView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
