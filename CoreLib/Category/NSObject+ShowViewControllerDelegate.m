//
//  NSObject+ShowViewControllerDelegate.m
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "NSObject+ShowViewControllerDelegate.h"
#import "UIViewController+DesignatedShow.h"

@implementation NSObject (ShowViewControllerDelegate)

- (BOOL)object:(id)object wantToShowViewController:(UIViewController *)viewController animated:(BOOL)animated completedBlock:(void(^)())completedBlock
{
    id<CLShowViewControllerDelegate> forwardingTarget = [self forwardingTargetForShowViewController:viewController];

    if (forwardingTarget && [forwardingTarget respondsToSelector:_cmd]) {

        return [forwardingTarget object:self wantToShowViewController:viewController animated:animated completedBlock:completedBlock];

    }else if ([self isKindOfClass:[UIViewController class]]) {

        return [(UIViewController *)self showViewControllerWithDesignatedWay:viewController
                                                                    animated:animated
                                                              completedBlock:completedBlock];
    }


    return NO;
}

- (BOOL)objectWantToHideViewController:(id)object animated:(BOOL)animated completedBlock:(void(^)())completedBlock
{
    id<CLShowViewControllerDelegate> forwardingTarget = [self forwardingTargetForShowViewController:nil];

    if (forwardingTarget && [forwardingTarget respondsToSelector:_cmd]) {

        return [forwardingTarget objectWantToHideViewController:object animated:animated completedBlock:completedBlock];

    }else if ([self isKindOfClass:[UIViewController class]]) {

        return [(UIViewController *)self hideWithDesignatedWay:animated completedBlock:completedBlock];

    }

    return NO;
}

- (id<CLShowViewControllerDelegate>)forwardingTargetForShowViewController:(UIViewController *)viewController {
    return nil;
}


@end
