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
    
}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    NSLog(@"%s", __func__);
    NSLog(@"%@", data);
    if (type == ServiceRequestTypeV3RegiestInit) {
        registrationInitModel =( RH_RegisetInitModel *)data;
        [self.contentLoadingIndicateView hiddenView];
        [self layoutContentViews];
    }
}
@end
