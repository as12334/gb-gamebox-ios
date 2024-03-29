//
//  RH_MainTabBarController.m
//  CoreLib
//
//  Created by jinguihua on 2016/12/2.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "RH_MainTabBarController.h"
#import "RH_MainNavigationController.h"
#import "RH_APPDelegate.h"
#import "RH_CustomServicePageViewController.h"
#import "coreLib.h"
#import "RH_CustomTabBar.h"

@interface RH_MainTabBarController ()
@end

@implementation RH_MainTabBarController
#pragma mark -

+ (instancetype)mainTabBarController
{
    id viewController =  [UIApplication sharedApplication].keyWindow.rootViewController ;
    if ([viewController isKindOfClass:[RH_MainTabBarController class]]) {
        return viewController;
    }

    return nil;
}

#pragma mark -

+ (UIViewController *)currentCenterMainViewController
{
    RH_MainTabBarController * mainTabBarController = [self mainTabBarController];

    id selectedViewController = [mainTabBarController selectedViewController];
    if ([selectedViewController isKindOfClass:[UINavigationController class]]) {

        id mainViewController = [[selectedViewController viewControllers] firstObject];
        return mainViewController;
    }

    return selectedViewController ;
}

+ (UIViewController *)currentCenterTopViewController {
    return [[self mainTabBarController] currentTopViewController];
}

+ (void)hideAllSubViews:(BOOL)animated
{
    UIViewController * viewController = [self currentCenterMainViewController];

    if (viewController.presentedViewController) {
        [viewController dismissViewControllerAnimated:animated completion:^{
            [viewController.navigationController popToRootViewControllerAnimated:animated];
        }];
    }else{
        [viewController.navigationController popToRootViewControllerAnimated:animated];
    }

}

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([SITE_TYPE isEqualToString:@"integratedv3"] ||
        [SITE_TYPE isEqualToString:@"integratedv3oc"]){
        RH_CustomTabBar *tabbar = [[RH_CustomTabBar alloc] init] ;
        tabbar.midMoveUP = 20.0f ;
        [self setValue:tabbar forKey:@"tabBar"];
        [RH_CustomTabBar appearance].translucent = NO;
        [RH_CustomTabBar appearance].barTintColor = RH_TabBar_BackgroundColor ;
        
        if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
            [RH_CustomTabBar appearance].barTintColor = colorWithRGB(37, 37, 37) ;
        }
    }
    
