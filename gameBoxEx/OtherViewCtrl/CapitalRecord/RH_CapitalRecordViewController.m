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
#import "coreLib.h"
#import "RH_CapitalInfoOverviewModel.h"
#import "RH_CapitalRecordDetailsController.h"
#import "RH_CapitalPulldownListView.h"
@interface RH_CapitalRecordViewController ()<CapitalRecordHeaderViewDelegate>
@property(nonatomic,strong,readonly) RH_CapitalRecordHeaderView *capitalRecordHeaderView ;
@property(nonatomic,strong,readonly) RH_CapitalRecordBottomView *capitalBottomView ;
@property (nonatomic,strong,readonly) RH_CapitalPulldownListView *listView;
@end

@implementation RH_CapitalRecordViewController
@synthesize capitalRecordHeaderView = _capitalRecordHeaderView ;
@synthesize capitalBottomView = _capitalBottomView               ;
@synthesize listView =_listView;
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
//    [self.serviceRequest startV3SiteMessageMyMessageWithpageNumber:1 pageSize:1];
     [self.serviceRequest startV3AddApplyDiscountsVerify];
}


#pragma mark-
-(void)setupUI
{
    [self.topView addSubview:self.capitalRecordHeaderView] ;
    __block RH_CapitalRecordViewController *weakSelf = self;
    self.capitalRecordHeaderView.block = ^(CGRect frame){
        [weakSelf pullDownAndCloseListView:frame];
    };
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
    self.contentTableView.backgroundColor = RH_View_DefaultBackgroundColor ;
    [self setupPageLoadManager] ;
    self.needObserverTapGesture = YES ;
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
-(RH_CapitalPulldownListView *)listView
{
    if (!_listView) {
        _listView = [[RH_CapitalPulldownListView alloc]init];
        __block RH_CapitalRecordViewController *weakSelf = self;
        _listView.block = ^(){
            if (weakSelf.listView.superview){
                [UIView animateWithDuration:0.2f animations:^{
                    CGRect framee = weakSelf.listView.frame;
                    framee.size.height = 0;
                    weakSelf.listView.frame = framee;
                } completion:^(BOOL finished) {
                    [weakSelf.listView removeFromSuperview];
                }];
                [weakSelf.capitalRecordHeaderView.typeButton setTitle:weakSelf.listView.typeString forState:UIControlStateNormal];
            }
        };
    }
    return _listView;
}
-(void)pullDownAndCloseListView:(CGRect )frame
{
    if (!self.listView.superview) {
        frame.origin.y +=heighStatusBar+NavigationBarHeight+frame.size.height;
        self.listView.frame = frame;
        [self.view addSubview:self.listView];
        [UIView animateWithDuration:.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 200;
            self.listView.frame = framee;
        }];
    }
    else
    {
        [UIView animateWithDuration:.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 0;
            self.listView.frame = framee;
        } completion:^(BOOL finished) {
            [self.listView removeFromSuperview];
        }];
    }
    
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
-(void)capitalRecordHeaderViewWillSelectedStartDate:(RH_CapitalRecordHeaderView *)CapitalRecordHeaderView DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置开始日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  CapitalRecordHeaderView.startDate = returnDate ;
              }] ;
}
-(void)capitalRecordHeaderViewWillSelectedEndDate:(RH_CapitalRecordHeaderView *)CapitalRecordHeaderView DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置结止日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  CapitalRecordHeaderView.endDate = returnDate ;
              }] ;
}
#pragma mark --- 搜索按钮点击
-(void)capitalRecordHeaderViewTouchSearchButton:(RH_CapitalRecordHeaderView *)capitalRecordHeaderView
{
    NSLog(@"搜索");
}
#pragma mark- observer Touch gesture
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.listView.superview?YES:NO ;
}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (self.listView.superview){
        [UIView animateWithDuration:0.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 0;
            self.listView.frame = framee;
        } completion:^(BOOL finished) {
            [self.listView removeFromSuperview];
        }];
    }
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
    NSDate *startDate = [[NSDate date] dateWithMoveDay:-300] ;
    NSDate *endDate = [NSDate date] ;
    [self.serviceRequest startV3DepositList:dateStringWithFormatter(startDate, @"yyyy-MM-dd")
                                    EndDate:dateStringWithFormatter(endDate, @"yyyy-MM-dd")
                                 SearchType:nil
                                 PageNumber:page
                                   PageSize:pageSize] ;
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
    if (type == ServiceRequestTypeV3DepositList){
        RH_CapitalInfoOverviewModel *capitalInfoOverModel = ConvertToClassPointer(RH_CapitalInfoOverviewModel, data) ;
        
        [self loadDataSuccessWithDatas:capitalInfoOverModel.mList
                            totalCount:capitalInfoOverModel.mTotalCount] ;
    }
    if (type == ServiceRequestTypeV3AddApplyDiscountsVerify) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString11 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString11);
    }
   


}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3DepositList){
        [self loadDataFailWithError:error] ;
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
        return [RH_CapitalTableViewCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_CapitalTableViewCell *capitalCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_CapitalTableViewCell defaultReuseIdentifier]] ;
        [capitalCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]];
        return capitalCell ;

    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        [self showViewController:[RH_CapitalRecordDetailsController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]]
                          sender:self] ;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}
@end
