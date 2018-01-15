//
//  RH_BankCardController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BankCardController.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_ModifyPasswordCell.h"
#import "RH_BankCardCell.h"
#import "RH_BankPickerSelectView.h"

typedef NS_ENUM(NSInteger,BankCardStatus ) {
    BankCardStatus_Init                        ,
    BankCardStatus_None                        ,
    BankCardStatus_Exist                   ,
};


@interface RH_BankCardController ()<CLTableViewManagementDelegate,BankPickerSelectViewDelegate>
@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic,strong, readonly)  RH_ModifyPasswordCell *realNameCell ;
@property (nonatomic,strong, readonly)  RH_BankCardCell *bankSelectedCell ;
@property (nonatomic,strong, readonly)  RH_ModifyPasswordCell *bankCardNumCell ;
@property (nonatomic,strong, readonly)  RH_ModifyPasswordCell *bankLocationCell ;

@property (nonatomic,strong, readonly)  RH_BankPickerSelectView *bankPickerSelectView ;

////---
@property (nonatomic, strong,readonly) UIView *footerView ;
@property (nonatomic, strong,readonly) UIButton *addButton ;
@end

@implementation RH_BankCardController
{
    BankCardStatus _bankCardStatus ;
    
    //添加银行卡所需信息
    NSString *_addBankCardRealName ;
    NSString *_addBankCardBankName ;
    NSString *_addBankCardBankCardNumber ;
    NSString *_addBankCardMasterBankName ;
    
}
@synthesize tableViewManagement = _tableViewManagement;
@synthesize footerView = _footerView ;
@synthesize addButton = _addButton ;
@synthesize bankPickerSelectView = _bankPickerSelectView ;

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的银行卡";
    [self setupInfo];
    self.needObserverTapGesture = YES ;
    [self setNeedUpdateView] ;
}

- (void)setupInfo {
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
}

-(void)updateView
{
    if (MineSettingInfo==nil){
        _bankCardStatus = BankCardStatus_Init ;
        [self.tableViewManagement reloadDataWithPlistName:@"BankCardInit"] ;
        [self loadingIndicateViewDidTap:nil] ;
        return ;
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
        
        if (MineSettingInfo.mBankCard)
        {
            _bankCardStatus = BankCardStatus_Exist ;
            [self.tableViewManagement reloadDataWithPlistName:@"BankCardExist"] ;
            return ;
        }else{
            self.contentTableView.tableFooterView = self.footerView ;
            _bankCardStatus = BankCardStatus_None ;
            [self.tableViewManagement reloadDataWithPlistName:@"BankCardNone"] ;
            return ;
        }
    }
}

#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.realNameCell.isEditing || self.bankCardNumCell.isEditing || self.bankLocationCell.isEditing ||[_bankPickerSelectView superview] ;
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.realNameCell endEditing:YES] ;
    [self.bankCardNumCell endEditing:YES] ;
    [self.bankLocationCell endEditing:YES] ;
    
    if (_bankPickerSelectView.superview){
        [self hideBankPickerSelectView] ;
    }
}

#pragma mark -
-(RH_BankPickerSelectView *)bankPickerSelectView
{
    if (!_bankPickerSelectView){
        _bankPickerSelectView = [RH_BankPickerSelectView createInstance] ;
        _bankPickerSelectView.delegate = self ;
    }
    
    return _bankPickerSelectView ;
}

-(void)showBankPickerSelectView
{
    if (self.bankPickerSelectView.superview){
        [self.bankPickerSelectView removeFromSuperview] ;
    }
    
    self.bankPickerSelectView.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
    [self.view addSubview:self.bankPickerSelectView] ;
    [UIView animateWithDuration:0.5f animations:^{
        self.bankPickerSelectView.frame = CGRectMake(0, MainScreenH - BankPickerSelectViewHeight , MainScreenW, BankPickerSelectViewHeight) ;
    } completion:^(BOOL finished) {
    }] ;
}

