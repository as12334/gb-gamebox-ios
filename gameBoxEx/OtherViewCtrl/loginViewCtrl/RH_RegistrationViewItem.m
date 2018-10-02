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
#import "RH_ServiceRequest.h"
#import "RH_UserInfoManager.h"
#import "Masonry.h"


@interface RH_RegistrationViewItem() <RH_RegistrationSelectViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate,RH_ServiceRequestDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@end
@implementation RH_RegistrationViewItem
{
    UIImageView *_startImageView;
    UILabel *label_Title;
    UITextField *textField;
    UIButton *button_Check;
    
    UIImageView *imageView_VerifyCode;
    FieldModel *fieldModel;
    NSInteger minDateYear;
    NSInteger maxDateYear;
    RH_RegistrationSelectView *selectView;
    RH_ServiceRequest *serverRequest ;
    
    NSArray<SexModel *> *sexModel;
    NSArray<MainCurrencyModel *> *mainCurrencyModel;
    NSArray<DefaultLocaleModel *> *defaultLocaleModel;
    NSArray<SecurityIssuesModel *> *securityIssuesModel;
    
    id selectedItem;
    NSInteger countDownNumber;
    
    
}

@synthesize serviceRequest = _serviceRequest ;

- (instancetype)init {
    self = [super init];
    if (self) {
        
        textField = [UITextField new];
        [self addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(70*WIDTH_PERCENT) ;
//            iPhoneX?make.top.mas_offset(35):make.top.mas_offset(20) ;
            make.centerY.mas_equalTo(0);
            make.right.mas_offset(-10) ;
            make.height.mas_offset(38) ;
        }] ;
        textField.layer.borderColor = colorWithRGB(234, 234, 234).CGColor;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        textField.clipsToBounds = YES;
        textField.font = [UIFont systemFontOfSize:15];
        textField.textColor = colorWithRGB(99, 99, 99);
        textField.delegate = self;
        
        label_Title = [UILabel new];
        [self addSubview:label_Title];
        
        [label_Title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(textField.mas_centerY) ;
            make.right.mas_equalTo(textField.mas_left).offset(-5) ;
        }] ;
        label_Title.font = [UIFont systemFontOfSize:13];
        label_Title.textColor = colorWithRGB(131, 131, 131);
        label_Title.textAlignment = NSTextAlignmentRight;

        _startImageView = [UIImageView new] ;
        [self addSubview:_startImageView];
        [_startImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(label_Title.mas_left) ;
            make.centerY.mas_equalTo(textField.mas_centerY) ;
            make.height.width.mas_offset(8) ;
        }] ;
        _startImageView.image = [UIImage imageNamed:@"star"] ;
        _startImageView.hidden = YES ;
        
        fieldModel = [[FieldModel alloc] init];
        
        serverRequest = [[RH_ServiceRequest alloc] init] ;
        serverRequest.delegate = self ;
    }
    return self;
}


- (BOOL)isRequire {
    if ([fieldModel.isRequired isEqualToString:@"2"]) {
        return NO;
    }
    return YES;
}


-(void)setIsShowTopView:(BOOL)isShowTopView
{
    _isShowTopView = isShowTopView ;
}

-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest){
        _serviceRequest = [[RH_ServiceRequest alloc] init] ;
        _serviceRequest.delegate = self ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageView_VerfyCode1) name:@"changeImageView_VerfyCode" object:nil];
    }
    
    return _serviceRequest ;
}
- (NSString *)contentType {
    return fieldModel.name;
}

- (NSString *)textFieldContent {
    if ([fieldModel.name isEqualToString:@"sex"]) {
        SexModel *model = selectedItem;
        return model.mValue ?: @"";
    }
    if ([fieldModel.name isEqualToString:@"mainCurrency"]) {
        MainCurrencyModel *model = selectedItem;
        return model.mValue ?: @"";
    }
    if ([fieldModel.name isEqualToString:@"defaultLocale"]) {
        DefaultLocaleModel *model = selectedItem;
        return model.mValue ?: @"";
    }
    if ([fieldModel.name isEqualToString:@"securityIssues"]) {
        SecurityIssuesModel *model = selectedItem;
        return model.mValue ?: @"";
    }
    return  textField.text ;
}

