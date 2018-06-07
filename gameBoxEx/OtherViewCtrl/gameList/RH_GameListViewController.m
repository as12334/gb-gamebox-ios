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
#import "CLRefreshBaseControl.h"
#import "RH_TypeSelectView.h"
#import "RH_LotteryCategoryModel.h"
#import "RH_GameItemsCell.h"
#import "RH_GameListScrollView.h"
#import "RH_GameListCell.h"
#import "CLPageView.h"
#import "CLRefreshControl.h"

@interface RH_GameListViewController ()<GameListHeaderViewDelegate, RH_ServiceRequestDelegate, LotteryGameListTopViewDelegate,GameListContentPageCellProtocol,UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, RH_TypeSelectViewDelegate, RH_GameListScrollViewDatasource>

@property (nonatomic, strong) RH_LotteryGameListTopView *searchView;
@property (nonatomic, strong) RH_GameListHeaderView *typeTopView;
@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, strong) CLRefreshBaseControl *typeControl;
@property (nonatomic, strong) RH_TypeSelectView *typeSelectView;
@property (nonatomic, assign) NSInteger currentCategoryIndex;
@property (nonatomic, strong) RH_LotteryCategoryModel *categoryModel;
@property (nonatomic, assign) BOOL isListMode;//列表模式 默认为false
@property (nonatomic, strong) NSMutableArray *gameListArray;//游戏列表数组
@property (nonatomic, assign) int currentGameListPageIndex;//当前分页数
@property (nonatomic, strong) NSDictionary *currentTypeModel;//当前小分类信息
@property (nonatomic, assign) NSInteger currentSubTypeIndex;//当前小分类信息index
@property (nonatomic, strong) CLRefreshControl *bottomLoadControl;

@end

@implementation RH_GameListViewController
{
    RH_LotteryAPIInfoModel *_lotteryApiModel ;
}

@synthesize typeTopView = _typeTopView;

-(void)setupViewContext:(id)context
{
    NSArray *info = (NSArray *)context;
    self.categoryModel = [info firstObject];
    self.currentCategoryIndex = [[info lastObject] integerValue];
    _lotteryApiModel = self.categoryModel.mSiteApis[self.currentCategoryIndex];
    self.typeSelectView.categoryModel = self.categoryModel;
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
    self.currentGameListPageIndex = 1;//默认第一页
//    self.isListMode = YES;
    [self.navigationBar setBackgroundColor:[UIColor blueColor]];
    if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
        self.view.backgroundColor = [UIColor blackColor];
    }
    [self loadingIndicateViewDidTap:nil] ;

    //item模式
    CLButton *itemTypeBt = [CLButton buttonWithType:UIButtonTypeSystem];
    itemTypeBt.frame = CGRectMake(0, 0, 30,30);
    [itemTypeBt setImage:[UIImage imageNamed:@"gamelist_3hover"] forState:UIControlStateNormal];
    [itemTypeBt addTarget:self action:@selector(changeToItemModel:) forControlEvents:UIControlEventTouchUpInside];
    [itemTypeBt setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    UIBarButtonItem *itemTypeBtItem = [[UIBarButtonItem alloc] initWithCustomView:itemTypeBt] ;

    //list模式
    CLButton *listTypeBt = [CLButton buttonWithType:UIButtonTypeSystem];
    listTypeBt.frame = CGRectMake(0, 0, 30, 30);
    [listTypeBt setImage:[UIImage imageNamed:@"gamelist_column"] forState:UIControlStateNormal];
    [listTypeBt addTarget:self action:@selector(changeToListModel:) forControlEvents:UIControlEventTouchUpInside];
    [listTypeBt setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    UIBarButtonItem *listTypeBtItem = [[UIBarButtonItem alloc] initWithCustomView:listTypeBt] ;

    //搜索
    CLButton *searchBt = [CLButton buttonWithType:UIButtonTypeSystem];
    searchBt.frame = CGRectMake(0, 0, 30, 30);
    [searchBt setImage:[UIImage imageNamed:@"gamelist_query"] forState:UIControlStateNormal];
    [searchBt addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchBt setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    UIBarButtonItem *searchBtItem = [[UIBarButtonItem alloc] initWithCustomView:searchBt] ;

    self.navigationBarItem.rightBarButtonItems = @[itemTypeBtItem,listTypeBtItem,searchBtItem];
}

- (CLRefreshControl *)bottomLoadControl
{
    if (!_bottomLoadControl) {
        _bottomLoadControl = [[CLRefreshControl alloc] initWithType:CLRefreshControlTypeBottom style:CLRefreshControlStyleProgress];
        [_bottomLoadControl addTarget:self
                               action:@selector(bottomLoadControlHandle:)
                     forControlEvents:UIControlEventValueChanged];
    }
    
    return _bottomLoadControl;
}

- (void)bottomLoadControlHandle:(id)sender
{
    [self loadMore];
}

- (NSMutableArray *)gameListArray
{
    if (_gameListArray == nil) {
        _gameListArray = [NSMutableArray array];
    }
    return _gameListArray;
}

- (RH_TypeSelectView *)typeSelectView
{
    if (_typeSelectView == nil) {
        _typeSelectView = [[RH_TypeSelectView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        _typeSelectView.backgroundColor = [UIColor whiteColor];
        _typeSelectView.delegate = self;
    }
    return _typeSelectView;
}

- (CLRefreshBaseControl *)typeControl
{
    if (_typeControl == nil) {
        _typeControl = [[CLRefreshBaseControl alloc] initWithThreshold:100 height:100 animationView:self.typeSelectView];
    }
    return _typeControl;
}

- (UITableView *)listTable
{
    if (_listTable == nil)
    {
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), self.view.frame.size.width, self.view.frame.size.height-(64+(MainScreenH==812?20.0:0.0))) style:UITableViewStyleGrouped];
        _listTable.dataSource = self;
        _listTable.delegate = self;
        _listTable.separatorColor = [UIColor clearColor];
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_listTable registerNib:[UINib nibWithNibName:@"RH_GameListCell" bundle:nil] forCellReuseIdentifier:@"listIdentifier"];

        [self.contentView addSubview:_listTable];
        [_listTable addSubview:self.typeControl];
        [_listTable addSubview:self.bottomLoadControl];
    }
    return _listTable;
}

