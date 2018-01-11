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

typedef NS_ENUM(NSInteger,ModifySafetyStatus ) {
    ModifySafetyStatus_Init                         ,
    ModifySafetyStatus_SetRealName                  ,
    ModifySafetyStatus_SetPermissionPassword        ,
    ModifySafetyStatus_SetPermissionPasswordUsedCode        ,
    ModifySafetyStatus_UpdatePermissionPassword     ,
    ModifySafetyStatus_UpdatePermissionPasswordUsedCode     ,
};

@interface RH_ModifySafetyPasswordController() <CLTableViewManagementDelegate, RH_ServiceRequestDelegate>
@property (nonatomic, strong,readonly) CLTableViewManagement *tableViewManagement       ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordCell *userNameCell               ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordCell *userPermissionCell      ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordCell *userNewPermissionCell      ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordCell *userConfirmPermissionCell  ;

@property (nonatomic, strong,readonly) UIView *footerView ;
@property (nonatomic, strong,readonly) UIButton *modifyButton ;
@end

@implementation RH_ModifySafetyPasswordController
{
    ModifySafetyStatus _modifySafetyStatus  ;
}
@synthesize tableViewManagement = _tableViewManagement;
@synthesize footerView = _footerView ;
@synthesize modifyButton = _modifyButton ;

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改安全密码";
    [self setupInfo];
    [self setNeedUpdateView] ;
    
    self.needObserverTapGesture = YES ;
}

- (void)setupInfo {
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
}

-(void)updateView
{
    if (UserSafetyInfo==nil){
        _modifySafetyStatus = ModifySafetyStatus_Init ;
        [self.tableViewManagement reloadDataWithPlistName:@"ModifySafetyInitInfo"] ;
        [self loadingIndicateViewDidTap:nil] ;
        return ;
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
        self.contentTableView.tableFooterView = self.footerView ;
        
        if (UserSafetyInfo.mHasRealName==FALSE){
            _modifySafetyStatus = ModifySafetyStatus_SetRealName ;
            showAlertView(@"用户姓名未设置", @"请先设置姓名") ;
            [self.tableViewManagement reloadDataWithPlistName:@"ModifySafetyNoRealName"] ;
            [self.modifyButton setTitle:@"设置用户真实姓名" forState:UIControlStateNormal] ;
            return ;
        }else if (UserSafetyInfo.mHasPersimmionPwd==FALSE){
            _modifySafetyStatus = UserSafetyInfo.mIsOpenCaptch?ModifySafetyStatus_SetPermissionPasswordUsedCode:ModifySafetyStatus_SetPermissionPassword ;
            [self.tableViewManagement reloadDataWithPlistName:UserSafetyInfo.mIsOpenCaptch?@"ModifySafetyNoPermissionUsedCode":@"ModifySafetyNoPermission"] ;
            [self.modifyButton setTitle:@"设置安全密码" forState:UIControlStateNormal] ;
            return ;
        }else{
            _modifySafetyStatus = UserSafetyInfo.mIsOpenCaptch?ModifySafetyStatus_UpdatePermissionPasswordUsedCode:ModifySafetyStatus_UpdatePermissionPassword ;
            [self.tableViewManagement reloadDataWithPlistName:UserSafetyInfo.mIsOpenCaptch?@"ModifySafetyPasswordUsedCode":@"ModifySafetyPassword"] ;
            [self.modifyButton setTitle:@"修改安全密码" forState:UIControlStateNormal] ;
            return ;
        }
    }
}

#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.userNameCell.isEditing || self.userPermissionCell.isEditing || self.userNewPermissionCell.isEditing || self.userConfirmPermissionCell.isEditing ;
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.userNameCell endEditing:YES] ;
    [self.userPermissionCell endEditing:YES] ;
    [self.userNewPermissionCell endEditing:YES] ;
    [self.userConfirmPermissionCell endEditing:YES] ;
}

#pragma mark -
-(RH_ModifyPasswordCell *)userNameCell
{
    return ConvertToClassPointer(RH_ModifyPasswordCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) ;
}

-(RH_ModifyPasswordCell *)userPermissionCell
{
    return ConvertToClassPointer(RH_ModifyPasswordCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]) ;
}

-(RH_ModifyPasswordCell *)userNewPermissionCell
{
    return ConvertToClassPointer(RH_ModifyPasswordCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]) ;
}

-(RH_ModifyPasswordCell *)userConfirmPermissionCell
{
    return ConvertToClassPointer(RH_ModifyPasswordCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]) ;
}

#pragma mark - footerView
-(UIView *)footerView
{
    if (!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 80)] ;
        [_footerView addSubview:self.modifyButton];
        self.modifyButton.whc_Center(0, 0).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(44);
    }
    
    return _footerView ;
}

-(UIButton *)modifyButton
{
    if (!_modifyButton){
        _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _modifyButton.backgroundColor = colorWithRGB(27, 117, 217);
        _modifyButton.layer.cornerRadius = 5;
        _modifyButton.clipsToBounds = YES;
        [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(modifyButtonHandle) forControlEvents:UIControlEventTouchUpInside] ;
    }
    
    return _modifyButton ;
}

