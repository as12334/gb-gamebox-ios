//
//  RH_LoginViewController.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/18.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicViewController.h"

@class RH_LoginViewController;
@protocol RH_LoginViewControllerDelegate <NSObject>

@optional
- (void)userLoginViewControllerDidSucceedLogin:(RH_LoginViewController *)userLoginViewController;

@end


@interface RH_LoginViewController : RH_BasicViewController
+(instancetype)shareLoginViewController ;

@property(nonatomic,weak) id<RH_LoginViewControllerDelegate> delegate;
@end
