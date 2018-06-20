//
//  RH_MainTabBarControllerEx.h
//  cpLottery
//
//  Created by luis on 2017/11/15.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_MainNavigationController.h"

@interface RH_MainTabBarControllerEx : UIViewController
//创建实例
+ (RH_MainNavigationController *)createInstanceEmbedInNavigationControllerWithContext:(id)context;

//返回主导航视图实例
+ (RH_MainNavigationController *)mainNavigationController;
//返回主页视图实例
+ (instancetype)mainTabBarController;

//当前显示的最上面的视图
+ (UIViewController *)currentCenterTopViewController;

//隐藏所有的子视图，包括present，naviegation到根视图
+ (void)hideAllSubViews:(BOOL)animated;

//tabbar 切换
-(void)switchToTabIndex:(NSUInteger)tabIndex ;
@end


@interface UIViewController (currentTopViewControllerEx)

- (UIViewController *)currentTopViewController;

@end
