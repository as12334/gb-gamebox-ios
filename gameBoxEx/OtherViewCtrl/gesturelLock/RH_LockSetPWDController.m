//
//  RH_LockSetPWDController.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/17.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LockSetPWDController.h"
#import "RH_GesturelLockView.h"
#import "RH_GesturelLockController.h"
#import "RH_UserInfoManager.h"
#import "coreLib.h"

@interface RH_LockSetPWDController ()
{
    NSString *pwdStr1;
    NSString *pwdStr2;
    BOOL isFirst;
}
@end

@implementation RH_LockSetPWDController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.title = @"设置解锁密码";
    isFirst = YES;
}
-(void)setupUI{
    self.view.backgroundColor = RH_NavigationBar_BackgroundColor;
    RH_GesturelLockView *lockView = [[RH_GesturelLockView alloc]  initWithFrame:CGRectMake(0,
                                                                                           StatusBarHeight+NavigationBarHeight,
                                                                                           MainScreenW,
                                                                                           MainScreenH - StatusBarHeight - NavigationBarHeight) WithMode:PwdStateSetting];
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
            [[RH_UserInfoManager shareUserManager] updateScreenLockPassword:pwdStr1] ;
            [self backBarButtonItemHandle] ;
            
        }else{
            showAlertView(@"请重新设置 ", @"两次设置的密码不一致") ;
            vcs.title = @"设置解锁密码";
            isFirst = YES;
            pwdStr2 = @"";
            pwdStr1 = @"";
        }
    };
    
    [self.view addSubview:lockView];
}


@end
