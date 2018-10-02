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
#import "RH_UserInfoManager.h"
#import "RH_PromoDetailViewController.h"
#import "GameWebViewController.h"
#import "CheckTimeManager.h"
#import "JPUSHService.h"

@interface RH_PromoViewControllerEx ()<CLPageViewDelegate,CLPageViewDatasource,PromoTypeHeaderViewDelegate,PromoContentPageCellDelegate>
@property(nonatomic,strong,readonly) RH_PromoTypeHeaderView *typeTopView  ;
@property(nonatomic,strong,readonly) CLPageView *pageView ;
@property(nonatomic,strong,readonly) NSMutableDictionary *dictPageCellDataContext ; //存储 pagecell data content ;
@property(nonatomic,strong)NSArray *typrlistArray;
@end

@implementation RH_PromoViewControllerEx
@synthesize typeTopView = _typeTopView ;
@synthesize pageView = _pageView ;
@synthesize dictPageCellDataContext = _dictPageCellDataContext ;

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

//-(void)viewWillAppear:(BOOL)animated
//{
//    //初始化 优惠类别信息
//    [self loadingIndicateViewDidTap:nil] ;
//}
- (void)viewDidLoad {
    [super viewDidLoad];

//   Do any additional setup after loading the view.
//    self.navigationBarItem.leftBarButtonItem = self.logoButtonItem      ;
    self.title = @"优惠" ;
    //增加login status changed notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
//    if ([THEMEV3 isEqualToString:@"black"]) {
        self.view.backgroundColor = colorWithRGB(234, 234, 234);
//    }
//    self.view.backgroundColor = [UIColor lightGrayColor];
//    if ([THEMEV3 isEqualToString:@"black"]) {
//        self.view.backgroundColor = [UIColor blackColor];
//    }
    //初始化 优惠类别信息
    [self loadingIndicateViewDidTap:nil] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reOpenH5:) name:@"GB_Retry_Open_H5" object:nil];

}

- (void)reOpenH5:(NSNotification *)notification
{
    NSDictionary *obj = notification.object;
    NSString *target = [obj objectForKey:@"targetController"];
    if ([target isEqualToString:@"promoView"]) {
        RH_DiscountActivityModel *discountActivityModel = [[obj objectForKey:@"data"] firstObject];
        GameWebViewController *gameViewController = [[GameWebViewController alloc] initWithNibName:nil bundle:nil];
        gameViewController.hideMenuView = YES;
        NSString *checkType = [[self.appDelegate.checkType componentsSeparatedByString:@"+"] firstObject];
        gameViewController.url = [NSString stringWithFormat:@"%@://%@%@",checkType,self.appDelegate.demainName,discountActivityModel.mUrl];
        
        [self.navigationController pushViewController:gameViewController animated:YES];
    }
}
    
-(void)setupInfo
{
//    self.typeTopView.frame = CGRectMake(0, StatusBarHeight+NavigationBarHeight, MainScreenW, self.typeTopView.viewHeight) ;
//    self.typeTopView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
//    [self.view addSubview:self.typeTopView] ;
//    self.typeTopView.selectedIndex = 0 ;
//
//    //分页视图
//    self.pageView.frame = CGRectMake(10,
//                                     self.typeTopView.frameY + self.typeTopView.frameHeigh + 10,
//                                     MainScreenW-20,
//                                     MainScreenH - (self.typeTopView.frameY + self.typeTopView.frameHeigh + 10 + TabBarHeight)) ;
//    self.pageView.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin ;
//    [self.contentView addSubview:self.pageView];
    
    [self.view addSubview:self.typeTopView] ;
    [self.contentView addSubview:self.pageView] ;
    [self updateLayout] ;
    self.typeTopView.selectedIndex = 0 ;
    
    //注册复用
    [self.pageView registerCellForPage:[RH_PromoContentPageCell class] andReuseIdentifier:[RH_PromoContentPageCell defaultReuseIdentifier]] ;
    
    //设置索引
    self.pageView.dispalyPageIndex = self.typeTopView.selectedIndex;
}

