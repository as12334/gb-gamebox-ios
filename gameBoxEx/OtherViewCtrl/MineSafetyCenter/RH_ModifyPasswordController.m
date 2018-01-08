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
@interface RH_ModifyPasswordController () <CLTableViewManagementDelegate, RH_ServiceRequestDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong) UIButton *button;
@end

@implementation RH_ModifyPasswordController
@synthesize tableViewManagement = _tableViewManagement;
- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改登录密码";
    self.needObserverTapGesture = YES ;
    self.needObserverKeyboard = YES ;
    [self setupInfo];
}

#pragma mark - keyboard
- (void)keyboardFrameWillChange
{
    
}

- (void)keyboardFrameDidChange
{
    
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
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view_Footer addSubview:self.button];
    self.button.whc_Center(0, 0).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(44);
    self.button.backgroundColor = colorWithRGB(27, 117, 217);
    self.button.layer.cornerRadius = 5;
    self.button.clipsToBounds = YES;
    [self.button setTitle:@"修改" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(modifyPassword) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)modifyPassword {
    
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
    [self.serviceRequest startV3ChangePasswordWith:currentPwd and:newPwd];
    self.serviceRequest.delegate = self;
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    NSLog(@"%s", __func__);
    NSLog(@"%@", error);
}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    NSLog(@"%s", __func__);
}

@end
