//
//  RH_MainTabBarControllerEx.m
//  cpLottery
//
//  Created by luis on 2017/11/15.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MainTabBarControllerEx.h"
#import "coreLib.h"
#import "RH_APPDelegate.h"
#import "RH_BasicViewController.h"
#import "RH_TestSafariViewController.h"
@interface RH_MainTabBarControllerEx ()<CLStaticCollectionViewDelegate,CLStaticCollectionViewDataSource,CLMaskViewDataSource>
//内容视图
@property(nonatomic,strong) UIView * contentView;

//视图控制器集合
@property(nonatomic,strong,readonly) NSMutableDictionary * viewControllers;

//当前显示的视图控制器
@property(nonatomic,strong,readonly) UIViewController * currentShowVC;

//当前选中的tab索引
@property(nonatomic) NSUInteger selectedTabIndex;

//tab栏
@property(nonatomic,strong,readonly) NSArray * tabInfos;
@property(nonatomic,strong,readonly) CLMaskView *tabBarMaskView;
@property(nonatomic,strong) CLStaticCollectionView * tabBarView;

//提问按钮
@property(nonatomic,strong,readonly) UIButton * homeButton;
@end

@implementation RH_MainTabBarControllerEx
@synthesize tabBarMaskView = _tabBarMaskView ;
@synthesize tabInfos = _tabInfos;
@synthesize viewControllers = _viewControllers;
@synthesize homeButton   = _homeButton ;

#pragma mark-
//创建实例
+ (RH_MainNavigationController *)createInstanceEmbedInNavigationControllerWithContext:(id)context
{
    RH_MainNavigationController * navigationController = [[RH_MainNavigationController alloc] initWithRootViewController:[self viewControllerWithContext:context]];
    navigationController.useForTabRootViewController = YES;
    return navigationController;
}

//返回主导航视图实例
+ (RH_MainNavigationController *)mainNavigationController
{
    id viewController = [RH_APPDelegate appDelegate].window.rootViewController;
    if ([viewController isKindOfClass:[RH_MainNavigationController class]]) {
        return viewController;
    }
    
    return nil;
}

//返回主页视图实例
+ (instancetype)mainTabBarController
{
    id viewController = [[[self mainNavigationController] viewControllers] firstObject];
    if ([viewController isKindOfClass:[self class]]) {
        return viewController;
    }
    
    return nil;
}

//当前显示的最上面的视图
+ (UIViewController *)currentCenterTopViewController
{
    return [[self mainNavigationController] currentTopViewController];
}

- (UIViewController *)currentTopViewController
{
    UIViewController * currentTopViewController = super.currentTopViewController;
    if (currentTopViewController == self) {
        currentTopViewController = self.currentShowVC;
    }
    return currentTopViewController;
}

//隐藏所有的子视图，包括present，naviegation到根视图
+ (void)hideAllSubViews:(BOOL)animated
{
    RH_MainTabBarControllerEx * viewController = [self mainTabBarController];
    
    if (viewController.presentedViewController) {
        [viewController dismissViewControllerAnimated:animated completion:^{
            [viewController.navigationController popToRootViewControllerAnimated:animated];
        }];
    }else{
        [viewController.navigationController popToRootViewControllerAnimated:animated];
    }
}

-(void)switchToTabIndex:(NSUInteger)tabIndex
{
    if (tabIndex>=0 && tabIndex<self.tabInfos.count){
        self.selectedTabIndex = tabIndex;
        [self.tabBarView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedTabIndex inSection:0] animated:YES];
    }
}

#pragma mark-
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //内容视图
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tabBarMaskView] ;
    
    [self.tabBarMaskView reloadMask] ;
    //tab栏
    self.tabBarView = [[CLStaticCollectionView alloc] initWithFrame:self.tabBarMaskView.bounds];
    [self.tabBarMaskView addSubview:self.tabBarView];
    self.tabBarView.delegate = self;
    self.tabBarView.dataSource = self;
    self.tabBarView.allowCellSeparationLine = NO ;
    self.tabBarView.backgroundColor = [UIColor lightGrayColor];
    self.tabBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.tabBarView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBarView.layer.shadowOpacity = 0.1f;
    self.tabBarView.layer.shadowOffset = CGSizeMake(0.f, -2.f);
    self.tabBarView.layer.shadowRadius = 2.f;
    self.tabBarView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tabBarView.bounds].CGPath;
    
    [self.tabBarView reloadData] ;
    //选中第一个
    _selectedTabIndex = NSNotFound;
    
    if ([SITE_TYPE isEqualToString:@"integratedv3"]){
        self.selectedTabIndex = 2 ;
    }else{
        self.selectedTabIndex = 0;
    }
    
    [self.tabBarView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedTabIndex inSection:0] animated:NO];
}

