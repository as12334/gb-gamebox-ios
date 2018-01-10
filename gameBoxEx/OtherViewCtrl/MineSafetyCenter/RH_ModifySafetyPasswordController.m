//
//  RH_ModifySafetyPasswordController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ModifySafetyPasswordController.h"
#import "RH_ModifyPasswordCell.h"
#import "RH_UserInfoManager.h"
@interface RH_ModifySafetyPasswordController() <CLTableViewManagementDelegate, RH_ServiceRequestDelegate>

@property (nonatomic, strong) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong) UIButton *button;
@end
@implementation RH_ModifySafetyPasswordController
@synthesize tableViewManagement = _tableViewManagement;

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改安全密码";
    [self setupInfo];
}

- (void)setupInfo {
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
    
    UIView *view_Footer = [[UIView alloc] init];
    view_Footer.frame = CGRectMake(0, 0, screenSize().width, 80);
    self.contentTableView.tableFooterView = view_Footer;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view_Footer addSubview:self.button];
    self.button.whc_Center(0, 0).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(44);
    self.button.backgroundColor = colorWithRGB(27, 117, 217);
    self.button.layer.cornerRadius = 5;
    self.button.clipsToBounds = YES;
    [self.button setTitle:@"修改" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(modifyPassword) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //没有安全密码，需要设置。
    if (UserSafetyInfo.mHasRealName == NO && UserSafetyInfo.mHasPersimmionPwd == NO) {
        [self.tableViewManagement reloadDataWithPlistName:@"RH_ModifySafetyPasswordNoName"] ;
        [self.button setTitle:@"确认" forState:UIControlStateNormal];
        self.title = @"设置安全密码";
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (UserSafetyInfo.mHasRealName == NO) {
        [self showInputNameAlertView];
    }
}

- (void)showInputNameAlertView {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置真实姓名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入真实姓名";
    }];
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textF = alertController.textFields[0];
        if (textF.text.length == 0) {
            [self showInputNameAlertView];
        }else {
            [self.serviceRequest startV3SetRealName:textF.text];
            self.serviceRequest.delegate = self;
        }
    }];
    [alertController addAction:actionDefault];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_ModifySafetyPassword" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)modifyPassword {
    
    if (UserSafetyInfo.mHasPersimmionPwd == NO && UserSafetyInfo.mHasRealName == NO) {
        RH_ModifyPasswordCell *pwdCell = (RH_ModifyPasswordCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        RH_ModifyPasswordCell *pwdCell2 = (RH_ModifyPasswordCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        NSString *pwd = pwdCell.textField.text;
        NSString *pwd2 = pwdCell2.textField.text;
        if (pwd.length == 0 || pwd2.length == 0) {
            showMessage(self.view, nil, @"请输入密码");
            return;
        }
        if (![pwd isEqualToString:pwd2]) {
            showMessage(self.view, nil, @"两次输入密码不一样！");
            return;
        }
        [self.serviceRequest startV3UpdateSafePassword:NO name:nil originPassword:nil newPassword:pwd confirmPassword:pwd2 verifyCode:nil];
        self.serviceRequest.delegate = self;
    }
    if (UserSafetyInfo.mHasPersimmionPwd == NO) {
        RH_ModifyPasswordCell *truelyNameCell = (RH_ModifyPasswordCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        RH_ModifyPasswordCell *currentPwdCell = (RH_ModifyPasswordCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        RH_ModifyPasswordCell *newPwdCell = (RH_ModifyPasswordCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        RH_ModifyPasswordCell *newPwdCell2 = (RH_ModifyPasswordCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        NSString *currentPwd = currentPwdCell.textField.text;
        NSString *newPwd = newPwdCell.textField.text;
        NSString *newPwd2 = newPwdCell2.textField.text;
        NSString *truelyName = truelyNameCell.textField.text;
        if (currentPwd.length == 0 || newPwd.length == 0 || newPwd2.length == 0 || truelyName.length == 0) {
            showMessage(self.view, nil, @"请输入密码");
            return;
        }
        if (![newPwd isEqualToString:newPwd2]) {
            showMessage(self.view, nil, @"两次输入的密码不一样！");
            return;
        }
        [self.serviceRequest startV3UpdateSafePassword:NO name:truelyName originPassword:nil newPassword:newPwd confirmPassword:newPwd2 verifyCode:nil];
        self.serviceRequest.delegate = self;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    NSLog(@"%s", __func__);
    NSLog(@"%@", error);
}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    NSLog(@"%s", __func__);
    if (type == ServiceRequestTypeV3SetRealName) {
        NSLog(@"%@", data);
    }
    if (type == ServiceRequestTypeV3UpdateSafePassword) {
        NSLog(@"%@", data);
        [self.serviceRequest startV3UserSafetyInfo];
    }
    if (type == ServiceRequestTypeV3UserSafeInfo) {
        NSLog(@"%@", data);
        RH_UserSafetyCodeModel *model = data;
    }
}
@end
