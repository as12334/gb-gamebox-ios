//
//  RH_LoginViewController.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/18.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicViewController.h"

@class RH_LoginOCViewController;
@protocol RH_LoginOCViewControllerDelegate <NSObject>

@optional
- (void)userLoginViewControllerDidSucceedLogin:(RH_LoginOCViewController *)userLoginViewController;

@end


@interface RH_LoginOCViewController : RH_BasicViewController
+(instancetype)shareLoginViewController ;

@property(nonatomic,weak) id<RH_LoginOCViewControllerDelegate>delegate;
@end
