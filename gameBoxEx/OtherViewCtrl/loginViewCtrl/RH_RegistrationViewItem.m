//
//  RH_RegistrationViewItem.m
//  gameBoxEx
//
//  Created by Lenny on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//
#import "RH_APPDelegate.h"
#import "RH_RegistrationSelectView.h"
#import "RH_RegistrationViewItem.h"
#import "coreLib.h"

@interface RH_RegistrationViewItem() <RH_RegistrationSelectViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>
@end
@implementation RH_RegistrationViewItem
{
    UILabel *label_Title;
    UITextField *textField;
    UIButton *button_Check;
    
    UIImageView *imageView_VerifyCode;
    FieldModel *fieldModel;
    NSInteger minDateYear;
    NSInteger maxDateYear;
    RH_RegistrationSelectView *selectView;
    
    NSArray<SexModel *> *sexModel;
    NSArray<MainCurrencyModel *> *mainCurrencyModel;
    NSArray<DefaultLocaleModel *> *defaultLocaleModel;
    NSArray<SecurityIssuesModel *> *securityIssuesModel;
    
    id selectedItem;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        label_Title = [UILabel new];
        [self addSubview:label_Title];
        label_Title.whc_TopSpace(2).whc_LeftSpace(20).whc_Height(18).whc_WidthAuto();
        label_Title.font = [UIFont systemFontOfSize:13];
        label_Title.textColor = colorWithRGB(131, 131, 131);
        label_Title.textAlignment = NSTextAlignmentCenter;
        
        textField = [UITextField new];
        [self addSubview:textField];
        textField.whc_TopSpaceToView(1, label_Title).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(38);
        textField.layer.borderColor = colorWithRGB(234, 234, 234).CGColor;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        textField.clipsToBounds = YES;
        textField.font = [UIFont systemFontOfSize:15];
        textField.textColor = colorWithRGB(99, 99, 99);
        textField.delegate = self;
    }
    return self;
}




- (BOOL)isRequire {
    if ([fieldModel.isRequired isEqualToString:@"2"]) {
        return NO;
    }
    return YES;
}

- (NSString *)contentType {
    return fieldModel.name;
}

- (NSString *)textFieldContent {
    if ([fieldModel.name isEqualToString:@"sex"]) {
        SexModel *model = selectedItem;
        return model.mValue;
    }
    if ([fieldModel.name isEqualToString:@"mainCurrency"]) {
        MainCurrencyModel *model = selectedItem;
        return model.mValue;
    }
    if ([fieldModel.name isEqualToString:@"defaultLocale"]) {
        DefaultLocaleModel *model = selectedItem;
        return model.mValue;
    }
    if ([fieldModel.name isEqualToString:@"securityIssues"]) {
        SecurityIssuesModel *model = selectedItem;
        return model.mValue;
    }
    return  textField.text ;
}

- (void)setFieldModel:(FieldModel *)model {
    fieldModel = model;
    if ([model.name isEqualToString:@"username"]) {
        label_Title.text = @"请输入用户名☆";
        textField.placeholder = @"请输入用户名";
    }
    if ([model.name isEqualToString:@"password"]) {
        label_Title.text = @"请输入密码☆";
        textField.placeholder = @"请输入6-20个字母数字或字符";
        [self setPasswordLayout];
    }
    if ([model.name isEqualToString:@"password2"]) {
        label_Title.text = @"请再次输入密码☆";
        textField.placeholder = @"请再次输入登录密码";
        [self setPasswordLayout];
    }
    if ([model.name isEqualToString:@"verificationCode"]) {
        label_Title.text = @"请输入验证码☆";
        textField.placeholder = @"请输入验证码";
        [self setVerifyCodeLayout];
    }
    if ([model.name isEqualToString:@"regCode"]) {
        label_Title.text = @"请输入推荐码☆";
        textField.placeholder = @"请输入推荐码";
    }
    if ([model.name isEqualToString:@"304"]) {
        label_Title.text = @"请输入微信☆";
        textField.placeholder = @"请输入微信";
    }
    if ([model.name isEqualToString:@"110"]) {
        label_Title.text = @"请输入手机号☆";
        textField.placeholder = @"请输入手机号";
    }
    if ([model.name isEqualToString:@"110verify"]) {
        label_Title.text = @"请输入手机验证码☆";
        textField.placeholder = @"请输入手机验证码";
        [self setPhoneVerifyCodeLayout];
    }
    if ([model.name isEqualToString:@"201"]) {
        label_Title.text = @"邮箱☆";
        textField.placeholder = @"请输入邮箱地址";
    }
    if ([model.name isEqualToString:@"realName"]) {
        label_Title.text = @"请输入真实姓名☆";
        textField.placeholder = @"请输入真实姓名";
    }
    if ([model.name isEqualToString:@"301"]) {
        label_Title.text = @"请输入QQ号码☆";
        textField.placeholder = @"请输入QQ号码";
    }
    if ([model.name isEqualToString:@"paymentPassword"]) {
        label_Title.text = @"请输入6位数字安全密码☆";
        textField.placeholder = @"请输入6位数字安全密码";
    }
    if ([model.name isEqualToString:@"paymentPassword2"]) {
        label_Title.text = @"请再次输入6位数字安全密码☆";
        textField.placeholder = @"请再次输入6位数字安全密码";
    }
    if ([model.name isEqualToString:@"defaultTimezone"]) {
        label_Title.text = @"时区☆";
        textField.placeholder = @"";
    }
    if ([model.name isEqualToString:@"birthday"]) {
        label_Title.text = @"生日☆";
        textField.placeholder = @"";
        [self setBirthdaySelectLayout];
    }
    if ([model.name isEqualToString:@"sex"]) {
        label_Title.text = @"性别☆";
        textField.placeholder = @"请选择性别";
    }
    if ([model.name isEqualToString:@"mainCurrency"]) {
        label_Title.text = @"货币☆";
        textField.placeholder = @"人民币";
    }
    if ([model.name isEqualToString:@"defaultLocale"]) {
        label_Title.text = @"主语言☆";
        textField.placeholder = @"简体中文";
    }
    if ([model.name isEqualToString:@"securityIssues"]) {
        label_Title.text = @"请选择安全问题☆";
        textField.placeholder = @"请选择安全问题";
    }
    if ([model.name isEqualToString:@"securityIssues2"]) {
        label_Title.text = @"回答安全问题☆";
        textField.placeholder = @"请输入回答";
    }
}