//    self.view.backgroundColor = [UIColor blackColor];
    //从文件初始化各tab的视图控制器
    NSDictionary *tabBarSites = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RH_MainTabBarItems" ofType:@"plist"]] ;
    NSArray * tabBarItems = ConvertToClassPointer(NSArray, tabBarSites[SITE_TYPE]);

    NSMutableArray * viewControllers = [NSMutableArray arrayWithCapacity:tabBarItems.count];
    for (NSDictionary * tabBarItem in tabBarItems) {
        NSString * viewControllerClassName = [tabBarItem objectForKey:@"viewControllerClass"];
        Class viewControllerClass = NSClassFromString(viewControllerClassName);

        if ([viewControllerClass isSubclassOfClass:[UIViewController class]]) {
            RH_MainNavigationController * navigationController =
            [[RH_MainNavigationController alloc] initWithRootViewController:[viewControllerClass viewController]];

            MyAssert(navigationController != nil);
            
            //初始化视图控制器
            navigationController.tabBarItem.title = NSLocalizedString([tabBarItem myTitle], nil);
            navigationController.tabBarItem.image = [[tabBarItem myImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navigationController.tabBarItem.selectedImage = [[tabBarItem mySelectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            navigationController.useForTabRootViewController = YES;
            [viewControllers addObject:navigationController];
        }
    }

    self.viewControllers = viewControllers;
    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
        self.selectedIndex = 0 ;
    }
    [self updateTabbarSkins] ;
}

-(void)updateTabbarSkins
{
    if (self.tabBar.items.count >0) {
        UITabBarItem *home = [self.tabBar.items objectAtIndex:0];
        UITabBarItem *deposit = [self.tabBar.items objectAtIndex:1];
        UITabBarItem *transfer = [self.tabBar.items objectAtIndex:2];
        UITabBarItem *service = [self.tabBar.items objectAtIndex:3];
        UITabBarItem *mine = [self.tabBar.items objectAtIndex:4];
       if (!([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
        home.image = [[UIImage imageNamed:@"tab_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        deposit.image = [[UIImage imageNamed:@"tab_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        service.image = [[UIImage imageNamed:@"tab_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        mine.image = [[UIImage imageNamed:@"tab_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    if ([@"integrated" isEqualToString:SITE_TYPE]) {
        transfer.image = [[UIImage imageNamed:@"tab_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if ([@"blue.skin" isEqualToString:THEME]) {
            home.selectedImage = [[UIImage imageNamed:@"tab_blue_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            deposit.selectedImage = [[UIImage imageNamed:@"tab_blue_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            transfer.selectedImage = [[UIImage imageNamed:@"tab_blue_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            service.selectedImage = [[UIImage imageNamed:@"tab_blue_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mine.selectedImage = [[UIImage imageNamed:@"tab_blue_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = [UIColor colorWithRed:0.00 green:0.53 blue:1.00 alpha:1.0];
        } else if ([@"green.skin" isEqualToString:THEME]) {
            home.selectedImage = [[UIImage imageNamed:@"tab_green_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            deposit.selectedImage = [[UIImage imageNamed:@"tab_green_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            transfer.selectedImage = [[UIImage imageNamed:@"tab_green_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            service.selectedImage = [[UIImage imageNamed:@"tab_green_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mine.selectedImage = [[UIImage imageNamed:@"tab_green_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = [UIColor colorWithRed:0.08 green:0.50 blue:0.37 alpha:1.0];
        } else if ([@"pink.skin" isEqualToString:THEME]) {
            home.selectedImage = [[UIImage imageNamed:@"tab_pink_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            deposit.selectedImage = [[UIImage imageNamed:@"tab_pink_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            transfer.selectedImage = [[UIImage imageNamed:@"tab_pink_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            service.selectedImage = [[UIImage imageNamed:@"tab_pink_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mine.selectedImage = [[UIImage imageNamed:@"tab_pink_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = [UIColor colorWithRed:0.88 green:0.10 blue:0.48 alpha:1.0];
        } else {
            home.selectedImage = [[UIImage imageNamed:@"tab_default_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            deposit.selectedImage = [[UIImage imageNamed:@"tab_default_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            transfer.selectedImage = [[UIImage imageNamed:@"tab_default_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            service.selectedImage = [[UIImage imageNamed:@"tab_default_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mine.selectedImage = [[UIImage imageNamed:@"tab_default_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = [UIColor colorWithRed:0.09 green:0.40 blue:0.73 alpha:1.0];
        }
    }else if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
        UITabBarItem *saveMoneyItem = [self.tabBar.items objectAtIndex:0];
        UITabBarItem *promoItem = [self.tabBar.items objectAtIndex:1];
        UITabBarItem *homeItem = [self.tabBar.items objectAtIndex:2];
        UITabBarItem *serviceItem = [self.tabBar.items objectAtIndex:3];
        UITabBarItem *mineItem = [self.tabBar.items objectAtIndex:4];
        
        if ([THEMEV3 isEqualToString:@"green"]){
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = RH_NavigationBar_BackgroundColor_Green;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = RH_NavigationBar_BackgroundColor_Red;
            
        }else if ([THEMEV3 isEqualToString:@"black"]){
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = colorWithRGB(21, 141, 246);
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = RH_NavigationBar_BackgroundColor_Orange;
        }else if ([THEMEV3 isEqualToString:@"red_white"]){
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = RH_NavigationBar_BackgroundColor_Red_White;
        }else if ([THEMEV3 isEqualToString:@"green_white"]){
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = RH_NavigationBar_BackgroundColor_Green_White;
        }else if ([THEMEV3 isEqualToString:@"orange_white"]){
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = RH_NavigationBar_BackgroundColor_Orange_White;
        }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_coffee"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_coffee"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_coffee"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_coffee"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_coffee"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = RH_NavigationBar_BackgroundColor_Coffee_White;
        }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_coffee"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_coffee"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_coffee"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_coffee"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_coffee"]
                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = RH_NavigationBar_BackgroundColor_Coffee_Black;
        }else{
            saveMoneyItem.selectedImage = [[UIImage imageNamed:@"tab_v3_home_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            promoItem.selectedImage = [[UIImage imageNamed:@"tab_v3_deposit_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            homeItem.selectedImage = [[UIImage imageNamed:@"tab_v3_promo_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            serviceItem.selectedImage = [[UIImage imageNamed:@"tab_v3_service_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mineItem.selectedImage = [[UIImage imageNamed:@"tab_v3_my_selected_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = RH_NavigationBar_BackgroundColor;
        }
        
    }else if ([@"lottery" isEqualToString:SITE_TYPE]) {
        transfer.image = [[UIImage imageNamed:@"tab_withdraw"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        deposit.image = [[UIImage imageNamed:@"tab_lottery_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        transfer.image = [[UIImage imageNamed:@"tab_hall_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        service.image = [[UIImage imageNamed:@"tab_bet_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


        home.selectedImage = [[UIImage imageNamed:@"tab_lottery_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        deposit.selectedImage = [[UIImage imageNamed:@"tab_lottery_deposit_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        transfer.selectedImage = [[UIImage imageNamed:@"tab_hall_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        service.selectedImage = [[UIImage imageNamed:@"tab_bet_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        mine.selectedImage = [[UIImage imageNamed:@"tab_lottery_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBar.tintColor = [UIColor colorWithRed:0.87 green:0.32 blue:0.30 alpha:1.0];
    }
}
//    if ([@"185" isEqualToString:SID]) {
//        home.title = @"メインページ";
//        deposit.title = @"振込";
//        transfer.title = @"振替";
//        service.title = @"サービス";
//        mine.title = @"マイ";
//    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (super.selectedIndex!=selectedIndex){
        if (selectedIndex>=0 && selectedIndex<self.viewControllers.count){
            [super setSelectedIndex:selectedIndex] ;
        }
    }
}

#pragma mark -
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    static int index = 0;
//    RH_CustomTabBar *tabbar = (RH_CustomTabBar *)tabBar;
//    for (int i = 0; i < tabBar.items.count; i++) {
//        if (tabBar.items[i] == item) {
//            index = i;
//        }
//    }
//    if (index != 2) {
//        [tabbar setViewBackgroundColor:[UIColor whiteColor]];
//    }else {
//        [tabbar setViewBackgroundColor:[UIColor blackColor]];
//    }
//}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if ([super tabBarController:tabBarController shouldSelectViewController:viewController]) {

        if (viewController != self.selectedViewController)
        {
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                UIViewController * rootViewController = [(UINavigationController *)viewController topViewController];
                //
                if ([rootViewController isKindOfClass:[RH_CustomServicePageViewController class]]){
                    if ([SID isEqualToString:@"211"] ||[SID isEqualToString:@"136"]||[SID isEqualToString:@"270"]){
                        RH_APPDelegate *appDelegate =  ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate)  ;
                        openURL(appDelegate.servicePath.trim) ;
                        return NO ;
                    }
                }
                
                if ([rootViewController isKindOfClass:[CLViewController class]]) {
                    [(CLViewController *)rootViewController tryRefreshData];
                }
            }
        }else{
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                UIViewController * rootViewController = [(UINavigationController *)viewController topViewController];
                if ([rootViewController isKindOfClass:[CLViewController class]]) {
                    ifRespondsSelector(rootViewController, @selector(tryRefreshData)){
                        [(CLViewController *)rootViewController tryRefreshData];
                    }
                }
            }
        }
        return YES;
    }
    
    return NO;
}

#pragma mark -

- (BOOL)shouldAutorotate {
//    return NO;
    return [self.selectedViewController shouldAutorotate];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
//    return UIInterfaceOrientationMaskPortrait;
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


#pragma mark -

- (BOOL)changeToShowViewControllerWithViewControllerClass:(Class)viewControllerClass
{
    if ([viewControllerClass isSubclassOfClass:[CLViewController class]]) {

        //隐藏所有子视图
        [[self class] hideAllSubViews:NO];
        //查找并显示
        NSUInteger index = 0;
        for (UINavigationController * viewController in self.viewControllers) {
            if ([[viewController.viewControllers firstObject] isMemberOfClass:viewControllerClass]) {
                self.selectedIndex = index;
                return YES;
            }
            ++ index;
        }
    }

    return NO;
}

@end

//----------------------------------------------------------

@implementation UIViewController (currentTopViewController)

- (UIViewController *)currentTopViewController
{
    id presentedViewController = self.presentedViewController;

    if (presentedViewController) {
        return [presentedViewController currentTopViewController];
    }else if ([self isKindOfClass:[UINavigationController class]]){
        return [[(UINavigationController *)self topViewController] currentTopViewController];
    }else if ([self isKindOfClass:[UITabBarController class]]){
        return [[(UITabBarController *)self selectedViewController] currentTopViewController];
    }

    return self;
}

@end
