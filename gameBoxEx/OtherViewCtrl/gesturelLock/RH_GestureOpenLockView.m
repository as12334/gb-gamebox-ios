//
//  RH_GestureOpenLockView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GestureOpenLockView.h"
#import "RH_GesturelLockView.h"
#import "MBProgressHUD.h"
#import "coreLib.h"
#import "RH_LockSetPWDController.h"
#import "RH_UserInfoManager.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RH_GestureOpenLockView()
@property (nonatomic,strong) MBProgressHUD *hud;
//@property(nonatomic,strong,readonly)UIWindow *subwindow;
@end

@implementation RH_GestureOpenLockView
{
   BOOL _boolMark;
}
//@synthesize subwindow = _subwindow;

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
    //解锁界面
    RH_GesturelLockView *lockView = [[RH_GesturelLockView alloc] initWithFrame:CGRectMake(0, 220,SCREEN_WIDTH,SCREEN_WIDTH) WithMode:PwdStateResult];
    lockView.center = self.center;
    lockView.btnSelectdImgae = [UIImage imageNamed:@"gesturelLock_Selected"];
    lockView.btnImage = [UIImage imageNamed:@"gesturelLock_normal"];
    lockView.btnErrorImage = [UIImage imageNamed:@"gesturelLock_error"];
    [self addSubview:lockView];
    [[RH_UserInfoManager shareUserManager] updateScreenLockFlag:NO];
    //解锁手势完成之后判断密码是否正确
    _hud = [[MBProgressHUD alloc] init];
    lockView.sendReaultData = ^(NSString *resultPwd){
        //        从本地获取保存的密码
        NSString *savePwd = [RH_UserInfoManager shareUserManager].screenLockPassword;
        
        
        if ([savePwd isEqualToString:resultPwd]) {//密码相同，解锁成功
            _hud.labelText = @"解锁成功";
            [self addSubview:_hud];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelColor = [UIColor blueColor];
            _boolMark = YES;
            [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
            [_hud show:YES];
            ifRespondsSelector(self.delegate, @selector(gestureOpenLockViewOpenLockSuccessful:)) {
                [self.delegate gestureOpenLockViewOpenLockSuccessful:self];
            }
            
            return YES;
        }else{
            _hud.labelText = @"解锁失败";
            [self addSubview:_hud];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelColor = [UIColor redColor];
            _boolMark = NO;
            [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
            [_hud show:YES];
            return NO;
        }
    };
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"忘记手势密码？" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, (self.frame.size.height + SCREEN_WIDTH)/2.0 , SCREEN_WIDTH, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
-(void)btnClick{
    [self.delegate forgetGesturePWD];
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



#pragma mark-
//-(UIWindow *)subwindow
//{
//    if(!_subwindow){
//        _subwindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _subwindow.windowLevel = UIWindowLevelNormal + 1;
//        _subwindow.backgroundColor = [UIColor whiteColor];
//    }
//    return _subwindow;
//}

//- (void)show
//{
//    self.frame = self.subwindow.bounds;
//    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//
//    //显示时建立引用循环
//    [self.subwindow addSubview:self];
//    [self.subwindow setHidden:NO];
//}
//
//- (void)hidden
//{
//    if (_subwindow) {
//
//        //隐藏
//        [UIView animateWithDuration:0.3f animations:^{
//            _subwindow.alpha = 0.f;
//        } completion:^(BOOL finished){
//            [_subwindow setHidden:YES];
//            [self removeFromSuperview];
//        }];
//    }
//}
@end