- (void)setTimeZone:(NSString *)zone {
    textField.text = zone;
}

- (void)setSexModel:(NSArray<SexModel *> *)models {
    sexModel = [NSArray array];
    sexModel = models;
    [self setSexSelectLayout];
    textField.enabled = NO;
}
- (void)setDefaultLocale:(NSArray<DefaultLocaleModel *> *)models {
    defaultLocaleModel = [NSArray array];
    defaultLocaleModel = models;
    [self setDefaultLocaleLayout];
    textField.enabled = NO;
}
- (void)setMainCurrencyModel:(NSArray<MainCurrencyModel *> *)models {
    mainCurrencyModel = [NSArray array];
    mainCurrencyModel = models;
    [self setMainCurrencyLayout];
    textField.enabled = NO;
}
- (void)setSecurityIssues:(NSArray<SecurityIssuesModel *> *)models {
    securityIssuesModel = [NSArray array];
    securityIssuesModel = models;
    [self setSecurityIssuesLayout];
    textField.enabled = NO;
}

- (void)setBirthDayMin:(NSInteger )start MaxDate:(NSInteger )end {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];//@"yyyy-MM-dd-HHMMss"
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:start/1000];
//    NSString* dateString = [formatter stringFromDate:date];
//    NSLog(@"%@", dateString);
    minDateYear = date.year;
    
    date = [NSDate dateWithTimeIntervalSince1970:end/1000];
//    NSString* dateString2 = [formatter stringFromDate:date];
//    NSLog(@"%@", dateString2);
    maxDateYear = date.year;
    textField.enabled = NO;
}

- (void)setSexSelectLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    button.whc_CenterYToView(0, textField).whc_RightSpace(25).whc_Width(25).whc_Height(20);
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(sexSelectDidTap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sexSelectDidTap {
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@""];
        [selectView setColumNumbers:1];
        [selectView setDataList:sexModel];
        selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height - 200, screenSize().width, 200);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        }completion:^(BOOL finished) {
            [selectView removeFromSuperview];
        }];
    }
}

- (void)setMainCurrencyLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    button.whc_CenterYToView(0, textField).whc_RightSpace(25).whc_Width(25).whc_Height(20);
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(mainCurrencyDidTaped) forControlEvents:UIControlEventTouchUpInside];
}
- (void)mainCurrencyDidTaped {
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@""];
        [selectView setColumNumbers:1];
        [selectView setDataList:mainCurrencyModel];
        selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height - 200, screenSize().width, 200);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        }completion:^(BOOL finished) {
            [selectView removeFromSuperview];
        }];
    }
}

- (void)setDefaultLocaleLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    button.whc_CenterYToView(0, textField).whc_RightSpace(25).whc_Width(25).whc_Height(20);
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(defaultLocaleDidTaped) forControlEvents:UIControlEventTouchUpInside];
}
- (void)defaultLocaleDidTaped {
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@""];
        [selectView setColumNumbers:1];
        [selectView setDataList:defaultLocaleModel];
        selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height - 200, screenSize().width, 200);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        }completion:^(BOOL finished) {
            [selectView removeFromSuperview];
        }];
    }
}

