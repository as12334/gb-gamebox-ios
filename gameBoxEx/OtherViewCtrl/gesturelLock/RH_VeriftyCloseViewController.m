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
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RH_VeriftyCloseViewController ()<VerifyCloseViewDelegate>
@property(nonatomic,strong)RH_VerifyCloseView *verifyCloseView;

@end

@implementation RH_VeriftyCloseViewController
@synthesize verifyCloseView = _verifyCloseView;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.hiddenStatusBar = YES ;
    self.hiddenTabBar = YES ;
//    self.hiddenNavigationBar = YES ;
    
    [self.view addSubview:self.verifyCloseView];
}

-(RH_VerifyCloseView *)verifyCloseView {
    if (!_verifyCloseView) {
        _verifyCloseView = [[RH_VerifyCloseView alloc] initWithFrame:self.view.bounds];
        _verifyCloseView.delegate = self ;
    }
    return _verifyCloseView ;
}

-(void)VerifyCloseViewVerifySuccessful:(RH_VerifyCloseView *)VerifyCloseView
{
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}



@end
