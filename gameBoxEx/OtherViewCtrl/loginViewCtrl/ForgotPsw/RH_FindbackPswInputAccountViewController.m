//
//  RH_FindbackPswInputAccountViewController.m
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FindbackPswInputAccountViewController.h"
#import "RH_InputAccountView.h"
#import "RH_FindbackPswSendCodeViewController.h"

@interface RH_FindbackPswInputAccountViewController () <RH_InputAccountViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) RH_InputAccountView *inputAccountView;
@property (nonatomic, strong) NSString *username;

@end

@implementation RH_FindbackPswInputAccountViewController

- (BOOL)isSubViewController
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    [self.view addSubview:self.inputAccountView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RH_InputAccountView *)inputAccountView
{
    if (_inputAccountView == nil) {
        _inputAccountView = [[[NSBundle mainBundle] loadNibNamed:@"RH_InputAccountView" owner:nil options:nil] lastObject];
        _inputAccountView.frame = CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+(MainScreenH==812?20.0:0.0)));
        _inputAccountView.themeColor = [self themeColor];
        _inputAccountView.delegate = self;
    }
    return _inputAccountView;
}

#pragma mark - RH_InputAccountViewDelegate M

- (void)inputAccountView:(RH_InputAccountView *)view next:(NSString *)account
{
    self.username = account;
    [self.serviceRequest findUserPhone:account];
}

#pragma mark - service request

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3FindUserPhone){
        int code = [[data objectForKey:@"code"] intValue];
        if (code == 0) {
            NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, [data objectForKey:@"data"]);
            NSString *phone = ConvertToClassPointer(NSString, [dataDic objectForKey:@"phone"]);
            if ([phone isEqualToString:@""] || phone == nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该账号未绑定手机号，请联系客服找回密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服", nil];
                alert.delegate = self;
                [alert show];
            }
            else
            {
                [self showViewController:[RH_FindbackPswSendCodeViewController viewControllerWithContext:@{@"phone":[dataDic objectForKey:@"phone"],@"encryptedId":[dataDic objectForKey:@"encryptedId"],@"username":self.username}] sender:nil];
            }
        }
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest
           serviceType:(ServiceRequestType)type
didFailRequestWithError:(NSError *)error
{
    showMessage(self.view, error.localizedDescription, nil);
}

#pragma mark - UIAlertViewDelegate M

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.myTabBarController.selectedIndex = 3 ;
        });
    }
}

@end
