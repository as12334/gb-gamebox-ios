//
//  RH_ApplyDiscountSystemPageCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountSystemPageCell.h"
#import "RH_MPSystemNoticeCell.h"
#import "RH_LoadingIndicateTableViewCell.h"
#import "RH_SystemNoticeListView.h"
#import "RH_MPSystemNoticHeaderView.h"
#import "RH_MPSystemNoticeDetailController.h"
#import "coreLib.h"
#import "RH_API.h"
@interface RH_ApplyDiscountSystemPageCell()<RH_ServiceRequestDelegate,MPSystemNoticHeaderViewDelegate>
@property(nonatomic,strong,readonly) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property (nonatomic,strong,readonly)RH_MPSystemNoticHeaderView *headerView;
@property (nonatomic,strong,readonly)RH_SystemNoticeListView *listView;
@property (nonatomic,assign)NSInteger apiId;
@property(nonatomic,strong)NSArray *dataArr ;
@end

@implementation RH_ApplyDiscountSystemPageCell
@synthesize loadingIndicateTableViewCell = _loadingIndicateTableViewCell ;
@synthesize serviceRequest = _serviceRequest;
@synthesize headerView = _headerView;
@synthesize listView = _listView;

-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    if (self.contentTableView == nil) {
        [self.contentView addSubview:self.headerView];
        self.headerView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(50) ;
        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.backgroundColor = colorWithRGB(242, 242, 242);
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentTableView registerCellWithClass:[RH_MPSystemNoticeCell class]] ;
        self.contentScrollView = self.contentTableView;
        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
        self.contentTableView.whc_TopSpaceEqualViewOffset(self.headerView, 50).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
        [self setupPageLoadManagerWithdatasContext:context1] ;
        __block RH_ApplyDiscountSystemPageCell *weakSelf = self;
        self.headerView.block = ^(CGRect frame){
             [weakSelf selectedHeaderViewGameType:frame];
        };
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
//    [self startUpdateData] ;
      [self showNoRefreshLoadData] ;
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
//    NSDate *date = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *strDate = [dateFormatter stringFromDate:date];
    
//    NSDate *selectStareDate = [dateFormatter dateFromString:self.startDate] ;
//    self.headerView.startDate =selectStareDate?selectStareDate:[[NSDate date] dateWithMoveDay:-30];
//    //默认开始时间
//    NSString *defaultStartStr = [dateFormatter stringFromDate:dateFormatter] ;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"] ;
    NSDate *defaultStartDate = [[NSDate date] dateWithMoveDay:-30];
    NSDate *selectStareDate = [dateFormatter dateFromString:self.startDate] ;
    self.headerView.startDate =selectStareDate?selectStareDate:[[NSDate date] dateWithMoveDay:-30];
    //默认开始时间
    NSString *defaultStartStr = [dateFormatter stringFromDate:defaultStartDate] ;
    
    NSDate *date = [NSDate date];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    [self.serviceRequest startV3LoadSystemNoticeStartTime:self.startDate?self.startDate:defaultStartStr endTime:self.endDate?self.endDate:strDate pageNumber:page+1 pageSize:pageSize];
}

-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeV3SystemNotice)
    {
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
        [self loadDataSuccessWithDatas:[dictTmp arrayValueForKey:RH_GP_SYSTEMNOTICE_LIST] totalCount:[dictTmp integerValueForKey:RH_GP_SYSTEMNOTICE_TOTALNUM] completedBlock:nil];
        [self.contentTableView reloadData];
    }
}


- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type==ServiceRequestTypeV3SystemNotice )
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
        return [RH_MPSystemNoticeCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        return tableView.boundHeigh - tableView.contentInset.top - tableView.contentInset.bottom ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_MPSystemNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_MPSystemNoticeCell defaultReuseIdentifier]] ;
        [cell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return cell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}

#pragma mark headerView
-(RH_MPSystemNoticHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPSystemNoticHeaderView createInstance];
        _headerView.frame  = CGRectMake(0, 0, self.frameWidth, 50);
        _headerView.delegate=self;
    }
    return _headerView;
}
-(void)selectedHeaderViewGameType:(CGRect )frame
{
    if (!self.listView.superview) {
        frame.origin.y +=self.contentTableView.frameY -20.f;
        self.listView.frame = frame;
        [self addSubview:self.listView];
        [UIView animateWithDuration:.2f animations:^{
            CGRect frame = CGRectMake(self.listView.frame.origin.x, self.listView.frame.origin.y +2, self.listView.frame.size.width*1.5, 200);
            self.listView.frame = frame;
        }];
    }
    else
    {
        [UIView animateWithDuration:.2f animations:^{
            CGRect frame = CGRectMake(self.listView.frame.origin.x, self.listView.frame.origin.y +2, self.listView.frame.size.width*1.5, 0);
            self.listView.frame = frame;
        } completion:^(BOOL finished) {
            [self.listView removeFromSuperview];
        }];
    }
}
#pragma mark 点击headerview的游戏类型
-(RH_SystemNoticeListView *)listView
{
    if (!_listView) {
        __block RH_ApplyDiscountSystemPageCell *weakSelf = self;
        _listView = [[RH_SystemNoticeListView alloc]init];
        _listView.kuaixuanBlock = ^(NSInteger row){
            if (weakSelf.listView.superview){
                [UIView animateWithDuration:0.2f animations:^{
                    CGRect frame = CGRectMake(weakSelf.listView.frame.origin.x, weakSelf.listView.frame.origin.y +2, weakSelf.listView.frame.size.width*1.5, 0);
                    weakSelf.listView.frame = frame;
                } completion:^(BOOL finished) {
                    [weakSelf.listView removeFromSuperview];
                }];
            }
            weakSelf.startDate = [weakSelf changedSinceTimeString:row][0];
            weakSelf.endDate = [weakSelf changedSinceTimeString:row][1];
//            [weakSelf startUpdateData] ;
            [weakSelf showNoRefreshLoadData] ;
        };
    }
    return _listView;
}

