//
//  RH_FBPChangePwView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FBPChangePwView.h"
#import "MacroDef.h"
//#import "MBProgressHUD.h"


@interface RH_FBPChangePwView ()

//@property (weak, nonatomic) IBOutlet UITextField *pswTF;
//@property (weak, nonatomic) IBOutlet UITextField *verifyPswTF;
@property (weak, nonatomic) IBOutlet UIButton *changeBt;

@end

@implementation RH_FBPChangePwView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.changeBt.layer.cornerRadius = 4;
    self.changeBt.clipsToBounds = YES;
}

- (void)setThemeColor:(UIColor *)themeColor
{
    _themeColor = themeColor;
    [self.changeBt setBackgroundColor:_themeColor];
}

- (IBAction)changeAction:(id)sender {
    if ([self.pswTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入新密" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if ([self.verifyPswTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请再次输入新密码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    } else if (self.verifyPswTF.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入至少6-20个字母、数字或字符" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    if (![self.pswTF.text isEqualToString:self.verifyPswTF.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;

    }
    
    if (self.pswTF.text.length >= 6 && self.verifyPswTF.text.length >= 6) {
        
        ifRespondsSelector(self.delegate, @selector(changePwViewSubmit:psw:))
        {
            [self.delegate changePwViewSubmit:self psw:self.verifyPswTF.text];
        }
    }
    

}


@end
