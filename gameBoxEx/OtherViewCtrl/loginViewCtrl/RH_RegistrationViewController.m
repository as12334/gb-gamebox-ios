//
//  RH_RegistrationViewController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegisetInitModel.h"
#import "RH_RegistrationViewController.h"
#import "coreLib.h"
#import "RH_RegistrationViewItem.h"
@interface RH_RegistrationViewController ()<RH_ServiceRequestDelegate>

@property (nonatomic, strong, readonly) WHC_StackView *stackView;
@end

@implementation RH_RegistrationViewController
{
    RH_RegisetInitModel *registrationInitModel;
    UIScrollView *mainScrollView;
    NSInteger animate_Item_Index;
}
@synthesize stackView = _stackView;


- (BOOL)hasTopView {
    return NO;
}
- (BOOL)hasNavigationBar {
    return YES;
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (WHC_StackView *)stackView {
    if (_stackView == nil) {
        _stackView = [WHC_StackView new];
        _stackView.whc_Column = 1;
        _stackView.whc_Orientation = All;
        _stackView.whc_VSpace = 5;
        _stackView.whc_SubViewHeight = 60;
        _stackView.whc_Edge = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"免费注册";
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"正在加载..." detailText:@"请稍候"];
    animate_Item_Index = 1;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.serviceRequest startV3RegisetInit];
}

