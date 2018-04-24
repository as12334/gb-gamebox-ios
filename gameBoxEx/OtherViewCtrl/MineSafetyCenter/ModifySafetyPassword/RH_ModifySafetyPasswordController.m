//
//  RH_ModifySafetyPasswordController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/7.
//  Copyright © 2018年 luis. All rights reserved.
//
#import "RH_ModifyPasswordNameCell.h"
#import "RH_ModifySafetyPasswordController.h"
#import "RH_ModifyPasswordCell.h"
#import "RH_UserInfoManager.h"
#import "RH_ModifySafetyPwdCodeCell.h"
#import "RH_ModifyPasswordCodeCell.h"
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
@property (nonatomic,strong,readonly) RH_ModifySafetyPwdCodeCell *userPasswordCodeCell  ;

@property (nonatomic, strong,readonly) UIView *footerView ;
@property (nonatomic, strong,readonly) UIButton *modifyButton ;
@property (nonatomic, strong)           UILabel *label_Notice ;
@property (nonatomic,assign) BOOL isInitSuccess ;
@end

@implementation RH_ModifySafetyPasswordController
{
    ModifySafetyStatus _modifySafetyStatus  ;
    NSString *_titleStr ;
}
@synthesize tableViewManagement = _tableViewManagement;
@synthesize footerView = _footerView ;
@synthesize modifyButton = _modifyButton ;

-(void)setupViewContext:(id)context
{
    _titleStr = ConvertToClassPointer(NSString, context) ;
}

- (BOOL)isSubViewController {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
     [self.serviceRequest startV3GetWithDraw] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr?:@"修改安全密码";
    [self setupInfo];
    [self setNeedUpdateView] ;
    self.needObserverTapGesture = YES ;
    self.isInitSuccess = NO ;
}

- (void)setupInfo {
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
    
    UIView *view_Footer = [[UIView alloc] init];
    view_Footer.frame = CGRectMake(0, 0, screenSize().width, 150);
    self.contentTableView.tableFooterView = view_Footer;
    
    [view_Footer addSubview:self.modifyButton];
    self.modifyButton.whc_TopSpace(32).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(40);
    self.label_Notice = [UILabel new];
    _label_Notice.font = [UIFont systemFontOfSize:10];
    [view_Footer addSubview:self.label_Notice];
    self.label_Notice.whc_LeftSpace(20).whc_TopSpace(0).whc_Width(screenSize().width/2).whc_Height(30);
}

