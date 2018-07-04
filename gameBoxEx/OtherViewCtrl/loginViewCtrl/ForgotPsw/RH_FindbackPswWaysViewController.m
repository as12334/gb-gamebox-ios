//
//  RH_FindbackPswWaysViewController.m
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FindbackPswWaysViewController.h"
#import "RH_FindbackPswWayView.h"
#import "RH_BindPhoneViewController.h"
#import "RH_FindbackPswInputAccountViewController.h"

@interface RH_FindbackPswWaysViewController () <RH_FindbackPswWayViewDelegate>
@property (nonatomic, strong) RH_FindbackPswWayView *findbackPswWayView;

@end

@implementation RH_FindbackPswWaysViewController

- (BOOL)isSubViewController
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"忘记密码";
    [self.view addSubview:self.findbackPswWayView];
    __weak typeof(self) weakSelf = self;

    //检测是否打开该功能
    [self.serviceRequest checkForgetPswStatus];
    self.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
        if (type == ServiceRequestTypeV3ForgetPswCheckStatus)
        {
            if (data) {
                int code = [[data objectForKey:@"code"] intValue];
                if (code == 0) {
                    int switchStatus = [[data objectForKey:@"data"] intValue];
                    if (switchStatus == 1) {
                        //打开
                        weakSelf.findbackPswWayView.findbackPswH.constant = 50;
                    }
                    else
                    {
                        //关闭
                        weakSelf.findbackPswWayView.findbackPswH.constant = 0;
                    }
                }
            }
            else
            {
                //关闭
                weakSelf.findbackPswWayView.findbackPswH.constant = 0;
            }
        }
    };
    self.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
        if (type == ServiceRequestTypeV3ForgetPswCheckStatus)
        {
            weakSelf.findbackPswWayView.findbackPswH.constant = 0;
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RH_FindbackPswWayView *)findbackPswWayView
{
    if (_findbackPswWayView == nil) {
        _findbackPswWayView = [[[NSBundle mainBundle] loadNibNamed:@"RH_FindbackPswWayView" owner:nil options:nil] lastObject];
        _findbackPswWayView.frame = CGRectMake(0, 64+(MainScreenH==812?20.0:0.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+(MainScreenH==812?20.0:0.0)));
        _findbackPswWayView.themeColor = [self themeColor];
        _findbackPswWayView.delegate = self;
    }
    return _findbackPswWayView;
}

#pragma mark - RH_FindbackPswWayViewDelegate M

- (void)findbackPswWayViewFindByPhone:(RH_FindbackPswWayView *)view
{
    [self showViewController:[RH_FindbackPswInputAccountViewController viewController] sender:nil];
}

- (void)findbackPswWayViewFindByCust:(RH_FindbackPswWayView *)view
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.myTabBarController.selectedIndex = 3 ;
    });
}

- (void)findbackPswWayViewBindPhone:(RH_FindbackPswWayView *)view
{
    [self showViewController:[RH_BindPhoneViewController viewController] sender:nil];
}

@end
