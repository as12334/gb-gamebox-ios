//
//  RH_MePageViewController.m
//  lotteryBox
//
//  Created by luis on 2017/12/8.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MePageViewController.h"
#import "RH_MinePageBannarCell.h"
#import "RH_UserInfoManager.h"
#import "RH_MineSettingsViewController.h"
#import "RH_UserInfoManager.h"
#import "RH_MineAccountCell.h"
#import "RH_CustomViewController.h"
#import "RH_WithdrawCashController.h"
#import "RH_MinePageLoginoutBannarCell.h"
#import "RH_LoginViewControllerEx.h"
#import "RH_ApplyDiscountViewController.h"
#import "RH_MineRecordTableViewCell.h"

@interface RH_MePageViewController ()<CLTableViewManagementDelegate,MineAccountCellDelegate,MineRecordTableViewCellProtocol>
@property(nonatomic,strong,readonly)UIBarButtonItem *barButtonCustom ;
@property(nonatomic,strong,readonly)UIBarButtonItem *barButtonSetting;
@property(nonatomic,strong)RH_MinePageBannarCell *bannarCell;
@property(nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement ;
@end

@implementation RH_MePageViewController
@synthesize barButtonCustom = _barButtonCustom ;
@synthesize barButtonSetting = _barButtonSetting ;
@synthesize tableViewManagement = _tableViewManagement;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的" ;
    [self setupUI];
    [self setNeedUpdateView] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:NT_LoginStatusChangedNotification object:nil] ;
}

-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self setNeedUpdateView] ;
    }
}
#pragma mark-

-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self loginButtonItemHandle] ;
}

#pragma mark-
-(UIBarButtonItem *)barButtonCustom
{
    if (!_barButtonCustom){
        UIImage *menuImage = ImageWithName(@"mine_page_customer");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, menuImage.size.width, menuImage.size.height);
        [button setBackgroundImage:menuImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_barButtonCustomHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _barButtonCustom = [[UIBarButtonItem alloc] initWithCustomView:button] ;
    }
    
    return _barButtonCustom ;
}

-(void)_barButtonCustomHandle
{
     [self.tabBarController setSelectedIndex:3];
}

#pragma mark-
-(UIBarButtonItem *)barButtonSetting
{
    if (!_barButtonSetting){
#if 1
        UIImage *menuImage = ImageWithName(@"mine_page_settings");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, menuImage.size.width, menuImage.size.height);
        [button setBackgroundImage:menuImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_barButtonSettingHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _barButtonSetting = [[UIBarButtonItem alloc] initWithCustomView:button] ;
#else
        _barButtonSetting = [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(_barButtonSettingHandle)] ;
#endif
    }
    
    return _barButtonSetting ;
}

-(void)_barButtonSettingHandle
{
#if 1
    [self showViewController:[RH_MineSettingsViewController viewController] sender:self] ;
#else
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否退出账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showProgressIndicatorViewWithAnimated:YES title:@"退出中..."] ;
        [self.serviceRequest startV3UserLoginOut];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
#endif
}


#pragma mark-
-(void)setupUI
{
    if ([THEMEV3 isEqualToString:@"green"]){
        [self.navigationBar setBarTintColor:RH_NavigationBar_BackgroundColor_Green];
    }else if ([THEMEV3 isEqualToString:@"red"]){
        [self.navigationBar setBarTintColor:RH_NavigationBar_BackgroundColor_Red];
        
    }else if ([THEMEV3 isEqualToString:@"black"]){
        [self.navigationBar setBarTintColor:RH_NavigationBar_BackgroundColor];
    }else{
        [self.navigationBar setBarTintColor:RH_NavigationBar_BackgroundColor];
    }
    self.navigationBarItem.leftBarButtonItem = self.barButtonCustom;
    if (self.appDelegate.isLogin) {
        
        self.navigationBarItem.rightBarButtonItem = self.barButtonSetting;
    }
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.tableViewManagement reloadData] ;
}

#pragma mark-
-(void)updateView
{
    if (!self.appDelegate.isLogin){//未login
        [self.tableViewManagement reloadDataWithPlistName:@"RH_UserCenterlogout"] ;
//        [self.contentLoadingIndicateView showDefaultNeedLoginStatus] ;
        self.navigationBarItem.rightBarButtonItem = nil ;
    }else{
        if (MineSettingInfo==nil){
            if ([self.serviceRequest isRequestingWithType:ServiceRequestTypeV3UserInfo]==FALSE){
                [self.serviceRequest startV3UserInfo] ;
            }
        }
        
        [self.contentLoadingIndicateView hiddenView] ;
        [self.tableViewManagement reloadDataWithPlistName:@"RH_UserCenterlogin"] ;
        self.navigationBarItem.rightBarButtonItem = self.barButtonSetting  ;
    }
}

#pragma mark -mineAcceount delegate
-(void)mineAccountCellTouchRchargeButton:(RH_MineAccountCell*)mineAccountCell
{
    if (HasLogin)
    {
        self.tabBarController.selectedIndex = 0  ;
    }else{
        [self loginButtonItemHandle] ;
    }
    
}

-(void)mineAccountCellTouchWithDrawButton:(RH_MineAccountCell*)mineAccountCell
{
    if (HasLogin)
    {
        [self showViewController:[RH_WithdrawCashController viewController] sender:self] ;
    }else{
        [self loginButtonItemHandle] ;
    }

//    self.appDelegate.customUrl = @"/wallet/withdraw/index.html" ;
//    [self showViewController:[RH_CustomViewController viewController] sender:self] ;
}

