//
//  RH_ShareRecordCollectionViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareRecordCollectionPageCell.h"
#import "RH_ShareRecordTableViewCell.h"
#import "RH_ShowShareRecordViewCell.h"
#import "RH_ServiceRequest.h"
#import "RH_LoadingIndicateTableViewCell.h"
#import "RH_SharePlayerRecommendModel.h"
@interface RH_ShareRecordCollectionPageCell()<RH_ServiceRequestDelegate,RH_ShareRecordTableViewCellDelegate>
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property(nonatomic,strong,readonly) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
@property(nonatomic,strong)RH_SharePlayerRecommendModel *model;

@end

@implementation RH_ShareRecordCollectionPageCell
@synthesize serviceRequest = _serviceRequest;
@synthesize loadingIndicateTableViewCell = _loadingIndicateTableViewCell ;

-(void)updateViewWithType:(RH_SharePlayerRecommendModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    if (self.contentTableView == nil) {
        self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 200) style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.sectionFooterHeight = 10.0f;
        self.contentTableView.sectionHeaderHeight = 10.0f ;
        self.contentTableView.backgroundColor = colorWithRGB(242, 242, 242);
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        [self.contentTableView registerCellWithClass:[RH_ShareRecordTableViewCell class]] ;
        [self.contentTableView registerCellWithClass:[RH_ShowShareRecordViewCell class]];
        self.contentScrollView = self.contentTableView;
        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
        [self setupPageLoadManagerWithdatasContext:context1] ;
        
    }else {
        [self updateWithContext:context];
    }
}


#pragma mark - 初始化serviceRequest
-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc]init];
        _serviceRequest.delegate = self;
    }
    return _serviceRequest;
}
-(RH_SharePlayerRecommendModel *)model
{
    if (!_model) {
        _model = [[RH_SharePlayerRecommendModel alloc] init];
    }
    return _model ;
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
    [self.loadingIndicateView showNothingWithImage:nil title:@"暂无内容"
                                        detailText:@"点击重试"] ;
    return YES ;
}

#pragma mark-  请求数据
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3LoadSharePlayerRecommend] ;
}
#pragma mark - 搜索
-(void)shareRecordTableViewSearchBtnDidTouch:(RH_ShareRecordTableViewCell *)shareRecordTableViewCell
{
    if ( [self compareOneDay:shareRecordTableViewCell.startDate?:[NSDate date] withAnotherDay:shareRecordTableViewCell.endDate?:[NSDate date]] == 1) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
        return;
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _startDate = [dateFormatter stringFromDate:shareRecordTableViewCell.startDate]?:[dateFormatter stringFromDate:date];
    _endDate = [dateFormatter stringFromDate:shareRecordTableViewCell.endDate]?:[dateFormatter stringFromDate:date];
      [self startUpdateData] ;
}

#pragma mark -- 时间比较
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间晚");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay比 anotherDay时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
}

-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeV3SharePlayerRecommend)
    {
        _model = ConvertToClassPointer(RH_SharePlayerRecommendModel, data);
        [self loadDataSuccessWithDatas:_model.mCommendModel
                            totalCount:_model.mCommendModel.count
                        completedBlock:nil];
      
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
    {
        return MAX(1, self.pageLoadManager.currentDataCount) ;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  100 ;
    }else if (indexPath.section ==1){
        return 35 ;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RH_ShareRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_ShareRecordTableViewCell defaultReuseIdentifier] forIndexPath:indexPath] ;
        cell.delegate = self;
        return cell ;
    }else if(indexPath.section == 1){
        if (_model) {
            RH_ShowShareRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_ShowShareRecordViewCell defaultReuseIdentifier] forIndexPath:indexPath] ;
            if (indexPath.row%2 == 0) {
                cell.topView.backgroundColor = [UIColor whiteColor] ;
            }else
            {
                cell.topView.backgroundColor =  colorWithRGB(228, 235, 247) ;
            }
            [cell updateCellWithInfo:nil context:_model];
            return cell ;
        }else
        {
            return  self.loadingIndicateTableViewCell;
        }
       
    }
    return nil;
    
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

#pragma mark -- RH_ShareRecordTableViewCellDelegate
//搜索
-(void)shareRecordTableViewSearchBtnDidTouchBackButton:(RH_ShareRecordTableViewCell *)shareRecordTableViewCell
{
     [self startUpdateData] ;
}
//开始时间
-(void)shareRecordTableViewWillSelectedStartDate:(RH_ShareRecordTableViewCell *)shareRecordTableView DefaultDate:(NSDate *)defaultDate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RH_ShareRecodStartDate_NT" object:@[self,shareRecordTableView,defaultDate?:[NSDate date]]];
}

//截止时间
-(void)shareRecordTableViewWillSelectedEndDate:(RH_ShareRecordTableViewCell *)shareRecordTableView DefaultDate:(NSDate *)defaultDate
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"RH_ShareRecodEndDate_NT" object:@[self,shareRecordTableView,defaultDate?:[NSDate date]]];
}
@end
