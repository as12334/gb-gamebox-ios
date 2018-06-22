//
//  RH_FBPChangePswViewController.m
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FBPChangePswViewController.h"
#import "RH_FBPChangePwView.h"
#import "RH_ChangePswSuccessView.h"

@interface RH_FBPChangePswViewController () <RH_FBPChangePwViewDelegate, RH_ChangePswSuccessViewDelegate>

@property (nonatomic, strong) RH_FBPChangePwView *changePwView;
@property (nonatomic, strong) RH_ChangePswSuccessView *successView;
@property (nonatomic, strong) NSString *username;
@end

@implementation RH_FBPChangePswViewController

- (BOOL)isSubViewController
{
    return YES;
}

- (void)setupViewContext:(id)context
{
    self.username = context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置登录密码";
    [self.view addSubview:self.changePwView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RH_FBPChangePwView *)changePwView
{
    if (_changePwView == nil) {
        _changePwView = [[[NSBundle mainBundle] loadNibNamed:@"RH_FBPChangePwView" owner:nil options:nil] lastObject];
        _changePwView.frame = CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+(MainScreenH==812?20.0:0.0)));
        _changePwView.themeColor = [self themeColor];
        _changePwView.delegate = self;
    }
    return _changePwView;
}

- (RH_ChangePswSuccessView *)successView
{
    if (_successView == nil) {
        _successView = [[[NSBundle mainBundle] loadNibNamed:@"RH_ChangePswSuccessView" owner:nil options:nil] lastObject];
        _successView.frame = CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+(MainScreenH==812?20.0:0.0)));
        _successView.delegate = self;
    }
    return _successView;
}

#pragma mark - RH_FBPChangePwViewDelegate M

- (void) changePwViewSubmit:(RH_FBPChangePwView *)view psw:(NSString *)psw
{
    [self.serviceRequest finbackLoginPsw:self.username psw:psw];
}

#pragma mark - RH_ChangePswSuccessViewDelegate M

- (void)changePswSuccessViewClose:(RH_ChangePswSuccessView *)view
{
    [self.successView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - service request

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3ForgetPswFindbackPsw){
        int code = [[data objectForKey:@"code"] intValue];
        if (code == 0) {
            [self.view addSubview:self.successView];
            [self.view endEditing:YES];
        }
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest
           serviceType:(ServiceRequestType)type
didFailRequestWithError:(NSError *)error
{
    showMessage(self.view, error.localizedDescription, nil);
}

@end
