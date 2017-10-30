//
//  RH_LoginViewController.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/18.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicViewController.h"

@class RH_LoginViewControllerEx;
@protocol RH_LoginViewControllerExDelegate <NSObject>

@optional
- (void)userLoginViewControllerDidSucceedLogin:(RH_LoginViewControllerEx *)userLoginViewController;

@end


@interface RH_LoginViewControllerEx : RH_BasicViewController
+(instancetype)shareLoginViewController ;
@property(nonatomic,weak) id<RH_LoginViewControllerExDelegate>delegate;
@end
