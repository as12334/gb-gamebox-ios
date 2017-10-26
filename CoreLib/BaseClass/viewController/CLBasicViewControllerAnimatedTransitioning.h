//
//  CLBasicViewControllerAnimatedTransitioning.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/29.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------------------------------------------------------

@class CLBasicViewControllerAnimatedTransitioning;

//----------------------------------------------------------

@protocol CLBasicViewControllerAnimatedTransitioningDelegate <NSObject>

@optional

- (void)viewControllerAnimatedTransitioning:(CLBasicViewControllerAnimatedTransitioning *)viewControllerAnimatedTransitioning didEndTransitioning:(BOOL)completed;

@end

//----------------------------------------------------------

//该类为视图控制器过渡动画基类
NS_CLASS_AVAILABLE_IOS(7_0) @interface CLBasicViewControllerAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

- (void)didEndTransitioningAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
                                       finished:(BOOL)isfinished;

@property(nonatomic,weak) id<CLBasicViewControllerAnimatedTransitioningDelegate> delegate;

//动画时长，默认为0.4f;
@property(nonatomic) NSTimeInterval transitionDuration ;

@end
