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
#import "RH_LimitTransferViewController.h" // 额度转换原生
#import "RH_WebsocketManagar.h"
#import "RH_SiteMsgUnReadCountModel.h"
@interface RH_MePageViewController ()<CLTableViewManagementDelegate,MineAccountCellDelegate,MineRecordTableViewCellProtocol>
@property(nonatomic,strong,readonly)UIBarButtonItem *barButtonCustom ;
@property(nonatomic,strong,readonly)UIBarButtonItem *barButtonSetting;
@property(nonatomic,strong)RH_MinePageBannarCell *bannarCell;
@property(nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement ;
@property(nonatomic,strong)RH_SiteMsgUnReadCountModel *readCountModel;
@end

@implementation RH_MePageViewController
@synthesize barButtonCustom = _barButtonCustom ;
@synthesize barButtonSetting = _barButtonSetting ;
@synthesize tableViewManagement = _tableViewManagement;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    if (self.appDelegate.isLogin) {
        [self.serviceRequest startV3GetUserAssertInfo] ;
        //消息未读条数
        [self.serviceRequest startV3LoadMessageCenterSiteMessageUnReadCount];
    }else
    {
        [self loadDataSuccessWithDatas:@[] totalCount:0] ;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的" ;
    [self setupUI];
    [self setNeedUpdateView] ;
    [self setupPageLoadManager] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:NT_LoginStatusChangedNotification object:nil] ;
    if (self.appDelegate.isLogin) {
        [self.serviceRequest startV3UserSafetyInfo] ;
    }
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
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
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
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
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

-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self setNeedUpdateView] ;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ; 
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

#pragma mark -
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    if (HasLogin) {
        [self.serviceRequest startV3GetUserAssertInfo] ;
    }else
    {
         [self loadDataSuccessWithDatas:@[] totalCount:0] ;
    }
}

-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleServiceWithType:ServiceRequestTypeV3GETUSERASSERT] ;
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
#if 0
        //注释设置按钮  改成退出
//        UIImage *menuImage = ImageWithName(@"mine_page_settings");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, menuImage.size.width, menuImage.size.height);
        button.frame = CGRectMake(0, 0, 50, 30) ;
//        [button setBackgroundImage:menuImage forState:UIControlStateNormal];
        [button setTitle:@"退出" forState:UIControlStateNormal] ;
        button.titleLabel.font = [UIFont systemFontOfSize:15.f] ;
        [button addTarget:self action:@selector(_barButtonSettingHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _barButtonSetting = [[UIBarButtonItem alloc] initWithCustomView:button] ;
#else
        _barButtonSetting = [[UIBarButtonItem alloc] initWithTitle:@"设置"
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
    
    self.navigationBarItem.leftBarButtonItem = self.barButtonCustom;
    if (self.appDelegate.isLogin) {
        self.navigationBarItem.rightBarButtonItem = self.barButtonSetting;
    }
    self.view.backgroundColor = colorWithRGB(242, 242, 242);
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    [self.contentView addSubview:self.contentTableView] ;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
//    [self.contentTableView addGestureRecognizer:tap];
    [self.tableViewManagement reloadData] ;
}
-(void)click
{
    //测试websocket
    [[RH_WebsocketManagar instance] SRWebSocketOpenWithURLString:[NSString stringWithFormat:@"ws://192.168.0.236:8080/ws/websocket"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
}
#pragma mark ==============test webSocket================
- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    NSLog(@"message===%@",message);
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
            if ([self.serviceRequest isRequestingWithType:ServiceRequestTypeV3GETUSERASSERT]==FALSE){
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
        self.tabBarController.selectedIndex = 1  ;
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
//        mineAccountCell updateCellWithInfo:<#(NSDictionary *)#> context:<#(id)#>
    }
    RH_MinePageLoginoutBannarCell *loginoutCell = ConvertToClassPointer(RH_MinePageLoginoutBannarCell, cell);
    __weak RH_MePageViewController *weakSelf = self;
    if (loginoutCell) {
        loginoutCell.block = ^(){
            [weakSelf loginButtonItemHandle] ;
                    };
    }
    
    RH_MineRecordTableViewCell *mineRecordTableCell = ConvertToClassPointer(RH_MineRecordTableViewCell, cell) ;
    mineRecordTableCell.readCountModel = self.readCountModel;
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
                //额度转换
//                self.appDelegate.customUrl = @"/transfer/index.html" ;
//                [self showViewController:[RH_CustomViewController viewController] sender:self] ;
                [self showViewController:[RH_LimitTransferViewController viewController] sender:self] ;
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
    }else if (type == ServiceRequestTypeV3GETUSERASSERT)
    {
        [self loadDataSuccessWithDatas:@[] totalCount:0] ;
    }else if (type == ServiceRequestTypeV3UserSafeInfo)
    {
        RH_UserInfoManager *manager = [RH_UserInfoManager shareUserManager] ;
        RH_UserSafetyCodeModel *codeModel = ConvertToClassPointer(RH_UserSafetyCodeModel, data) ;
        manager.isSetSafetySecertPwd = codeModel.mHasPersimmionPwd ;
        
    }
    else if (type==ServiceRequestTypeSiteMessageUnReadCount){
        RH_SiteMsgUnReadCountModel *readCountModel = ConvertToClassPointer(RH_SiteMsgUnReadCountModel, data);
        self.readCountModel = readCountModel;
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
            if (error.code==RH_API_ERRORCODE_USER_LOGOUT || error.code == RH_API_ERRORCODE_SESSION_TAKEOUT || error.code == RH_API_ERRORCODE_SESSION_EXPIRED){
                [self.appDelegate updateLoginStatus:NO] ;
                showSuccessMessage(self.view, @"用户已成功退出",nil) ;
            }else{
                showErrorMessage(self.view, error, @"退出失败") ;
            }
        }] ;
    }else if (type == ServiceRequestTypeV3GETUSERASSERT)
    {
        
        [self loadDataSuccessWithDatas:@[] totalCount:0] ;
        showErrorMessage(self.view, error, @"");
        if (error.code == RH_API_ERRORCODE_SESSION_TAKEOUT) {
             [self.appDelegate updateLoginStatus:NO] ;
        }
    }
}


@end
