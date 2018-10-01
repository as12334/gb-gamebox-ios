//
//  RH_RegistrationViewController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//
#import "WHC_KeyboardManager.h"
#import "RH_RegisetInitModel.h"
#import "RH_RegistrationViewController.h"
#import "coreLib.h"
#import "RH_RegistrationViewItem.h"
#import "RH_RegisterClauseViewController.h"
#import "TTTAttributedLabel.h"
#import "RH_RegistrationTopView.h"

@interface RH_RegistrationViewController ()<RH_ServiceRequestDelegate,TTTAttributedLabelDelegate,RegistrationTopViewDelegate>

@property (nonatomic, strong, readonly) WHC_StackView *stackView;

@property (nonatomic ,strong)RH_RegistrationTopView *registTopView ;

@property(nonatomic,strong)TTTAttributedLabel *tttLab;

@end

@implementation RH_RegistrationViewController
{
    RH_RegisetInitModel *registrationInitModel;
    UIScrollView *mainScrollView;
    NSInteger animate_Item_Index;
    BOOL isAgreedServiceTerm;
    BOOL _isShowTopView;
}
@synthesize stackView = _stackView;
- (BOOL)isSubViewController {
    return  YES;
}

- (BOOL)hasTopView {
    return NO;
}

- (BOOL)hasNavigationBar {
    return YES;
}
+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            if ([THEMEV3 isEqualToString:@"green"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            if ([THEMEV3 isEqualToString:@"green"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else{
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
            }
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
                                              NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
    }else{
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            navigationBar.barTintColor = [UIColor blackColor];
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = [UIColor blackColor] ;
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    }
}
- (WHC_StackView *)stackView {
    if (_stackView == nil) {
        _stackView = [WHC_StackView new];
        _stackView.whc_Column = 1;
        _stackView.whc_Orientation = All;
        _stackView.whc_VSpace = 5;
        _stackView.whc_SubViewHeight = 45;
        _stackView.whc_Edge = UIEdgeInsetsMake(40, 0, 0, 0);
    }
    return _stackView;
}

-(RH_RegistrationTopView *)registTopView
{
    if (_registTopView == nil) {
        _registTopView = [RH_RegistrationTopView new] ;
        _registTopView.delegate = self ;
        [self.view addSubview:_registTopView];
        _registTopView.whc_LeftSpace(0).whc_TopSpace(NavigationBarHeight+STATUS_HEIGHT).whc_RightSpace(0).whc_Height(30);
    }
    return _registTopView ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.serviceRequest  startV3RequsetLoginWithGetLoadSid];
    self.title = @"免费注册";
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"正在加载..." detailText:@"请稍候"];
    animate_Item_Index = 1;
    [[WHC_KeyboardManager share] addMonitorViewController:self];
    
    [self.serviceRequest startV3RegisetInit];
    isAgreedServiceTerm = YES;
    _isShowTopView = YES ;
    //获取验证码
    //    [self.serviceRequest startV3RegisetCaptchaCode];
   
}

