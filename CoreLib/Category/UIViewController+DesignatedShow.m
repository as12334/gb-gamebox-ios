//
//  UIViewController+DesignatedShow.m
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "UIViewController+DesignatedShow.h"
#import "UIViewController+Instance.h"
#import <objc/runtime.h>

static char showViewControllerDelegateKey;

@implementation UIViewController (DesignatedShow)
- (CLViewControllerDesignatedShowWay)viewControllerDesignatedShowWay {
    return CLViewControllerDesignatedShowWayPresent;
}

- (BOOL)showViewControllerWithDesignatedWay:(UIViewController *)viewController
                                   animated:(BOOL)animated
                             completedBlock:(void (^)())completedBlock
{
    //进行转发
    id<CLShowViewControllerDelegate> delegate = self.showViewControllerDelegate;
    if (delegate && [delegate respondsToSelector:@selector(object:wantToShowViewController:animated:completedBlock:)]) {
        return [delegate object:self wantToShowViewController:viewController animated:animated completedBlock:completedBlock];
    }

    if (!viewController) {
        NSLog(@"viewController为nil,显示失败");
        return NO;
    }

    //将要显示视图
    if ([viewController respondsToSelector:@selector(willShowBaseViewController:)] && ![viewController willShowBaseViewController:self]) {
        return NO;
    }

    //获取要显示的视图
    UIViewController * viewControllerForShow = [viewController relocationViewControllerForShowBaseViewController:self];

    switch ([viewController viewControllerDesignatedShowWay]) {
        case CLViewControllerDesignatedShowWayPush:
        {

            UINavigationController * navigationController = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;

            if (!navigationController) {
                NSLog(@"当前ViewController不为UINavigationController实例或者不在navigationController中,无法用push方式显示视图");
                return NO;
            }else{
                [navigationController pushViewController:viewControllerForShow animated:animated];

                if (completedBlock) {
                    completedBlock();
                }
            }
        }
            break;

        case CLViewControllerDesignatedShowWayPresent:
            [self presentViewController:viewControllerForShow animated:animated completion:completedBlock];
            break;

        case CLViewControllerDesignatedShowWayUserDefine:
            return [viewControllerForShow showWithUserDefineWayBasicViewController:self
                                                                          animated:animated
                                                                    completedBlock:completedBlock];

            break;
    }

    return YES;
}

- (UIViewController *)relocationViewControllerForShowBaseViewController:(UIViewController *)baseViewController {
    return self;
}

- (BOOL)showWithUserDefineWayBasicViewController:(UIViewController *)basicViewController
                                        animated:(BOOL)animated
                                  completedBlock:(void (^)())completedBlock
{
    if ([self viewControllerDesignatedShowWay] != CLViewControllerDesignatedShowWayUserDefine) {
        NSLog(@"当前viewController设计的显示方式非用户自定义，自定义显示失败");
        return NO;
    }

    NSLog(@"无默认的自定义显示方式，显示失败");

    return NO;
}

- (BOOL)hideWithDesignatedWay:(BOOL)animated completedBlock:(void(^)())completedBlock
{
    //首先进行转发
    id<CLShowViewControllerDelegate> delegate = self.showViewControllerDelegate;
    if (delegate && [delegate respondsToSelector:@selector(objectWantToHideViewController:animated:completedBlock:)]) {
        return [delegate objectWantToHideViewController:self animated:animated completedBlock:completedBlock];
    }

    switch ([self viewControllerDesignatedShowWay]) {
        case CLViewControllerDesignatedShowWayPush:

            if(!self.navigationController){
                NSLog(@"当前viewController不在navigationController中，无法以pop方式隐藏");
                return NO;
            }else{

                NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
                if (index >= 1 && index != NSNotFound) {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[index - 1]
                                                          animated:YES];

                    if (completedBlock) {
                        completedBlock();
                    }

                }else {

                    NSLog(@"当前viewController输入根视图或存在问题无法隐藏，无法以pop方式隐藏");
                    return NO;
                }
            }

            break;

        case CLViewControllerDesignatedShowWayPresent:

            if (!self.presentingViewController) {
                NSLog(@"当前viewController未被Present，无法以Dimiss方式隐藏");
                return NO;
            }else{
                [self.presentingViewController dismissViewControllerAnimated:animated completion:completedBlock];
            }

            break;

        case CLViewControllerDesignatedShowWayUserDefine:

            return [self hideWithUserDefineWay:animated completedBlock:completedBlock];

            break;
    }

    return YES;
}

- (BOOL)hideWithUserDefineWay:(BOOL)animated completedBlock:(void (^)())completedBlock
{
    if ([self viewControllerDesignatedShowWay] != CLViewControllerDesignatedShowWayUserDefine) {
        NSLog(@"当前viewController设计的隐藏方式非用户自定义，自定义隐藏失败");
        return NO;
    }

    NSLog(@"无默认的自定义隐藏方式，显示失败");
    return NO;
}


#pragma mark -

+ (instancetype)showViewControllerWithContext:(id)context
                           baseViewController:(UIViewController *)baseViewController
                                     animated:(BOOL)animted
                               completedBlock:(void (^)())completedBlock
{
    baseViewController = baseViewController ?: [self defaultShowBaseViewController];
    if (baseViewController && [self willCreateInstaceWithContext:context
                                       forShowBaseViewController:baseViewController
                                                        animated:animted
                                                  completedBlock:completedBlock])
    {

        UIViewController * instance = [self viewControllerWithContext:context];
        if ([baseViewController showViewControllerWithDesignatedWay:instance animated:animted completedBlock:completedBlock]) {
            return instance;
        }
    }

    return nil;
}

+ (UIViewController *)defaultShowBaseViewController {
    return nil;
}

+ (BOOL)willCreateInstaceWithContext:(id)context
           forShowBaseViewController:(UIViewController *)baseViewController
                            animated:(BOOL)animted
                      completedBlock:(void(^)())completedBlock
{
    return YES;
}

#pragma mark -

- (id<CLShowViewControllerDelegate>)showViewControllerDelegate {
    return objc_getAssociatedObject(self, &showViewControllerDelegateKey);
}

- (void)setShowViewControllerDelegate:(id<CLShowViewControllerDelegate>)showViewControllerDelegate {
    objc_setAssociatedObject(self, &showViewControllerDelegateKey, showViewControllerDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<CLShowViewControllerDelegate>)forwardingTargetForShowViewController:(UIViewController *)viewController {
    return self.showViewControllerDelegate;
}

@end
