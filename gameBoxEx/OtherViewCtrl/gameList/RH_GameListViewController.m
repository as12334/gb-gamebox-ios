//
//  RH_GameListViewController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListViewController.h"
#import "RH_GameListHeaderView.h"
#import "RH_LotteryGameListTopView.h"
#import "RH_GameListContentPageCell.h"
#import "RH_LotteryAPIInfoModel.h"
#import "RH_CustomViewController.h"
#import "RH_UserInfoManager.h"
#import "RH_ElecGameViewController.h"

@interface RH_GameListViewController ()<CLPageViewDelegate, CLPageViewDatasource, GameListHeaderViewDelegate, RH_ServiceRequestDelegate, LotteryGameListTopViewDelegate,GameListContentPageCellProtocol,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) RH_LotteryGameListTopView *searchView;
@property (nonatomic, strong) RH_GameListHeaderView *typeTopView;
@property (nonatomic, strong,readonly) CLPageView            *pageView;
@property(nonatomic,strong,readonly) NSMutableDictionary *dictPageCellDataContext ; //存储 pagecell data content ;
@property (nonatomic, strong) UITableView *listTable;

@end

@implementation RH_GameListViewController
{
    RH_LotteryAPIInfoModel *_lotteryApiModel ;
}

@synthesize typeTopView = _typeTopView;
@synthesize pageView = _pageView;
@synthesize dictPageCellDataContext = _dictPageCellDataContext ;

-(void)setupViewContext:(id)context
{
    _lotteryApiModel = ConvertToClassPointer(RH_LotteryAPIInfoModel, context) ;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _lotteryApiModel.mName?:@"列表" ;
    [self.navigationBar setBackgroundColor:[UIColor blueColor]];
//    [self.navigationBar setTintColor:[UIColor whiteColor]];
    if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
        self.view.backgroundColor = [UIColor blackColor];
    }
    [self loadingIndicateViewDidTap:nil] ;
}

- (UITableView *)listTable
{
    if (_listTable == nil)
    {
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _listTable.dataSource = self;
        _listTable.delegate = self;
        // 设置表视图的分割线的颜色
        _listTable.separatorColor = [UIColor clearColor];
        // 设置表视图的分割线的风格
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:_listTable];
    }
    return _listTable;
}

- (void)setupInfo {
//    [self.contentView addSubview:self.searchView];
//    self.searchView.whc_TopSpace(64+(MainScreenH==812?20.0:0.0)).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(55);
//    self.typeTopView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
//    [self.contentView addSubview:self.typeTopView];
//    self.typeTopView.backgroundColor = [UIColor whiteColor];
//    self.typeTopView.selectedIndex = 0;
//    self.typeTopView.whc_TopSpaceToView(0, self.searchView).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(40);
//
//    [self.contentView addSubview:self.pageView];
//    self.pageView.whc_TopSpaceToView(2, self.typeTopView).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0);
//    //注册复用
//    [self.pageView registerCellForPage:[RH_GameListContentPageCell class]] ;
//    //设置索引
//    self.pageView.dispalyPageIndex = self.typeTopView.selectedIndex;
    [self.listTable reloadData];
}

#pragma mark - typeTopView
- (RH_GameListHeaderView *)typeTopView {
    if (_typeTopView == nil) {
        _typeTopView = [RH_GameListHeaderView createInstance];
        _typeTopView.delegate = self;
    }
    return _typeTopView;
}

-(void)gameListHeaderViewDidChangedSelectedIndex:(RH_GameListHeaderView*)gameListHeaderView SelectedIndex:(NSInteger)selectedIndex
{
    self.pageView.dispalyPageIndex = selectedIndex;
}

#pragma mark searchView
-(RH_LotteryGameListTopView *)searchView
{
    if (!_searchView) {
        _searchView = [RH_LotteryGameListTopView createInstance];
        _searchView.frame = CGRectMake(0, 0, self.topView.frameWidth, 35);
        _searchView.delegate=self;
    }
    return _searchView;
}

-(void)lotteryGameListTopViewDidReturn:(RH_LotteryGameListTopView*)lotteryGameListTopView
{
    [self.pageView reloadPages:YES] ;
    [self.view endEditing:YES];
}

#pragma mark - CLLoadingIndicateView
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"数据请求中" detailText:@"请稍等"];
    [self.serviceRequest startV3LoadGameTypeWithApiId:_lotteryApiModel.mApiID searchApiTypeId:_lotteryApiModel.mApiTypeID];
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

-(void)gameListContentPageCellDidTouchCell:(RH_GameListContentPageCell*)gameListContentPageCell CellModel:(RH_LotteryInfoModel*)lotteryInfoModel
{
    if (HasLogin)
    {
//        [self showViewController:[RH_CustomViewController viewControllerWithContext:lotteryInfoModel] sender:self] ;
        [self showViewController:[RH_ElecGameViewController viewControllerWithContext:lotteryInfoModel] sender:self];
        return ;
    }else{
        [self loginButtonItemHandle] ;
    }
}

- (NSUInteger)numberOfPagesInPageView:(CLPageView *)pageView
{
    return self.typeTopView.allTypes  ;
//    return 0 ;
}

- (UICollectionViewCell *)pageView:(CLPageView *)pageView cellForPageAtIndex:(NSUInteger)pageIndex
{
    RH_GameListContentPageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_GameListContentPageCell defaultReuseIdentifier] forPageIndex:pageIndex];
    cell.delegate = self ;
    [cell updateViewWithType:[self.typeTopView typeModelWithIndex:pageIndex]
                  SearchName:self.searchView.searchInfo
                APIInfoModel:_lotteryApiModel Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
    
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

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    
    [self.pageView registerCellForPage:[RH_GameListContentPageCell class]] ;
    self.pageView.dispalyPageIndex = self.typeTopView.selectedIndex;
    [cell addSubview:self.pageView];
    
    self.pageView.whc_TopSpaceToView(2, cell).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.height-40-(64+(MainScreenH==812?20.0:0.0));
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.typeTopView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    self.typeTopView.backgroundColor = [UIColor whiteColor];
    self.typeTopView.selectedIndex = 0;

    return self.typeTopView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

#pragma mark -
-(NSMutableDictionary *)dictPageCellDataContext
{
    if (!_dictPageCellDataContext){
        _dictPageCellDataContext = [[NSMutableDictionary alloc] init] ;
    }
    
    return _dictPageCellDataContext ;
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
    RH_GameListContentPageCell * cell = [self.pageView cellForPageAtIndex:pageIndex];
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

#pragma mark - serviceRequest

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    
    if (type == ServiceRequestTypeV3LoadGameType) {
        [self.contentLoadingIndicateView hiddenView];
        NSMutableArray *dataArr = [NSMutableArray array] ;
        [dataArr insertObject:@{@"key":@"all",@"value":@"所有游戏"} atIndex:0];
        NSArray *arr = ConvertToClassPointer(NSArray, data);
        [dataArr addObjectsFromArray:arr];
        NSArray *arr1 = [dataArr copy] ;
        
        if (arr1.count == 0) {
            [self.contentLoadingIndicateView showInfoInInvalidWithTitle:@"" detailText:@""] ;
        }else{
            [self.typeTopView updateView:arr1];
            [self setupInfo];
        }
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3LoadGameType) {
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}

@end
