//
//  RH_FindbackPswSendPhoneCodeView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FindbackPswSendPhoneCodeView.h"
#import "MacroDef.h"

@interface RH_FindbackPswSendPhoneCodeView()
{
    dispatch_source_t timer;
}

@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBt;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;

@end

@implementation RH_FindbackPswSendPhoneCodeView

- (void)dealloc
{
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.nextBt.layer.cornerRadius = 4;
    self.nextBt.clipsToBounds = YES;
}

- (void)autoSendCode
{
    [self sendCode:nil];
}

- (void)clearTimer
{
    //否则内存泄漏
    if (timer) {
        dispatch_source_cancel(timer);
    }
}

- (void)setThemeColor:(UIColor *)themeColor
{
    _themeColor = themeColor;
    [self.nextBt setBackgroundColor:_themeColor];
    [self.sendCodeBt setTitleColor:_themeColor forState:UIControlStateNormal];
    self.phoneLB.textColor = _themeColor;
}

- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    self.phoneLB.text = _phone;
}

- (IBAction)sendCode:(id)sender {
    ifRespondsSelector(self.delegate, @selector(findbackPswSendPhoneCodeViewSendCode:))
    {
        [self.delegate findbackPswSendPhoneCodeViewSendCode:self];
    }
    
    if (timer == nil) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW,
                                  1.0 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    }
    __weak typeof(self) weakSelf = self;
    __block int i = 0;
    dispatch_source_set_event_handler(timer, ^() {
        i++;
        if (i<90) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.sendCodeBt.enabled = NO;
                [weakSelf.sendCodeBt setTitle:[NSString stringWithFormat:@"%i秒后重试", 90-i] forState:UIControlStateNormal];
            });
        }
        else
        {
            dispatch_suspend(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.sendCodeBt.enabled = YES;
                [weakSelf.sendCodeBt setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }
    });
    
    dispatch_resume(timer);
}

- (IBAction)nextAction:(id)sender {
    if ([self.verifyCodeTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    ifRespondsSelector(self.delegate, @selector(findbackPswSendPhoneCodeViewNext:code:))
    {
        [self.delegate findbackPswSendPhoneCodeViewNext:self code:self.verifyCodeTF.text];
    }
}

@end
