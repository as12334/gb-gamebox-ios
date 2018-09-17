//
//  UIViewController+RHScrollPageController.h
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RHScrollPageController)
/**
 *  所有子控制的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作
 */
@property (nonatomic, weak) UIViewController *scrollPageParentViewController;

@end
