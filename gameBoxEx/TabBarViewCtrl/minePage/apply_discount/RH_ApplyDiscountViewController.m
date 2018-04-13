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
@property(nonatomic,strong)RH_ApplyDiscountPageCell *gameCell;
@property(nonatomic,strong)RH_ApplyDiscountSystemPageCell *systemCell;
@property(nonatomic,strong)RH_ApplyDiscountSitePageCell *sendCell;
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
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NT_LoginStatusChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self loginButtonItemHandle] ;
    }] ;
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
                navigationBar.barTintColor = ColorWithNumberRGB(0x1766bb) ;
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
                backgroundView.backgroundColor = ColorWithNumberRGB(0x1766bb) ;
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
-(void)TouchSegmentedControlAndRemoveSuperView:(RH_ApplyDiscountHeaderView *)discountTypeHeaderView
{
    [self.gameCell.listView removeFromSuperview];
    [self.systemCell.listView removeFromSuperview];
    [self.sendCell.siteSendCell.listView removeFromSuperview];
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
        _gameCell = cell;
        return cell;
    }
    else if (pageIndex==1){
        RH_ApplyDiscountSystemPageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ApplyDiscountSystemPageCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:[self.headerView typeModelWithIndex:pageIndex] Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
        cell.delegate=self;
        _systemCell = cell;
        return cell;
    }
    else if (pageIndex ==2)
    {
        RH_ApplyDiscountSitePageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_ApplyDiscountSitePageCell defaultReuseIdentifier] forPageIndex:pageIndex];
        [cell updateViewWithType:[self.headerView typeModelWithIndex:pageIndex] Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex] andSelectedIndex:_selectedIndex] ;
        _sendCell = cell;
        return cell;
    }
    return nil;
    
}
#pragma mark cell的代理
-(void)applyDiscountPageCellStartDateSelected:(RH_ApplyDiscountPageCell *)cell dateSelected:(RH_MPGameNoticHeaderView*)view DefaultDate:(NSDate *)defaultDate
{
    NSString *defaultDateStr1 =  dateStringWithFormatter(view.startDate, @"yyyy-MM-dd 00:00");
    NSString *defaultDateStr2 =  dateStringWithFormatter(defaultDate, @"yyyy-MM-dd 00:00");

    [self showCalendarView:@"设置开始日期"
            initDateString:defaultDateStr1?:defaultDateStr2
                   MinDate:[[NSDate date]dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  view.startDate = returnDate ;
                  cell.startDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
//                  [cell startUpdateData];
                  [cell startUpdateData:NO];
//                  [self showProgressIndicatorViewWithAnimated:YES title:nil];
              }] ;
}
-(void)applyDiscountPageCellEndDateSelected:(RH_ApplyDiscountPageCell *)cell dateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    NSString *defaultDateStr1 =  dateStringWithFormatter(view.endDate, @"yyyy-MM-dd 00:00");
    NSString *defaultDateStr2 =  dateStringWithFormatter(defaultDate, @"yyyy-MM-dd 00:00");
    [self showCalendarView:@"设置结束日期"
            initDateString:defaultDateStr1?:defaultDateStr2
                   MinDate:[[NSDate date]dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  view.endDate = returnDate ;
                  cell.endDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
//                  [cell startUpdateData];
                  [cell startUpdateData:NO];
//                  [self showProgressIndicatorViewWithAnimated:YES title:nil];
              }] ;
}


#pragma mark --
-(void)applyDiscountSystemStartDateSelected:(RH_ApplyDiscountSystemPageCell *)cell dateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    NSString *defaultDateStr1 =  dateStringWithFormatter(view.startDate, @"yyyy-MM-dd 00:00");
    NSString *defaultDateStr2 =  dateStringWithFormatter(defaultDate, @"yyyy-MM-dd 00:00");
    [self showCalendarView:@"设置开始日期"
            initDateString:defaultDateStr1?:defaultDateStr2
                   MinDate:[[NSDate date]dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  view.startDate = returnDate ;
                  cell.startDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
//                  [cell startUpdateData];
                  [cell startUpdateData:NO];
//                  [self showProgressIndicatorViewWithAnimated:YES title:nil];
              }] ;
}
-(void)applyDiscountSystemEndDateSelected:(RH_ApplyDiscountSystemPageCell *)cell dateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    NSString *defaultDateStr1 =  dateStringWithFormatter(view.endDate, @"yyyy-MM-dd 00:00");
    NSString *defaultDateStr2 =  dateStringWithFormatter(defaultDate, @"yyyy-MM-dd 00:00");
    [self showCalendarView:@"设置结束日期"
            initDateString:defaultDateStr1?:defaultDateStr2
                   MinDate:[[NSDate date]dateWithMoveDay:-30]
                   MaxDate:[NSDate date]
              comfirmBlock:^(NSDate *returnDate) {
                  view.endDate = returnDate ;
                  cell.endDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
//                  [cell startUpdateData];
                  [cell startUpdateData:NO];
//                  [self showProgressIndicatorViewWithAnimated:YES title:nil];
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
