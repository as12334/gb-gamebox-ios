//
//  RH_VeriftyCloseViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_VeriftyCloseViewController.h"
//#import "RH_GesturelLockView.h"
#import "RH_VerifyCloseView.h"
#import "RH_LockSetPWDController.h"
#import "MBProgressHUD.h"
#import "RH_GestureOpenLockView.h"
#import "RH_VeriftyLoginPWDViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RH_VeriftyCloseViewController ()<VerifyCloseViewDelegate>
@property(nonatomic,strong)RH_VerifyCloseView *verifyCloseView;

@end

@implementation RH_VeriftyCloseViewController
@synthesize verifyCloseView = _verifyCloseView;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.hiddenStatusBar = YES ;
    self.hiddenTabBar = YES;
//    self.hiddenNavigationBar = YES ;
    self.title = @"清空手势密码";
    
    [self.view addSubview:self.verifyCloseView];
}
- (BOOL)isSubViewController {
    return YES;
}
-(RH_VerifyCloseView *)verifyCloseView
{
    if (!_verifyCloseView) {
        _verifyCloseView = [[RH_VerifyCloseView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT+NavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - STATUS_HEIGHT-NavigationBarHeight)];
        _verifyCloseView.delegate = self ;
    }
    return _verifyCloseView ;
}

-(void)VerifyCloseViewVerifySuccessful:(RH_VerifyCloseView *)VerifyCloseView
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}
- (void)fogetPassWordBtnClick{
    //忘记手势密码按钮点击事件
    RH_VeriftyLoginPWDViewController *vc = [[RH_VeriftyLoginPWDViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