#pragma mark-
-(CLTableViewManagement*)tableViewManagement
{
    if (!_tableViewManagement){
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView
                                                              configureFileName:@"RH_UserCenterCells"
                                                                         bundle:nil] ;
        
        _tableViewManagement.delegate = self ;
    }
    return _tableViewManagement ;
}

-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement IndexPath:(NSIndexPath *)indexPath Cell:(UITableViewCell*)cell
{
    RH_MineAccountCell *mineAccountCell = ConvertToClassPointer(RH_MineAccountCell, cell) ;
    if (mineAccountCell){
        mineAccountCell.delegate = self ;
    }
    RH_MinePageLoginoutBannarCell *loginoutCell = ConvertToClassPointer(RH_MinePageLoginoutBannarCell, cell);
    __weak RH_MePageViewController *weakSelf = self;
    if (loginoutCell) {
        loginoutCell.block = ^(){
            [weakSelf loginButtonItemHandle] ;
                    };
    }
    
    RH_MineRecordTableViewCell *mineRecordTableCell = ConvertToClassPointer(RH_MineRecordTableViewCell, cell) ;
    if (mineRecordTableCell){
        mineRecordTableCell.delegate = self ;
    }
}

-(CGFloat)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return MainScreenH - StatusBarHeight - NavigationBarHeight - TabBarHeight ;
}

-(UITableViewCell*)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellAtIndexPath:(NSIndexPath *)indexPath
{
    return self.loadingIndicateTableViewCell ;
}

#pragma mark - RH_MineRecordTableViewCell delegate
-(void)mineRecordTableViewCellDidTouchCell:(RH_MineRecordTableViewCell*)mineRecordTableCell CellInfo:(NSDictionary*)dictInfo
{
    if (self.appDelegate.isLogin){
        UIViewController *viewCtrl = [dictInfo targetViewControllerWithContext:[dictInfo targetContext]] ;
        if ([dictInfo[@"title"] isEqualToString:@"消息中心"]) {
            RH_ApplyDiscountViewController *discountVC = ConvertToClassPointer(RH_ApplyDiscountViewController, viewCtrl);
            [discountVC setTitle:@"消息中心"];
        }else if ([dictInfo[@"title"] isEqualToString:@"申请优惠"]){
            RH_ApplyDiscountViewController *discountVC = ConvertToClassPointer(RH_ApplyDiscountViewController, viewCtrl);
            [discountVC setTitle:@"申请优惠"];
            discountVC.selectedIndex = 2;
        }
        
        if (viewCtrl){
            [self showViewController:viewCtrl sender:self] ;
            return ;
        }else{
            NSString *code = [dictInfo stringValueForKey:@"code"] ;
            if ([code isEqualToString:@"transfer"]){
                self.appDelegate.customUrl = @"/transfer/index.html" ;
                [self showViewController:[RH_CustomViewController viewController] sender:self] ;
                return ;
            }else if ([code isEqualToString:@"gameNotice"]){
                self.appDelegate.customUrl = @"/message/gameNotice.html?isSendMessage=true" ;
                [self showViewController:[RH_CustomViewController viewController] sender:self] ;
                return ;
            }else if ([code isEqualToString:@"bankCard"]){
                self.appDelegate.customUrl = @"/bankCard/page/addCard.html" ;
                [self showViewController:[RH_CustomViewController viewController] sender:self] ;
                return ;
            }else if ([code isEqualToString:@"btc"]){
                self.appDelegate.customUrl = @"/bankCard/page/addBtc.html" ;
                [self showViewController:[RH_CustomViewController viewController] sender:self] ;
                return ;
            }else if ([code isEqualToString:@"withdraw"]){
                self.appDelegate.customUrl = @"/wallet/withdraw/index.html" ;
                [self showViewController:[RH_CustomViewController viewController] sender:self] ;
                return ;
            }
        }
    }else{
        if ([dictInfo boolValueForKey:@"freeLogin"]){
            UIViewController *viewCtrl = [dictInfo targetViewControllerWithContext:[dictInfo targetContext]] ;
            if (viewCtrl){
                [self showViewController:viewCtrl sender:self] ;
                return ;
            }
        }
        
        [self loginButtonItemHandle] ;
        
    }
}

#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            NSDictionary *dict = ConvertToClassPointer(NSDictionary, data) ;
            if ([dict boolValueForKey:@"success" defaultValue:FALSE]){
                [self.appDelegate updateLoginStatus:true] ;
            }else{
                [self.appDelegate updateLoginStatus:false] ;
            }
        }] ;
    }else if (type == ServiceRequestTypeV3UserLoginOut){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"用户已成功退出",nil) ;
        }] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showAlertView(@"自动登录失败", @"提示信息");
        }] ;
    }else if (type == ServiceRequestTypeV3UserLoginOut){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            if (error.code==RH_API_ERRORCODE_USER_LOGOUT){
                [self.appDelegate updateLoginStatus:NO] ;
                showSuccessMessage(self.view, @"用户已成功退出",nil) ;
            }else{
                showErrorMessage(self.view, error, @"退出失败") ;
            }
        }] ;
    }
}


@end