#pragma mark - CapitalRecordHeaderViewDelegate
-(void)gameSystemHeaderViewStartDateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    
    ifRespondsSelector(self.delegate, @selector(applyDiscountSystemStartDateSelected:dateSelected:DefaultDate:)){
        [self.delegate applyDiscountSystemStartDateSelected:self dateSelected:view DefaultDate:defaultDate];
    }
}
-(void)gameSystemHeaderViewEndDateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    ifRespondsSelector(self.delegate, @selector(applyDiscountPageCellEndDateSelected:dateSelected:DefaultDate:)){
        [self.delegate applyDiscountSystemEndDateSelected:self dateSelected:view DefaultDate:defaultDate];
    }
}
-(void)cellStartUpdata
{
//    [self startUpdateData] ;
    [self showNoRefreshLoadData] ;
}

#pragma mark - 当有数据的时候，隐藏下拉动画
-(void)showNoRefreshLoadData
{
    if ([self.pageLoadManager currentDataCount]){
        [self showProgressIndicatorViewWithAnimated:YES title:nil] ;
    }
    [self startUpdateData:NO] ;
}

#pragma mark 修改时间
-(NSArray *)changedSinceTimeString:(NSInteger)row
{
    NSDate *date = [[NSDate alloc]init];
    //获取本周的日期
    NSArray *currentWeekarr = [self getWeekTimeOfCurrentWeekDay];
    NSArray *lastWeekArr = [self getWeekTimeOfLastWeekDay];
    switch (row) {
        case 0:
            //今天
            date= [[NSDate date] dateWithMoveDay:0];
            _headerView.endDate = date;
            break;
        case 1:
            //昨天
            date= [[NSDate date] dateWithMoveDay:-1];
            _headerView.endDate = date;
            break;
        case 2:
            //本周
            date = currentWeekarr[0];
            _headerView.endDate = currentWeekarr[1];
            break;
        case 3:
            //上周
            date = lastWeekArr[0];
            _headerView.endDate = lastWeekArr[1];
            break;
        case 4:
            //本月
            date= [self dateFromDateFirstDay];
            _headerView.endDate = [self getMonthEndDate];
            break;
        case 5:
            //最近7天
            date= [[NSDate date] dateWithMoveDay:-7];
            _headerView.endDate = [date  dateWithMoveDay:+7];
            break;
        case 6:
            //最近三十天
            date= [[NSDate date] dateWithMoveDay:-30];
            _headerView.endDate = [date  dateWithMoveDay:+30];
            break;
            
        default:
            break;
    }
    _headerView.startDate = date;
    NSString *beforDate = dateStringWithFormatter(date, @"yyyy-MM-dd ");
    NSString *endDate = dateStringWithFormatter(_headerView.endDate, @"yyyy-MM-dd") ;
    return @[beforDate,endDate];
}

#pragma mark - 获取当前月1号
- (NSDate *)dateFromDateFirstDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *str1 =  [currentDateString substringWithRange:NSMakeRange(7, 3)];
    NSString *str2 = [currentDateString stringByReplacingOccurrencesOfString:str1 withString:@"-01"];
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"yyyy-MM-dd";
    //NSString转NSDate
    NSDate *date = [formatter dateFromString:str2] ;
    return date;
}

#pragma mark -  获取当前周的周一周日的时间
- (NSArray *)getWeekTimeOfCurrentWeekDay
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    // 在当前日期(去掉时分秒)基础上加上差的天数
    [comp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:comp];
    [comp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:comp];
    NSArray *dateArr = @[firstDayOfWeek,lastDayOfWeek];
    return dateArr;
}

#pragma mark -  获取上一周的周一周日的时间
- (NSArray *)getWeekTimeOfLastWeekDay
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    NSInteger lastDay = day - 7;
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay +1;
        lastDiff = 8 - weekDay;
    }
    // 在当前日期(去掉时分秒)基础上加上差的天数
    [comp setDay:lastDay + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:comp];
    [comp setDay:lastDay + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:comp];
    NSArray *dateArr = @[firstDayOfWeek,lastDayOfWeek];
    return dateArr;
}

#pragma mark - 获取本月最后一天
- (NSDate *)getMonthEndDate
{
    NSDate *newDate=[NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSCalendarUnitMonth NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY-MM-dd"];
    return endDate;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_MPSystemNoticeDetailController *detailVC= [RH_MPSystemNoticeDetailController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]];
        [self showViewController:detailVC];
        [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    }
}
@end