- (void)setSecurityIssuesLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    button.whc_CenterYToView(0, textField).whc_RightSpace(25).whc_Width(25).whc_Height(20);
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(securityIssuesDidTaped) forControlEvents:UIControlEventTouchUpInside];
}
- (void)securityIssuesDidTaped {
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@""];
        [selectView setColumNumbers:1];
        [selectView setDataList:securityIssuesModel];
        selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height - 200, screenSize().width, 200);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        }completion:^(BOOL finished) {
            [selectView removeFromSuperview];
        }];
    }
}
- (void)setBirthdaySelectLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    button.whc_CenterYToView(0, textField).whc_RightSpace(25).whc_Width(25).whc_Height(20);
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(birthdaySelectTaped) forControlEvents:UIControlEventTouchUpInside];
}
- (void)birthdaySelectTaped {
    
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@"birthday"];
        [selectView setColumNumbers:3];
        selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height - 200, screenSize().width, 200);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
        }completion:^(BOOL finished) {
            [selectView removeFromSuperview];
        }];
    }
    
}

- (void)RH_RegistrationSelectViewDidCancelButtonTaped {
    [UIView animateWithDuration:0.3 animations:^{
        selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
    }completion:^(BOOL finished) {
        [selectView removeFromSuperview];
    }];
}
- (void)RH_RegistrationSelectViewDidConfirmButtonTapedwith:(NSString *)selected {
    textField.text = selected;
    [UIView animateWithDuration:0.3 animations:^{
        selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
    }completion:^(BOOL finished) {
        [selectView removeFromSuperview];
    }];
}
- (void)RH_RegistrationSelectViewDidConfirmButtonTaped:(id)selected {
    selectedItem = selected;
    if ([fieldModel.name isEqualToString:@"sex"]) {
        SexModel *model = ConvertToClassPointer(SexModel, selected);
        textField.text = model.mText;
    }
    if ([fieldModel.name isEqualToString:@"mainCurrency"]) {
        MainCurrencyModel *model = ConvertToClassPointer(MainCurrencyModel, selected);
        textField.text = model.mText;
    }
    if ([fieldModel.name isEqualToString:@"defaultLocale"]) {
        DefaultLocaleModel *model = ConvertToClassPointer(DefaultLocaleModel, selected);
        textField.text = model.mText;
    }
    if ([fieldModel.name isEqualToString:@"securityIssues"]) {
        SecurityIssuesModel *model = ConvertToClassPointer(SecurityIssuesModel, selected);
        textField.text = model.mText;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        selectView.frame = CGRectMake(0, screenSize().height, screenSize().width, 200);
    }completion:^(BOOL finished) {
        [selectView removeFromSuperview];
    }];
}

- (void)setPasswordLayout {
    button_Check = [UIButton new];
    [self addSubview:button_Check];
    button_Check.whc_CenterYToView(0, textField).whc_RightSpace(25).whc_Width(25).whc_Height(25);
    button_Check.backgroundColor = [UIColor blueColor];
}

- (void)setVerifyCodeLayout {
    textField.whc_RightSpace(150);
//    imageView_VerifyCode = [UIImageView new];
//    [self addSubview:imageView_VerifyCode];
//    imageView_VerifyCode.whc_CenterYToView(0, textField).whc_LeftSpaceToView(10, textField).whc_RightSpace(25).whc_Height(35);
//    imageView_VerifyCode.backgroundColor = [UIColor redColor];
    UIWebView *webView = [UIWebView new];
    [self addSubview:webView];
    webView.whc_CenterYToView(0, textField).whc_LeftSpaceToView(10, textField).whc_RightSpace(25).whc_Height(35);
    webView.backgroundColor = [UIColor redColor];
    RH_APPDelegate *app = (RH_APPDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/captcha/pmregister.html", app.domain]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTapHandle:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [webView addGestureRecognizer:tap];
    webView.multipleTouchEnabled = NO;
}
- (void)webViewTapHandle:(UITapGestureRecognizer *)tap {
    UIWebView *webView = (UIWebView *)tap.view;
    [webView reload];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setPhoneVerifyCodeLayout {
    textField.whc_RightSpace(150);
    UIButton *button = [UIButton new];
    [self addSubview:button];
    button.whc_CenterYToView(0, textField).whc_LeftSpaceToView(10, textField).whc_RightSpace(25).whc_Height(35);
    button.layer.borderColor = colorWithRGB(20, 90, 180).CGColor;
    [button setTitleColor:colorWithRGB(20, 90, 180) forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button setTitleColor:colorWithRGB(168, 168, 168) forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(obtainVerifyTaped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)obtainVerifyTaped {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@""];;
    if ([fieldModel.name isEqualToString:@"username"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
    }
    if ([fieldModel.name isEqualToString:@"password"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
    }
    if ([fieldModel.name isEqualToString:@"password2"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
    }
    if ([fieldModel.name isEqualToString:@"verificationCode"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    if ([fieldModel.name isEqualToString:@"304"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_"];
    }
    if ([fieldModel.name isEqualToString:@"110"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    if ([fieldModel.name isEqualToString:@"201"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM@_"];
    }
    if ([fieldModel.name isEqualToString:@"realName"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
        return YES;
    }
    if ([fieldModel.name isEqualToString:@"301"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    if ([fieldModel.name isEqualToString:@"paymentPassword"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if (textField.text.length > 6) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"paymentPassword2"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if (textField.text.length > 6) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"regCode"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
//    tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
