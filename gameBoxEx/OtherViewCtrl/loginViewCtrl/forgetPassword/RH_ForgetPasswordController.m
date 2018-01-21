//
//  RH_ForgetPasswordController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ForgetPasswordController.h"
#import "RH_ForgetPasswordView.h"
@interface RH_ForgetPasswordController ()
@property(nonatomic,strong,readonly)RH_ForgetPasswordView *passwordView;
@end

@implementation RH_ForgetPasswordController
@synthesize passwordView = _passwordView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    [self.contentView addSubview:self.passwordView];
}
-(RH_ForgetPasswordView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [RH_ForgetPasswordView createInstance];
        _passwordView.frame = CGRectMake(0, StatusBarHeight+NavigationBarHeight, MainScreenW, MainScreenH-StatusBarHeight-NavigationBarHeight);
    }
    return _passwordView;
}

@end
