//
//  RH_ApplyDiscountViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountViewController.h"
#import "RH_ApplyDiscountHeaderView.h"
#import "coreLib.h"
#import "RH_ApplyDiscountPageCell.h"
#import "RH_ApplyDiscountSystemPageCell.h"
#import "RH_ApplyDiscountSitePageCell.h"
#import "RH_SiteMessageModel.h"

@interface RH_ApplyDiscountViewController ()<CLPageViewDelegate,CLPageViewDatasource,discountTypeHeaderViewDelegate,ApplyDiscountPageCellDelegate,ApplyDiscountSystemPageCellDelegate>
@property(nonatomic,strong,readonly)RH_ApplyDiscountHeaderView *headerView;
@property(nonatomic,strong,readonly) CLPageView *pageView ;
@property(nonatomic,strong,readonly) NSMutableDictionary *dictPageCellDataContext ; 
@end

@implementation RH_ApplyDiscountViewController
@synthesize headerView = _headerView;
@synthesize pageView = _pageView ;
@synthesize dictPageCellDataContext = _dictPageCellDataContext ;

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
    [super viewWillAppear:animated] ;
    [self.serviceRequest startV3LoadMessageCenterSiteMessageUnReadCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"申请优惠";
    
    //初始化 优惠类别信息
//    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"数据请求中" detailText:@"请稍等..."] ;
//    [self.serviceRequest startV3LoadDiscountActivityType] ;
    
    [self createUI];
}
-(void)createUI{
    self.headerView.frame = CGRectMake(0,0, self.contentView.frameWidth, 63);
    [self.topView addSubview:self.headerView];
    
    NSArray *typeList =@[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
    [self.headerView updateView:typeList] ;
    
    //分页视图
    [self.contentView addSubview:self.pageView];
    
    //注册复用
    [self.pageView registerCellForPage:[RH_ApplyDiscountPageCell class] andReuseIdentifier:[RH_ApplyDiscountPageCell defaultReuseIdentifier]] ;
     [self.pageView registerCellForPage:[RH_ApplyDiscountSystemPageCell class] andReuseIdentifier:[RH_ApplyDiscountSystemPageCell defaultReuseIdentifier]] ;
    [self.pageView registerCellForPage:[RH_ApplyDiscountSitePageCell class] andReuseIdentifier:[RH_ApplyDiscountSitePageCell defaultReuseIdentifier]];
    //设置索引
    self.pageView.dispalyPageIndex =  _selectedIndex ;//self.headerView.segmentedControl.selectedSegmentIndex;
}
#pragma mark --- 头视图
-(RH_ApplyDiscountHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_ApplyDiscountHeaderView createInstance];
        _headerView.delegate= self;
        _headerView.selectedIndex = self.selectedIndex;
        
    }
    return _headerView;
}
#pragma mark 离开此控制器，移除通知
-(void)viewWillDisappear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 分页视图
-(CLPageView *)pageView
{
    if (!_pageView) {
        _pageView = [[CLPageView alloc] initWithFrame:CGRectMake(0, 63+NavigationBarHeight + 10 + 15, MainScreenW, MainScreenH-63-NavigationBarHeight-StatusBarHeight)];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        _pageView.delegate = self ;
        _pageView.dataSource = self ;
        _pageView.pageMargin = 5.0f;
    }
    return _pageView;
}
#pragma mark --初始化字典
-(NSMutableDictionary *)dictPageCellDataContext
{
    if (!_dictPageCellDataContext){
        _dictPageCellDataContext = [[NSMutableDictionary alloc] init] ;
    }
    
    return _dictPageCellDataContext ;
}
- (NSUInteger)numberOfPagesInPageView:(CLPageView *)pageView
{
    return 3  ;
}