+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            if ([THEMEV3 isEqualToString:@"green"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            if ([THEMEV3 isEqualToString:@"green"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else{
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
            }
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
                                              NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
    }else{
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            navigationBar.barTintColor = [UIColor blackColor];
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = [UIColor blackColor] ;
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    }
}

-(void)updateView
{
    if (self.isInitSuccess) {
        [self.tableViewManagement reloadDataWithPlistName:@"WithdrawInit"] ;
        return ;
    }
   else if (UserSafetyInfo==nil){
        _modifySafetyStatus = ModifySafetyStatus_Init ;
        [self.tableViewManagement reloadDataWithPlistName:@"ModifySafetyInitInfo"] ;
        [self loadingIndicateViewDidTap:nil] ;
         self.title = @"设置安全密码";
        return ;
    }else{
        [self.contentLoadingIndicateView hiddenView] ;

        if (UserSafetyInfo.mHasRealName==FALSE){
            _modifySafetyStatus = ModifySafetyStatus_SetRealName ;
            showAlertView(@"用户姓名未设置", @"请先设置姓名") ;
            [self.tableViewManagement reloadDataWithPlistName:@"ModifySafetyNoRealName"] ;
            RH_ModifyPasswordCell *cell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.textField.secureTextEntry = NO;
            [self.modifyButton setTitle:@"设置用户真实姓名" forState:UIControlStateNormal] ;
            self.title = @"设置真实姓名";
            return ;
        }else if (UserSafetyInfo.mHasPersimmionPwd==FALSE){
            _modifySafetyStatus = UserSafetyInfo.mIsOpenCaptch?ModifySafetyStatus_SetPermissionPasswordUsedCode:ModifySafetyStatus_SetPermissionPassword ;
            [self.tableViewManagement reloadDataWithPlistName:UserSafetyInfo.mIsOpenCaptch?@"ModifySafetyNoPermissionUsedCode":@"ModifySafetyNoPermission"] ;
            [self.modifyButton setTitle:@"设置安全密码" forState:UIControlStateNormal] ;
            RH_ModifyPasswordCell *cell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.textField.secureTextEntry = NO;
            self.title = @"设置安全密码";
            return ;
        }else{
            _modifySafetyStatus = UserSafetyInfo.mIsOpenCaptch?ModifySafetyStatus_UpdatePermissionPasswordUsedCode:ModifySafetyStatus_UpdatePermissionPassword ;
            [self.tableViewManagement reloadDataWithPlistName:UserSafetyInfo.mIsOpenCaptch?@"ModifySafetyPasswordUsedCode":@"ModifySafetyPassword"] ;
            [self.modifyButton setTitle:@"确定" forState:UIControlStateNormal] ;
            RH_ModifyPasswordCell *cell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.textField.secureTextEntry = NO;
            self.title = @"修改安全密码";
            return ;
        }
    }
}

#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.userNameCell.isEditing || self.userPermissionCell.isEditing || self.userNewPermissionCell.isEditing || self.userConfirmPermissionCell.isEditing || self.userPasswordCodeCell.isEditing;
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.userNameCell endEditing:YES] ;
    [self.userPermissionCell endEditing:YES] ;
    [self.userNewPermissionCell endEditing:YES] ;
    [self.userConfirmPermissionCell endEditing:YES] ;
    [self.userPasswordCodeCell endEditing:YES] ;
}

#pragma mark -
-(RH_ModifyPasswordNameCell *)userNameCell
{
    return ConvertToClassPointer(RH_ModifyPasswordNameCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) ;
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
-(RH_ModifySafetyPwdCodeCell *)userPasswordCodeCell
{
    if (_modifySafetyStatus == ModifySafetyStatus_SetPermissionPasswordUsedCode){
        return ConvertToClassPointer(RH_ModifySafetyPwdCodeCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]) ;
    }else if (_modifySafetyStatus == ModifySafetyStatus_UpdatePermissionPasswordUsedCode)
    {
        return ConvertToClassPointer(RH_ModifySafetyPwdCodeCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]]) ;
    }
    
    return nil ;
}

