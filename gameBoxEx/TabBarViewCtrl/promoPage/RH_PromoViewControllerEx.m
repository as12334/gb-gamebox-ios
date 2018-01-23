//
//  RH_PromoViewControllerEx.m
//  gameBoxEx
//
//  Created by luis on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PromoViewControllerEx.h"
#import "RH_PromoTypeHeaderView.h"
#import "RH_PromoContentPageCell.h"
#import "coreLib.h"
#import "RH_DiscountActivityTypeModel.h"

@interface RH_PromoViewControllerEx ()<CLPageViewDelegate,CLPageViewDatasource,PromoTypeHeaderViewDelegate>
@property(nonatomic,strong,readonly) RH_PromoTypeHeaderView *typeTopView  ;
@property(nonatomic,strong,readonly) CLPageView *pageView ;
@property(nonatomic,strong,readonly) NSMutableDictionary *dictPageCellDataContext ; //存储 pagecell data content ;
@end

@implementation RH_PromoViewControllerEx
@synthesize typeTopView = _typeTopView ;
@synthesize pageView = _pageView ;
@synthesize dictPageCellDataContext = _dictPageCellDataContext ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBarItem.leftBarButtonItem = self.logoButtonItem      ;
    self.title = @"优惠" ;
    //增加login status changed notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    
    //初始化 优惠类别信息
    [self loadingIndicateViewDidTap:nil] ;
}

-(void)setupInfo
{
    self.typeTopView.frame = CGRectMake(0, StatusBarHeight+NavigationBarHeight, MainScreenW, self.typeTopView.viewHeight) ;
    self.typeTopView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.typeTopView] ;
    self.typeTopView.selectedIndex = 0 ;
    
    //分页视图
    self.pageView.frame = CGRectMake(10,
                                     self.typeTopView.frameY + self.typeTopView.frameHeigh + 10,
                                     MainScreenW-20,
                                     MainScreenH - (self.typeTopView.frameY + self.typeTopView.frameHeigh + 10 + TabBarHeight)) ;
    self.pageView.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin ;
    [self.contentView addSubview:self.pageView];
    
    //注册复用
    [self.pageView registerCellForPage:[RH_PromoContentPageCell class] andReuseIdentifier:[RH_PromoContentPageCell defaultReuseIdentifier]] ;

    //设置索引
    self.pageView.dispalyPageIndex = self.typeTopView.selectedIndex;
}

#pragma mark -
-(NSMutableDictionary *)dictPageCellDataContext
{
    if (!_dictPageCellDataContext){
        _dictPageCellDataContext = [[NSMutableDictionary alloc] init] ;
    }
    
    return _dictPageCellDataContext ;
}

#pragma mark - type header View
-(RH_PromoTypeHeaderView *)typeTopView
{
    if (!_typeTopView){
        _typeTopView = [RH_PromoTypeHeaderView createInstance] ;
        _typeTopView.delegate = self ;
    }
    
    return _typeTopView ;
}

-(void)promoTypeHeaderViewDidChangedSelectedIndex:(RH_PromoTypeHeaderView*)promoTypeHeaderView SelectedIndex:(NSInteger)selectedIndex
{
    self.pageView.dispalyPageIndex = selectedIndex ;
}

#pragma mark -
-(void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"数据请求中" detailText:@"请稍等..."] ;
    [self.serviceRequest startV3LoadDiscountActivityType] ;
}


#pragma mark -pageView
-(CLPageView*)pageView
{
    if (!_pageView){
        _pageView = [[CLPageView alloc] initWithFrame:self.contentView.bounds];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        _pageView.delegate = self ;
        _pageView.dataSource = self ;
        _pageView.pageMargin = 5.0f;
    }
    
    return _pageView ;
}

- (NSUInteger)numberOfPagesInPageView:(CLPageView *)pageView
{
    return self.typeTopView.allTypes  ;
}

- (UICollectionViewCell *)pageView:(CLPageView *)pageView cellForPageAtIndex:(NSUInteger)pageIndex
{
    RH_PromoContentPageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_PromoContentPageCell defaultReuseIdentifier] forPageIndex:pageIndex];
    [cell updateViewWithType:[self.typeTopView typeModelWithIndex:pageIndex] Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
    return cell;
}

- (void)pageView:(CLPageView *)pageView didDisplayPageAtIndex:(NSUInteger)pageIndex
{
    self.typeTopView.selectedIndex = pageIndex ;
}

- (void)pageView:(CLPageView *)pageView didEndDisplayPageAtIndex:(NSUInteger)pageIndex
{
    [self _savePageLoadDatasContextAtPageIndex:pageIndex] ;
}

- (void)pageViewWillReloadPages:(CLPageView *)pageView {
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
    RH_PromoContentPageCell * cell = [self.pageView cellForPageAtIndex:pageIndex];
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


#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3PromoActivityType){
        NSArray *typeList = ConvertToClassPointer(NSArray , data) ;
        [self.typeTopView updateView:typeList] ;
        [self.contentLoadingIndicateView hiddenView] ;
        [self setupInfo] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3PromoActivityType){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}

@end
