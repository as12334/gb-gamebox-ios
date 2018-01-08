//
//  RH_BettingRecordViewController.m
//  lotteryBox
//
//  Created by luis on 2017/12/8.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingRecordViewController.h"
#import "RH_BettingRecordHeaderView.h"
#import "RH_BettingTableHeaderView.h"
#import "RH_BettingRecordBottomView.h"
#import "coreLib.h"

@interface RH_BettingRecordViewController ()<BettingRecordHeaderViewDelegate>
@property(nonatomic,strong,readonly) RH_BettingRecordHeaderView *bettingRecordHeaderView ;
@property(nonatomic,strong,readonly) RH_BettingTableHeaderView *bettingTableHeaderView ;
@property(nonatomic,strong,readonly) RH_BettingRecordBottomView *bettingBottomView ;
@end

@implementation RH_BettingRecordViewController
@synthesize bettingRecordHeaderView = _bettingRecordHeaderView ;
@synthesize bettingTableHeaderView = _bettingTableHeaderView     ;
@synthesize bettingBottomView = _bettingBottomView               ;


-(BOOL)isSubViewController
{
    return YES ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"投注记录";
    [self setupUI] ;
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

#pragma mark-
-(void)setupUI
{
    [self.topView addSubview:self.bettingRecordHeaderView] ;
    [self.bottomView addSubview:self.bettingBottomView] ;
    self.bottomView.borderMask = CLBorderMarkTop ;
    self.bottomView.borderColor = RH_Line_DefaultColor ;
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    self.contentTableView.tableHeaderView = self.bettingTableHeaderView ;
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
-(RH_BettingRecordHeaderView *)bettingRecordHeaderView
{
    if (!_bettingRecordHeaderView){
        _bettingRecordHeaderView = [RH_BettingRecordHeaderView createInstance] ;
        _bettingRecordHeaderView.frame = self.topView.bounds ;
        _bettingRecordHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
        _bettingRecordHeaderView.delegate = self ;
    }
    
    return _bettingRecordHeaderView ;
}

-(void)bettingRecordHeaderViewWillSelectedStartDate:(RH_BettingRecordHeaderView*)bettingRecordHeaderView DefaultDate:(NSDate*)defaultDate
{
    [self showCalendarView:@"设置开始日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  bettingRecordHeaderView.startDate = returnDate ;
              }] ;
}

-(void)bettingRecordHeaderViewWillSelectedEndDate:(RH_BettingRecordHeaderView*)bettingRecordHeaderView DefaultDate:(NSDate*)defaultDate
{
    [self showCalendarView:@"设置结止日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  bettingRecordHeaderView.endDate = returnDate ;
              }] ;
}

#pragma mark-sort table header view
-(RH_BettingTableHeaderView *)bettingTableHeaderView
{
    if (!_bettingTableHeaderView){
        _bettingTableHeaderView = [[RH_BettingTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.contentTableView.frameWidth, 50.0f)] ;
        _bettingTableHeaderView.backgroundColor = colorWithRGB(240, 240, 240) ;
    }
    
    return _bettingTableHeaderView ;
}

#pragma mark-sort bottom view
-(RH_BettingRecordBottomView*)bettingBottomView
{
    if (!_bettingBottomView){
        _bettingBottomView = [RH_BettingRecordBottomView createInstance] ;
        _bettingBottomView.frame = self.bottomView.bounds ;
        _bettingBottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
    }
    
    return _bettingBottomView ;
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
    [self.serviceRequest startV3BettingList:dateStringWithFormatter(self.bettingRecordHeaderView.startDate, @"yyyy-MM-dd")
                                    EndDate:dateStringWithFormatter(self.bettingRecordHeaderView.endDate, @"yyyy-MM-dd")] ;
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
    if (type == ServiceRequestTypeV3BettingList){
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
        [self loadDataSuccessWithDatas:dictTmp.allValues totalCount:dictTmp.allValues.count] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3BettingList){
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
//        RH_LotteryRecordCell *lotteryRecordCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_LotteryRecordCell defaultReuseIdentifier]] ;
//        [lotteryRecordCell updateCellWithInfo:nil context:indexPath];
//        return lotteryRecordCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
    
    return nil ;
}

@end