- (void)layoutContentViews {
    
    mainScrollView = [UIScrollView new];
    [self.contentView addSubview:mainScrollView];
    mainScrollView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0);
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.showsVerticalScrollIndicator = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(screenSize().width, screenSize().height + 200);
    [mainScrollView addSubview:self.stackView];
    self.stackView.whc_TopSpace(40).whc_LeftSpace(10).whc_Width(screenSize().width - 20).whc_HeightAuto();
    for (FieldModel *field in registrationInitModel.fieldModel) {
        if ([field.name isEqualToString:@"regCode"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            [item setFieldModel:field];
            item.isShowTopView = !self.registTopView.isHidden ;
            [item setRequiredJson:registrationInitModel.requiredJson];
            [self.stackView addSubview:item];
        }
    }
    for (FieldModel *field in registrationInitModel.fieldModel) {
        if ([field.name isEqualToString:@"regCode"]) {
            continue;
        }
        if ([field.name isEqualToString:@"serviceTerms"]) {
            continue;
        }
        if ([field.name isEqualToString:@"verificationCode"]) {
            continue ;
        }
        RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
        //        FieldModel *field;
        //        for (FieldModel *model in registrationInitModel.fieldModel) {
        //            if ([model.name isEqualToString:obj]) {
        //                field = model;
        //            }
        //        }
        item.isShowTopView = !self.registTopView.isHidden ;
        [item setFieldModel:field];
        if ([field.name isEqualToString:@"defaultTimezone"]) {
            [item setTimeZone:registrationInitModel.paramsModel.timezone];
        }
        if ([field.name isEqualToString:@"birthday"]) {
            [item setBirthDayMin:registrationInitModel.paramsModel.minDate MaxDate:registrationInitModel.paramsModel.maxDate];
        }
        if ([field.name isEqualToString:@"sex"]) {
            [item setSexModel:registrationInitModel.selectOptionModel.sexModel];
        }
        if ([field.name isEqualToString:@"mainCurrency"]) {
            [item setMainCurrencyModel:registrationInitModel.selectOptionModel.mainCurrencyModel];
        }
        if ([field.name isEqualToString:@"defaultLocale"]) {
            [item setDefaultLocale:registrationInitModel.selectOptionModel.defaultLocaleModel];
        }
        if ([field.name isEqualToString:@"securityIssues"]) {
            [item setSecurityIssues:registrationInitModel.selectOptionModel.securityIssuesModel];
        }
        [self.stackView addSubview:item];
        
        if ([field.name isEqualToString:@"password"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            item.isShowTopView = !self.registTopView.isHidden ;
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"password2";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
        }
        if (registrationInitModel.isPhone) {
            if ([field.name isEqualToString:@"110"]) {
                RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
                item.isShowTopView = !self.registTopView.isHidden ;
                FieldModel *field = [[FieldModel alloc] init];
                field.name = @"110verify";
                [item setFieldModel:field];
                [self.stackView addSubview:item];
            }
        }
        if ([field.name isEqualToString:@"paymentPassword"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            item.isShowTopView = !self.registTopView.isHidden ;
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"paymentPassword2";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
        }
        if ([field.name isEqualToString:@"securityIssues"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            item.isShowTopView = self.registTopView.isHidden ;
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"securityIssues2";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
        }
        [item setRequiredJson:registrationInitModel.requiredJson];
    }
    for (FieldModel *f in registrationInitModel.fieldModel) {
        if ([f.name isEqualToString:@"verificationCode"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            item.isShowTopView = !self.registTopView.isHidden ;
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"verificationCode";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
            [item setRequiredJson:registrationInitModel.requiredJson];
        }
    }
    [self.stackView whc_StartLayout];
    [self.view layoutIfNeeded];
    if (self.stackView.boundHeigh > screenSize().height) {
        mainScrollView.contentSize = CGSizeMake(screenSize().width, self.stackView.boundHeigh + 220);
    }
    for (RH_RegistrationViewItem *item in self.stackView.whc_Subviews) {
        item.isShowTopView = !self.registTopView.isHidden ;
        item.transform = CGAffineTransformMakeTranslation(screenSize().width, 0);
    }
    [self startAnimate];
    
}

- (void)setupBottomView {
    UIButton *button_Check = [UIButton new];
    button_Check.tag = 1023;
    [mainScrollView addSubview:button_Check];
    mainScrollView.userInteractionEnabled = YES ;
    button_Check.whc_TopSpaceToView(40, self.stackView).whc_LeftSpace(40).whc_Width(25).whc_Height(25);
    
    [button_Check setSelected:YES];
    [button_Check setImage:ImageWithName(@"choose") forState:UIControlStateNormal];
    [button_Check addTarget:self action:@selector(button_CheckHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tttLab.whc_LeftSpaceToView(10, button_Check).whc_BottomSpaceEqualView(button_Check).whc_Height(20).whc_WidthAuto();
    [self setBottomLabWithMessage:@"同意 用户注册协议"];
    
    UIButton *button = [UIButton new];
    [mainScrollView addSubview:button];
    button.whc_TopSpaceToView(20, button_Check).whc_LeftSpaceEqualView(button_Check).whc_RightSpaceEqualViewOffset(self.stackView, 20).whc_Height(44);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setTitle:@"立即注册" forState:UIControlStateNormal];
    [button setBackgroundColor:colorWithRGB(20, 90, 180)];
    if ([THEMEV3 isEqualToString:@"green"]) {
        [button setBackgroundColor:colorWithRGB(4, 109, 79)];
    }else if ([THEMEV3 isEqualToString:@"red"]) {
        [button setBackgroundColor:RH_NavigationBar_BackgroundColor_Red];
    }else if ([THEMEV3 isEqualToString:@"black"]) {
        //        [button setBackgroundColor:colorWithRGB(4, 109, 79)];
    }else if ([THEMEV3 isEqualToString:@"bule"]) {
        [button setBackgroundColor:RH_NavigationBar_BackgroundColor_Blue];
    }else if ([THEMEV3 isEqualToString:@"orange"]) {
        [button setBackgroundColor:RH_NavigationBar_BackgroundColor_Orange];
    }else if ([THEMEV3 isEqualToString:@"red_white"]) {
        [button setBackgroundColor:RH_NavigationBar_BackgroundColor_Red_White];
    }else if ([THEMEV3 isEqualToString:@"green_white"]) {
        [button setBackgroundColor:RH_NavigationBar_BackgroundColor_Green_White];
    }else if ([THEMEV3 isEqualToString:@"orange_white"]) {
        [button setBackgroundColor:RH_NavigationBar_BackgroundColor_Orange_White];
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]) {
        [button setBackgroundColor:RH_NavigationBar_BackgroundColor_Coffee_White];
    }
    [button addTarget:self action:@selector(buttonRegistrationHandle) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - lazy
- (TTTAttributedLabel *)tttLab
{
    if (!_tttLab)
    {
        _tttLab = [TTTAttributedLabel  new];
        _tttLab.lineBreakMode = NSLineBreakByWordWrapping;
        _tttLab.numberOfLines = 0;
        _tttLab.delegate = self;
        _tttLab.lineSpacing = 1;
        //要放在`text`, with either `setText:` or `setText:afterInheritingLabelAttributesAndConfiguringWithBlock:前面才有效
        _tttLab.enabledTextCheckingTypes = NSTextCheckingTypePhoneNumber|NSTextCheckingTypeAddress|NSTextCheckingTypeLink;
        _tttLab.textColor = colorWithRGB(168, 168, 168) ;
        //链接正常状态文本属性
        _tttLab.linkAttributes = @{NSForegroundColorAttributeName:colorWithRGB(31, 103, 185),NSUnderlineStyleAttributeName:@(1)};
        //链接高亮状态文本属性
        _tttLab.activeLinkAttributes = @{NSForegroundColorAttributeName:colorWithRGB(168, 168, 168),NSUnderlineStyleAttributeName:@(1)};
        _tttLab.font = [UIFont  systemFontOfSize:14.0];
        _tttLab.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [mainScrollView addSubview:_tttLab];
    }
    return _tttLab;
}

-(void)setBottomLabWithMessage:(NSString *)message{
    [self.tttLab  setText:message afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //设置可点击文字的范围
        NSRange boldRange = [[mutableAttributedString string]rangeOfString:@"用户注册协议"options:NSCaseInsensitiveSearch];
        //设定可点击文字的的大小
        UIFont*boldSystemFont = [UIFont systemFontOfSize:14];
        CTFontRef font =CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize,NULL);
        if(font){
            {
                //设置可点击文本的大小
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                value:(__bridge id)font
                                                range:boldRange];
                //文字颜色
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                                value:colorWithRGB(31, 103, 185)
                                                range:boldRange];
                CFRelease(font);
            }
        }
        return  mutableAttributedString;
    }];
    NSRange boldRange1 = [message rangeOfString:@"用户注册协议" options:NSCaseInsensitiveSearch];
    [self.tttLab addLinkToURL:[NSURL URLWithString:@""]
                    withRange:boldRange1];
}
#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [self showViewController:[RH_RegisterClauseViewController viewController] sender:nil];
}

- (void)button_CheckHandle:(UIButton *)button {
    
    if ([button isSelected]) {
        [button setSelected:NO];
        [button setImage:ImageWithName(@"not-choose") forState:UIControlStateNormal];
        isAgreedServiceTerm = NO;
    }else {
        [button setSelected:YES];
        [button setImage:ImageWithName(@"choose") forState:UIControlStateNormal];
        isAgreedServiceTerm = YES;
    }
}


#pragma mark - RegistrationTopViewDelegate
//更新UI
-(void)registrationTopViewbcloseBtnDidClick
{
    _isShowTopView = NO ;
    for (UIView *view in self.stackView.subviews) {
        if ([view isKindOfClass:[RH_RegistrationViewItem class]])
        {
            RH_RegistrationViewItem *item =  (RH_RegistrationViewItem *)view ;
            item.isShowTopView = _isShowTopView ;
        }
    }
    self.stackView.whc_TopSpace(20).whc_LeftSpace(10).whc_Width(screenSize().width - 20).whc_HeightAuto();
    
    UIButton *btn_check = [mainScrollView viewWithTag:1023];
    if (btn_check)
    {
        btn_check.whc_TopSpaceToView(20, self.stackView).whc_LeftSpace(40).whc_Width(25).whc_Height(25);
    }
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
    for (NSString *obj in registrationInitModel.requiredJson) {
        if ([obj isEqualToString:@"regCode"]) {
            if (registrationInitModel.isRequiredForRegisterCode) {
                if (regCode.length == 0) {
                    showMessage(self.contentView, @"请输入邀请码", @"");
                    return ;
                }
            }
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
    
    NSString *weixin = [self obtainContent:@"304"];
    
    NSString *phone = [self obtainContent:@"110"];
    
    NSString *phoneVerify = [self obtainContent:@"110verify"];
    
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
            if (registrationInitModel.isPhone) {
                if (phoneVerify.length == 0) {
                    showMessage(self.contentView, @"请输入手机验证码", @"");
                    return;
                }
            }
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
            //            if ([obj isEqualToString:@"securityIssues2"]) {
            if (securityIssues2.length == 0) {
                showMessage(self.contentView, @"请回答安全问题", @"");
                return;}
            //            }
        }
        
    }
    NSString *verificationCode = [self obtainContent:@"verificationCode"];
    if (verificationCode.length == 0) {
        showMessage(self.contentView, @"请输入验证码", @"");
        return;}
    if (isAgreedServiceTerm == NO) {
        showMessage(self.contentView, @"请同意注册条款", nil);
        return ;
    }
    NSString *registcode = registrationInitModel.paramsModel.registCode ?: @"";
    [self showProgressIndicatorViewWithAnimated:YES title:@"正在注册..."];
    [self.serviceRequest startV3RegisetSubmitWithBirthday:[NSString stringWithFormat:@"%@",birthday] sex:sex permissionPwd:permission defaultTimezone:timezone defaultLocale:defaultLocale phonecontactValue:phone realName:realname defaultCurrency:mainCurrency password:password question1:securityIssues emailValue:email qqValue:qq weixinValue:weixin userName:usernama captchaCode:verificationCode recommendRegisterCode:registcode editType:@"" recommendUserInputCode:regCode confirmPassword:password2 confirmPermissionPwd:permission2 answer1:securityIssues2 termsOfService:@"11" requiredJson:registrationInitModel.requiredJson phoneCode:phoneVerify checkPhone:@"checkPhone"];
    
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
    
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil];
    if (type == ServiceRequestTypeV3RegiestInit) {
        registrationInitModel =( RH_RegisetInitModel *)data;
        [self.contentLoadingIndicateView hiddenView];
        //头部跑马灯
        [self.registTopView updateContentWithContext:@"1204567"] ;
        [self layoutContentViews];
        
    }
    if (type == ServiceRequestTypeV3RegiestSubmit) {
        NSDictionary *dict = ConvertToClassPointer(NSDictionary, data);
        NSLog(@"···%@", dict);
        
        if ([dict[@"success"] isEqual:@true]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[self obtainContent:@"username"] forKey:@"account"];
            [defaults setObject:[self obtainContent:@"password"] forKey:@"password"];
            
            [defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didRegistratedSuccessful" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        showMessage(self.view, @"提示信息",[dict objectForKey:@"message"] );
        if ([[dict objectForKey:@"message"] isEqualToString:@"验证码输入错误"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeImageView_VerfyCode" object:self];
        }
    }
    
}

@end
