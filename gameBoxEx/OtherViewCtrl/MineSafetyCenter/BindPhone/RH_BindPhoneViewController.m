//
//  RH_BindPhoneViewController.m
//  gameBoxEx
//
//  Created by shin on 2018/6/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BindPhoneViewController.h"
#import "RH_BindUserPhone.h"
#import "RH_ChangeBIndPhoneView.h"
#import "RH_BindNewPhoneView.h"
#import "RH_UserInfoManager.h"

@interface RH_BindPhoneViewController () <RH_BindUserPhoneDelegate, RH_ChangeBIndPhoneViewDelegate, RH_BindNewPhoneViewDelegate>

@property (nonatomic, strong) RH_BindUserPhone *bindPhoneView;
@property (nonatomic, strong) RH_ChangeBIndPhoneView *changeBindPhoneView;
@property (nonatomic, strong) RH_BindNewPhoneView *bindNewPhoneView;

@end

@implementation RH_BindPhoneViewController

- (void)dealloc
{
    if (_bindPhoneView) {
        [self.bindPhoneView clearTimer];
        self.bindPhoneView = nil;
    }
    
    if (_bindNewPhoneView) {
        [self.bindNewPhoneView clearTimer];
        self.bindNewPhoneView = nil;
    }
}

-(BOOL)isSubViewController
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手机绑定";
    if (HasLogin) {
        [self.serviceRequest getUserPhone];
    }
    else
    {
        [self.view addSubview:self.bindPhoneView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RH_BindUserPhone *)bindPhoneView
{
    if (_bindPhoneView == nil) {
        _bindPhoneView = [[[NSBundle mainBundle] loadNibNamed:@"RH_BindUserPhone" owner:nil options:nil] lastObject];
        _bindPhoneView.frame = CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+(MainScreenH==812?20.0:0.0)));
        _bindPhoneView.themeColor = [self themeColor];
        _bindPhoneView.delegate = self;
    }
    return _bindPhoneView;
}

- (RH_ChangeBIndPhoneView *)changeBindPhoneView
{
    if (_changeBindPhoneView == nil) {
        _changeBindPhoneView = [[[NSBundle mainBundle] loadNibNamed:@"RH_ChangeBIndPhoneView" owner:nil options:nil] lastObject];
        _changeBindPhoneView.frame = CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+(MainScreenH==812?20.0:0.0)));
        _changeBindPhoneView.themeColor = [self themeColor];
        _changeBindPhoneView.delegate = self;
    }
    return _changeBindPhoneView;
}

- (RH_BindNewPhoneView *)bindNewPhoneView
{
    if (_bindNewPhoneView == nil) {
        _bindNewPhoneView = [[[NSBundle mainBundle] loadNibNamed:@"RH_BindNewPhoneView" owner:nil options:nil] lastObject];
        _bindNewPhoneView.frame = CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+(MainScreenH==812?20.0:0.0)));
        _bindNewPhoneView.themeColor = [self themeColor];
        _bindNewPhoneView.delegate = self;
    }
    return _bindNewPhoneView;
}

#pragma mark - RH_BindUserPhoneDelegate M

- (void)bindUserPhoneContact:(RH_BindUserPhone *)view
{
    //联系客服
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.myTabBarController.selectedIndex = 3 ;
    });
}

- (void)bindUserPhoneSendCode:(RH_BindUserPhone *)view phone:(NSString *)phone
{
    [self.serviceRequest bindPhoneSendCode:phone];
}

- (void)bindUserPhoneBind:(RH_BindUserPhone *)view phone:(NSString *)phone code:(NSString *)code
{
    [self.serviceRequest bindPhone:phone code:code];
}

#pragma mark - RH_ChangeBIndPhoneViewDelegate M

- (void)changBindUserPhoneContact:(RH_ChangeBIndPhoneView *)view
{
    //联系客服
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.myTabBarController.selectedIndex = 3 ;
    });
}

- (void)changBindUserPhoneChangeBind:(RH_ChangeBIndPhoneView *)view
{
    [self.view addSubview:self.bindNewPhoneView];
}

#pragma mark - RH_BindNewPhoneViewDelegate M

- (void)bindNewPhoneViewContact:(RH_BindNewPhoneView *)view
{
    //联系客服
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.myTabBarController.selectedIndex = 3 ;
    });
}

- (void)bindNewPhoneViewSendCode:(RH_BindNewPhoneView *)view phone:(NSString *)phone
{
    [self.serviceRequest bindPhoneSendCode:phone];
}

- (void)bindNewPhoneViewBind:(RH_BindNewPhoneView *)view phone:(NSString *)phone code:(NSString *)code
{
    [self.serviceRequest bindPhone:phone code:code];
}

#pragma mark - service request

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    __weak typeof(self) weakSelf = self;

    if (type == ServiceRequestTypeV3GetUserPhone){
        NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, data);
        NSString *data = [dataDic objectForKey:@"data"];
        if (data == nil || [data isEqualToString:@""]) {
            [weakSelf.view addSubview:weakSelf.bindPhoneView];
        }
        else
        {
            weakSelf.changeBindPhoneView.phone = data;
            [weakSelf.view addSubview:weakSelf.changeBindPhoneView];
        }
    }
    else if (type == ServiceRequestTypeV3BindSendCode)
    {
        NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, data);
        int code = [[dataDic objectForKey:@"code"] intValue];
        if (code == 0) {
            showMessage(self.view, @"发送成功", nil);
        }
    }
    else if (type == ServiceRequestTypeV3BindPhone)
    {
        NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, data);
        int code = [[dataDic objectForKey:@"code"] intValue];
        if (code == 0) {
            showMessage(self.view, @"绑定手机成功", nil);
            [self.navigationController popToRootViewControllerAnimated:YES];
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
