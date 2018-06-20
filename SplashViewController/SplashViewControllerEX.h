//
//  SplashViewControllerEX.h
//  gameBoxEx
//
//  Created by lewis on 2018/5/28.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicViewController.h"
@class SplashViewControllerEX ;
@protocol SplashViewControllerDelegate
@optional
- (BOOL)splashViewControllerWillHidden:(SplashViewControllerEX *)viewController;

@end
@interface SplashViewControllerEX : RH_BasicViewController
//代理
@property(nonatomic, weak) id<SplashViewControllerDelegate> delegate;
@end
