//
//  RH_VerityPWDView.m
//  gameBoxEx
//
//  Created by jun on 2018/7/3.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_VerityPWDView.h"
#import "coreLib.h"
@interface RH_VerityPWDView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property(nonatomic,assign)NSInteger num;
@end
@implementation RH_VerityPWDView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.num = 5;
}

- (IBAction)netBtnClick:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *passWord = [defaults objectForKey:@"password"];
    if (self.textF.text.length != 0) {
        if ([self.textF.text isEqualToString:passWord]) {
            //成功
            #define RH_GuseterLock  @"RH_GuseterLock"
            [SAMKeychain deletePasswordForService:@" " account:RH_GuseterLock];
            #define RH_updateScreenLockFlag  @"updateScreenLockFlag"
            [SAMKeychain deletePasswordForService:@" " account:RH_updateScreenLockFlag];
            [self.delegate setPSW];
        }else{
              self.num--;
            if (self.num == 0) {
                self.num = 5;
                //调到登录注册页面
                [self.delegate jumpTologin];
            }else{
                showMessage(self, [NSString stringWithFormat:@"登录密码输入错误,还剩%ld次机会",(long)self.num], nil);
            }
            
            
        }
    }else{
         showMessage(self, @"请输入密码", nil);
    }
  
}

- (IBAction)forgetBtnClick:(id)sender {
    [self.delegate forgetPSWBtnClick];
}

@end
