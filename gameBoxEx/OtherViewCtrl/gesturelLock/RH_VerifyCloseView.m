//
//  RH_VerifyCloseView.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_VerifyCloseView.h"
#import "RH_GesturelLockView.h"
#import "MBProgressHUD.h"
#import "coreLib.h"
#import "RH_LockSetPWDController.h"
#import "RH_UserInfoManager.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RH_VerifyCloseView()
@property(nonatomic,strong) MBProgressHUD *hud;
@end

@implementation RH_VerifyCloseView
{
    BOOL _boolMark;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    //    self.backgroundColor = RH_NavigationBar_BackgroundColor;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.frame.size.height - SCREEN_WIDTH)/2.0-40, SCREEN_WIDTH, 20)];
    lab.text = @"请绘制解锁图案";
    lab.font = [UIFont systemFontOfSize:20];
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    //解锁界面
    RH_GesturelLockView *lockView = [[RH_GesturelLockView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - SCREEN_WIDTH)/2.0,SCREEN_WIDTH,SCREEN_WIDTH) WithMode:PwdStateVerityClose];
    lockView.btnSelectdImgae = [UIImage imageNamed:@"gesturelLock_Selected"];
    lockView.btnImage = [UIImage imageNamed:@"gesturelLock_normal"];
    lockView.btnErrorImage = [UIImage imageNamed:@"gesturelLock_error"];
    [self addSubview:lockView];
    
    //解锁手势完成之后判断密码是否正确
    _hud = [[MBProgressHUD alloc] init];
    
    lockView.sendReaultData = ^(NSString *resultPwd) {
            //        从本地获取保存的密码
            #define RH_GuseterLock  @"RH_GuseterLock"
            NSString * savePwd = [SAMKeychain passwordForService:@" " account:RH_GuseterLock];
            //        NSString *savePwd = [RH_UserInfoManager shareUserManager].screenLockPassword;
            if ([savePwd isEqualToString:resultPwd]) {//密码相同，解锁成功
                _hud.labelText = @"验证成功";
                [self addSubview:_hud];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelColor = [UIColor blueColor];
                _boolMark =YES;
                [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
                [_hud show:YES];
                ifRespondsSelector(self.delegate, @selector(VerifyCloseViewVerifySuccessful:)) {
                    [self.delegate VerifyCloseViewVerifySuccessful:self];
                }
                [SAMKeychain deletePasswordForService:@" " account:RH_GuseterLock];
                #define RH_updateScreenLockFlag            @"updateScreenLockFlag"
                [SAMKeychain deletePasswordForService:@" " account:RH_updateScreenLockFlag];
                return YES;
            } else{
                _hud.labelText = @"验证失败";
                [self addSubview:_hud];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelColor = [UIColor redColor];
                _boolMark = NO;
                [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
                [_hud show:YES];
                return NO;
            }
//        }
    };
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"忘记手势密码？" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, (self.frame.size.height + SCREEN_WIDTH)/2.0 , SCREEN_WIDTH, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)hideProgressHUD
{
    if (_boolMark == YES) {
        for (UIView *subView in [self subviews]) {
            [subView removeFromSuperview];
            [self setHidden:YES];
            [self removeFromSuperview];
        }
    }
    else
    {
        
    }
    [_hud hide:YES];
}

-(void)btnClick{
    ifRespondsSelector(self.delegate, @selector(fogetPassWordBtnClick)){
        [self.delegate fogetPassWordBtnClick];
    }
}
@end
