//
//  RH_LoginViewControllerEx.h
//  gameBoxEx
//
//  Created by luis on 2017/12/5.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicSubViewController.h"

@class  RH_LoginViewControllerEx ;
@protocol LoginViewControllerExDelegate <NSObject>
-(void)loginViewViewControllerExTouchBack:(RH_LoginViewControllerEx*)loginViewContrller BackToFirstPage:(BOOL)bFirstPage;
-(void)loginViewViewControllerExLoginSuccessful:(RH_LoginViewControllerEx*)loginViewContrller ;
-(void)loginViewViewControllerExSignSuccessful:(RH_LoginViewControllerEx*)loginViewContrller SignFlag:(BOOL)bFlag;
@end

@interface RH_LoginViewControllerEx : RH_BasicSubViewController
@property(nonatomic,weak) id<LoginViewControllerExDelegate> delegate;
@end