-(void)updateLayout
{
    self.typeTopView.whc_TopSpace(heighStatusBar+NavigationBarHeight).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(self.typeTopView.viewHeight) ;
    self.pageView.whc_TopSpace(heighStatusBar + NavigationBarHeight + self.typeTopView.viewHeight +10).whc_LeftSpace(10).whc_RightSpace(10).whc_BottomSpace(TabBarHeight) ;
   
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

#pragma mark- RH_PromoContentPageCell delegate
-(void)promoContentPageCellDidTouchCell:(RH_PromoContentPageCell*)promoContentPageCell CellModel:(RH_DiscountActivityModel *)discountActivityModel
{
    RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    
    if (appDelegate.demainName == nil && [CheckTimeManager shared].lotteryLineCheckFail == NO) {
        //线路正在检测 则提示 正在获取可用线路 请稍后
        showErrorMessage(self.view, nil, @"正在获取可用线路 请稍后");
        return ;
    }
    if ([CheckTimeManager shared].lotteryLineCheckFail) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GB_Retry_H5_Host" object:@{@"targetController":@"promoView",@"data":@[discountActivityModel]}];
        return ;
    }

    GameWebViewController *gameViewController = [[GameWebViewController alloc] initWithNibName:nil bundle:nil];
    gameViewController.hideMenuView = YES;
    NSString *checkType = [[self.appDelegate.checkType componentsSeparatedByString:@"+"] firstObject];
    gameViewController.url = [NSString stringWithFormat:@"%@://%@%@",checkType,self.appDelegate.demainName,discountActivityModel.mUrl];
    
    [self.navigationController pushViewController:gameViewController animated:YES];
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
    cell.delegate = self ;
    
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
        if (_typeTopView.allTypes==0){
            NSArray *typeList = ConvertToClassPointer(NSArray , data) ;
            [self.typeTopView updateView:typeList] ;
            [self.contentLoadingIndicateView hiddenView] ;
            [self setupInfo] ;
            self.typrlistArray = typeList;
        }else{
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                NSArray *typeList = ConvertToClassPointer(NSArray , data) ;
                [self.typeTopView updateView:typeList] ;
            }] ;
        }
    }else if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        if (self.progressIndicatorView.superview){
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                NSDictionary *dict = ConvertToClassPointer(NSDictionary, data) ;
                if ([dict boolValueForKey:@"success" defaultValue:FALSE]){
                    [self.appDelegate updateLoginStatus:true] ;
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *account = [defaults stringForKey:@"account"] ;
                    //设置jpush别名
                    [JPUSHService setAlias:account completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        if (iResCode == 0) {
                            NSLog(@"别名设置成功");
                        }else{
                            NSLog(@"别名设置失败");
                        }
                    } seq:1];
                }else{
                    [self.appDelegate updateLoginStatus:false] ;
                }
            }] ;
        }else{
            NSDictionary *dict = ConvertToClassPointer(NSDictionary, data) ;
            if ([dict boolValueForKey:@"success" defaultValue:FALSE]){
                [self.appDelegate updateLoginStatus:true] ;
            }else{
                [self.appDelegate updateLoginStatus:false] ;
            }
        }
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3PromoActivityType){
        if (_typeTopView.allTypes==0){
            [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
        }else{
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                showErrorMessage(self.view, error, @"更新失败") ;
            }] ;
        }
    }else if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showAlertView(@"自动登录失败", @"提示信息");
        }] ;
    }
}

#pragma mark -
-(void)tryRefreshData
{
    if (_typeTopView.allTypes>0){
        //已存在数据情况 ，更新优惠标签 。
        [self showProgressIndicatorViewWithAnimated:YES title:@"信息更新中"] ;
        [self.serviceRequest startV3LoadDiscountActivityType] ;
    }
}

@end
