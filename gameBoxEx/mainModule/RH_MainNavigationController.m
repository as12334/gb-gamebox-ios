//
//  RH_MainNavigationController.m
//  CoreLib
//
//  Created by jinguihua on 2016/12/2.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "RH_MainNavigationController.h"
#import "CLNavigationTransitioningDelegate.h"
#import "CLViewControllerTransitioningDelegate.h"

@interface RH_MainNavigationController ()

@end

@implementation RH_MainNavigationController
{
    CLNavigationTransitioningDelegate * _navigationTransitioningDelegate;
    CLViewControllerTransitioningDelegate * _transitioningDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];
    self.navigationBarHidden = YES;

    //导航过渡代理
    _navigationTransitioningDelegate = [[CLNavigationTransitioningDelegate alloc] initWithNavigationController:self];

    //present过渡代理
    if (!self.useForTabRootViewController) {
        _transitioningDelegate = [[CLViewControllerTransitioningDelegate alloc] init];
        [_transitioningDelegate presentViewController:self];
    }
}

#pragma mark -

- (BOOL)shouldAutorotate {
//    return [self.topViewController shouldAutorotate];
    return YES ;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
//    return [self.topViewController supportedInterfaceOrientations];
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{    // 返回nav栈中最后一个对象,坚持旋转的方向
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}


@end
