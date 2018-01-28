//
//  RH_ModifyPasswordController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ModifyPasswordController.h"
#import "RH_ModifyPasswordCell.h"
#import "RH_ModifyPasswordCodeCell.h"
#import "RH_ModifyPasswordSpecialCell.h"
#import "coreLib.h"
#import "RH_API.h"

@interface RH_ModifyPasswordController () <CLTableViewManagementDelegate, RH_ServiceRequestDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong,readonly) UIButton *modifyButton;

//--
@property (nonatomic,strong,readonly) RH_ModifyPasswordCell *currentPasswordCell ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordSpecialCell *newSettingPasswordCell    ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordCell *confirmSettingPasswordCell ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordCodeCell *passwordCodeCell ;

@property (nonatomic, strong,readonly) UILabel *label_Notice;
@end

@implementation RH_ModifyPasswordController
@synthesize tableViewManagement = _tableViewManagement;
@synthesize modifyButton = _modifyButton  ;
@synthesize label_Notice = _label_Notice  ;

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

#pragma mark - tableview cell--
-(RH_ModifyPasswordCell *)currentPasswordCell
{
    return ConvertToClassPointer(RH_ModifyPasswordCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) ;
}

-(RH_ModifyPasswordSpecialCell *)newSettingPasswordCell
{
    return ConvertToClassPointer(RH_ModifyPasswordSpecialCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]) ;
}

-(RH_ModifyPasswordCell *)confirmSettingPasswordCell
{
    return ConvertToClassPointer(RH_ModifyPasswordCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]) ;
}

-(RH_ModifyPasswordCodeCell *)passwordCodeCell
{
    return ConvertToClassPointer(RH_ModifyPasswordCodeCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]) ;
}

#pragma mark-
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.currentPasswordCell.isEditing || self.newSettingPasswordCell.isEditing || self.confirmSettingPasswordCell.isEditing || self.passwordCodeCell.isEditing ;
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.currentPasswordCell endEditing:YES] ;
    [self.newSettingPasswordCell endEditing:YES] ;
    [self.confirmSettingPasswordCell endEditing:YES] ;
    [self.passwordCodeCell endEditing:YES] ;
}

- (void)setupInfo {
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
    
    UIView *view_Footer = [[UIView alloc] init];
    view_Footer.frame = CGRectMake(0, 0, screenSize().width, 120);
    self.contentTableView.tableFooterView = view_Footer;
    
    [view_Footer addSubview:self.modifyButton];
    self.modifyButton.whc_Center(0, 0).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(44);
    
    [view_Footer addSubview:self.label_Notice];
    self.label_Notice.whc_LeftSpace(20).whc_TopSpace(0).whc_Width(screenSize().width/2).whc_Height(30);
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
    if (!_modifyButton) {
        _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _modifyButton.backgroundColor = colorWithRGB(27, 117, 217);
        _modifyButton.layer.cornerRadius = 5;
        _modifyButton.clipsToBounds = YES ;
        [_modifyButton setTitle:@"确定" forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(modifyButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _modifyButton ;
}

- (void)modifyButtonHandle
{
    NSString *currentPwd = self.currentPasswordCell.textField.text;
    NSString *newPwd = self.newSettingPasswordCell.textField.text;
    NSString *newPwd2 = self.confirmSettingPasswordCell.textField.text;
    
    if (currentPwd.length == 0 || newPwd.length == 0 || newPwd2.length == 0) {
        showMessage(self.view, @"错误", @"请输入密码");
        return;
    }
    if (![newPwd isEqualToString:newPwd2]) {
        showMessage(self.view, nil, @"两次输入的密码不一样！");
        return;
    }
    
    if (self.passwordCodeCell){//需要输入验证码
        if (self.passwordCodeCell.passwordCode.length<1){
            showMessage(self.view, nil, @"请输入验证码！");
            return;
        }
    }
    
    if (NetworkAvailable()){
        [self showProgressIndicatorViewWithAnimated:YES title:@"正在修改密码"];
        [self.serviceRequest startV3UpdateLoginPassword:currentPwd newPassword:newPwd verifyCode:self.passwordCodeCell.passwordCode];
    }else{
        showAlertView(@"无网络", @"请稍后再试") ;
    }

}

-(UILabel *)label_Notice
{
    if (!_label_Notice){
        _label_Notice = [[UILabel alloc] init];
        _label_Notice.font = [UIFont systemFontOfSize:10];
        _label_Notice.textColor = colorWithRGB(153, 153, 153);
        _label_Notice.textAlignment = NSTextAlignmentLeft;
    }
    
    return _label_Notice ;
}

#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UpdateLoginPassword){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"密码修改成功", @"提示信息") ;
        }] ;
        
        [self backBarButtonItemHandle] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3UpdateLoginPassword){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"修改密码失败");
        }] ;
        
        NSDictionary *userInfo = error.userInfo ;
        if ([userInfo boolValueForKey:RH_GP_MINEMODIFYPASSWORD_ISOPENCAPTCHA]){
            [self.tableViewManagement reloadDataWithPlistName:@"RH_ModifyPasswordUsercode"] ;
        }
        
        self.label_Notice.text = [NSString stringWithFormat:@"你还有 %ld 机会",[userInfo integerValueForKey:RH_GP_MINEMODIFYPASSWORD_REMAINTIMES]] ;
    }
}


@end
