//
//  RH_MainTabBarController.h
//  CoreLib
//
//  Created by jinguihua on 2016/12/2.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coreLib.h"

@interface RH_MainTabBarController : CLTabBarController
//返回主滑动视图实例
+ (instancetype)mainTabBarController;

+ (UIViewController*)currentCenterMainViewController;
+ (UIViewController *)currentCenterTopViewController;

//隐藏所有的子视图，包括present，naviegation到根视图
+ (void)hideAllSubViews:(BOOL)animated;

//切换到显示特定视图控制器
- (BOOL)changeToShowViewControllerWithViewControllerClass:(Class)viewControllerClass;

@end


//----------------------------------------------------------

@interface UIViewController (currentTopViewController)

- (UIViewController *)currentTopViewController;

@end
