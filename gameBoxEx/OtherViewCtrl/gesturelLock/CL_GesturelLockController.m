//
//  CL_GesturelLockController.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/17.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CL_GesturelLockController.h"
#import "CLGesturelLockView.h"
#import "CL_LockSetPWDController.h"
#import "MBProgressHUD.h"
#import "CL_GestureOpenLockView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CL_GesturelLockController ()
//@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)CL_GestureOpenLockView *openLockView;
@end

@implementation CL_GesturelLockController
@synthesize openLockView = _openLockView;
- (BOOL)isSubViewController {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupUI];
    [self.view addSubview:self.openLockView];
}
-(CL_GestureOpenLockView *)openLockView
{
    if (!_openLockView) {
        _openLockView = [[CL_GestureOpenLockView alloc]initWithFrame:self.view.bounds];
        
    }
    return _openLockView;
}
//-(void)setupUI{
//    self.view.backgroundColor = RH_NavigationBar_BackgroundColor;
//
//    CGFloat RightButtonX = [UIScreen mainScreen].bounds.size.width -160;
//    UIButton * _navRightButton  = [[UIButton alloc]initWithFrame:CGRectMake(RightButtonX, 30, 150, 50)];
//    [_navRightButton setTitle:@"重新设置密码" forState:UIControlStateNormal];
//    _navRightButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [_navRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_navRightButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:_navRightButton];
//    self.navigationBarItem.titleView = _navRightButton;
//    //解锁界面
//    CLGesturelLockView *lockView = [[CLGesturelLockView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH)*0.5,SCREEN_WIDTH,SCREEN_WIDTH) WithMode:PwdStateResult];
//    [lockView setBtnImage:[UIImage imageNamed:@"gesturelLock_normal"]];
//    [lockView setBtnSelectdImgae:[UIImage imageNamed:@"gesturelLock_Selected"]];
//    [lockView setBtnErrorImage:[UIImage imageNamed:@"gesturelLock_error"]];
//    [self.view addSubview:lockView];
//
//    //解锁手势完成之后判断密码是否正确
//    _hud = [[MBProgressHUD alloc]init];
//    lockView.sendReaultData = ^(NSString *resultPwd){
//        //        从本地获取保存的密码
//        NSString *savePwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"passWord"];
//        if ([savePwd isEqualToString:resultPwd]) {//密码相同，解锁成功
//            _hud.labelText = @"解锁成功";
//            [self.view addSubview:_hud];
//            _hud.mode = MBProgressHUDModeText;
//            _hud.labelColor = [UIColor blueColor];
//            [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
//            [_hud show:YES];
//            return YES;
//        }else{
//
//            _hud.labelText = @"解锁失败";
//            [self.view addSubview:_hud];
//            _hud.mode = MBProgressHUDModeText;
//            _hud.labelColor = [UIColor redColor];
//            [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:1];
//            [_hud show:YES];
//            return NO;
//        }
//    };
//}
//-(void)hideProgressHUD
//{
//    [_hud hide:YES];
//}
//
//-(void)popView{
//    CL_LockSetPWDController *vc = [[CL_LockSetPWDController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//
//}
@end
