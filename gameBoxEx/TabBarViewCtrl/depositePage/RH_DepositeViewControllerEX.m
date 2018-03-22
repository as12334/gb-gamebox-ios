//
//  RH_DepositeViewControllerEX.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeViewControllerEX.h"

@interface RH_DepositeViewControllerEX ()

@end

@implementation RH_DepositeViewControllerEX
-(BOOL)tabBarHidden
{
    return NO ;
}
-(BOOL)needLogin
{
    return YES  ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    [self setNeedUpdateView];
   
}
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self setNeedUpdateView] ;
    }
}
-(void)updateView
{
    if (self.appDelegate.isLogin&&NetworkAvailable()){
        
    }
    else if(!self.appDelegate.isLogin){
        //进入登录界面
        [self loginButtonItemHandle] ;
    }
    else if (NetNotReachability()){
        showAlertView(@"无网络", @"") ;
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
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
