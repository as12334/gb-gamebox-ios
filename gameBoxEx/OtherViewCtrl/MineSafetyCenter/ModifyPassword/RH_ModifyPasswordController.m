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
#import "RH_StaticAlertView.h"
#import "RH_UserInfoManager.h"

@interface RH_ModifyPasswordController () <CLTableViewManagementDelegate, RH_ServiceRequestDelegate, RH_StaticAlertViewDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong,readonly) UIButton *modifyButton;
@property (nonatomic, strong) RH_StaticAlertView *rhAlertView;
//--
@property (nonatomic,strong,readonly) RH_ModifyPasswordCell *currentPasswordCell ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordSpecialCell *newSettingPasswordCell    ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordCell *confirmSettingPasswordCell ;
@property (nonatomic,strong,readonly) RH_ModifyPasswordCodeCell *passwordCodeCell ;
@property(nonatomic,strong,readonly)RH_UserInfoManager *infoManager ;

@property (nonatomic, strong,readonly) UILabel *label_Notice;
@end

@implementation RH_ModifyPasswordController
@synthesize tableViewManagement = _tableViewManagement;
@synthesize modifyButton = _modifyButton  ;
@synthesize label_Notice = _label_Notice  ;
@synthesize infoManager = _infoManager;

- (BOOL)isSubViewController {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    if (_infoManager.updateUserVeifyCode) {
          [self.tableViewManagement reloadDataWithPlistName:@"RH_ModifyPasswordUsercode"] ;
          self.tableViewManagement.delegate = self;
    }else
    {
          [self.tableViewManagement reloadDataWithPlistName:@"RH_ModifyPassword"] ;
          self.tableViewManagement.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改登录密码";
    self.needObserverTapGesture = YES ;
    [self setupInfo];
    _infoManager = [RH_UserInfoManager shareUserManager] ;
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
- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        if (_infoManager.updateUserVeifyCode) {
            _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_ModifyPasswordUsercode" bundle:nil];
            _tableViewManagement.delegate = self;
        }else
        {
            _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_ModifyPassword" bundle:nil];
            _tableViewManagement.delegate = self;
        }
       
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
        _modifyButton.clipsToBounds = YES ;
        [_modifyButton setTitle:@"确定" forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(modifyButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _modifyButton ;
}

- (void)modifyButtonHandle
{
    
    [self.view endEditing:YES];
    NSString *currentPwd = self.currentPasswordCell.textField.text;
    NSString *newPwd = self.newSettingPasswordCell.textField.text;
    NSString *newPwd2 = self.confirmSettingPasswordCell.textField.text;
    if (currentPwd.length == 0) {
        showMessage(self.view, nil, @"请输入当前密码");
        return;
    }
    
    if (newPwd.length == 0 ) {
        showMessage(self.view, nil, @"请输入新密码");
        return;
    }
    
    if (newPwd2.length == 0) {
        showMessage(self.view, nil, @"请再次输入密码");
        return;
    }
    
    
    if (newPwd.length < 6 || newPwd2.length < 6) {
        showMessage(self.view, @"提示", @"密码至少六位");
        return;
    }
    if (newPwd.length>0 && newPwd2.length>0) {
        if (![newPwd isEqualToString:newPwd2]) {
            showMessage(self.view, nil, @"两次输入的密码不一样！");
            return;
        }
    }
    //密码升序或者降序
//    if (isDescendingAndPwdisAscendingPwd(newPwd) &&isDescendingAndPwdisAscendingPwd(newPwd2)) {
//        showMessage(self.view, @"提示", @"新密码过于简单");
//        return;
//    }
    //三位以上的重复数字
//    if (isSameMoreThreePwd(newPwd) &&isSameMoreThreePwd(newPwd2)) {
//        showMessage(self.view, @"提示", @"新密码过于简单");
//        return;
//    }
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

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
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
#pragma mark -StaticAlertViewDelegate
- (void)didStaticAlertViewCancelButtonClicked {
    
    [self backBarButtonItemHandle] ;
}
#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UpdateLoginPassword){
        _infoManager.updateUserVeifyCode = NO ;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
        [defaults setObject:self.confirmSettingPasswordCell.textField.text forKey:@"password"];
        [defaults synchronize];
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            if (self.rhAlertView.superview == nil) {
                self.rhAlertView = [[RH_StaticAlertView alloc] init];
                self.rhAlertView.alpha = 0;
                self.rhAlertView.delegate = self;
                [self.contentView addSubview:self.rhAlertView];
                self.rhAlertView.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
                [UIView animateWithDuration:0.3 animations:^{
                    self.rhAlertView.alpha = 1;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self.rhAlertView showContentView];
                    }
                }];
            }
        }] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3UpdateLoginPassword){
        if(error.code != RH_API_ERRORCODE_SESSION_TAKEOUT){
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                showErrorMessage(self.view, error, @"修改密码失败");
            }] ;
        }
        NSDictionary *userInfo = error.userInfo ;
        if ([userInfo boolValueForKey:RH_GP_MINEMODIFYPASSWORD_ISOPENCAPTCHA]){
            [self.tableViewManagement reloadDataWithPlistName:@"RH_ModifyPasswordUsercode"] ;
            _infoManager.updateUserVeifyCode = YES ;
        }
        if ([userInfo integerValueForKey:RH_GP_MINEMODIFYPASSWORD_REMAINTIMES]) {
            self.label_Notice.text = [NSString stringWithFormat:@"你还有 %ld 次机会",[userInfo integerValueForKey:RH_GP_MINEMODIFYPASSWORD_REMAINTIMES]+1] ;
        }
        if ([userInfo integerValueForKey:RH_GP_MINEMODIFYPASSWORD_REMAINTIMES] == 5) {
            self.label_Notice.text = [NSString stringWithFormat:@"你还有1次机会"] ;
        }else
        {
             self.label_Notice.hidden = NO ;
        }
        //在这里判断状态码， 如果冻结，就直接退出APP
        //TODO
        if (error.code == RH_API_ERRORCODE_SESSION_TAKEOUT) {
            UIAlertView *alert = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.appDelegate updateLoginStatus:false];
            } title:@"您已被强制踢出！"
            message:nil
            cancelButtonName:@"确定"
            otherButtonTitles:nil, nil] ;
            [alert show] ;
        }
        if (error.code == RH_API_ERRORCODE_USER_LOGOUT) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self.appDelegate updateLoginStatus:false];
        }
        if (error.code == RH_API_ERRORCODE_SESSION_EXPIRED) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self.appDelegate updateLoginStatus:false];
        }
    }
}


@end
