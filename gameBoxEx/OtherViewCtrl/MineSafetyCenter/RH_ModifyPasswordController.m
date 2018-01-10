//
//  RH_ModifyPasswordController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ModifyPasswordController.h"
#import "RH_ModifyPasswordCell.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_ModifyPasswordController () <CLTableViewManagementDelegate, RH_ServiceRequestDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong,readonly) UIButton *modifyButton;
@end

@implementation RH_ModifyPasswordController
@synthesize tableViewManagement = _tableViewManagement;
@synthesize modifyButton = _modifyButton  ;

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改登录密码";
    self.needObserverTapGesture = YES ;
    [self setupInfo];
}

#pragma mark-
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return YES;
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    [self.view endEditing:YES];
}

- (void)setupInfo {
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
    
    UIView *view_Footer = [[UIView alloc] init];
    view_Footer.frame = CGRectMake(0, 0, screenSize().width, 80);
    self.contentTableView.tableFooterView = view_Footer;
    
//    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view_Footer addSubview:self.modifyButton];
    self.modifyButton.whc_Center(0, 0).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(44);
//    self.button.backgroundColor = colorWithRGB(27, 117, 217);
//    self.button.layer.cornerRadius = 5;
//    self.button.clipsToBounds = YES;
//    [self.button setTitle:@"修改" forState:UIControlStateNormal];
//    [self.button addTarget:self action:@selector(modifyPassword) forControlEvents:UIControlEventTouchUpInside];
    
}

- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_ModifyPassword" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    
    return  YES;
}

#pragma mark- modify
-(UIButton *)modifyButton
{
    if (!_modifyButton){
        _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _modifyButton.backgroundColor = colorWithRGB(27, 117, 217);
        _modifyButton.layer.cornerRadius = 5;
        _modifyButton.clipsToBounds = YES ;
        [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(modifyButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _modifyButton ;
}

- (void)modifyButtonHandle
{
    
    RH_ModifyPasswordCell *currentPwdCell = (RH_ModifyPasswordCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    RH_ModifyPasswordCell *newPwdCell = (RH_ModifyPasswordCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    RH_ModifyPasswordCell *newPwdCell2 = (RH_ModifyPasswordCell *)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *currentPwd = currentPwdCell.textField.text;
    NSString *newPwd = newPwdCell.textField.text;
    NSString *newPwd2 = newPwdCell2.textField.text;
    if (currentPwd.length == 0 || newPwd.length == 0 || newPwd2.length == 0) {
        showMessage(self.view, @"错误", @"请输入密码");
        return;
    }
    if (![newPwd isEqualToString:newPwd2]) {
        showMessage(self.view, nil, @"两次输入的密码不一样！");
        return;
    }
    
    if (NetworkAvailable()){
        [self showProgressIndicatorViewWithAnimated:YES title:@"正在修改密码"];
        [self.serviceRequest startV3ChangePasswordWith:currentPwd and:newPwd];
    }else{
        showAlertView(@"无网络", @"请稍后再试") ;
    }
}


#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3ModifyPassword){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"密码修改成功", @"提示信息") ;
        }] ;
        
        [self backBarButtonItemHandle] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3ModifyPassword){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"修改密码失败");
        }] ;
        
        NSDictionary *userInfo = error.userInfo ;
        if ([userInfo boolValueForKey:RH_GP_MINEMODIFYPASSWORD_ISOPENCAPTCHA]){
            
        }
    }
}


@end
