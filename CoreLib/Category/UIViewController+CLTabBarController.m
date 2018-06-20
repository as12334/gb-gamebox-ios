//
//  UIViewController+CLTabBarController.m
//  CoreLib
//
//  Created by jinguihua on 2016/11/29.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "UIViewController+CLTabBarController.h"
#import "CLTabBarController.h"
#import "MacroDef.h"
#import  <objc/runtime.h>


static char tabBarInteractiveEnabledkey,gestureHiddenTabBarEnabledKey;

@implementation UIViewController (CLTabBarController)

- (CLTabBarController *)myTabBarController
{
    if ([self isKindOfClass:[CLTabBarController class]]) {
        return (CLTabBarController *)self;
    }else{

        UITabBarController * tabBarController = self.tabBarController;
        if (tabBarController && [tabBarController isKindOfClass:[CLTabBarController class]]) {
            return (CLTabBarController *)tabBarController;
        }else if (self.parentViewController){
            return [self.parentViewController myTabBarController];
        }else{
            return [[UIApplication sharedApplication].keyWindow.rootViewController myTabBarController] ;
        }
    }
}

#pragma mark - CLTabBarControllerTransitioningProtocol

- (CLBasicViewControllerAnimatedTransitioning *)changeTabAnimatedTransitioningForDiretion:(CLTabChangeDirection)diretion
{
    MyAssert(diretion != CLTabChangeDirectionNone);

    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];
    return childViewController ? [childViewController changeTabAnimatedTransitioningForDiretion:diretion] : nil;
}

- (BOOL)isInteractiveChangeTabEnabled
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];
    return childViewController ? [childViewController isInteractiveChangeTabEnabled] :[objc_getAssociatedObject(self, &tabBarInteractiveEnabledkey) boolValue];
}

- (void)setInteractiveChangeTabEnabled:(BOOL)interactiveChangeTabEnabled
{
    objc_setAssociatedObject(self, &tabBarInteractiveEnabledkey, interactiveChangeTabEnabled ? @YES : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTabBarInteracting {
    return [self myTabBarController].isInteracting;
}

- (BOOL)isTabBarTransitioning {
    return [self myTabBarController].isTabBarTransitioning;
}

- (BOOL)interactiveGestureChangeTabShouldReceiveTouch:(UITouch *)touch
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];
    return childViewController ? [childViewController interactiveGestureChangeTabShouldReceiveTouch:touch] : YES;
}

- (BOOL)interactiveGestureChangeTabShouldBeginWithPoint:(CGPoint)point andDirection:(CLTabChangeDirection)diretion
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];
    return childViewController ? [childViewController interactiveGestureChangeTabShouldBeginWithPoint:point
                                                                                         andDirection:diretion] : YES;
}

- (float)interactiveChangeTabCompletePercentForTranslation:(CGPoint)translation
                                                 direction:(CLTabChangeDirection)diretion
                                                startPoint:(CGPoint)startPoint
{
    MyAssert(diretion != CLTabChangeDirectionNone);

    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];
    if (childViewController) {
        return [childViewController interactiveChangeTabCompletePercentForTranslation:translation
                                                                            direction:diretion
                                                                           startPoint:startPoint];
    }else{
        //计算比例
        float completePercent = ((diretion == CLTabChangeDirectionPrev) ? translation.x : - translation.x) / CGRectGetWidth(self.view.bounds);

        return completePercent;
    }
}

- (void)startInteractiveChangeTabWithDirection:(CLTabChangeDirection)diretion
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];

    if (childViewController) {
        [childViewController startInteractiveChangeTabWithDirection:diretion];
    }
}

- (void)finishInteractiveChangeTabWithDirection:(CLTabChangeDirection)diretion
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];

    if (childViewController) {
        [childViewController finishInteractiveChangeTabWithDirection:diretion];
    }
}

- (void)cancelInteractiveChangeTabWithDirection:(CLTabChangeDirection)diretion
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];

    if (childViewController) {
        [childViewController cancelInteractiveChangeTabWithDirection:diretion];
    }
}

#pragma mark - CLTabBarControllerTabBarHiddenProtocol

- (BOOL)isGestureHiddenTabBarEnabled
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];
    return childViewController ? [childViewController isGestureHiddenTabBarEnabled] :[objc_getAssociatedObject(self, &gestureHiddenTabBarEnabledKey) boolValue];
}

- (void)setGestureHiddenTabBarEnabled:(BOOL)gestureHiddenTabBarEnabled
{
    objc_setAssociatedObject(self, &gestureHiddenTabBarEnabledKey, gestureHiddenTabBarEnabled ? @YES : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hiddenTabBarGestureShouldReceiveTouch:(UITouch *)touch
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];
    return childViewController ? [childViewController hiddenTabBarGestureShouldReceiveTouch:touch] : YES;
}

- (CGFloat)minMoveValueForHiddenTabBar
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];
    return childViewController ? [childViewController minMoveValueForHiddenTabBar] : 20.f;
}

- (void)gestureWantToHiddenTabBar:(BOOL)hidden
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];

    if (childViewController) {
        [childViewController gestureWantToHiddenTabBar:hidden];
    }
}

- (BOOL)tabBarWillGestureHidden:(BOOL)hidden
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];
    return childViewController ? [childViewController tabBarWillGestureHidden:hidden] : YES;
}

- (void)animationWhenTabBarGestureHidden:(BOOL)hidden
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];

    if (childViewController) {
        [childViewController animationWhenTabBarGestureHidden:hidden];
    }
}

- (void)tabBarDidGestureHidden:(BOOL)hidden
{
    UIViewController * childViewController = [self childViewControllerForTabBarControllerTransitioning];

    if (childViewController) {
        [childViewController tabBarDidGestureHidden:hidden];
    }
}

- (UIViewController *)childViewControllerForTabBarControllerTransitioning
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)self topViewController];
    }

    if ([self isKindOfClass:[UITabBarController class]]) {
        return [(UITabBarController *)self selectedViewController];
    }

    return nil;
}

- (UIViewController *)childViewControllerForTabBarHidden
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)self topViewController];
    }

    if ([self isKindOfClass:[UITabBarController class]]) {
        return [(UITabBarController *)self selectedViewController];
    }

    return nil;
}


@end