-(void)hideBankPickerSelectView
{
    if (self.bankPickerSelectView.superview){
        [self.view addSubview:self.bankPickerSelectView] ;
        [UIView animateWithDuration:0.5f animations:^{
            self.bankPickerSelectView.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
        } completion:^(BOOL finished) {
            [self.bankPickerSelectView removeFromSuperview] ;
        }] ;
    }
}

-(void)bankPickerSelectViewDidTouchConfirmButton:(RH_BankPickerSelectView*)bankPickerSelectView WithSelectedBank:(id)bankModel
{
    
}

-(void)bankPickerSelectViewDidTouchCancelButton:(RH_BankPickerSelectView*)bankPickerSelectView
{
    
}

#pragma mark -
-(RH_ModifyPasswordCell *)realNameCell
{
    return _bankCardStatus==BankCardStatus_None?ConvertToClassPointer(RH_ModifyPasswordCell, [self.tableViewManagement cellContext:[NSIndexPath indexPathForItem:0 inSection:0]]):nil ;
}

-(RH_BankCardCell *)bankSelectedCell
{
    return _bankCardStatus==BankCardStatus_None?ConvertToClassPointer(RH_BankCardCell, [self.tableViewManagement cellContext:[NSIndexPath indexPathForItem:1 inSection:0]]):nil ;
}

-(RH_ModifyPasswordCell *)bankCardNumCell
{
    return _bankCardStatus==BankCardStatus_None?ConvertToClassPointer(RH_ModifyPasswordCell, [self.tableViewManagement cellContext:[NSIndexPath indexPathForItem:2 inSection:0]]):nil ;
}

-(RH_ModifyPasswordCell *)bankLocationCell
{
    return _bankCardStatus==BankCardStatus_None?ConvertToClassPointer(RH_ModifyPasswordCell, [self.tableViewManagement cellContext:[NSIndexPath indexPathForItem:3 inSection:0]]):nil ;
}

#pragma mark - footerView
-(UIView *)footerView
{
    if (!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 80)] ;
        [_footerView addSubview:self.addButton];
        self.addButton.whc_LeftSpace(20).whc_CenterY(0).whc_RightSpace(20).whc_Height(44);
    }
    
    return _footerView ;
}

-(UIButton *)addButton
{
    if (!_addButton){
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _addButton.backgroundColor = colorWithRGB(27, 117, 217);
        _addButton.layer.cornerRadius = 5;
        _addButton.clipsToBounds = YES;
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonHandle) forControlEvents:UIControlEventTouchUpInside] ;
    }
    
    return _addButton ;
}

