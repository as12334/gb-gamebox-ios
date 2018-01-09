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
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong,readonly)UIWindow *subwindow;
@property(nonatomic,strong,readonly)UILabel *titleLab;
@end

@implementation RH_GestureOpenLockView
{
   BOOL _boolMark;
}

@synthesize subwindow = _subwindow;
@synthesize titleLab = _titleLab;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = self.subwindow.bounds;
        [self.subwindow addSubview:self];
        self.userInteractionEnabled = YES;
        self.subwindow.userInteractionEnabled = YES;
        [self.subwindow setHidden:NO];
        [self.subwindow addSubview:self.titleLab];
        [self createUI];
    }
    return self;
}

-(UIWindow *)subwindow
{
    if(!_subwindow){
        _subwindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _subwindow.windowLevel = UIWindowLevelStatusBar + 1;
        _subwindow.backgroundColor = [UIColor whiteColor];
    }
    return _subwindow;
}

//添加一个uilabel
-(UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake((self.frameWidth-150)/2, 64, 150, 30)];
        _titleLab.text = @"重新设置密码";
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:16.0f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popView)];
        _titleLab.userInteractionEnabled = YES;
        [_titleLab addGestureRecognizer:tap];
    }
    return _titleLab;
}

-(void)createUI{
//    self.backgroundColor = RH_NavigationBar_BackgroundColor;
    //解锁界面
    RH_GesturelLockView *lockView = [[RH_GesturelLockView alloc]initWithFrame:CGRectMake(0, 220,SCREEN_WIDTH,SCREEN_WIDTH) WithMode:PwdStateResult];
    lockView.center = self.center;
    lockView.btnSelectdImgae = [UIImage imageNamed:@"gesturelLock_Selected"];
    lockView.btnImage = [UIImage imageNamed:@"gesturelLock_normal"];
    lockView.btnErrorImage = [UIImage imageNamed:@"gesturelLock_error"];
    [self.subwindow addSubview:lockView];
    
    //解锁手势完成之后判断密码是否正确
    _hud = [[MBProgressHUD alloc]init];
    lockView.sendReaultData = ^(NSString *resultPwd){
        //        从本地获取保存的密码
        NSString *savePwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"passWord"];
        if ([savePwd isEqualToString:resultPwd]) {//密码相同，解锁成功
            _hud.labelText = @"解锁成功";
            [self.subwindow addSubview:_hud];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelColor = [UIColor blueColor];
            _boolMark =YES;
            [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
            [_hud show:YES];
            return YES;
        }else{
            
            _hud.labelText = @"解锁失败";
            [self.subwindow addSubview:_hud];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelColor = [UIColor redColor];
            _boolMark =NO;
            [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
            [_hud show:YES];
            return NO;
        }
    };
}


-(void)hideProgressHUD
{
    if (_boolMark == YES) {
        for (UIView *subView in [self.subwindow subviews]) {
            [subView removeFromSuperview];
            [self.subwindow setHidden:YES];
            [self removeFromSuperview];
        }
    }
    else
    {
        
    }
    [_hud hide:YES];
}

-(void)popView{
    for (UIView *subView in [self.subwindow subviews]) {
        [subView removeFromSuperview];
        [self.subwindow setHidden:YES];
        [self removeFromSuperview];
    }
    
    RH_LockSetPWDController *vc = [[RH_LockSetPWDController alloc]init];
    [self showViewController:vc];
    
}
@end
