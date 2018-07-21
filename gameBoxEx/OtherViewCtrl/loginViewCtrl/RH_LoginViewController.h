//
//  RH_LoginViewController.h
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicViewController.h"
#import "RH_SimpleWebViewController.h"

@class  RH_LoginViewController ;
@protocol LoginViewControllerDelegate <NSObject>
-(void)loginViewViewControllerTouchBack:(RH_LoginViewController*)loginViewContrller ;
-(void)loginViewViewControllerLoginSuccessful:(RH_LoginViewController*)loginViewContrller ;
@end

@interface RH_LoginViewController : RH_SimpleWebViewController
@property(nonatomic,weak) id<LoginViewControllerDelegate> delegate;

@end