- (void)addButtonHandle
{
//    if (_modifySafetyStatus == ModifySafetyStatus_SetRealName){
//        NSString *realName = [self.userNameCell.textField.text copy] ;
//        if (realName.length<1){
//            showMessage(self.view, nil, @"请输入真实姓名");
//            [self.userNameCell.textField becomeFirstResponder] ;
//        }
//
//        [self showProgressIndicatorViewWithAnimated:YES title:@"正在设置..."] ;
//        [self.serviceRequest startV3SetRealName:realName];
//
//        return ;
//    }else if (_modifySafetyStatus == ModifySafetyStatus_SetPermissionPassword){
//        NSString *realName = [self.userNameCell.textField.text copy] ;
//        NSString *newPassword = [self.userPermissionCell.textField.text copy] ;
//        NSString *confirmPassword = [self.userNewPermissionCell.textField.text copy] ;
//        if (realName.length<1){
//            showMessage(self.view, nil, @"请输入真实姓名");
//            [self.userNameCell.textField becomeFirstResponder] ;
//        }
//
//        if (newPassword.length<1){
//            showMessage(self.view, nil, @"请输入新密码");
//            [self.userPermissionCell.textField becomeFirstResponder] ;
//        }
//
//        if (confirmPassword.length<1){
//            showMessage(self.view, nil, @"请重新输入新密码");
//            [self.userNewPermissionCell.textField becomeFirstResponder] ;
//        }
//
//        if (![newPassword isEqualToString:confirmPassword]) {
//            showMessage(self.view, nil, @"两次输入密码不一样！");
//            [self.userPermissionCell.textField becomeFirstResponder] ;
//            return;
//        }
//
//        if (self.userPasswordCodeCell){
//            if (self.userPasswordCodeCell.passwordCode.length<1){
//                showMessage(self.view, nil, @"请输入验证码");
//                [self.userPasswordCodeCell becomeFirstResponder] ;
//                return;
//            }
//        }
//
//        [self showProgressIndicatorViewWithAnimated:YES title:@"正在设置..."] ;
//        [self.serviceRequest startV3ModifySafePasswordWithRealName:realName
//                                                    originPassword:nil
//                                                       newPassword:newPassword
//                                                   confirmPassword:confirmPassword
//                                                        verifyCode:self.userPasswordCodeCell.passwordCode] ;
//
//        return ;
//    }else{
//        NSString *realName = [self.userNameCell.textField.text copy] ;
//        NSString *oldPassword = [self.userPermissionCell.textField.text copy] ;
//        NSString *newPassword = [self.userNewPermissionCell.textField.text copy] ;
//        NSString *confirmPassword = [self.userConfirmPermissionCell.textField.text copy] ;
//        if (realName.length<1){
//            showMessage(self.view, nil, @"请输入真实姓名");
//            [self.userNameCell.textField becomeFirstResponder] ;
//        }
//
//        if (oldPassword.length<1){
//            showMessage(self.view, nil, @"请输入旧密码");
//            [self.userPermissionCell.textField becomeFirstResponder] ;
//        }
//
//        if (newPassword.length<1){
//            showMessage(self.view, nil, @"请输入新密码");
//            [self.userNewPermissionCell.textField becomeFirstResponder] ;
//        }
//
//        if (confirmPassword.length<1){
//            showMessage(self.view, nil, @"请重新输入新密码");
//            [self.userConfirmPermissionCell.textField becomeFirstResponder] ;
//        }
//
//        if (![newPassword isEqualToString:confirmPassword]) {
//            showMessage(self.view, nil, @"两次输入密码不一样！");
//            [self.userNewPermissionCell.textField becomeFirstResponder] ;
//            return;
//        }
//
//        [self showProgressIndicatorViewWithAnimated:YES title:@"正在设置..."] ;
//        [self.serviceRequest startV3ModifySafePasswordWithRealName:realName
//                                                    originPassword:oldPassword
//                                                       newPassword:newPassword
//                                                   confirmPassword:confirmPassword
//                                                        verifyCode:nil] ;
//
//        return ;
//    }
    
}


#pragma mark-
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"初始化银行卡信息" detailText:@"请稍等"] ;
    [self.serviceRequest startV3UserInfo] ;
}

#pragma mark - service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UserInfo){
        [self setNeedUpdateView] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3UserInfo){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}

#pragma mark-
- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"BankCardInit" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (id)tableViewManagement:(CLTableViewManagement *)tableViewManagement cellContextAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bankCardStatus == BankCardStatus_Exist){
        if (indexPath.item == 0){ //真实姓名
            return MineSettingInfo.mRealName ;
        }else if (indexPath.item == 1){ //银行
            return MineSettingInfo.mBankCard.mBankName ;
        }else if (indexPath.item == 2){ //卡号
            return MineSettingInfo.mBankCard.mBankCardNumber ;
        }else if (indexPath.item == 3){ //开户行
            return MineSettingInfo.mBankCard.mBankCardMasterName ;
        }
    }else if (_bankCardStatus == BankCardStatus_None){
        if (indexPath.item == 0){ //真实姓名
            return _addBankCardRealName?:@"" ;
        }else if (indexPath.item == 1){ //选择银行
            return _addBankCardBankName?:@"请选择银行" ;
        }else if (indexPath.item == 2){ //卡号
            return _addBankCardBankCardNumber?:@"" ;
        }else if (indexPath.item == 3){ //开户行
            return _addBankCardMasterBankName?:@"" ;
        }
    }
    
    return nil ;
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bankCardStatus == BankCardStatus_None){
       if (indexPath.item == 1){ //选择银行
           [self showBankPickerSelectView] ;
        }
    }
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