#pragma mark- maskView
-(CLMaskView *)tabBarMaskView
{
    if (!_tabBarMaskView){
        _tabBarMaskView = [[CLMaskView alloc] initWithFrame:CGRectMake(0.f, self.view.frameHeigh - TabBarHeight, self.view.frameWidth, TabBarHeight)] ;
        _tabBarMaskView.backgroundColor = [UIColor clearColor] ;
        _tabBarMaskView.dataSource = self ;
        _tabBarMaskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _tabBarMaskView ;
}

- (CALayer *)maskLayerForMaskView:(CLMaskView *)maskView
{
    static UIImage *bgImage = nil ;
    if (!bgImage){
        bgImage = ImageWithName(@"tabbar_mark_bg") ;
    }
    
    CALayer *maskLayer = [[CALayer alloc] init] ;
    maskLayer.frame = maskView.bounds ;
    maskLayer.contentsGravity = kCAGravityResize ;
    maskLayer.contentsScale = [UIScreen mainScreen].scale ;
    // maskLayer.contentsCenter = CGRectMake(0.1, 0, 0.1, 1.f) ;
    maskLayer.contentsCenter = CGRectMake(0.4, 0.4, 0.2, 0.f);
    maskLayer.contents = (id)bgImage.CGImage ;
    
    return maskLayer ;
}

#pragma mark -

- (NSMutableDictionary *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [NSMutableDictionary dictionaryWithCapacity:self.tabInfos.count];
    }
    
    return _viewControllers;
}

- (UIViewController *)_tabSubViewControllerAtIndex:(NSUInteger)index
{
    UIViewController * vc = self.viewControllers[@(index)];
    if (vc == nil) {
        NSDictionary * info = self.tabInfos[index];
         Class viewControllerClass = NSClassFromString([info stringValueForKey:@"viewControllerClass"]);
        vc = [info targetViewController]?:[viewControllerClass viewController];
        vc = vc ?: [RH_BasicViewController viewController];
        
        vc.title = [info myTitle];
        vc.showViewControllerDelegate = self;
        
        self.viewControllers[@(index)] = vc;
    }
    return vc;
}

- (UIViewController *)currentShowVC {
    return [self _tabSubViewControllerAtIndex:self.selectedTabIndex];
}

- (void)setSelectedTabIndex:(NSUInteger)selectedTabIndex
{
    if (_selectedTabIndex != selectedTabIndex) {
        
        if (_selectedTabIndex != NSNotFound) {
            
            UIViewController * fromVc = [self _tabSubViewControllerAtIndex:_selectedTabIndex];
            assert(fromVc.parentViewController == self);
            
            //移除显示
            [fromVc beginAppearanceTransition:NO animated:NO];
            [fromVc.view removeFromSuperview];
            [fromVc endAppearanceTransition];
        }
        
        _selectedTabIndex = selectedTabIndex;
        
        UIViewController * toVc = [self _tabSubViewControllerAtIndex:_selectedTabIndex];
        
        toVc.view.frame = self.contentView.frame;
        toVc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (toVc.parentViewController != self) {
            
            //加入成为子控制器
            [self addChildViewController:toVc];
            [toVc didMoveToParentViewController:self];
            [self.contentView addSubview:toVc.view];
            
        }else {
            
            //开始显示
            [toVc beginAppearanceTransition:YES animated:NO];
            [self.contentView addSubview:toVc.view];
            [toVc endAppearanceTransition];
        }
    }
}

#pragma mark -

- (NSArray *)tabInfos
{
    if (!_tabInfos) {
        _tabInfos =  [[NSDictionary dictionaryWithContentsOfFile:PlistResourceFilePath(@"RH_MainTabBarItems")] arrayValueForKey:SITE_TYPE] ;
    }
    
    return _tabInfos;
}

