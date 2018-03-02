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
#import "RH_MainTabBarController.h"
#import "RH_LockSetPWDController.h"
#import "RH_GesturelLockView.h"
#import "RH_VeriftyCloseViewController.h"

@interface RH_MineSettingsViewController () <CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong) UIButton *button;

@end

@implementation RH_MineSettingsViewController
@synthesize tableViewManagement = _tableViewManagement;

- (BOOL)isSubViewController {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    #define RH_GuseterLock            @"RH_GuseterLock"
    #define RH_updateScreenLockFlag            @"updateScreenLockFlag"
    NSString * currentGuseterLockStr = [SAMKeychain passwordForService:@" "account:RH_GuseterLock];
    //判断手势密码是否存在，更新开关状态
    if (currentGuseterLockStr) {
        [SAMKeychain setPassword: @"1" forService:@" "account:RH_updateScreenLockFlag];
        [[RH_UserInfoManager shareUserManager] updateScreenLockFlag:YES] ;
        
    }else
    {
        [SAMKeychain setPassword: @"0" forService:@" "account:RH_updateScreenLockFlag];
        [[RH_UserInfoManager shareUserManager] updateScreenLockFlag:NO] ;
    }
    [self.tableViewManagement reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setupInfo];
    [self setNeedUpdateView] ;
}

- (void)setupInfo {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"OpenLock_NT" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
       NSArray *tempArr = note.object ;
        NSLog(@"----%@-----",tempArr[0]) ;
        if ([SITE_TYPE isEqualToString:@"integratedv3oc"] && [tempArr[0] boolValue] == YES){

            RH_MainTabBarController *tabBarController =  ConvertToClassPointer(RH_MainTabBarController, [UIApplication sharedApplication].keyWindow.rootViewController) ;
            if (tabBarController){
                [tabBarController.selectedViewController presentViewController:[RH_LockSetPWDController viewController]
                                                                      animated:YES
                                                                    completion:nil] ;
            }
        }else if([SITE_TYPE isEqualToString:@"integratedv3oc"] && [tempArr[0] boolValue] == NO){
            
            RH_MainTabBarController *tabBarController =  ConvertToClassPointer(RH_MainTabBarController, [UIApplication sharedApplication].keyWindow.rootViewController) ;
            if (tabBarController){
                [tabBarController.selectedViewController presentViewController:[RH_VeriftyCloseViewController viewController]
                                                                      animated:YES
                                                                    completion:nil] ;
            }
         

        }
    }];
    
   
    
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
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
            [defaults removeObjectForKey:@"password"];
            [defaults synchronize] ;
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
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
                [defaults removeObjectForKey:@"password"];
                [defaults synchronize] ;
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
            return @([RH_UserInfoManager shareUserManager].isScreenLock);
            break;
        default:
            break;
    }
    return nil ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:@"OpenLock_NT" object:nil] ;
    
}

@end
