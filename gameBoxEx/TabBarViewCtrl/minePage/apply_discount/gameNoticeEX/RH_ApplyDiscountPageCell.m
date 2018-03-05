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
#import "RH_GameNoticeDetailController.h"
@interface RH_ApplyDiscountPageCell()<RH_ServiceRequestDelegate,MPGameNoticHeaderViewDelegate>
@property(nonatomic,strong,readonly) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
//@property (nonatomic,strong) RH_DiscountActivityTypeModel *typeModel ;
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property (nonatomic,strong,readonly)RH_MPGameNoticHeaderView *headerView;
@property (nonatomic,strong,readonly)RH_MPGameNoticePulldownView *listView;
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
        [self.contentView addSubview:self.headerView];
        self.headerView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(50.f) ;

        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.backgroundColor = colorWithRGB(242, 242, 242);
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentTableView registerCellWithClass:[RH_MPGameNoticeCell class]] ;
        self.contentScrollView = self.contentTableView;
        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
        self.contentTableView.whc_TopSpaceEqualViewOffset(self.headerView, 50).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
        [self setupPageLoadManagerWithdatasContext:context1]  ;
        __block RH_ApplyDiscountPageCell *weakSelf = self;
        self.headerView.block = ^(int number, CGRect frame){
            [weakSelf selectedHeaderViewGameType:frame andMarkNnmber:2];
        };
        self.headerView.kuaixuanBlock = ^(int number, CGRect frame){
            [weakSelf selectedHeaderViewGameType:frame andMarkNnmber:1];
        };
        NSDate *date1 = [[NSDate date] dateWithMoveDay:-30] ;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        self.startDate =  [formatter stringFromDate:date1];
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
    if (self.listView.superview){
        [UIView animateWithDuration:0.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 0;
            self.listView.frame = framee;
        } completion:^(BOOL finished) {
            [self.listView removeFromSuperview];
        }];
    }else
    {
//         [self startUpdateData] ;
        [self showNoRefreshLoadData] ;
    }
}
#pragma mark - 当有数据的时候，隐藏下拉动画
-(void)showNoRefreshLoadData
{
    if ([self.pageLoadManager currentDataCount]){
        [self showProgressIndicatorViewWithAnimated:YES title:nil] ;
    }
    [self startUpdateData:NO] ;
}


-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:ImageWithName(@"empty_searchRec_image")
                                             title:nil
                                        detailText:@"暂无内容，点击重试"] ;
    return YES ;
}

#pragma mark-
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"] ;
    NSDate *defaultStartDate = [[NSDate date] dateWithMoveDay:-30];
    NSDate *selectStareDate = [dateFormatter dateFromString:self.startDate] ;
    self.headerView.startDate =selectStareDate?selectStareDate:[[NSDate date] dateWithMoveDay:-30];
    //默认开始时间
    NSString *defaultStartStr = [dateFormatter stringFromDate:defaultStartDate] ;
    
    NSDate *date = [NSDate date];
    NSString *strDate = [dateFormatter stringFromDate:date];
    [self.serviceRequest startV3LoadGameNoticeStartTime:self.startDate?self.startDate:defaultStartStr
                                                endTime:self.endDate?self.endDate:strDate
                                             pageNumber:page+1
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
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
        RH_GameNoticeModel *gameModel = ConvertToClassPointer(RH_GameNoticeModel, data);
        for (ApiSelectModel *selectModel in gameModel.mApiSelectModel) {
            [self.listView.modelArray addObject:selectModel.mApiName];
            [self.listView.modelIdArray addObject:[NSString stringWithFormat:@"%ld",selectModel.mApiId]];
        }
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
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
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
        frame.origin.y +=30;
        frame.size.width+=100;
        self.listView.frame = frame;
        [self addSubview:self.listView];
        [UIView animateWithDuration:.2f animations:^{
            CGRect framee = CGRectMake(self.listView.frame.origin.x, self.listView.frame.origin.y +2, 100, 200);
            self.listView.frame = framee;
        }];
    }
    else
    {
        [UIView animateWithDuration:.2f animations:^{
            CGRect framee = CGRectMake(self.listView.frame.origin.x, self.listView.frame.origin.y+2, 100, 0);
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
        _listView.modelArray = [NSMutableArray array];
        [_listView.modelArray addObject:@"所有游戏"];
        _listView.backgroundColor = [UIColor redColor];
        _listView.modelIdArray = [NSMutableArray array];
        [_listView.modelIdArray addObject:@""];
        _listView.block = ^(NSInteger apiId){
            if (weakSelf.listView.superview){
                [UIView animateWithDuration:0.2f animations:^{
                    CGRect framee = CGRectMake(weakSelf.listView.frame.origin.x, weakSelf.listView.frame.origin.y +2, 100, 0);
                    framee.size.height = 0;
                    weakSelf.listView.frame = framee;
                } completion:^(BOOL finished) {
                    [weakSelf.listView removeFromSuperview];
                }];
                weakSelf.headerView.gameTypeLabel.text = weakSelf.listView.gameTypeString;
            }
            weakSelf.apiId = apiId;
//            [weakSelf startUpdateData] ;
             [weakSelf showNoRefreshLoadData] ;
        };
    }
    return _listView;
}
#pragma mark- observer Touch gesture
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return (self.listView.superview?YES:NO) ;
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



#pragma mark - CapitalRecordHeaderViewDelegate
-(void)gameNoticHeaderViewStartDateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    ifRespondsSelector(self.delegate, @selector(applyDiscountPageCellStartDateSelected:dateSelected:DefaultDate:)){
        [self.delegate applyDiscountPageCellStartDateSelected:self dateSelected:view DefaultDate:defaultDate];
    }
}
-(void)gameNoticHeaderViewEndDateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    ifRespondsSelector(self.delegate, @selector(applyDiscountPageCellEndDateSelected:dateSelected:DefaultDate:)){
        [self.delegate applyDiscountPageCellEndDateSelected:self dateSelected:view DefaultDate:defaultDate];
    }
}
-(void)cellStartUpdata
{
//     [self startUpdateData] ;
     [self showNoRefreshLoadData] ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listView.superview){
        [UIView animateWithDuration:0.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 0;
            self.listView.frame = framee;
        } completion:^(BOOL finished) {
            [self.listView removeFromSuperview];
        }];
    }else if (self.pageLoadManager.currentDataCount){
        RH_GameNoticeDetailController *detailVC= [RH_GameNoticeDetailController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]];
        [self showViewController:detailVC];
        [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    }
}
@end
