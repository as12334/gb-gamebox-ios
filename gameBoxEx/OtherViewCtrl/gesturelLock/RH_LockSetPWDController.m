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
    //设置界面指示图片
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((MainScreenW-100)/2, 80, 100, 100)];
    imgV.image = [UIImage imageNamed:@"yishiyuan"];
    [self.view addSubview:imgV];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenW-150)/2, 190, 150, 20)];
    label.text = @"请滑动设置新密码";
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = colorWithRGB(27, 117, 217);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    isFirst = YES;
}
-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    RH_GesturelLockView *lockView = [[RH_GesturelLockView alloc]  initWithFrame:CGRectMake(0,220,MainScreenW,MainScreenH - StatusBarHeight - NavigationBarHeight) WithMode:PwdStateSetting];
    lockView.btnSelectdImgae = [UIImage imageNamed:@"gesturelLock_Selected"];
    lockView.btnImage = [UIImage imageNamed:@"gesturelLock_normal"];
    lockView.btnErrorImage = [UIImage imageNamed:@"gesturelLock_error"];
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
