//
//  UIViewController+RHScrollPageController.m
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "UIViewController+RHScrollPageController.h"
#import <objc/runtime.h>
@implementation UIViewController (RHScrollPageController)
static char key;
- (void)setScrollPageParentViewController:(UIViewController *)scrollPageParentViewController {
    objc_setAssociatedObject(self, &key, scrollPageParentViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)scrollPageParentViewController {
    return (UIViewController *)objc_getAssociatedObject(self, &key);
}
@end
