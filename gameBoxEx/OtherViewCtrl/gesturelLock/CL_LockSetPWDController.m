//
//  CL_LockSetPWDController.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/17.
//  Copyright © 2017年 luis. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "CL_LockSetPWDController.h"
#import "CLGesturelLockView.h"
#import "CL_GesturelLockController.h"
@interface CL_LockSetPWDController ()
{
    NSString *pwdStr1;
    NSString *pwdStr2;
    BOOL isFirst;
}
@end

@implementation CL_LockSetPWDController
- (BOOL)isSubViewController {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
-(void)setupUI{
    isFirst = YES;
    self.title = @"设置解锁密码";
    self.view.backgroundColor = RH_NavigationBar_BackgroundColor;
    CLGesturelLockView *lockView = [[CLGesturelLockView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH)*0.5,SCREEN_WIDTH,SCREEN_WIDTH) WithMode:PwdStateSetting];
    [lockView setBtnImage:[UIImage imageNamed:@"gesturelLock_normal"]];
    [lockView setBtnSelectdImgae:[UIImage imageNamed:@"gesturelLock_Selected"]];
    [lockView setBtnErrorImage:[UIImage imageNamed:@"gesturelLock_error"]];
    __weak typeof (self)vcs = self;
    lockView.setPwdData = ^(NSString *resultPwd){
        
        if (isFirst == YES) {
            pwdStr1 = resultPwd;
            isFirst = NO;
            vcs.title = @"请再次设置解锁密码";
            return;
        }else{
            pwdStr2 = resultPwd;
        }
        if ([pwdStr1 isEqualToString:pwdStr2]) {
            [[NSUserDefaults standardUserDefaults] setObject:resultPwd forKey:@"passWord"];
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                CL_GesturelLockController *vc = [[CL_GesturelLockController alloc]init];
                [vcs.navigationController pushViewController:vc animated:YES];
            }
        }else{
//            [WSProgressHUD showErrorWithStatus:@"两次设置的密码不一致"];
            vcs.title = @"设置解锁密码";
            isFirst = YES;
            pwdStr2 = @"";
            pwdStr1 = @"";
        }
    };
    
    [self.view addSubview:lockView];
}

@end