- (UICollectionViewCell *)pageView:(CLPageView *)pageView cellForPageAtIndex:(NSUInteger)pageIndex
{
    if (pageIndex ==0) {
        RH_ApplyDiscountPageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ApplyDiscountPageCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:[self.headerView typeModelWithIndex:pageIndex] Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
        cell.delegate = self;
        return cell;
    }
    else if (pageIndex==1){
        RH_ApplyDiscountSystemPageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ApplyDiscountSystemPageCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:[self.headerView typeModelWithIndex:pageIndex] Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
        cell.delegate=self;
        return cell;
    }
    else if (pageIndex ==2)
    {
        RH_ApplyDiscountSitePageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ApplyDiscountSitePageCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:[self.headerView typeModelWithIndex:pageIndex] Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex] andSelectedIndex:_selectedIndex] ;
        return cell;
    }
    return nil;
    
}
#pragma mark cell的代理
-(void)applyDiscountPageCellStartDateSelected:(RH_ApplyDiscountPageCell *)cell dateSelected:(RH_MPGameNoticHeaderView*)view DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置开始日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
                   MinDate:[[NSDate date]dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  view.startDate = returnDate ;
                  cell.startDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
                  [cell startUpdateData];
              }] ;
}
-(void)applyDiscountPageCellEndDateSelected:(RH_ApplyDiscountPageCell *)cell dateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置结束日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
                   MinDate:[[NSDate date]dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  view.endDate = returnDate ;
                  cell.endDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
                  [cell startUpdateData];
              }] ;
}
#pragma mark --
-(void)applyDiscountSystemStartDateSelected:(RH_ApplyDiscountSystemPageCell *)cell dateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置开始日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
                   MinDate:[[NSDate date]dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  view.startDate = returnDate ;
                  cell.startDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
                  [cell startUpdateData];
              }] ;
}
-(void)applyDiscountSystemEndDateSelected:(RH_ApplyDiscountSystemPageCell *)cell dateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置结束日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
                   MinDate:[[NSDate date]dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  view.endDate = returnDate ;
                  cell.endDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
                  [cell startUpdateData];
              }] ;
}

#pragma mark -- 滑动
- (void)pageView:(CLPageView *)pageView didDisplayPageAtIndex:(NSUInteger)pageIndex
{
    self.headerView.segmentedControl.selectedSegmentIndex = pageIndex;
}

- (void)pageView:(CLPageView *)pageView didEndDisplayPageAtIndex:(NSUInteger)pageIndex
{
//    [self _savePageLoadDatasContextAtPageIndex:pageIndex] ;
}

- (void)pageViewWillReloadPages:(CLPageView *)pageView {

}
#pragma mark - 点击
-(void)DiscountTypeHeaderViewDidChangedSelectedIndex:(RH_ApplyDiscountHeaderView*)discuntTypeHeaderView SelectedIndex:(NSInteger)selectedIndex
{
    self.pageView.dispalyPageIndex = selectedIndex ;
}
#pragma mark-pageload context
- (CLPageLoadDatasContext *)_pageLoadDatasContextForPageAtIndex:(NSUInteger)pageIndex
{
    NSString *key = [NSString stringWithFormat:@"%ld",pageIndex] ;
    CLPageLoadDatasContext * context = self.dictPageCellDataContext[key];
    if (context == nil) {
        context = [[CLPageLoadDatasContext alloc] initWithDatas:nil context:nil];
    }
    
    return context;
}

- (void)_savePageLoadDatasContextAtPageIndex:(NSUInteger)pageIndex
{
    RH_ApplyDiscountPageCell * cell = [self.pageView cellForPageAtIndex:pageIndex];
    if (cell != nil) {
        CLPageLoadDatasContext * context = (id)[cell currentPageContext];
        NSString *key = [NSString stringWithFormat:@"%ld",pageIndex] ;
        if (context) {
            [self.dictPageCellDataContext setObject:context forKey:key] ;
        }else {
            [self.dictPageCellDataContext removeObjectForKey:key];
        }
    }
}


@end
