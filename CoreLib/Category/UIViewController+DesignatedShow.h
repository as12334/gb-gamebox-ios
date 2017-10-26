//
//  UIViewController+DesignatedShow.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "help.h"
#import "NSObject+ShowViewControllerDelegate.h"

@protocol CLDesignatedShowProtocol <NSObject>

@required
//设计的方式显示
- (CLViewControllerDesignatedShowWay)viewControllerDesignatedShowWay;

//通过设计的显示方法显示
- (BOOL)showViewControllerWithDesignatedWay:(UIViewController *)viewController
                                   animated:(BOOL)animated
                             completedBlock:(void(^)())completedBlock;


@optional

//将要显示
- (BOOL)willShowBaseViewController:(UIViewController *)baseViewController;

@required

//重定向的用于显示的视图控制器，当要以某一种方法显示视图时，可能需要将该视图加入某一容器视图后再显示，或者重定向到另一个视图显示，默认返回视图控制器自己
- (UIViewController *)relocationViewControllerForShowBaseViewController:(UIViewController *)baseViewController;

//隐藏
- (BOOL)hideWithDesignatedWay:(BOOL)animated completedBlock:(void(^)())completedBlock;


//用户定义的方式显示
- (BOOL)showWithUserDefineWayBasicViewController:(UIViewController *)basicViewController
                                        animated:(BOOL)animated
                                  completedBlock:(void(^)())completedBlock;
- (BOOL)hideWithUserDefineWay:(BOOL)animated completedBlock:(void(^)())completedBlock;


//默认的初始化并显示方法
+ (instancetype)showViewControllerWithContext:(id)context
                           baseViewController:(UIViewController *)baseViewController
                                     animated:(BOOL)animted
                               completedBlock:(void(^)())completedBlock;

//默认的显示时候基于的视图控制器，当showViewControllerWithContext:baseViewController:animated:completedBlock:传入的baseViewController为nil时会使用该方法获取默认基于的视图控制器，默认返回nil
+ (UIViewController *)defaultShowBaseViewController;

//将要创建实例并基于baseViewController显示
+ (BOOL)willCreateInstaceWithContext:(id)context
           forShowBaseViewController:(UIViewController *)baseViewController
                            animated:(BOOL)animted
                      completedBlock:(void(^)())completedBlock;


@end



@interface UIViewController (DesignatedShow) <CLDesignatedShowProtocol>

//显示视图的转发代理（如果设置了代理且实现了方法，任何显示隐藏视图相关方法都会被转发）
@property(nonatomic,weak) id<CLShowViewControllerDelegate> showViewControllerDelegate;
@end