-(UIButton *)modifyButton
{
    if (!_modifyButton){
        _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        if ([THEMEV3 isEqualToString:@"green"]){
            _modifyButton.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            _modifyButton.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
        }else if ([THEMEV3 isEqualToString:@"black"]){
//            _modifyButton.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
            _modifyButton.backgroundColor = colorWithRGB(23, 102, 187);
        }else{
            _modifyButton.backgroundColor = RH_NavigationBar_BackgroundColor;
        }
        
        _modifyButton.layer.cornerRadius = 5;
        _modifyButton.clipsToBounds = YES;
        [_modifyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
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
            return ;
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
            return ;
        }
        if (newPassword.length<1){
            showMessage(self.view, nil, @"请输入新密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
       
        if (newPassword.length > 6) {
            showMessage(self.view, nil, @"请输入6位新数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (!isNumberSecert(newPassword)) {
            showMessage(self.view, nil, @"请输入数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        
        
        if (confirmPassword.length<1){
            showMessage(self.view, nil, @"请再次输入新密码");
            [self.userNewPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        if (confirmPassword.length > 6) {
            showMessage(self.view, nil, @"请再次输入6位新数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (!isNumberSecert(confirmPassword)) {
            showMessage(self.view, nil, @"请输入数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (![newPassword isEqualToString:confirmPassword]) {
            showMessage(self.view, nil, @"两次输入密码不一样！");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return;
        }
        
        if (self.userPasswordCodeCell){
            if (self.userPasswordCodeCell.passwordCode.length<1){
                showMessage(self.view, nil, @"请输入验证码");
                [self.userPasswordCodeCell becomeFirstResponder] ;
                return;
            }
        }
        [self showProgressIndicatorViewWithAnimated:YES title:@"正在设置..."] ;
        [self.serviceRequest startV3ModifySafePasswordWithRealName:realName
                                                    originPassword:nil
                                                       newPassword:newPassword
                                                   confirmPassword:confirmPassword
                                                        verifyCode:self.userPasswordCodeCell.passwordCode] ;
        
        return ;
    }else if (_modifySafetyStatus == ModifySafetyStatus_UpdatePermissionPasswordUsedCode) {
        NSString *realName = [self.userNameCell.textField.text copy] ;
        NSString *oldPassword = [self.userPermissionCell.textField.text copy] ;
        NSString *newPassword = [self.userNewPermissionCell.textField.text copy] ;
        NSString *confirmPassword = [self.userConfirmPermissionCell.textField.text copy] ;
        NSString *verifyCode = [self.userPasswordCodeCell.passwordCode copy];
        if (realName.length<1){
            showMessage(self.view, nil, @"请输入真实姓名");
            [self.userNameCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (oldPassword.length<1){
            showMessage(self.view, nil, @"请输入旧数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
       
        if (oldPassword.length > 6) {
            showMessage(self.view, nil, @"请输入6位旧数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (!isNumberSecert(oldPassword)) {
            showMessage(self.view, nil, @"请输入数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (newPassword.length<1){
            showMessage(self.view, nil, @"请输入新数字密码");
            [self.userNewPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (newPassword.length > 6) {
            showMessage(self.view, nil, @"请输入6位新数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (!isNumberSecert(newPassword)) {
            showMessage(self.view, nil, @"请输入新数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (confirmPassword.length<1){
            showMessage(self.view, nil, @"请再次输入密码");
            [self.userConfirmPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (confirmPassword.length > 6) {
            showMessage(self.view, nil, @"请再次输入6位密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (!isNumberSecert(confirmPassword)) {
            showMessage(self.view, nil, @"请再次输入数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (![newPassword isEqualToString:confirmPassword]) {
            showMessage(self.view, nil, @"两次输入密码不一样！");
            [self.userNewPermissionCell.textField becomeFirstResponder] ;
            return;
        }
        if (verifyCode.length < 1) {
            showMessage(self.view, nil, @"请输入验证码！");
            return ;
        }
        [self showProgressIndicatorViewWithAnimated:YES title:@"正在设置..."] ;
        [self.serviceRequest startV3ModifySafePasswordWithRealName:realName
                                                    originPassword:oldPassword
                                                       newPassword:newPassword
                                                   confirmPassword:confirmPassword
                                                        verifyCode:self.userPasswordCodeCell.passwordCode] ;
        
        return ;
    }
    
    else if(_modifySafetyStatus== ModifySafetyStatus_UpdatePermissionPassword){
        NSString *realName = [self.userNameCell.textField.text copy] ;
        NSString *oldPassword = [self.userPermissionCell.textField.text copy] ;
        NSString *newPassword = [self.userNewPermissionCell.textField.text copy] ;
        NSString *confirmPassword = [self.userConfirmPermissionCell.textField.text copy] ;
        if (realName.length<1){
            showMessage(self.view, nil, @"请输入真实姓名");
            [self.userNameCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (oldPassword.length<1){
            showMessage(self.view, nil, @"请输入旧数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
       
        if (oldPassword.length > 6) {
            showMessage(self.view, nil, @"请输入6位旧数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }

        if (!isNumberSecert(oldPassword)) {
            showMessage(self.view, nil, @"请输入数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (newPassword.length<1){
            showMessage(self.view, nil, @"请输入新数字密码");
            [self.userNewPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (newPassword.length > 6) {
            showMessage(self.view, nil, @"请输入6位新数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        if (!isNumberSecert(newPassword)) {
            showMessage(self.view, nil, @"请输入数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        if (confirmPassword.length<1){
            showMessage(self.view, nil, @"请再次输入数字密码");
            [self.userConfirmPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (confirmPassword.length > 6) {
            showMessage(self.view, nil, @"请再次输入6位数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        if (!isNumberSecert(confirmPassword)) {
            showMessage(self.view, nil, @"请再次输入数字密码");
            [self.userPermissionCell.textField becomeFirstResponder] ;
            return ;
        }
        
        if (![newPassword isEqualToString:confirmPassword]) {
            showMessage(self.view, nil, @"两次输入密码不一样！");
            [self.userNewPermissionCell.textField becomeFirstResponder] ;
            return;
        }
        if ([oldPassword isEqualToString:newPassword]) {
            showMessage(self.view, nil, @"新密码与旧密码一样！");
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
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"初始化安全信息" detailText:@"请稍等"] ;
    [self.serviceRequest startV3UserSafetyInfo] ;
    [self.serviceRequest startV3GetWithDraw] ;
}


#pragma mark - service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UserSafeInfo){
        if (data==nil){
            [self.contentLoadingIndicateView showInfoInInvalidWithTitle:@"提示" detailText:@"获取安全初始化信息失败"];
        }else{
            [self setNeedUpdateView] ;
        }
    }else if (type == ServiceRequestTypeV3SetRealName){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
        [UserSafetyInfo updateHasRealName:YES] ;
        [self setNeedUpdateView] ;
    }else if (type == ServiceRequestTypeV3UpdateSafePassword){
        [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_AlreadySucfullSettingSafetyPassword object:nil] ;
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showMessage_b(self.appDelegate.window, _modifySafetyStatus==ModifySafetyStatus_SetPermissionPassword?@"安全密码设置成功":@"安全密码修改成功", nil, ^{
                [self backBarButtonItemHandle] ;
                [serviceRequest startV3UserSafetyInfo];
            });
            
        }] ;
    }else if (type == ServiceRequestTypeV3UserSafeInfo) {
        [self backBarButtonItemHandle];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3UserSafeInfo){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }else if (type == ServiceRequestTypeV3SetRealName){
        showErrorMessage(self.view, error, @"设置真实姓名失败") ;
    }else if (type == ServiceRequestTypeV3UpdateSafePassword){
         NSDictionary *userInfo = error.userInfo ;
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, _modifySafetyStatus==ModifySafetyStatus_SetPermissionPassword?@"设定失败":@"更新失败") ;
        }] ;
        
        if ([userInfo boolValueForKey:@"isOpenCaptcha"]){
            [self.tableViewManagement reloadDataWithPlistName:@"ModifySafetyPasswordUsedCode"] ;
        }
        if (_modifySafetyStatus != ModifySafetyStatus_SetPermissionPassword) {
            if ([userInfo integerValueForKey:@"remindTimes"]) {
                self.label_Notice.text = [NSString stringWithFormat:@"你还有 %ld 次机会",[userInfo integerValueForKey:@"remindTimes"]] ;
            }
            if ([userInfo integerValueForKey:@"remindTimes"] == 5) {
                self.label_Notice.hidden = YES ;
            }else if([userInfo integerValueForKey:@"remindTimes"] == 0){
                self.label_Notice.hidden = YES ;
                [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                    showMessage_b(self.view, nil, @"您输入的安全密码已上限，用户余额被冻结，请联系客服", ^{
                        [self backBarButtonItemHandle] ;
                        [serviceRequest startV3UserSafetyInfo];
                    });
                }] ;
            }else
            {
                self.label_Notice.hidden = NO ;
            }
        }
        [self setNeedUpdateView] ;
    }else if (type == ServiceRequestTypeV3GetWithDrawInfo){
        if (error.code == 1101) {
            self.isInitSuccess = YES ;
            [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
           
        }else
        {
            self.isInitSuccess = NO ;
            [self.contentLoadingIndicateView hiddenView] ;
        }
         [self setNeedUpdateView] ;
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