- (void)modifyButtonHandle
{
    if (_modifySafetyStatus == ModifySafetyStatus_SetRealName){
        NSString *realName = [self.userNameCell.textField.text copy] ;
        if (realName.length<1){
            showMessage(self.view, nil, @"请输入真实姓名");
            [self.userNameCell.textField becomeFirstResponder] ;
        }
        
        [self showProgressIndicatorViewWithAnimated:YES title:@"正在设置..."] ;
        [self.serviceRequest startV3SetRealName:realName];
        
        return ;
    }else if (_modifySafetyStatus == ModifySafetyStatus_SetPermissionPassword){
        NSString *realName = [self.userNameCell.textField.text copy] ;
        NSString *newPassword = [self.userPermissionCell.textField.text copy] ;
        NSString *confirmPassword = [self.userNewPermissionCell.textField.text copy] ;
        if (realName.length<1){
            showMessage(self.view, nil, @"请输入真实姓名");
            [self.userNameCell.textField becomeFirstResponder] ;
        }
        
        if (newPassword.length<1){
            showMessage(self.view, nil, @"请输入新密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
        }
        
        if (confirmPassword.length<1){
            showMessage(self.view, nil, @"请重新输入新密码");
            [self.userNewPermissionCell.textField becomeFirstResponder] ;
        }
        
        if (![newPassword isEqualToString:confirmPassword]) {
            showMessage(self.view, nil, @"两次输入密码不一样！");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return;
        }
        
        [self showProgressIndicatorViewWithAnimated:YES title:@"正在设置..."] ;
        [self.serviceRequest startV3ModifySafePasswordWithRealName:realName
                                                    originPassword:nil
                                                       newPassword:newPassword
                                                   confirmPassword:confirmPassword
                                                        verifyCode:nil] ;
        
        return ;
    }else{
        NSString *realName = [self.userNameCell.textField.text copy] ;
        NSString *oldPassword = [self.userPermissionCell.textField.text copy] ;
        NSString *newPassword = [self.userNewPermissionCell.textField.text copy] ;
        NSString *confirmPassword = [self.userConfirmPermissionCell.textField.text copy] ;
        if (realName.length<1){
            showMessage(self.view, nil, @"请输入真实姓名");
            [self.userNameCell.textField becomeFirstResponder] ;
        }
        
        if (oldPassword.length<1){
            showMessage(self.view, nil, @"请输入旧密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
        }
        
        if (newPassword.length<1){
            showMessage(self.view, nil, @"请输入新密码");
            [self.userNewPermissionCell.textField becomeFirstResponder] ;
        }
        
        if (confirmPassword.length<1){
            showMessage(self.view, nil, @"请重新输入新密码");
            [self.userConfirmPermissionCell.textField becomeFirstResponder] ;
        }
        
        if (![newPassword isEqualToString:confirmPassword]) {
            showMessage(self.view, nil, @"两次输入密码不一样！");
            [self.userNewPermissionCell.textField becomeFirstResponder] ;
            return;
        }
        
        [self showProgressIndicatorViewWithAnimated:YES title:@"正在设置..."] ;
        [self.serviceRequest startV3ModifySafePasswordWithRealName:realName
                                                    originPassword:oldPassword
                                                       newPassword:newPassword
                                                   confirmPassword:confirmPassword
                                                        verifyCode:nil] ;
        
        return ;
    }
    
}

#pragma mark-
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"初如化安全信息" detailText:@"请稍等"] ;
    [self.serviceRequest startV3UserSafetyInfo] ;
}


#pragma mark - service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UserSafeInfo){
        [self setNeedUpdateView] ;
    }else if (type == ServiceRequestTypeV3SetRealName){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
        [UserSafetyInfo updateHasRealName:YES] ;
        [self setNeedUpdateView] ;
    }else if (type == ServiceRequestTypeV3UpdateSafePassword){
        [UserSafetyInfo updateHasPersimmionPwd:YES] ;
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, _modifySafetyStatus==ModifySafetyStatus_SetPermissionPassword?@"已设定安全密码":@"已更新安全密码", nil);
            [self backBarButtonItemHandle] ;
        }] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3UserSafeInfo){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }else if (type == ServiceRequestTypeV3SetRealName){
        showErrorMessage(self.view, error, @"设置真实姓名失败") ;
    }else if (type == ServiceRequestTypeV3UpdateSafePassword){
        [UserSafetyInfo updateHasPersimmionPwd:YES] ;
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, _modifySafetyStatus==ModifySafetyStatus_SetPermissionPassword?@"设定失败":@"更新失败") ;
        }] ;
    }
}

#pragma mark - tableviewmanagement
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

-(CGFloat)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return MainScreenH - StatusBarHeight - NavigationBarHeight ;
}

-(UITableViewCell*)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellAtIndexPath:(NSIndexPath *)indexPath
{
    return self.loadingIndicateTableViewCell ;
}

@end
