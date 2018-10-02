//
//  RH_CollectionViewController.m
//  gameBoxEx
//
//  Created by paul on 2018/9/30.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_CollectionViewController.h"
#import "RH_CollectionHeaderView.h"
#import "RH_CollectionContentPageCell.h"
@interface RH_CollectionViewController ()<CLPageViewDelegate,CLPageViewDatasource,RH_CollectionHeaderViewDelegate>
@property(nonatomic,strong) CLPageView *pageView ;
@property(nonatomic,strong) NSMutableDictionary *dictPageCellDataContext ; //存储 pagecell data content ;
@property(nonatomic,strong) RH_CollectionHeaderView * headerView;
@end

@implementation RH_CollectionViewController
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
-(BOOL)hasNavigationBar
{
    return YES ;
}

- (BOOL)isSubViewController {
    return YES;
}

-(BOOL)hasTopView
{
    return YES ;
}

-(BOOL)topViewIncludeStatusBar
{
    return false ;
}
-(BOOL)hasBottomView{
    return false;
}

-(CGFloat)topViewHeight
{
    return 44;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    // Do any additional setup after loading the view.
    //初始化
//    [self loadingIndicateViewDidTap:nil] ;
    [self  configUI];
}
-(void)configUI{
    [self.view addSubview:self.headerView] ;
    [self.contentView addSubview:self.pageView] ;
 self.headerView.whc_TopSpace(NavigationBarHeight+STATUS_HEIGHT).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(44) ;
    self.pageView.whc_TopSpace(NavigationBarHeight+STATUS_HEIGHT +54).whc_LeftSpace(10).whc_RightSpace(10).whc_BottomSpace(0) ;
    //注册复用
    [self.pageView registerCellForPage:[RH_CollectionContentPageCell class] andReuseIdentifier:[RH_CollectionContentPageCell defaultReuseIdentifier]] ;
    //设置索引
    self.pageView.dispalyPageIndex = 0;
}
#pragma mark -- service data
-(void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"数据请求中" detailText:@"请稍等..."] ;
    [self.serviceRequest startV3LoadDiscountActivityType] ;
}

#pragma mark --pageView setter method
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
#pragma mark -- CLPageView CLPageViewDatasource method
- (NSUInteger)numberOfPagesInPageView:(CLPageView *)pageView
{
    return 2  ;
}

- (UICollectionViewCell *)pageView:(CLPageView *)pageView cellForPageAtIndex:(NSUInteger)pageIndex
{
    RH_CollectionContentPageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_CollectionContentPageCell defaultReuseIdentifier] forPageIndex:pageIndex];
//     cell.delegate = self ;
//
     [cell updateViewWithType:pageIndex Context:[self _pageLoadDatasContextForPageAtIndex:pageIndex]] ;
    return cell;
}

#pragma mark --CLPageView CLPageViewDelegate
- (void)pageView:(CLPageView *)pageView didDisplayPageAtIndex:(NSUInteger)pageIndex
{
    if (pageIndex==0) {
        [self.headerView.collection_button setBackgroundColor:[UIColor orangeColor]];
        [self.headerView.recentCollection_button setBackgroundColor:[UIColor  darkGrayColor]];
    }else{
        [self.headerView.recentCollection_button setBackgroundColor:[UIColor orangeColor]];
        [self.headerView.collection_button setBackgroundColor:[UIColor  darkGrayColor]];
    }
    
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
    RH_CollectionContentPageCell * cell = [self.pageView cellForPageAtIndex:pageIndex];
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
#pragma headerView  delegate method
-(void)collectionButtonClick:(UIButton *)sender{
    self.pageView.dispalyPageIndex = sender.tag -100;
}
#pragma mark ---  getter method
-(NSMutableDictionary *)dictPageCellDataContext
{
    if (!_dictPageCellDataContext){
        _dictPageCellDataContext = [[NSMutableDictionary alloc] init] ;
    }
    
    return _dictPageCellDataContext ;
}
-(RH_CollectionHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [RH_CollectionHeaderView  instanceCreateCollectionHeaderView];
        _headerView.delegate = self;
    }
    return _headerView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