-(NSUInteger)staticCollectionView:(CLStaticCollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section
{
    return self.tabInfos.count ;
}

- (CLStaticCollectionViewCell *)staticCollectionView:(CLStaticCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLImageTitleStaticCollectionViewCell * cell = [collectionView dequeueReusableCellWithIdentifier:defaultReuseDef];
    if (cell == nil) {
        cell = [[CLImageTitleStaticCollectionViewCell alloc] init];
        cell.layout = CLImageTitleStaticCollectionViewCellLayoutImageTop;
        cell.textFont = [UIFont systemFontOfSize:9.f];
        cell.autoAdjustTextColor = NO;
        cell.adjustImageWithTextColor = NO;
        cell.titleImageMargin = 5.f;
        cell.contentOffset = CGPointMake(0.f, 3.f);
        [cell setTextColor:ColorWithNumberRGB(0x303030)
                  forState:CLImageTitleStaticCollectionViewCellStateNormal];
        [cell setTextColor:[UIColor blueColor]
                  forState:CLImageTitleStaticCollectionViewCellStateSelected];
        [cell setTextColor:[UIColor blueColor]
                  forState:CLImageTitleStaticCollectionViewCellStateHighlighted];
        
        cell.backgroundColor = [UIColor clearColor] ;
    }
    
    if (indexPath.item==2){
        cell.contentOffset = CGPointMake(0, -5) ;
        cell.titleImageMargin = 15.f;
    }else{
        cell.contentOffset = CGPointMake(0, 5) ;
        cell.titleImageMargin = 5.f;
    }
    
    NSDictionary * info = self.tabInfos[indexPath.item];
    [cell setText:NSLocalizedString([info myTitle], nil) forState:CLImageTitleStaticCollectionViewCellStateNormal];
    [cell setImage:[info myImage] forState:CLImageTitleStaticCollectionViewCellStateNormal];

    [cell setImage:[info mySelectedImage] forState:CLImageTitleStaticCollectionViewCellStateSelected];
    [cell setImage:[info mySelectedImage] forState:CLImageTitleStaticCollectionViewCellStateSelected | CLImageTitleStaticCollectionViewCellStateHighlighted];

    return cell;
}

- (BOOL)staticCollectionView:(CLStaticCollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:collectionView.indexPathForSelectedItem animated:NO];
    
    return YES;
}


#pragma mark-
- (UIButton *)homeButton
{
    if (!_homeButton) {
        _homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 50.f, 50.f)];
        [_homeButton setImage:ImageWithName(@"tab_v3_home") forState:UIControlStateNormal];
        [_homeButton setImage:ImageWithName(@"tab_v3_home_selected") forState:UIControlStateHighlighted];
        _homeButton.alpha = 0.f;
        
        _homeButton.layer.shadowColor = [UIColor blackColor].CGColor;
        _homeButton.layer.shadowOpacity = 0.1f;
        _homeButton.layer.shadowOffset = CGSizeMake(0.f, -2.f);
        _homeButton.layer.shadowRadius = 2.f;
        _homeButton.layer.shadowPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25.f, 25.f) radius:25.f startAngle:M_PI endAngle:2 * M_PI clockwise:YES].CGPath;
        
        _homeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.view addSubview:_homeButton];
        
        [_homeButton addTarget:self
                        action:@selector(_homeButtonHandle)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _homeButton;
}

- (void)_homeButtonHandle
{
    
}

#pragma mark -

- (BOOL)shouldAutorotate {
    return YES ;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
    if (self.navigationController.topViewController==self){
        return UIInterfaceOrientationMaskPortrait ;
    }else{
        return [self.navigationController.topViewController supportedInterfaceOrientations] ;
    }
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{    // 返回nav栈中最后一个对象,坚持旋转的方向
    if (self.navigationController.topViewController==self){
        return UIInterfaceOrientationPortrait ;
    }else{
        return  [self.navigationController.topViewController preferredInterfaceOrientationForPresentation] ;
    }
}

@end


@implementation UIViewController (currentTopViewControllerEx)

- (UIViewController *)currentTopViewController
{
    id presentedViewController = self.presentedViewController;
    
    if (presentedViewController) {
        return [presentedViewController currentTopViewController];
    }else if ([self isKindOfClass:[UINavigationController class]]){
        return [[(UINavigationController *)self visibleViewController] currentTopViewController];
    }else if ([self isKindOfClass:[UITabBarController class]]){
        return [[(UITabBarController *)self selectedViewController] currentTopViewController];
    }
    
    return self;
}

@end