- (void)setRequiredJson:(NSArray<NSString *> *)requiredJson {
    for (NSString *obj in requiredJson) {
        // ⭐️
        if ([obj isEqualToString:fieldModel.name]) {
            if ([obj isEqualToString:@"username"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"用户名";
                textField.placeholder = @"请输入用户名"; break ;
            }
            if ([obj isEqualToString:@"password"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"密码";
                textField.placeholder = @"请输入6-20个字母数字或字符"; break ;
            }
            if ([obj isEqualToString:@"password2"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"确认密码";
                textField.placeholder = @"请再次输入登录密码"; break ;
            }
            if ([obj isEqualToString:@"verificationCode"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"验证码";
                textField.placeholder = @"请输入验证码"; break ;
            }
            if ([obj isEqualToString:@"regCode"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"推荐码";
                textField.placeholder = @"推荐码"; break ;
            }
            if ([obj isEqualToString:@"304"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"微信";
                textField.placeholder = @"请输入微信"; break ;
            }
            if ([obj isEqualToString:@"110"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"手机号";
                textField.placeholder = @"请输入手机号"; break ;
            }
            if ([obj isEqualToString:@"110verify"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"验证码";
                textField.placeholder = @"请输入手机验证码"; break ;
            }
            if ([obj isEqualToString:@"201"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"邮箱";
                textField.placeholder = @"请输入邮箱地址"; break ;
            }
            if ([obj isEqualToString:@"realName"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"真实姓名";
                textField.placeholder = @"请输入真实姓名"; break ;
            }
            if ([obj isEqualToString:@"301"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"QQ号码";
                textField.placeholder = @"请输入QQ号码"; break ;
            }
            if ([obj isEqualToString:@"paymentPassword"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"安全密码";
                textField.placeholder = @"请输入6位数字安全密码"; break ;
            }
            if ([obj isEqualToString:@"paymentPassword2"]) {
                label_Title.text = @"确认密码";
                textField.placeholder = @"请再次输入6位数字安全密码"; break ;
            }
            if ([obj isEqualToString:@"defaultTimezone"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"时区";
                textField.placeholder = @"";
                textField.enabled = NO; break ;
            }
            if ([obj isEqualToString:@"birthday"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"生日";
                textField.placeholder = @""; break ;
            }
            if ([obj isEqualToString:@"sex"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"性别";
                textField.placeholder = @"请选择性别"; break ;
            }
            if ([obj isEqualToString:@"mainCurrency"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"货币";
                textField.placeholder = @"人民币"; break ;
            }
            if ([obj isEqualToString:@"defaultLocale"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"主语言";
                textField.placeholder = @"简体中文"; break ;
            }
            if ([obj isEqualToString:@"securityIssues"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"安全问题";
                textField.placeholder = @"请选择安全问题"; break ;
            }
            if ([obj isEqualToString:@"securityIssues2"]) {
                _startImageView.hidden = NO;
                label_Title.text = @"回答问题";
                textField.placeholder = @"请输入回答";break ;
            }
        }
        [self setTextFieldPlaceHolder] ;
    }
}
#pragma mark - 设置placeHolder
-(void)setTextFieldPlaceHolder
{
    if (textField.placeholder)
    {
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:textField.placeholder];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:12]
                            range:NSMakeRange(0, textField.placeholder.length)];
        textField.attributedPlaceholder = placeholder;
    }
}

- (void)setFieldModel:(FieldModel *)model {
    fieldModel = model;
    if ([model.name isEqualToString:@"username"]) {
        label_Title.text = @"用户名";
        textField.placeholder = @"请输入用户名";
    }
    if ([model.name isEqualToString:@"password"]) {
        label_Title.text = @"密码";
        textField.placeholder = @"请输入6-20个字母数字或字符";
        [self setPasswordLayout];
    }
    if ([model.name isEqualToString:@"password2"]) {
        _startImageView.hidden = NO ;
        label_Title.text = @"确认密码";
        textField.placeholder = @"请再次输入登录密码";
        [self setPasswordLayout];
    }
    if ([model.name isEqualToString:@"verificationCode"]) {
        label_Title.text = @"验证码";
        textField.placeholder = @"请输入验证码";
        [self setVerifyCodeLayout];
    }
    if ([model.name isEqualToString:@"regCode"]) {
        label_Title.text = @"推荐码";
        textField.placeholder = @"推荐码";
    }
    if ([model.name isEqualToString:@"304"]) {
        label_Title.text = @"微信";
        textField.placeholder = @"请输入微信";
    }
    if ([model.name isEqualToString:@"110"]) {
        label_Title.text = @"手机号";
        textField.placeholder = @"请输入手机号";
        textField.keyboardType = UIKeyboardTypeNumberPad ;
    }
    if ([model.name isEqualToString:@"110verify"]) {
        label_Title.text = @"验证码";
        textField.placeholder = @"请输入手机验证码";
        textField.keyboardType = UIKeyboardTypeNumberPad ;
        [self setPhoneVerifyCodeLayout];
    }
    
    if ([model.name isEqualToString:@"201"]) {
        label_Title.text = @"邮箱";
        textField.placeholder = @"请输入邮箱地址";
    }
    if ([model.name isEqualToString:@"realName"]) {
        label_Title.text = @"真实姓名";
        textField.placeholder = @"请输入真实姓名";
    }
    if ([model.name isEqualToString:@"301"]) {
        label_Title.text = @"QQ号码";
        textField.placeholder = @"请输入QQ号码";
        textField.keyboardType = UIKeyboardTypeNumberPad ;
    }
    if ([model.name isEqualToString:@"paymentPassword"]) {
        label_Title.text = @"安全密码";
        textField.placeholder = @"请输入6位数字安全密码";
        textField.keyboardType = UIKeyboardTypeNumberPad ;
    }
    if ([model.name isEqualToString:@"paymentPassword2"]) {
        label_Title.text = @"确认密码";
        textField.placeholder = @"请再次输入6位数字安全密码";
        textField.keyboardType = UIKeyboardTypeNumberPad ;
    }
    if ([model.name isEqualToString:@"defaultTimezone"]) {
        label_Title.text = @"时区";
        textField.placeholder = @"";
        textField.enabled = NO;
    }
    if ([model.name isEqualToString:@"birthday"]) {
        label_Title.text = @"生日";
        textField.placeholder = @"";
        [self setBirthdaySelectLayout];
    }
    if ([model.name isEqualToString:@"sex"]) {
        label_Title.text = @"性别";
        textField.placeholder = @"请选择性别";
    }
    if ([model.name isEqualToString:@"mainCurrency"]) {
        label_Title.text = @"货币";
        textField.placeholder = @"人民币";
    }
    if ([model.name isEqualToString:@"defaultLocale"]) {
        label_Title.text = @"主语言";
        textField.placeholder = @"简体中文";
    }
    if ([model.name isEqualToString:@"securityIssues"]) {
        label_Title.text = @"安全问题";
        textField.placeholder = @"请选择安全问题";
    }
    if ([model.name isEqualToString:@"securityIssues2"]) {
        label_Title.text = @"回答问题";
        textField.placeholder = @"请输入回答";
    }
    [self setTextFieldPlaceHolder] ;
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
    [button setImage:ImageWithName(@"down") forState:UIControlStateNormal];
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
    [button setImage:ImageWithName(@"down") forState:UIControlStateNormal];
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
    [button setImage:ImageWithName(@"down") forState:UIControlStateNormal];
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
    [button setImage:ImageWithName(@"down") forState:UIControlStateNormal];
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
    [button setImage:ImageWithName(@"down") forState:UIControlStateNormal];
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
    textField.secureTextEntry = YES;
    [button_Check setImage:ImageWithName(@"eyeclose") forState:UIControlStateNormal];
    [button_Check addTarget:self action:@selector(button_CheckHandle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)button_CheckHandle:(UIButton *)button {
    if ([button isSelected]) {
        [button setSelected:NO];
        [button setImage:ImageWithName(@"eyeclose") forState:UIControlStateNormal];
        textField.secureTextEntry = YES;
    }else {
        [button setSelected:YES];
        [button setImage:ImageWithName(@"eye") forState:UIControlStateNormal];
        textField.secureTextEntry = NO;
    }
}

- (void)setVerifyCodeLayout {
    textField.whc_RightSpace(150);
    imageView_VerifyCode = [UIImageView new];
    [self addSubview:imageView_VerifyCode];
    imageView_VerifyCode.whc_CenterYToView(0, textField).whc_LeftSpaceToView(10, textField).whc_RightSpace(10).whc_Height(35);
    imageView_VerifyCode.backgroundColor = [UIColor redColor];
    [self.serviceRequest startV3RegisetCaptchaCode];
    imageView_VerifyCode.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageView_VerfyCode)];
    [imageView_VerifyCode addGestureRecognizer:tap];
//    UIWebView *webView = [UIWebView new];
//    [self addSubview:webView];
//    webView.whc_CenterYToView(0, textField).whc_LeftSpaceToView(10, textField).whc_RightSpace(25).whc_Height(35);
//    webView.backgroundColor = [UIColor redColor];
////    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
////    NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
//    RH_APPDelegate *app = (RH_APPDelegate *)[UIApplication sharedApplication].delegate;
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/captcha/pmregister.html",app.headerDomain]];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTapHandle:)];
//    tap.cancelsTouchesInView = NO;
//    tap.delegate = self;
//    [webView addGestureRecognizer:tap];
//    webView.multipleTouchEnabled = NO;
//    webView.scrollView.bounces = NO;
//    webView.scrollView.scrollEnabled = NO;
}
-(void)changeImageView_VerfyCode
{
    [self.serviceRequest startV3RegisetCaptchaCode];
}
-(void)changeImageView_VerfyCode1
{
    [self.serviceRequest startV3RegisetCaptchaCode];
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
    button.tag = 1002;
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
    WHC_StackView *stackView = (WHC_StackView *)self.superview;
    NSString *phone;
    for (RH_RegistrationViewItem *item in stackView.whc_Subviews) {
        if ([item.contentType isEqualToString:@"110"]) {
            phone = item.textFieldContent;
        }
    }
    NSLog(@"%@", phone);
    if (phone.length != 11) {
        showMessage(self.window, @"请输入正确的手机号码", nil);
        return ;
    }
    [serverRequest startV3GetPhoneCodeWithPhoneNumber:phone] ;
}

-(void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    NSLog(@"%@", data);
    if (type == ServiceRequestTypeV3GetPhoneCode) {
        NSDictionary *dict = ConvertToClassPointer(NSDictionary, data);
        NSLog(@"%@", dict);
            if ([dict[@"success"] isEqual:@YES]) {
                countDownNumber = 90;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountDown) userInfo:nil repeats:YES];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    showMessage(self.window, @"发送失败", @"");
                });
            }
    }
    else if (type==ServiceRequestTypeV3RegiestCaptchaCode){
        imageView_VerifyCode.image = ConvertToClassPointer(UIImage, data);
    }
}

-(void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3GetPhoneCode) {
        showErrorMessage(self.window, error, nil);
    }else if (type == ServiceRequestTypeV3RegiestCaptchaCode){
        showErrorMessage(self.window, error, nil);
        [self.serviceRequest startV3RegisetCaptchaCode];
    }

}

- (void)startCountDown {
    NSLog(@"%s", __func__);
        countDownNumber--;
        UIButton *button = [self viewWithTag:1002];
        if (countDownNumber > 0) {
            button.enabled = NO;
            button.layer.borderColor = colorWithRGB(168, 168, 168).CGColor;
            [button setTitle:[NSString stringWithFormat:@"%lds",(long)countDownNumber] forState:UIControlStateNormal];
            [button setTitleColor:colorWithRGB(168, 168, 168) forState:UIControlStateNormal];
        }else {
            [self.timer invalidate];
            button.layer.borderColor = colorWithRGB(20, 90, 180).CGColor;
            [button setTitleColor:colorWithRGB(20, 90, 180) forState:UIControlStateNormal];
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            button.enabled = YES;
        }
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
        if (textField.text.length + number.length > 20) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"password2"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
        if (textField.text.length + number.length > 20) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"verificationCode"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
    }
    if ([fieldModel.name isEqualToString:@"304"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_"];
    }
    if ([fieldModel.name isEqualToString:@"110"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if (textField.text.length + number.length > 11) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"110verify"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    if ([fieldModel.name isEqualToString:@"201"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM@_"];
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
        if (textField.text.length + number.length > 6) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"paymentPassword2"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if (textField.text.length + number.length > 6) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"regCode"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
    }
    if ([fieldModel.name isEqualToString:@"securityIssues2"]) {
//        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        return YES;
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeImageView_VerfyCode" object:self];
}
@end
