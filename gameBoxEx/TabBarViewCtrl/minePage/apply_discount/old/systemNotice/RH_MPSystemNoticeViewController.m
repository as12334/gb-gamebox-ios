//
//  RH_MPGameNoticeViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSystemNoticeViewController.h"
#import "RH_MPSystemNoticeCell.h"
#import "RH_MPSystemNoticHeaderView.h"
#import "RH_MPGameNoticePulldownView.h"
#import "RH_SystemNoticeModel.h"
#import "RH_API.h"
#import "RH_MPSystemNoticeDetailController.h"
@interface RH_MPSystemNoticeViewController ()<MPSystemNoticHeaderViewDelegate>
@property (nonatomic,strong,readonly)RH_MPSystemNoticeCell *systemNoticeCell;
@property (nonatomic,strong,readonly)RH_MPSystemNoticHeaderView *headerView;
@property (nonatomic,strong,readonly)RH_MPGameNoticePulldownView *listView;
@property (nonatomic,strong)RH_SystemNoticeModel *systemModel;
@property (nonatomic,strong)NSDate *startDate;
@property (nonatomic,strong)NSDate *endDate;
@end

@implementation RH_MPSystemNoticeViewController
@synthesize systemNoticeCell = _gameNoticeCell;
@synthesize headerView = _headerView;
@synthesize listView = _listView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
-(void)setupViewContext:(id)context
{
    _systemModel = ConvertToClassPointer(RH_SystemNoticeModel, context);
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.hidden = YES;
}
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView registerCellWithClass:[RH_MPSystemNoticeCell class]] ;
    self.contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
     self.needObserverTapGesture = YES ;
    [self setupPageLoadManager] ;
}
#pragma  mark headerView
-(RH_MPSystemNoticHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPSystemNoticHeaderView createInstance];
        _headerView.frame  = CGRectMake(0, 0, self.view.frameWidth, 50);
        _headerView.delegate=self;
    }
    return _headerView;
}
#pragma mark - CapitalRecordHeaderViewDelegate
-(void)gameSystemHeaderViewStartDateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    __block RH_MPSystemNoticeViewController *weakSelf = self;
    [self showCalendarView:@"设置开始日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  view.startDate = returnDate ;
                  weakSelf.startDate = returnDate;
              }] ;
}
-(void)gameSystemHeaderViewEndDateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    __block RH_MPSystemNoticeViewController *weakSelf = self;
    [self showCalendarView:@"设置结止日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  view.endDate = returnDate ;
                  weakSelf.endDate  = returnDate;
              }] ;
    [self startUpdateData] ;
}
#pragma mark-

#pragma mark 点击headerview的游戏类型
-(RH_MPGameNoticePulldownView *)listView
{
    if (!_listView) {
        _listView = [[RH_MPGameNoticePulldownView alloc]init];
    }
    return _listView;
}
-(void)selectedHeaderViewGameType:(CGRect )frame
{
    if (!self.listView.superview) {
        frame.origin.y +=self.topView.frameY+self.topView.frameHeigh+frame.size.height;
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
//-(NSUInteger)defaultPageSize
//{
//    
//}

-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
//    [self.serviceRequest startV3DepositListDetail:[NSString stringWithFormat:@"%d",self.systemModel.mId]] ;
    [self.serviceRequest startV3LoadSystemNoticeStartTime:self.startDate endTime:self.endDate pageNumber:page pageSize:pageSize];
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
    if (type == ServiceRequestTypeV3SYSTEMNOTICE){
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
        
        [self loadDataSuccessWithDatas:[dictTmp arrayValueForKey:RH_GP_SYSTEMNOTICE_LIST]
                            totalCount:[dictTmp integerValueForKey:RH_GP_SYSTEMNOTICE_TOTALNUM]]  ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3SYSTEMNOTICE){
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    __block RH_MPSystemNoticeViewController *weakSelf = self;
    self.headerView.block = ^(CGRect frame){
        [weakSelf selectedHeaderViewGameType:frame];
    };
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_MPSystemNoticeCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
    
    //    return 40.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_MPSystemNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_MPSystemNoticeCell defaultReuseIdentifier]] ;
        [noticeCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return noticeCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    RH_MPSystemNoticeDetailController *detailVC = [[RH_MPSystemNoticeDetailController alloc]init];
    RH_MPSystemNoticeDetailController *detailVC= [RH_MPSystemNoticeDetailController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end

