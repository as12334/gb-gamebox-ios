//
//  RH_FindbackPswSendCodeViewController.m
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FindbackPswSendCodeViewController.h"
#import "RH_FindbackPswSendPhoneCodeView.h"
#import "RH_FBPChangePswViewController.h"

@interface RH_FindbackPswSendCodeViewController () <RH_FindbackPswSendPhoneCodeViewDelegate>

@property (nonatomic, strong) RH_FindbackPswSendPhoneCodeView *sendCodeView;
@property (nonatomic, strong) NSString *encryptedId;
@property (nonatomic, strong) NSString *username;

@end

@implementation RH_FindbackPswSendCodeViewController

- (void)dealloc
{
    [self.sendCodeView clearTimer];
    self.sendCodeView = nil;
}

- (BOOL)isSubViewController
{
    return YES;
}

- (void)setupViewContext:(id)context
{
    self.sendCodeView.phone = [context objectForKey:@"phone"];
    self.encryptedId = [context objectForKey:@"encryptedId"];
    self.username = [context objectForKey:@"username"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"输入验证码";
    [self.view addSubview:self.sendCodeView];
    [self.sendCodeView autoSendCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RH_FindbackPswSendPhoneCodeView *)sendCodeView
{
    if (_sendCodeView == nil) {
        _sendCodeView = [[[NSBundle mainBundle] loadNibNamed:@"RH_FindbackPswSendPhoneCodeView" owner:nil options:nil] lastObject];
        _sendCodeView.frame = CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+(MainScreenH==812?20.0:0.0)));
        _sendCodeView.themeColor = [self themeColor];
        _sendCodeView.delegate = self;
    }
    return _sendCodeView;
}

#pragma mark - RH_FindbackPswSendPhoneCodeViewDelegate M

- (void)findbackPswSendPhoneCodeViewSendCode:(RH_FindbackPswSendPhoneCodeView *)view
{
    [self.serviceRequest forgetPswSendCode:self.encryptedId];
}

- (void)findbackPswSendPhoneCodeViewNext:(RH_FindbackPswSendPhoneCodeView *)view code:(NSString *)code
{
    [self.serviceRequest forgetPswCheckCode:code];
}

#pragma mark - service request

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3ForgetPswSendCode){
        int code = [[data objectForKey:@"code"] intValue];
        if (code == 0) {
            showMessage(self.view, @"发送成功", nil);
        }
    }
    else if (type == ServiceRequestTypeV3ForgetPswCheckCode)
    {
        int code = [[data objectForKey:@"code"] intValue];
        if (code == 0) {
            [self showViewController:[RH_FBPChangePswViewController viewControllerWithContext:self.username] sender:nil];
        }
        else
        {
            showMessage(self.view, [data objectForKey:@"message"], nil);
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
