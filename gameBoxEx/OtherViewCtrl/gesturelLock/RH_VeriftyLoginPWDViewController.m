//
//  RH_VeriftyLoginPWDViewController.m
//  gameBoxEx
//
//  Created by jun on 2018/7/3.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_VeriftyLoginPWDViewController.h"
#import "RH_VerityPWDView.h"
#import "RH_LoginViewControllerEx.h"
#import "RH_LockSetPWDController.h"
@interface RH_VeriftyLoginPWDViewController ()<RH_VerityPWDViewDelegate>

@end

@implementation RH_VeriftyLoginPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"验证登录密码";
    [self configUI];
}
- (BOOL)isSubViewController {
    return YES;
}
-(void)configUI{
    RH_VerityPWDView *view = [[NSBundle mainBundle]loadNibNamed:@"RH_VerityPWDView" owner:self  options:nil].firstObject;
    view.frame = CGRectMake(0, STATUS_HEIGHT+NavigationBarHeight, self.view.frame.size.width,self.view.frame.size.height - STATUS_HEIGHT - NavigationBarHeight);
    view.delegate = self;
    [self.view addSubview:view];
}
#pragma mark--
#pragma mark--忘记密码点击事件
- (void)forgetPSWBtnClick{
    NSLog(@"childs == %@",self.navigationController.childViewControllers);
    UITabBarController *tab = self.tabBarController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [tab setSelectedIndex:3];
    
}
- (void)jumpTologin{
    RH_LoginViewControllerEx *vc = [[RH_LoginViewControllerEx alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setPSW{
    //重新设置手势
    RH_LockSetPWDController *vc = [[RH_LockSetPWDController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
