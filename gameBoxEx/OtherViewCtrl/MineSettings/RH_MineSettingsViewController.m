//
//  RH_MineSettingsViewController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineSettingsViewController.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"

@interface RH_MineSettingsViewController () <CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong) UIButton *button;

@end

@implementation RH_MineSettingsViewController
@synthesize tableViewManagement = _tableViewManagement;

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setupInfo];
}

- (void)setupInfo {
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    UIView *view_Footer = [[UIView alloc] init];
    view_Footer.frame = CGRectMake(0, 0, screenSize().width, 100);
    self.contentTableView.tableFooterView = view_Footer;
    self.button = [[UIButton alloc] init];
    [view_Footer addSubview:self.button];
    self.button.whc_TopSpace(33).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(45);
    self.button.layer.cornerRadius = 5.0f;
    self.button.clipsToBounds = YES;
    [self.button setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.button setTitleColor:colorWithRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.button addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    if ([THEMEV3 isEqualToString:@"green"]){
         [self.button setBackgroundColor:RH_NavigationBar_BackgroundColor_Green];
    }else if ([THEMEV3 isEqualToString:@"red"]){
         [self.button setBackgroundColor:RH_NavigationBar_BackgroundColor_Red];
    }else if ([THEMEV3 isEqualToString:@"black"]){
         [self.button setBackgroundColor:RH_NavigationBar_BackgroundColor_Black];
    }else{
         [self.button setBackgroundColor:RH_NavigationBar_BackgroundColor];
    }
    [self.tableViewManagement reloadData];
    
}

#pragma mark - 退出登录
-(void)loginOut
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否退出账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showProgressIndicatorViewWithAnimated:YES title:@"退出中..."] ;
        [self.serviceRequest startV3UserLoginOut];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UserLoginOut){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"用户已成功退出",nil) ;
        }] ;
        
        [self backBarButtonItemHandle] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3UserLoginOut){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            if (error.code==RH_API_ERRORCODE_USER_LOGOUT){
                [self.appDelegate updateLoginStatus:NO] ;
                showSuccessMessage(self.view, @"用户已成功退出",nil) ;
                [self backBarButtonItemHandle] ;
            }else{
                showErrorMessage(self.view, error, @"退出失败") ;
            }
        }] ;
    }
}

- (CLTableViewManagement *)tableViewManagement {
    
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_MineSettings" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
}

- (id)tableViewManagement:(CLTableViewManagement *)tableViewManagement cellContextAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.tableViewManagement cellExtraInfo:indexPath] ;
    switch ([dict integerValueForKey:@"id"]) {
        case 0: ////声音
            return @([RH_UserInfoManager shareUserManager].isVoiceSwitch) ;
            break;
            
        case 1: ////锁屏
            return @([RH_UserInfoManager shareUserManager].isScreenLock) ;
            break;
        default:
            break;
    }

    return nil ;
}
@end
