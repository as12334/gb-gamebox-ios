//
//  UIViewController+CLTabBarController.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/29.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLBasicViewControllerAnimatedTransitioning.h"
#import "help.h"

//----------------------------------------------------------

@protocol CLTabBarControllerTransitioningProtocol

//切换tab标签的过渡动画
- (CLBasicViewControllerAnimatedTransitioning *)changeTabAnimatedTransitioningForDiretion:(CLTabChangeDirection)diretion;

//是否可以交互切换tab
@property(nonatomic, getter = isInteractiveChangeTabEnabled) BOOL interactiveChangeTabEnabled;
//是否正在交互切换tab
@property(nonatomic, readonly, getter = isTabBarInteracting) BOOL tabBarInteracting;
@property(nonatomic, readonly, getter = isTabBarTransitioning) BOOL tabBarTransitioning;



//手势将要收到触摸
- (BOOL)interactiveGestureChangeTabShouldReceiveTouch:(UITouch *)touch;

//将要开始
- (BOOL)interactiveGestureChangeTabShouldBeginWithPoint:(CGPoint)point andDirection:(CLTabChangeDirection)diretion;

//计算进度
- (float)interactiveChangeTabCompletePercentForTranslation:(CGPoint)translation
                                                 direction:(CLTabChangeDirection)diretion
                                                startPoint:(CGPoint)startPoint;


//交互过程
- (void)startInteractiveChangeTabWithDirection:(CLTabChangeDirection)diretion;
- (void)finishInteractiveChangeTabWithDirection:(CLTabChangeDirection)diretion;
- (void)cancelInteractiveChangeTabWithDirection:(CLTabChangeDirection)diretion;

//用于TabBarControllerTransitioning的子视图控制器，默认为nil,不能为self
- (UIViewController *)childViewControllerForTabBarControllerTransitioning;

@end

//----------------------------------------------------------

@protocol CLTabBarControllerTabBarHiddenProtocol

/*
 *是否可以通过滑动隐藏及显示TabBar，默认为NO
 */
@property(nonatomic, getter = isGestureHiddenTabBarEnabled) BOOL gestureHiddenTabBarEnabled;

//隐藏tabbar手势是否接收touch
- (BOOL)hiddenTabBarGestureShouldReceiveTouch:(UITouch *)touch;

//响应隐藏tabbar的临界值
- (CGFloat)minMoveValueForHiddenTabBar;

/*
 *手势想要隐藏tabbar，该函数调用后将判断是否可以被隐藏和tabBarWillGestureHidden
 */
- (void)gestureWantToHiddenTabBar:(BOOL)hidden;

/*
 *tabBar将要由于滑动隐藏或显示（hidden为YES为隐藏，否则为显示）
 *
 *默认该函数不执行任何操作，如果有需要请从子类覆盖该函数执行你想要的操作
 */
- (BOOL)tabBarWillGestureHidden:(BOOL)hidden;

/*
 *tabBar由于滑动隐藏或显示（hidden为YES为隐藏，否则为显示）时会执行的动作
 *
 *默认该函数不执行任何操作，如果有需要请从子类覆盖该函数执行你想要的操作
 */
- (void)animationWhenTabBarGestureHidden:(BOOL)hidden;

/*
 *tabBar已经由于滑动隐藏或显示（hidden为YES为隐藏，否则为显示）
 *
 *默认该函数不执行任何操作，如果有需要请从子类覆盖该函数执行你想要的操作
 */
- (void)tabBarDidGestureHidden:(BOOL)hidden;

//用于TabBarHidden的子视图控制器，默认为nil
- (UIViewController *)childViewControllerForTabBarHidden;

@end

//----------------------------------------------------------
@class CLTabBarController;
//----------------------------------------------------------
@interface UIViewController (CLTabBarController)<CLTabBarControllerTransitioningProtocol,CLTabBarControllerTabBarHiddenProtocol>

/*
 *获取当前页面的MyTabBarControlle，如果无返回nil
 */
@property(nonatomic,readonly) CLTabBarController * myTabBarController;

@end
