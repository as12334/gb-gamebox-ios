//
//  RH_MPGameNoticeViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPGameNoticeViewController.h"
#import "RH_MPGameNoticeCell.h"
#import "RH_MPGameNoticHeaderView.h"
#import "RH_MPGameNoticePulldownView.h"
#import "RH_API.h"
#import "coreLib.h"
#import "RH_GameNoticeModel.h"
#import "RH_GameNoticeDetailController.h"
@interface RH_MPGameNoticeViewController ()<MPGameNoticHeaderViewDelegate>
@property (nonatomic,strong,readonly)RH_MPGameNoticeCell *gameNoticeCell;
@property (nonatomic,strong,readonly)RH_MPGameNoticHeaderView *headerView;
@property (nonatomic,strong,readonly)RH_MPGameNoticePulldownView *listView;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSDate *endDate;
@property (nonatomic,assign)NSInteger apiId;
@end

@implementation RH_MPGameNoticeViewController
@synthesize gameNoticeCell = _gameNoticeCell;
@synthesize headerView = _headerView;
@synthesize listView = _listView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//  [self.navigationBar setHidden:YES];
    [self setupUI];
}
-(BOOL)hasTopView
{
    return YES;
}
-(CGFloat)topViewHeight
{
    return 50;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.hidden = YES;
}
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView registerCellWithClass:[RH_MPGameNoticeCell class]] ;
    self.contentTableView.contentInset = UIEdgeInsetsMake(0, 0,0, 0);
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
    self.needObserverTapGesture = YES ;
    [self setupPageLoadManager] ;
    
    self.topView.frame = CGRectMake(0, 0, self.view.frameWidth, 50);
    [self.topView addSubview:self.headerView];
    __block RH_MPGameNoticeViewController *weakSelf = self;
    self.headerView.block = ^(int number, CGRect frame){
        [weakSelf selectedHeaderViewGameType:frame andMarkNnmber:2];
    };
    self.headerView.kuaixuanBlock = ^(int number, CGRect frame){
        [weakSelf selectedHeaderViewGameType:frame andMarkNnmber:1];
    };
}
#pragma  mark headerView
-(RH_MPGameNoticHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPGameNoticHeaderView createInstance];
        _headerView.frame  = CGRectMake(0, 0, self.view.frameWidth, 50);
        _headerView.delegate=self;
    }
    return _headerView;
}
#pragma mark - CapitalRecordHeaderViewDelegate
-(void)gameNoticHeaderViewStartDateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    __block RH_MPGameNoticeViewController *weakSelf = self;
    [self showCalendarView:@"设置开始日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  view.startDate = returnDate ;
                  weakSelf.startDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
                  [weakSelf startUpdateData] ;
              }] ;
}
-(void)gameNoticHeaderViewEndDateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    __block RH_MPGameNoticeViewController *weakSelf = self;
    [self showCalendarView:@"设置结止日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  view.endDate = returnDate ;
                  weakSelf.endDate = returnDate;
                  [weakSelf startUpdateData] ;
              }] ;
}
#pragma mark-
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
        return [RH_MPGameNoticeCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_MPGameNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_MPGameNoticeCell defaultReuseIdentifier]] ;
        [noticeCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return noticeCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_GameNoticeDetailController *detailVC= [RH_GameNoticeDetailController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]];
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark 点击headerview的游戏类型
-(RH_MPGameNoticePulldownView *)listView
{
    if (!_listView) {
        _listView = [[RH_MPGameNoticePulldownView alloc]init];
        __block RH_MPGameNoticeViewController *weakSelf = self;

            _listView.block = ^(NSInteger apiId){
                if (weakSelf.listView.superview){
                    [UIView animateWithDuration:0.2f animations:^{
                        CGRect framee = weakSelf.listView.frame;
                        framee.size.height = 0;
                        weakSelf.listView.frame = framee;
                    } completion:^(BOOL finished) {
                        [weakSelf.listView removeFromSuperview];
                    }];
                    weakSelf.headerView.gameTypeLabel.text = weakSelf.listView.gameTypeString;
                }
                weakSelf.apiId = apiId;
                [weakSelf startUpdateData] ;
            };
            _listView.kuaixuanBlock = ^(NSInteger row){
                if (weakSelf.listView.superview){
                    [UIView animateWithDuration:0.2f animations:^{
                        CGRect framee = weakSelf.listView.frame;
                        framee.size.height = 0;
                        weakSelf.listView.frame = framee;
                    } completion:^(BOOL finished) {
                        [weakSelf.listView removeFromSuperview];
                    }];
                }
                weakSelf.startDate = [weakSelf changedSinceTimeString:row];
                [weakSelf startUpdateData] ;
            };
        }
    return _listView;
}
#pragma mark 修改时间
-(NSString *)changedSinceTimeString:(NSInteger)row
{
    NSDate *date = [[NSDate alloc]init];
    switch (row) {
        case 0:
            date= [[NSDate date] dateWithMoveDay:0];
            break;
        case 1:
            date= [[NSDate date] dateWithMoveDay:-1];
            break;
        case 2:
            date= [[NSDate date] dateWithMoveDay:-7];
            break;
        case 3:
            date= [[NSDate date] dateWithMoveDay:-14];
            break;
        case 4:
            date= [[NSDate date] dateWithMoveDay:-30];
            break;
        case 5:
            date= [[NSDate date] dateWithMoveDay:-7];
            break;
        case 6:
            date= [[NSDate date] dateWithMoveDay:-30];
            break;
            
        default:
            break;
    }
    NSString *beforDate = dateStringWithFormatter(date, @"yyyy-MM-dd");
    return beforDate;
}

-(void)selectedHeaderViewGameType:(CGRect )frame andMarkNnmber:(int )number
{
    if (!self.listView.superview) {
        frame.origin.y +=self.topView.frameY+self.topView.frameHeigh;
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
    if (number==1) {
        self.listView.number = number;
        [self.listView.tabelView reloadData];
    }
    else if (number==2){
        self.listView.number = number;
        [self.listView.tabelView reloadData];
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
    __weak RH_MPGameNoticeViewController *weakSelf = self;
    [self.serviceRequest startV3LoadGameNoticeStartTime:weakSelf.startDate
                                                endTime:weakSelf.endDate
                                             pageNumber:page
                                               pageSize:pageSize
                                                  apiId:weakSelf.apiId];
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
    if (type == ServiceRequestTypeV3GameNotice){
        RH_GameNoticeModel *gameModel = ConvertToClassPointer(RH_GameNoticeModel, data);
        self.listView.modelArray = gameModel.mApiSelectModel;
        [self loadDataSuccessWithDatas:gameModel.mListModel
                            totalCount:gameModel.mPageTotal]  ;

    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3GameNotice){
        [self loadDataFailWithError:error] ;
    }
}


@end
