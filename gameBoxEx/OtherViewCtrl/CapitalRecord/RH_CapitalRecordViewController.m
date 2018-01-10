//
//  RH_CapitalRecordViewController.m
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalRecordViewController.h"
#import "RH_CapitalRecordHeaderView.h"
#import "RH_CapitalRecordBottomView.h"
#import "RH_CapitalTableViewCell.h"

@interface RH_CapitalRecordViewController ()<CapitalRecordHeaderViewDelegate>
@property(nonatomic,strong,readonly) RH_CapitalRecordHeaderView *capitalRecordHeaderView ;
@property(nonatomic,strong,readonly) RH_CapitalRecordBottomView *capitalBottomView ;

@end

@implementation RH_CapitalRecordViewController
@synthesize capitalRecordHeaderView = _capitalRecordHeaderView ;
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
    return 150.0f ;
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
    self.capitalRecordHeaderView.userInteractionEnabled = YES;
    [self.bottomView addSubview:self.capitalBottomView] ;
    self.bottomView.borderMask = CLBorderMarkTop ;
    self.bottomView.borderColor = RH_Line_DefaultColor ;
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView registerCellWithClass:[RH_CapitalTableViewCell class]] ;
    
//    [self.contentCollectionView registerCellWithClass:[RH_CapitalTableViewCell class] andReuseIdentifier:@"RH_CapitalTableViewCell"];
    self.contentTableView.backgroundColor = RH_View_DefaultBackgroundColor ;
//    [self setupPageLoadManager] ;
}


- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
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
        _capitalRecordHeaderView.delegate = self;
        _capitalRecordHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
    }
    return _capitalRecordHeaderView ;
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

#pragma mark - CapitalRecordHeaderViewDelegate
-(void)CapitalRecordHeaderViewWillSelectedStartDate:(RH_CapitalRecordHeaderView *)CapitalRecordHeaderView DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置开始日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  CapitalRecordHeaderView.startDate = returnDate ;
              }] ;
}

-(void)CapitalRecordHeaderViewWillSelectedEndDate:(RH_CapitalRecordHeaderView *)CapitalRecordHeaderView DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置结止日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  CapitalRecordHeaderView.endDate = returnDate ;
              }] ;
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
//    return MAX(1, self.pageLoadManager.currentDataCount) ;
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.pageLoadManager.currentDataCount){
//        //        return [RH_LotteryRecordCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
//    }else{
//        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
//        return height ;
//    }
    
    return 40.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.pageLoadManager.currentDataCount){
                RH_CapitalTableViewCell *lotteryRecordCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_CapitalTableViewCell defaultReuseIdentifier]] ;
                [lotteryRecordCell updateCellWithInfo:nil context:nil];
                return lotteryRecordCell ;
//    }else{
//        return self.loadingIndicateTableViewCell ;
//    }
//
//    return nil ;
}



@end