- (void)setupInfo {
    [self.listTable reloadData];
    self.title = _lotteryApiModel.mName?:@"列表" ;
    self.searchView.hidden = YES;
    self.searchView.whc_TopSpace(64+(MainScreenH==812?20.0:0.0)).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(55);
}

//加载下一页
- (void)loadMore
{
    self.currentGameListPageIndex++;//递增
    [self.serviceRequest startV3GameListWithApiID:_lotteryApiModel.mApiID
                                        ApiTypeID:_lotteryApiModel.mApiTypeID
                                       PageNumber:self.currentGameListPageIndex
                                         PageSize:18
                                       SearchName:@""
                                            TagID:[self.currentTypeModel stringValueForKey:@"key"]] ;
}

- (void)changeToItemModel:(id)sender
{
    self.isListMode = NO;
    [self.listTable reloadData];
}

- (void)changeToListModel:(id)sender
{
    self.isListMode = YES;
    [self.listTable reloadData];
}

- (void)searchAction:(id)sender
{
    self.searchView.hidden = !self.searchView.hidden;
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
    self.currentSubTypeIndex = selectedIndex;
    [self.gameListArray removeAllObjects];//清空之前的数据
    self.currentGameListPageIndex = 1;//重置为1
    self.currentTypeModel = [self.typeTopView typeModelWithIndex:selectedIndex];
    [self.serviceRequest startV3GameListWithApiID:_lotteryApiModel.mApiID
                                        ApiTypeID:_lotteryApiModel.mApiTypeID
                                       PageNumber:self.currentGameListPageIndex
                                         PageSize:18
                                       SearchName:@""
                                            TagID:[self.currentTypeModel stringValueForKey:@"key"]] ;

}

#pragma mark searchView
-(RH_LotteryGameListTopView *)searchView
{
    if (!_searchView) {
        _searchView = [RH_LotteryGameListTopView createInstance];
        _searchView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35);
        _searchView.delegate=self;
        [self.contentView addSubview:_searchView];
    }
    return _searchView;
}

#pragma mark - CLLoadingIndicateView
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"数据请求中" detailText:@"请稍等"];
    [self.serviceRequest startV3LoadGameTypeWithApiId:_lotteryApiModel.mApiID searchApiTypeId:_lotteryApiModel.mApiTypeID];
}

#pragma mark - RH_GameListScrollViewDatasource M

- (NSInteger)numberOfPagesInScrollView:(RH_GameListScrollView *)view
{
    return self.typeTopView.allTypes;
}

/**
 * 点击方法
 */