- (void)layoutContentViews {
    
    mainScrollView = [UIScrollView new];
    [self.contentView addSubview:mainScrollView];
    mainScrollView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0);
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.scrollEnabled = YES;
    mainScrollView.showsVerticalScrollIndicator = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(screenSize().width, screenSize().height + 100);
    [mainScrollView addSubview:self.stackView];
    self.stackView.whc_TopSpace(70).whc_LeftSpace(20).whc_Width(screenSize().width - 40).whc_HeightAuto();
    if (registrationInitModel.registCodeField) {
        RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
        FieldModel *field = [[FieldModel alloc] init];
        field.name = @"regCode";
        [item setFieldModel:field];
        [self.stackView addSubview:item];
    }
    for (NSString *obj in registrationInitModel.requiredJson) {
        if ([obj isEqualToString:@"regCode"]) {
            continue;
        }
        if ([obj isEqualToString:@"serviceTerms"]) {
            continue;
        }
        RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
        FieldModel *field;
        for (FieldModel *model in registrationInitModel.fieldModel) {
            if ([model.name isEqualToString:obj]) {
                field = model;
            }
        }
        [item setFieldModel:field];
        if ([obj isEqualToString:@"defaultTimezone"]) {
            [item setTimeZone:registrationInitModel.paramsModel.timezone];
        }
        if ([obj isEqualToString:@"birthday"]) {
            [item setBirthDayMin:registrationInitModel.paramsModel.minDate MaxDate:registrationInitModel.paramsModel.maxDate];
        }
        if ([obj isEqualToString:@"sex"]) {
            [item setSexModel:registrationInitModel.selectOptionModel.sexModel];
        }
        if ([obj isEqualToString:@"mainCurrency"]) {
            [item setMainCurrencyModel:registrationInitModel.selectOptionModel.mainCurrencyModel];
        }
        if ([obj isEqualToString:@"defaultLocale"]) {
            [item setDefaultLocale:registrationInitModel.selectOptionModel.defaultLocaleModel];
        }
        if ([obj isEqualToString:@"securityIssues"]) {
            [item setSecurityIssues:registrationInitModel.selectOptionModel.securityIssuesModel];
        }
        [self.stackView addSubview:item];
        //密码输入框，要多插入一个
        if ([field.name isEqualToString:@"password"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"password2";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
        }
        //手机号输入框。也要多插入一个，输入手机号验证码
        if ([field.name isEqualToString:@"110"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"110verify";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
        }
        if ([field.name isEqualToString:@"paymentPassword"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"paymentPassword2";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
        }
        if ([field.name isEqualToString:@"securityIssues"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"securityIssues2";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
        }
    }
    [self.stackView whc_StartLayout];
    [self.view layoutIfNeeded];
    if (self.stackView.boundHeigh > screenSize().height) {
        mainScrollView.contentSize = CGSizeMake(screenSize().width, self.stackView.boundHeigh + 200);
    }
    for (RH_RegistrationViewItem *item in self.stackView.whc_Subviews) {
        item.transform = CGAffineTransformMakeTranslation(screenSize().width, 0);
    }
    [self startAnimate];
}

- (void)setupBottomView {
    UIButton *button_Check = [UIButton new];
    [mainScrollView addSubview:button_Check];
    button_Check.whc_TopSpaceToView(20, self.stackView).whc_LeftSpace(40).whc_Width(25).whc_Height(25);
    button_Check.backgroundColor = [UIColor blueColor];
    UILabel *label = [UILabel new];
    [mainScrollView addSubview:label];
    label.whc_LeftSpaceToView(10, button_Check).whc_BottomSpaceEqualView(button_Check).whc_Height(20).whc_WidthAuto();
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = colorWithRGB(168, 168, 168);
    label.text = @"hahahsasudnakubaksjhcbakshcajscnkaujskcn";
    
    UIButton *button = [UIButton new];
    [mainScrollView addSubview:button];
    button.whc_TopSpaceToView(20, button_Check).whc_LeftSpaceEqualView(button_Check).whc_RightSpaceEqualViewOffset(self.stackView, 20).whc_Height(44);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setTitle:@"立即注册" forState:UIControlStateNormal];
    [button setBackgroundColor:colorWithRGB(20, 90, 180)];
    [button addTarget:self action:@selector(buttonRegistrationHandle) forControlEvents:UIControlEventTouchUpInside];
}

- (NSString *)obtainContent:(NSString *)name {
    
//    FieldModel *model = [[FieldModel alloc] init];
    for (RH_RegistrationViewItem *item in self.stackView.whc_Subviews) {
        if ([item.contentType isEqualToString:name]) {
            NSString *content  = [item textFieldContent];
//            if (content.length == 0) {
//                if ([name isEqualToString:@"username"]) {
//                    showMessage(self.contentView, @"请输入账号", @"");
//                }
//                if ([name isEqualToString:@"birthday"]) {
//                    showMessage(self.contentView, @"请选择生日", @"");
//                }
//                if ([name isEqualToString:@"201"]) {
//                    showMessage(self.contentView, @"请输入邮箱", @"");
//                }
//                if ([name isEqualToString:@"301"]) {
//                    showMessage(self.contentView, @"请输入QQ号", @"");
//                }
//                if ([name isEqualToString:@"304"]) {
//                    showMessage(self.contentView, @"请输入微信", @"");
//                }
//                if ([name isEqualToString:@"password"]) {
//                    showMessage(self.contentView, @"请输入密码", @"");
//                }
//                if ([name isEqualToString:@"password2"]) {
//                    showMessage(self.contentView, @"请再次输入密码", @"");
//                }
//                if ([name isEqualToString:@"realName"]) {
//                    showMessage(self.contentView, @"请输入真实姓名", @"");
//                }
//                if ([name isEqualToString:@"verificationCode"]) {
//                    showMessage(self.contentView, @"请输入验证码", @"");
//                }
//                if ([name isEqualToString:@"paymentPassword"]) {
//                    showMessage(self.contentView, @"请输入安全密码", @"");
//                }
//                if ([name isEqualToString:@"paymentPassword2"]) {
//                    showMessage(self.contentView, @"请再次输入安全密码", @"");
//                }
//                if ([name isEqualToString:@"defaultTimezone"]) {
//                    showMessage(self.contentView, @"请选择时区", @"");
//                }
//                if ([name isEqualToString:@"sex"]) {
//                    showMessage(self.contentView, @"请选择性别", @"");
//                }
//                if ([name isEqualToString:@"mainCurrency"]) {
//                    showMessage(self.contentView, @"请选择货币", @"");
//                }
//                if ([name isEqualToString:@"defaultLocale"]) {
//                    showMessage(self.contentView, @"请选择语言", @"");
//                }
//                if ([name isEqualToString:@"securityIssues"]) {
//                    showMessage(self.contentView, @"请回答安全问题", @"");
//                }
//            }else {
                return content;
//            }
        }
    }
    return @"";
}

- (void)buttonRegistrationHandle {
    
    NSString *regCode = [self obtainContent:@"regCode"];
    if (registrationInitModel.isRequiredForRegisterCode) {
        if (regCode.length == 0) {
            showMessage(self.contentView, @"请输入邀请码", @"");
            return ;
        }
    }
    NSString *usernama = [self obtainContent:@"username"];
    if (usernama.length == 0) {
        showMessage(self.contentView, @"请输入用户名", @"");
        return;
    }
    NSString *password = [self obtainContent:@"password"];
    if (password.length == 0) {
        showMessage(self.contentView, @"请输入密码", @"");
        return;
    }
    NSString *password2 = [self obtainContent:@"password2"];
    if (password2.length == 0) {
        showMessage(self.contentView, @"请再次输入密码", @"");
        return;
    }
    if (![password isEqualToString:password2]) {
        showMessage(self.contentView, @"两次输入的密码不一样", @"");
        return;
    }
    NSString *verificationCode = [self obtainContent:@"verificationCode"];
    if (verificationCode.length == 0) {
        showMessage(self.contentView, @"请输入验证码", @"");
        return;}
    NSString *weixin = [self obtainContent:@"304"];
    
    NSString *phone = [self obtainContent:@"110"];
    
    NSString *email = [self obtainContent:@"201"];
    
    NSString *realname = [self obtainContent:@"realName"];
    
    NSString *qq = [self obtainContent:@"301"];
    
    NSString *permission = [self obtainContent:@"paymentPassword"];
    
    NSString *permission2 = [self obtainContent:@"paymentPassword2"];
    
    NSString *timezone = [self obtainContent:@"defaultTimezone"];
    
    NSString *birthday = [self obtainContent:@"birthday"];
    
    NSString *sex = [self obtainContent:@"sex"];
    
    NSString *mainCurrency = [self obtainContent:@"mainCurrency"];
    
    NSString *defaultLocale = [self obtainContent:@"defaultLocale"];
    
    NSString *securityIssues = [self obtainContent:@"securityIssues"];
    NSString *securityIssues2 = [self obtainContent:@"securityIssues2"];
    
    for (NSString *obj in registrationInitModel.requiredJson) {
        if ([obj isEqualToString:@"304"]) {
            if (weixin.length == 0) {
                showMessage(self.contentView, @"请输入与微信号", @"");
                return;}
        }
        if ([obj isEqualToString:@"110"]) {
            if (phone.length == 0) {
                showMessage(self.contentView, @"请输入手机号", @"");
                return;}
        }
        if ([obj isEqualToString:@"201"]) {
            if (email.length == 0) {
                showMessage(self.contentView, @"请输入邮箱", @"");
                return;}
        }
        if ([obj isEqualToString:@"realName"]) {
            if (realname.length == 0) {
                showMessage(self.contentView, @"请输入真实姓名", @"");
                return;}
        }
        if ([obj isEqualToString:@"301"]) {
            if (qq.length == 0) {
                showMessage(self.contentView, @"请输入QQ号", @"");
                return;}
        }
        if ([obj isEqualToString:@"paymentPassword"]) {
            if (permission.length == 0) {
                showMessage(self.contentView, @"请输入安全密码", @"");
                return;}
            if (permission2.length == 0) {
                showMessage(self.contentView, @"请再次输入安全密码", @"");
                return;}
            if (![permission2 isEqualToString:permission]) {
                showMessage(self.contentView, @"两次输入的安全密码不一样", @"");
                return;
            }
        }
        
        if ([obj isEqualToString:@"defaultTimezone"]) {
            if (timezone.length == 0) {
                showMessage(self.contentView, @"请选择时区", @"");
                return;}
        }
        if ([obj isEqualToString:@"birthday"]) {
            if (birthday.length == 0) {
                showMessage(self.contentView, @"请选择生日", @"");
                return;}
        }
        if ([obj isEqualToString:@"sex"]) {
            if (sex.length == 0) {
                showMessage(self.contentView, @"请选择性别", @"");
                return;}
        }
        if ([obj isEqualToString:@"mainCurrency"]) {
            if (mainCurrency.length == 0) {
                showMessage(self.contentView, @"请选择货币", @"");
                return;}
        }
        if ([obj isEqualToString:@"defaultLocale"]) {
            if (defaultLocale.length == 0) {
                showMessage(self.contentView, @"请选择语言", @"");
                return;}
        }
        if ([obj isEqualToString:@"securityIssues"]) {
            if (securityIssues.length == 0) {
                showMessage(self.contentView, @"请选择安全问题", @"");
                return;}
        }
        if ([obj isEqualToString:@"securityIssues2"]) {
            if (securityIssues.length == 0) {
                showMessage(self.contentView, @"请回答安全问题", @"");
                return;}
        }
    }
    NSString *registcode = registrationInitModel.paramsModel.registCode ?: @"";
    [self showProgressIndicatorViewWithAnimated:YES title:@"正在注册..."];
    [self.serviceRequest startV3RegisetSubmitWithBirthday:[NSString stringWithFormat:@"%@&",birthday] sex:sex permissionPwd:permission defaultTimezone:timezone defaultLocale:defaultLocale phonecontactValue:phone realName:realname defaultCurrency:mainCurrency password:password question1:securityIssues emailValue:email qqValue:qq weixinValue:weixin userName:usernama captchaCode:verificationCode recommendRegisterCode:registcode editType:@"" recommendUserInputCode:regCode confirmPassword:password2 confirmPermissionPwd:permission2 answer1:securityIssues2 termsOfService:@"11" requiredJson:registrationInitModel.requiredJson];

}

- (void)startAnimate {
    if (animate_Item_Index < self.stackView.whc_Subviews.count + 1) {
        RH_RegistrationViewItem *item = (RH_RegistrationViewItem *)self.stackView.whc_Subviews[animate_Item_Index - 1];
//        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1.0/0.4 options:UIViewAnimationOptionCurveLinear animations:^{
//            item.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            animate_Item_Index++;
//            [self startAnimate];
//        }];
        [UIView animateWithDuration:0.2 animations:^{
            item.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            animate_Item_Index++;
            [self startAnimate];
        }];
    }else {
        [self setupBottomView];
    }
}





#pragma mark Request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    NSLog(@"%s", __func__);
    NSLog(@"%@", error);
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil];
    showErrorMessage(self.contentView, error, @"");

}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    NSLog(@"%s", __func__);
    NSLog(@"%@", data);
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil];
    if (type == ServiceRequestTypeV3RegiestInit) {
        registrationInitModel =( RH_RegisetInitModel *)data;
        [self.contentLoadingIndicateView hiddenView];
        [self layoutContentViews];
    }
    if (type == ServiceRequestTypeV3RegiestSubmit) {
        
    }

}
@end
