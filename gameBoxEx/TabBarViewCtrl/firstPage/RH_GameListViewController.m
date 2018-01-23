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

@interface RH_GameListViewController ()<CLPageViewDelegate, CLPageViewDatasource, GameListHeaderViewDelegate, RH_ServiceRequestDelegate, GameListChooseGameSearchDelegate>
@property (nonatomic, strong) RH_LotteryGameListTopView *searchView;
@property (nonatomic, strong) RH_GameListHeaderView *typeTopView;
@property (nonatomic, strong,readonly) CLPageView            *pageView;
@property(nonatomic,strong,readonly) NSMutableDictionary *dictPageCellDataContext ; //存储 pagecell data content ;


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

- (BOOL)isSubViewController {
    return YES;
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
        _searchView.searchDelegate=self;
    }
    return _searchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"列表";
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"数据请求中" detailText:@"请稍等"];
    [self.serviceRequest startV3LoadGameType];
}

- (void)setupInfo {
    
    [self.contentView addSubview:self.searchView];
    self.searchView.whc_TopSpace(69).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(35);
//    self.typeTopView.frame = CGRectMake(0, StatusBarHeight+NavigationBarHeight, MainScreenW, 40.0);
    self.typeTopView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:self.typeTopView];
    self.typeTopView.selectedIndex = 0;
    self.typeTopView.whc_TopSpaceToView(0, self.searchView).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(40);
    
//    self.pageView.frame = CGRectMake(10,
//                                     self.typeTopView.frameY + self.typeTopView.frameHeigh + 10,
//                                     MainScreenW-20,
//                                     MainScreenH - (self.typeTopView.frameY + self.typeTopView.frameHeigh + 10)) ;
//    self.pageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin ;
    [self.contentView addSubview:self.pageView];
    self.pageView.whc_TopSpaceToView(5, self.typeTopView).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0);
    //注册复用
    [self.pageView registerCellForPage:[RH_GameListContentPageCell class]] ;
    //设置索引
    self.pageView.dispalyPageIndex = self.typeTopView.selectedIndex;
    
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
//    return 0 ;
}

- (UICollectionViewCell *)pageView:(CLPageView *)pageView cellForPageAtIndex:(NSUInteger)pageIndex
{
    RH_GameListContentPageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_GameListContentPageCell defaultReuseIdentifier] forPageIndex:pageIndex];
    [cell updateViewWithType:[self.typeTopView typeModelWithIndex:pageIndex]
                APIInfoModel:_lotteryApiModel
                     Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
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
        NSArray *arr = ConvertToClassPointer(NSArray, data);
        if (arr.count == 0) {
            [self.contentLoadingIndicateView showInfoInInvalidWithTitle:@"" detailText:@""] ;
        }else{
            [self.typeTopView updateView:arr];
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
