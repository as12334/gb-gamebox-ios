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

@interface RH_PromoViewControllerEx ()<CLPageViewDelegate,CLPageViewDatasource>
@property(nonatomic,strong,readonly) RH_PromoTypeHeaderView *typeTopView  ;
@property(nonatomic,strong,readonly) CLPageView *pageView ;
@end

@implementation RH_PromoViewControllerEx
@synthesize typeTopView = _typeTopView ;
@synthesize pageView = _pageView ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarItem.leftBarButtonItem = self.logoButtonItem      ;
    [self setNeedUpdateView] ;
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    
    //初始化 优惠类别信息
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"数据请求中" detailText:@"请稍等..."] ;
    [self.serviceRequest startV3LoadDiscountActivityType] ;
}

-(BOOL)hasTopView{
    return NO ;
}


-(void)setupInfo
{
    self.typeTopView.frame = CGRectMake(0, StatusBarHeight+NavigationBarHeight, MainScreenW, self.typeTopView.viewHeight) ;
    self.typeTopView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.typeTopView] ;
    
    //分页视图
    [self.contentView addSubview:self.pageView];
    //注册复用
    [self.pageView registerCellForPage:[RH_PromoContentPageCell class] andReuseIdentifier:[RH_PromoContentPageCell defaultReuseIdentifier]] ;

    //设置索引
    self.pageView.dispalyPageIndex = self.typeTopView.selectedType;
}

-(void)updateView
{
    if (self.appDelegate.isLogin){
        self.navigationBarItem.rightBarButtonItems = @[self.userInfoButtonItem] ;
    }else{
        self.navigationBarItem.rightBarButtonItems = @[self.signButtonItem,self.loginButtonItem] ;
    }
}

#pragma mark-
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self setNeedUpdateView] ;
    }
}

#pragma mark - type header View
-(RH_PromoTypeHeaderView *)typeTopView
{
    if (!_typeTopView){
        _typeTopView = [RH_PromoTypeHeaderView createInstance] ;
    }
    
    return _typeTopView ;
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

    [cell updateViewWithType:nil Context:nil] ;
    return cell;
}

- (void)pageView:(CLPageView *)pageView didDisplayPageAtIndex:(NSUInteger)pageIndex
{
    self.typeTopView.selectedType = pageIndex ;
}

- (void)pageView:(CLPageView *)pageView didEndDisplayPageAtIndex:(NSUInteger)pageIndex {
}

- (void)pageViewWillReloadPages:(CLPageView *)pageView {
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
