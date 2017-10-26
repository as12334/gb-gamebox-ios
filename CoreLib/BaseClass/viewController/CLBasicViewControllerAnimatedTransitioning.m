//
//  CLBasicViewControllerAnimatedTransitioning.m
//  CoreLib
//
//  Created by jinguihua on 2016/11/29.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLBasicViewControllerAnimatedTransitioning.h"
#import "MacroDef.h"

@implementation CLBasicViewControllerAnimatedTransitioning

- (id)init
{
    self = [super init];

    if (self) {
        _transitionDuration = 0.4;
    }

    return self;
}

- (void)didEndTransitioningAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
                                       finished:(BOOL)isfinished
{
    BOOL isCompleted =  isfinished && ![transitionContext transitionWasCancelled];
    [transitionContext completeTransition:isCompleted];

    id<CLBasicViewControllerAnimatedTransitioningDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(viewControllerAnimatedTransitioning:didEndTransitioning:)) {
        [delegate viewControllerAnimatedTransitioning:self didEndTransitioning:isCompleted];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self didEndTransitioningAnimationWithContext:transitionContext finished:YES];
}


@end
