//
//  CLTabBarController.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/29.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLBasicViewControllerAnimatedTransitioning.h"

/*
 *
 *该类实现了动画切换当前显示的视图，隐藏和显示tabbar
 *
 */
@interface CLTabBarController : UITabBarController<UITabBarControllerDelegate,
                                                   UIGestureRecognizerDelegate,
                                                   CLBasicViewControllerAnimatedTransitioningDelegate>



@property(nonatomic) BOOL tabBarHidden;

/*
 *设置tabbar的隐藏于显示，hidden为yes为隐藏，否则为显示，animated决定是否有动画效果
 *animations为需要执行的额外动画（animated为yes时才会执行），无需任何额外动画，请传入nil
 *completionBlock为操作完成后执行的代码块，无需请传入nil
 */
- (void)setTabBarHidden:(BOOL)hidden
               animated:(BOOL)animated
             animations:(void(^)(void))animations
             completion:(void (^)(void))completionBlock;


@property(nonatomic, readonly, getter = isInteracting) BOOL interacting;
@property(nonatomic, readonly, getter = isTransitioning) BOOL transitioning;

@end
