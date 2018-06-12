//
//  RH_BindUserPhone.m
//  gameBoxEx
//
//  Created by shin on 2018/6/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BindUserPhone.h"
#import "MacroDef.h"

@interface RH_BindUserPhone () <UITextViewDelegate>
{
    dispatch_source_t timer;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendBt;
@property (weak, nonatomic) IBOutlet UIButton *bindBT;
@property (weak, nonatomic) IBOutlet UITextView *noticeLB;

@end

@implementation RH_BindUserPhone

- (void)dealloc
{
    NSLog(@"");
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bindBT.layer.cornerRadius = 4;
    self.bindBT.clipsToBounds = YES;
    [self setupNoticeText];
}

- (void)setThemeColor:(UIColor *)themeColor
{
    _themeColor = themeColor;
    [self.bindBT setBackgroundColor:_themeColor];
    [self.sendBt setTitleColor:_themeColor forState:UIControlStateNormal];
}

- (void)clearTimer
{
    //否则内存泄漏
    if (timer) {
        dispatch_source_cancel(timer);
    }
}

-(void)setupNoticeText{
    // 设置属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置行间距
    paragraphStyle.paragraphSpacing = 2; // 段落间距
    paragraphStyle.lineSpacing = 10;      // 行间距
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:colorWithRGB(102,102, 102),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:self.noticeLB.text attributes:attributes];
    [attrStr addAttributes:@{
                             NSLinkAttributeName:@"联系在线客服"
                             }
                     range:[self.noticeLB.text rangeOfString:@"联系在线客服"]];
    self.noticeLB.linkTextAttributes = @{NSForegroundColorAttributeName:colorWithRGB(23, 102, 187)};
    self.noticeLB.attributedText = attrStr;
    self.noticeLB.editable = NO;
    self.noticeLB.scrollEnabled = NO;
    self.noticeLB.delegate = self;
}

- (IBAction)sendAction:(id)sender {
    if ([self.phoneTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先输入手机号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    ifRespondsSelector(self.delegate, @selector(bindUserPhoneSendCode:phone:))
    {
        [self.delegate bindUserPhoneSendCode:self phone:self.phoneTF.text];
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
        if (i<30) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.sendBt.enabled = NO;
                [weakSelf.sendBt setTitle:[NSString stringWithFormat:@"%i秒后重试", 30-i] forState:UIControlStateNormal];
            });
        }
        else
        {
            dispatch_suspend(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.sendBt.enabled = YES;
                [weakSelf.sendBt setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }
    });

    dispatch_resume(timer);
}

- (IBAction)bindAction:(id)sender {
    if ([self.phoneTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先输入手机号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.verifyCodeTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    ifRespondsSelector(self.delegate, @selector(bindUserPhoneBind:phone:code:))
    {
        [self.delegate bindUserPhoneBind:self phone:self.phoneTF.text code:self.verifyCodeTF.text];
    }
}

#pragma mark - UITextViewDelegate M

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    ifRespondsSelector(self.delegate, @selector(bindUserPhoneContact:)){
        [self.delegate bindUserPhoneContact:self];
    }
    return YES;
}


@end
