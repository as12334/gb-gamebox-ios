//
//  CLTabChangeTransitioning.m
//  CoreLib
//
//  Created by jinguihua on 2016/11/29.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLTabChangeTransitioning.h"
#import "MacroDef.h"

#define A_TAN_1_4  0.244979

@implementation CLTabChangeTransitioning
{
    CLTabChangeDirection           _direction;
    CLTabChangeTransitioningType   _type;
    void(^_animation)();
}

- (id)init
{
    return [self initWithTabChangeDirection:CLTabChangeDirectionNext
                                       type:CLTabChangeTransitioningTypeTranslation
                                  animation:nil];
}

- (id)initWithTabChangeDirection:(CLTabChangeDirection)direction
{
    return [self initWithTabChangeDirection:direction
                                       type:CLTabChangeTransitioningTypeTranslation
                                  animation:nil];
}

- (id)initWithTabChangeDirection:(CLTabChangeDirection)direction
                            type:(CLTabChangeTransitioningType)type
                       animation:(void(^)())animation
{
    self = [super init];

    if (self) {
        _direction = direction;
        _animation = animation;
        _type      = type;
    }

    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController * toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView    = [transitionContext containerView];

    CGFloat viewWidth   = CGRectGetWidth(containerView.bounds);
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame   = [transitionContext finalFrameForViewController:toVC];

    UIView * fromShadowView = nil;
    UIView * toShadowView = nil;

    if (_type == CLTabChangeTransitioningTypeRotation) {

        //设置旋转点
        CGFloat anchorPointY = CGRectGetWidth(initialFrame) * 2 / CGRectGetHeight(initialFrame) + 1.f;
        fromVC.view.layer.anchorPoint = CGPointMake(0.5f, anchorPointY);
        fromVC.view.center = CGPointMake(0.5f * CGRectGetWidth(initialFrame), CGRectGetHeight(initialFrame)* anchorPointY);

        toVC.view.frame = finalFrame;

    }else{

        fromVC.view.frame = initialFrame;
        toVC.view.frame   = CGRectOffset(finalFrame, _direction == CLTabChangeDirectionNext ? viewWidth : - viewWidth , 0.f);

        //设置阴影视图
        fromShadowView = [[UIView alloc] initWithFrame:fromVC.view.frame];
        fromShadowView.backgroundColor = BlackColorWithAlpha(0.6f);
        fromShadowView.alpha = 0.f;
        [containerView addSubview:fromShadowView];

    }


    toShadowView = [[UIView alloc] initWithFrame:toVC.view.frame];
    toShadowView.backgroundColor = BlackColorWithAlpha(0.6f);
    [containerView insertSubview:toShadowView belowSubview:fromVC.view];
    [containerView insertSubview:toVC.view belowSubview:toShadowView];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    toVC.view.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
#endif

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{

        //ios8以下SDK需如此不然会错乱
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        toVC.view.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
#endif
        toVC.view.transform = CGAffineTransformIdentity;


        if (_type == CLTabChangeTransitioningTypeRotation) {

            //设置旋转角度
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
            fromVC.view.transform = CGAffineTransformIdentity;
#endif
            fromVC.view.transform = (_direction == CLTabChangeDirectionPrev) ? CGAffineTransformMakeRotation(2 * A_TAN_1_4) :
            CGAffineTransformMakeRotation(- 2 * A_TAN_1_4);

        }else{

            fromVC.view.frame = CGRectOffset(initialFrame, (_direction == CLTabChangeDirectionNext) ? -viewWidth : viewWidth , 0.f);

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
            fromVC.view.transform = CGAffineTransformIdentity;
#endif
            fromVC.view.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        }


        toVC.view.frame      = finalFrame;
        fromShadowView.frame = fromVC.view.frame;
        toShadowView.frame   = finalFrame;

        fromShadowView.alpha = 1.f;
        toShadowView.alpha   = 0.f;


        //自定义动作
        if (_animation) {
            _animation();
        }

    } completion:^(BOOL finished){

        //移除
        [toShadowView removeFromSuperview];
        [fromShadowView removeFromSuperview];

        //还原
        fromVC.view.transform = CGAffineTransformIdentity;
        fromVC.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        toVC.view.transform = CGAffineTransformIdentity;

        //通知完成
        [self didEndTransitioningAnimationWithContext:transitionContext finished:finished];
    }];
}

@end
