//
//  SplashViewController.h
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicViewController.h"

@class SplashViewController ;
@protocol SplashViewControllerDelegate
@optional
- (BOOL)splashViewControllerWillHidden:(SplashViewController *)viewController;

@end


@interface SplashViewController : RH_BasicViewController
//代理
@property(nonatomic, weak) id<SplashViewControllerDelegate> delegate;
//显示
- (void)show:(BOOL)animated completedBlock:(void(^)())completedBlock;
//隐藏
- (void)hide:(BOOL)animated completedBlock:(void(^)())completedBlock;

@end
