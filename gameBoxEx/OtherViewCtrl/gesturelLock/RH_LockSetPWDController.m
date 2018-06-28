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
#import "SAMKeychain.h"
#import "WHC_AutoLayout.h"

@interface RH_LockSetPWDController ()
{
    NSString *pwdStr1;
    NSString *pwdStr2;
    BOOL isFirst;
    UILabel *label ;
}

@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) UILabel *errorLbl;
@end

@implementation RH_LockSetPWDController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.title = @"设置锁屏手势";
    //设置界面指示图片
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((MainScreenW-100)/2, 80, 100, 100)];
    imgV.image = [UIImage imageNamed:@"yishiyuan"];
    [self.view addSubview:imgV];
    label = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenW-150)/2, 190, 150, 20)];
    label.text = @"请滑动绘制新手势";
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = colorWithRGB(27, 117, 217);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    isFirst = YES;
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    RH_GesturelLockView *lockView = [[RH_GesturelLockView alloc] initWithFrame:CGRectMake(0,220,MainScreenW,MainScreenH - StatusBarHeight - NavigationBarHeight) WithMode:PwdStateSetting];
    lockView.btnSelectdImgae = [UIImage imageNamed:@"gesturelLock_Selected"];
    lockView.btnImage = [UIImage imageNamed:@"gesturelLock_normal"];
    lockView.btnErrorImage = [UIImage imageNamed:@"gesturelLock_error"];
    
     [[RH_UserInfoManager shareUserManager] updateScreenLockFlag:NO] ;

    lockView.setPwdData = ^(NSString *resultPwd){
        
        if (isFirst == YES) {
            pwdStr1 = resultPwd;
            isFirst = NO;
            label.text = @"请滑动绘制新手势";
            
            if (pwdStr1.length < 4) {
                self.errorView = [[UIView alloc] init];
                self.errorView.frame = CGRectMake(120, 600, 135, 28);
                self.errorView.backgroundColor = [UIColor blackColor];
                self.errorView.alpha = 0.5;
                [self.view addSubview:self.errorView];

                self.errorLbl = [[UILabel alloc] init];
                self.errorLbl.frame = CGRectMake(125, 600, 120, 25);
                self.errorLbl.textColor = [UIColor whiteColor];
                self.errorLbl.font = [UIFont systemFontOfSize:14.0];
                self.errorLbl.text = @"请输入至少四个点";
                self.errorLbl.textAlignment = NSTextAlignmentCenter;
                [self.errorView addSubview:self.errorLbl];
                [self.view addSubview:self.errorLbl];

                [UIView animateWithDuration:3.0 animations:^{
                    self.errorView.alpha = 0.0f;
                    self.errorLbl.alpha = 0.0f;
                }];
            }
            
            return;
        }else{
            pwdStr2 = resultPwd;
            label.text = @"请再次绘制确认手势";
        }
       
        if (pwdStr1.length < 4) {
            return;
        }
        
        #define RH_GuseterLock            @"RH_GuseterLock"
        if ([pwdStr1 isEqualToString:pwdStr2]) {
            [[RH_UserInfoManager shareUserManager] updateScreenLockPassword:pwdStr1];
            [[RH_UserInfoManager shareUserManager] updateScreenLockFlag:YES];
            label.text = @"锁屏手势设置成功！";
            [self backBarButtonItemHandle];
            
        }else{
            showAlertView(@"请重新设置 ", @"两次绘制的锁屏手势不一致");
            [[RH_UserInfoManager shareUserManager] updateScreenLockFlag:NO];
            isFirst = YES;
            pwdStr2 = @"";
            pwdStr1 = @"";
        }
    };
    
    [self.view addSubview:lockView];
}


@end