-(void)gameListContentPageCellDidTouchCell:(RH_GameListContentPageCell*)gameListContentPageCell CellModel:(RH_LotteryInfoModel*)lotteryInfoModel
{
    if (HasLogin)
    {
        [self showViewController:[RH_ElecGameViewController viewControllerWithContext:lotteryInfoModel] sender:self];
        return ;
    }else{
        [self loginButtonItemHandle] ;
    }
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isListMode) {
        return self.gameListArray.count;
    }
    else
    {
        int numOfRow = 3;//每行显示3个
        return self.gameListArray.count/numOfRow+(self.gameListArray.count%numOfRow==0 ? 0 : 1);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isListMode) {
        static NSString *cellIdentifier = @"listIdentifier";
        RH_GameListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RH_GameListCell" owner:nil options:nil] firstObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.typeModel = _lotteryApiModel;
        cell.model = self.gameListArray[indexPath.row];
        cell.type = _lotteryApiModel.mName;
        cell.subType = [self.currentTypeModel stringValueForKey:@"value"];
        cell.backgroundColor = indexPath.row%2 == 0 ? colorWithRGB(242, 242, 242) : [UIColor whiteColor];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"itemsCell";
        RH_GameItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[RH_GameItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)ColorWithRGBA(240, 240, 240, 1).CGColor];
            gradientLayer.locations = @[@0.5, @1.0];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1);
            
            int numOfRow = 3;//每行显示3个
            CGFloat temp = 10.0;
            CGFloat w = ([UIScreen mainScreen].bounds.size.width-temp*numOfRow*2)/numOfRow;
            CGFloat h = 1.2*w+temp+5;
            gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, h);
            [cell.layer addSublayer:gradientLayer];
        }
        cell.typeModel = _lotteryApiModel;
        
        int i = (int)indexPath.row;
        int numOfRow = 3;//每行显示3个
        if (numOfRow * (i+1) >= self.gameListArray.count) {
            //是最后一行
            NSArray *cellArr = [self.gameListArray subarrayWithRange:NSMakeRange(i*numOfRow, self.gameListArray.count%numOfRow==0 ? numOfRow : self.gameListArray.count%numOfRow)];
            cell.itemsArr = cellArr;
        }
        else
        {
            //不是最后一行
            NSArray *cellArr = [self.gameListArray subarrayWithRange:NSMakeRange(i*numOfRow, numOfRow)];
            cell.itemsArr = cellArr;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isListMode) {
        return 100.0f;
    }
    else
    {
        int numOfRow = 3;//每行显示3个
        CGFloat temp = 10.0;
        CGFloat w = ([UIScreen mainScreen].bounds.size.width-temp*numOfRow*2)/numOfRow;
        CGFloat h = 1.2*w+temp+5;
        return h;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.typeTopView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    self.typeTopView.backgroundColor = [UIColor whiteColor];
    self.typeTopView.selectedIndex = self.currentSubTypeIndex;

    return self.typeTopView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

#pragma mark - UIScrollViewDelegate M

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    static BOOL ended = NO;
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    if(translatedPoint.y < 0)
    {
        if (ended == NO && _typeControl.refreshing)
        {
            ended = YES;
            [_typeControl endRefreshing];
        }
    }
    if(translatedPoint.y > 0)
    {
        ended = NO;
    }
}

#pragma mark - RH_TypeSelectViewDelegate M

- (void)typeSelectView:(RH_TypeSelectView *)view didSelect:(NSInteger)index
{
    if (self.currentCategoryIndex != index) {
        self.currentSubTypeIndex = 0;
        self.currentCategoryIndex = index;
        self.typeTopView.selectedIndex = 0;
        _lotteryApiModel = self.categoryModel.mSiteApis[self.currentCategoryIndex];
        [self loadingIndicateViewDidTap:nil] ;
    }
}

#pragma mark  - LotteryGameListTopViewDelegate M
-(void)lotteryGameListTopViewDidReturn:(RH_LotteryGameListTopView*)lotteryGameListTopView
{
    [self.gameListArray removeAllObjects];//清空之前的数据
    self.currentGameListPageIndex = 1;//重置为1
    self.currentTypeModel = [self.typeTopView typeModelWithIndex:self.currentSubTypeIndex];
    [self.serviceRequest startV3GameListWithApiID:_lotteryApiModel.mApiID
                                        ApiTypeID:_lotteryApiModel.mApiTypeID
                                       PageNumber:self.currentGameListPageIndex
                                         PageSize:18
                                       SearchName:lotteryGameListTopView.searchInfo
                                            TagID:[self.currentTypeModel stringValueForKey:@"key"]] ;

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
            self.typeTopView.selectedIndex = 0;
            [self.typeTopView updateView:arr1];
            [self setupInfo];
        }
    }
    else if (type == ServiceRequestTypeV3APIGameList)
    {
        //获取对应类型的游戏列表
        NSDictionary *gameListDic = ConvertToClassPointer(NSDictionary, data);
        NSArray *gameListArr = ConvertToClassPointer(NSArray, [gameListDic objectForKey:@"casinoGames"]);
        [self.gameListArray addObjectsFromArray:gameListArr];
        [self.listTable reloadData];
        [self.bottomLoadControl endRefreshing];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3LoadGameType) {
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}

@end
