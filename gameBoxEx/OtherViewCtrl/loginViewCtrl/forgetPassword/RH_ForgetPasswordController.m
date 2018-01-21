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
-(BOOL)isSubViewController
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.passwordView];
}
-(RH_ForgetPasswordView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [RH_ForgetPasswordView createInstance];
        _passwordView.frame = self.view.bounds;
    }
    return _passwordView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
