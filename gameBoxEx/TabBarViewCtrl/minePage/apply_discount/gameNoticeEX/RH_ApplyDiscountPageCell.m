//
//  RH_ApplyDiscountPageCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountPageCell.h"
#import "RH_LoadingIndicateTableViewCell.h"
#import "RH_DiscountActivityModel.h"
#import "RH_APPDelegate.h"
#import "RH_API.h"
#import "coreLib.h"
#import "RH_CustomViewController.h"
#import "RH_UserInfoManager.h"
#import "RH_GameNoticeModel.h"
#import "RH_ServiceRequest.h"
#import "RH_MPGameNoticeCell.h"
#import "RH_DiscountActivityTypeModel.h"
#import "RH_MPSiteSystemNoticeCell.h"
#import "RH_MPGameNoticHeaderView.h"
#import "RH_MPGameNoticePulldownView.h"
@interface RH_ApplyDiscountPageCell()<RH_ServiceRequestDelegate,MPGameNoticHeaderViewDelegate>
@property(nonatomic,strong,readonly) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
//@property (nonatomic,strong) RH_DiscountActivityTypeModel *typeModel ;
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property (nonatomic,strong,readonly)RH_MPGameNoticHeaderView *headerView;
@property (nonatomic,strong,readonly)RH_MPGameNoticePulldownView *listView;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSDate *endDate;
@property (nonatomic,assign)NSInteger apiId;
@end

@implementation RH_ApplyDiscountPageCell
@synthesize loadingIndicateTableViewCell = _loadingIndicateTableViewCell ;
@synthesize serviceRequest = _serviceRequest;
@synthesize headerView = _headerView;
@synthesize listView = _listView;

-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
//    self.typeModel = ConvertToClassPointer(RH_DiscountActivityTypeModel, typeModel) ;
    
    if (self.contentTableView == nil) {
        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.sectionFooterHeight = 10.0f;
        self.contentTableView.sectionHeaderHeight = 10.0f ;
        self.contentTableView.backgroundColor = [UIColor clearColor];
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
//        self.contentTableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
        [self.contentTableView registerCellWithClass:[RH_MPGameNoticeCell class]] ;
        self.contentScrollView = self.contentTableView;
        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
        [self setupPageLoadManagerWithdatasContext:context1] ;
        
    }else {
        [self updateWithContext:context];
    }
}

-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc]init];
        _serviceRequest.delegate = self;
    }
    return _serviceRequest;
}
#pragma mark-
-(CLPageLoadManagerForTableAndCollectionView*)createPageLoadManager
{
    return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentTableView
                                                          pageLoadControllerClass:[CLArrayPageLoadController class]
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1];
    
}

#pragma mark-
- (UIEdgeInsets)contentScorllViewInitContentInset {
    return UIEdgeInsetsMake(0.0f, 0.f, 0.f, 0.f) ;
}

-(void)networkStatusChangeHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}

-(void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}

-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:nil title:@"当前无优惠活动"
                                        detailText:@"点击重试"] ;
    return YES ;
}

#pragma mark-
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3LoadGameNoticeStartTime:@"2017-01-01"
                                                endTime:@""
                                             pageNumber:page
                                               pageSize:pageSize
                                                  apiId:self.apiId];
}

-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeV3GameNotice)
    {
        RH_GameNoticeModel *gameModel = ConvertToClassPointer(RH_GameNoticeModel, data);
        self.listView.modelArray = gameModel.mApiSelectModel;
        [self loadDataSuccessWithDatas:gameModel.mListModel
                            totalCount:gameModel.mPageTotal
                        completedBlock:nil];
        [self.contentTableView reloadData];
    }
}


- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type==ServiceRequestTypeV3GameNotice )
    {
        [self loadDataFailWithError:error] ;
    }
}


#pragma mark-
-(RH_LoadingIndicateTableViewCell*)loadingIndicateTableViewCell
{
    if (!_loadingIndicateTableViewCell){
        _loadingIndicateTableViewCell = [[RH_LoadingIndicateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _loadingIndicateTableViewCell.backgroundColor = [UIColor whiteColor];
        _loadingIndicateTableViewCell.loadingIndicateView.delegate = self;
    }
    
    return _loadingIndicateTableViewCell ;
}

-(RH_LoadingIndicateView*)loadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}

#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_MPGameNoticeCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        return tableView.boundHeigh - tableView.contentInset.top - tableView.contentInset.bottom ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_MPGameNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_MPGameNoticeCell defaultReuseIdentifier]] ;
        [cell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return cell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    __block RH_ApplyDiscountPageCell *weakSelf = self;
    self.headerView.block = ^(int number, CGRect frame){
        [weakSelf selectedHeaderViewGameType:frame andMarkNnmber:2];
    };
    self.headerView.kuaixuanBlock = ^(int number, CGRect frame){
        [weakSelf selectedHeaderViewGameType:frame andMarkNnmber:1];
    };
    return self.headerView;
}
#pragma mark headerView
-(RH_MPGameNoticHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPGameNoticHeaderView createInstance];
        _headerView.frame  = CGRectMake(0, 0, self.frameWidth, 50);
        _headerView.delegate=self;
    }
    return _headerView;
}
-(void)selectedHeaderViewGameType:(CGRect )frame andMarkNnmber:(int )number
{
    if (!self.listView.superview) {
        frame.origin.y +=self.contentTableView.frameY+50;
        self.listView.frame = frame;
        [self addSubview:self.listView];
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
#pragma mark 点击headerview的游戏类型
-(RH_MPGameNoticePulldownView *)listView
{
    if (!_listView) {
        _listView = [[RH_MPGameNoticePulldownView alloc]init];
        __block RH_ApplyDiscountPageCell *weakSelf = self;
        
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

#pragma mark - CapitalRecordHeaderViewDelegate
-(void)gameNoticHeaderViewStartDateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    __block RH_ApplyDiscountPageCell *weakSelf = self;
//    [self showCalendarView:@"设置开始日期"
//            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
//              comfirmBlock:^(NSDate *returnDate) {
//                  view.startDate = returnDate ;
//                  weakSelf.startDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
//                  [weakSelf startUpdateData] ;
//              }] ;

}
-(void)gameNoticHeaderViewEndDateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    __block RH_ApplyDiscountPageCell *weakSelf = self;
//    [self showCalendarView:@"设置结止日期"
//            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
//              comfirmBlock:^(NSDate *returnDate) {
//                  view.endDate = returnDate ;
//                  weakSelf.endDate = returnDate;
//                  [weakSelf startUpdateData] ;
//              }] ;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        if (HasLogin)
        {
            RH_DiscountActivityModel *discountActivityModel = ConvertToClassPointer(RH_DiscountActivityModel, [self.pageLoadManager dataAtIndexPath:indexPath]) ;
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
            if (appDelegate){
                appDelegate.customUrl = discountActivityModel.showLink ;
                [self showViewController:[RH_CustomViewController viewController]] ;
            }
            
        }else{
            showAlertView(@"提示信息", @"您尚未登入") ;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    }
}
@end
