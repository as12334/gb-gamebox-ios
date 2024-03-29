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
#import "RH_BettingRecordCell.h"
#import "RH_API.h"
#import "coreLib.h"
#import "RH_BettingRecordDetailController.h"
#import "RH_BettingInfoModel.h"
#import "RH_CustomViewController.h"
//#import "RH_BettingDetailWebController.h"
@interface RH_BettingRecordViewController ()<BettingRecordHeaderViewDelegate>
@property(nonatomic,strong,readonly) RH_BettingRecordHeaderView *bettingRecordHeaderView ;
@property(nonatomic,strong,readonly) RH_BettingTableHeaderView *bettingTableHeaderView ;
@property(nonatomic,strong,readonly) RH_BettingRecordBottomView *bettingBottomView ;
@property(nonatomic,assign)BOOL isFirstLoad;
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
    self.isFirstLoad = YES;
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
    return 50.f ;
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
    self.contentTableView.allowsSelection = YES ;
    self.contentTableView.allowsMultipleSelection = NO ;
    
    [self.contentTableView registerCellWithClass:[RH_BettingRecordCell class]] ;
    [self.contentView addSubview:self.contentTableView] ;
    
    self.contentTableView.backgroundColor = [UIColor whiteColor];
    [self setupPageLoadManager] ;

}

+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            if ([THEMEV3 isEqualToString:@"green"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            if ([THEMEV3 isEqualToString:@"green"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
            }else{
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
            }
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
                                              NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
    }else{
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            navigationBar.barTintColor = [UIColor blackColor];
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = [UIColor blackColor] ;
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    }
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
    NSString *defaultDateStr1 =  dateStringWithFormatter(_bettingRecordHeaderView.startDate, @"yyyy-MM-dd");
    NSString *defaultDateStr2 =  dateStringWithFormatter(defaultDate, @"yyyy-MM-dd");
    [self showCalendarView:@"设置开始日期"
            initDateString:defaultDateStr1?:defaultDateStr2
                   MinDate:[[NSDate date] dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  bettingRecordHeaderView.startDate = returnDate ;
              }] ;
}

-(void)bettingRecordHeaderViewWillSelectedEndDate:(RH_BettingRecordHeaderView*)bettingRecordHeaderView DefaultDate:(NSDate*)defaultDate
{
    NSString *defaultDateStr1 =  dateStringWithFormatter(_bettingRecordHeaderView.endDate, @"yyyy-MM-dd");
    NSString *defaultDateStr2 =  dateStringWithFormatter(defaultDate, @"yyyy-MM-dd");
    [self showCalendarView:@"设置截止日期"
            initDateString:defaultDateStr1?:defaultDateStr2
                   MinDate:[[NSDate date] dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  bettingRecordHeaderView.endDate = returnDate ;
              }] ;
}

-(void)bettingRecordHeaderViewTouchSearchButton:(RH_BettingRecordHeaderView*)bettingRecordHeaderView
{
    if ( [self compareOneDay:self.bettingRecordHeaderView.startDate withAnotherDay:self.bettingRecordHeaderView.endDate] == 1) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
        return;
    }
    [self startUpdateData] ;
}

#pragma mark-sort table header view
-(RH_BettingTableHeaderView *)bettingTableHeaderView
{
    if (!_bettingTableHeaderView){
        _bettingTableHeaderView = [[RH_BettingTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.contentTableView.frameWidth, 40.0f)] ;
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
                                    EndDate:dateStringWithFormatter(self.bettingRecordHeaderView.endDate, @"yyyy-MM-dd")
                                 PageNumber:page+1
                                   PageSize:pageSize withIsStatistics:page+1==1?true:false] ;
    self.isFirstLoad = page+1==1?true:false;
}

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
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}


#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3BettingList){
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
        if (self.isFirstLoad) {
            [self.bettingBottomView updateUIInfoWithTotalNumber:[dictTmp integerValueForKey:RH_GP_BETTINGLIST_TOTALCOUNT defaultValue:0] SigleAmount:[[dictTmp dictionaryValueForKey:RH_GP_BETTINGLIST_STATISTICSDATA] floatValueForKey:RH_GP_BETTINGLIST_TOTALSINGLE] ProfitAmount:[[dictTmp dictionaryValueForKey:RH_GP_BETTINGLIST_STATISTICSDATA] floatValueForKey:RH_GP_BETTINGLIST_STATISTICSDATA_PROFIT]
                                                      effective:[[dictTmp dictionaryValueForKey:RH_GP_BETTINGLIST_STATISTICSDATA] floatValueForKey:RH_GP_BETTINGLIST_STATISTICSDATA_EFFECTIVE]];
        }
        [self loadDataSuccessWithDatas:[dictTmp arrayValueForKey:RH_GP_BETTINGLIST_LIST]
                            totalCount:[dictTmp integerValueForKey:RH_GP_BETTINGLIST_TOTALCOUNT defaultValue:0]] ;
        
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
        return [RH_BettingRecordCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
    
    return 0.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_BettingRecordCell *bettingRecordCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_BettingRecordCell defaultReuseIdentifier]] ;
        [bettingRecordCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return bettingRecordCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
#if 0
        [self showViewController:[RH_BettingRecordDetailController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]]
                          sender:self] ;
#else
        RH_BettingInfoModel *bettingInfoModel = ConvertToClassPointer(RH_BettingInfoModel, [self.pageLoadManager dataAtIndexPath:indexPath]) ;
        self.appDelegate.customUrl = bettingInfoModel.showDetailUrl ;
        [self showViewController:[RH_CustomViewController viewControllerWithContext:bettingInfoModel] sender:self] ;
#endif
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

@end
