//
//  RH_LoginViewControllerEx.m
//  gameBoxEx
//
//  Created by luis on 2017/12/5.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_RegistrationViewController.h"
#import "RH_LoginViewControllerEx.h"
#import "RH_LoginViewCell.h"
#import "RH_APPDelegate.h"
#import "RH_CustomViewController.h"
#import "RH_API.h"
#import "RH_ForgetPasswordController.h"
#import "RH_UserInfoManager.h"
#import "RH_OldUserVerifyView.h"//老用户验证

@interface RH_LoginViewControllerEx ()<LoginViewCellDelegate,RH_OldUserVerifyViewDelegate>
@property (nonatomic,strong,readonly) RH_LoginViewCell *loginViewCell ;
@property (nonatomic,assign) BOOL isInitOk ;
@property (nonatomic,assign) BOOL isNeedVerCode ;
@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic,assign)CGRect frame;
@property(nonatomic,strong)RH_OldUserVerifyView *oldUserVerifyView;
@property(nonatomic,strong)UIView *OldUserVerifyViewBgView;
@property(nonatomic,strong)NSString *token ;
@end

@implementation RH_LoginViewControllerEx
{
    BOOL _backToFirstPage ;
}
@synthesize loginViewCell = _loginViewCell ;

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
                navigationBar.barTintColor = ColorWithNumberRGB(0x1766bb) ;
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
                backgroundView.backgroundColor = ColorWithNumberRGB(0x1766bb) ;
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

- (BOOL)isSubViewController {
    return  YES;
}

-(void)setupViewContext:(id)context
{
    _backToFirstPage = [context boolValue] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.backButtonItem ;
    self.title = @"登录" ;
    self.isLogin = NO;
    self.needObserverTapGesture = YES ;
    self.needObserverKeyboard = YES ;
    [self setupUI] ;
//    _isInitOk = YES ;
    [self setNeedUpdateView] ;
   //关闭键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView registerCellWithClass:[RH_LoginViewCell class]] ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
}

-(RH_LoginViewCell*)loginViewCell
{
    if (!_loginViewCell){
        _loginViewCell = [RH_LoginViewCell createInstance] ;
        _loginViewCell.delegate = self ;
    }
    return _loginViewCell ;
}

#pragma mark-
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"初始化登录信息" detailText:@"请稍等"] ;
//    [self.serviceRequest startV3IsOpenCodeVerifty] ;
    [self.serviceRequest  startV3RequsetLoginWithGetLoadSid];
}

-(void)updateView
{
    if (!self.isInitOk){
        [self loadingIndicateViewDidTap:nil] ;
        return ;
    }
    [self.contentTableView reloadData] ;
}


#pragma mark - RH_OldUserVerifyViewDelegate

-(void)showVerifyView
{
    _OldUserVerifyViewBgView = [[UIView alloc] init];
    [self.view addSubview:_OldUserVerifyViewBgView];
    _OldUserVerifyViewBgView.backgroundColor = ColorWithRGBA(1, 1, 1, 0.7);
    _OldUserVerifyViewBgView.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpace(0).whc_BottomSpace(0);
    
    _oldUserVerifyView = [[RH_OldUserVerifyView alloc] init];
    [_OldUserVerifyViewBgView addSubview:_oldUserVerifyView];
    _oldUserVerifyView.delegate  = self ; _oldUserVerifyView.whc_CenterX(0).whc_CenterY(0).whc_Width(screenSize().width*0.8).whc_Height(screenSize().height*0.38) ;
}

-(void)hiddenVerifyView
{
    [_OldUserVerifyViewBgView removeFromSuperview];
    [_oldUserVerifyView removeFromSuperview];
}
//老用户验证 -确定
-(void)oldUserVerifyViewDidTochSureBtn:(RH_OldUserVerifyView *)oldUserVerifyView withRealName:(NSString *)realName
{
    if ([realName isEqualToString:@""]) {
        showMessage(self.view, @"真实姓名不能为空", nil);
        return ;
    }
    [self hiddenVerifyView] ;
    [self showProgressIndicatorViewWithAnimated:YES title:@"正在验证真实姓名..."];
    [self.serviceRequest startV3verifyRealNameForAppWithToken:self.token
                                               resultRealName:realName
                                                 needRealName:YES
                                          resultPlayerAccount:self.loginViewCell.userName searchPlayerAccount:self.loginViewCell.userName tempPass:self.loginViewCell.userPassword newPassword:self.loginViewCell.userPassword
                                                    passLevel:20];
}
#pragma mark - 老用户登录验证框 点击取消按钮
-(void)oldUserVerifyViewDidTochCancleBtn:(RH_OldUserVerifyView *)oldUserVerifyView
{
    [self hiddenVerifyView];
}
-(void)loginViewCellTouchLoginButton:(RH_LoginViewCell*)loginViewCell
{
    [self showProgressIndicatorViewWithAnimated:YES title:@"正在登录..."];
    [self.serviceRequest startLoginWithUserName:self.loginViewCell.userName
                                  Password:self.loginViewCell.userPassword
                                VerifyCode:self.loginViewCell.verifyCode] ;
    
}

-(void)loginViewCellTouchCreateButton:(RH_LoginViewCell*)loginViewCell
{

    [self showViewController:[RH_RegistrationViewController viewController] sender:nil];
}
-(void)loginViewCellTouchForgetPasswordButton:(RH_LoginViewCell *)loginViewCell
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.myTabBarController.selectedIndex = 3 ;
}
#pragma mark-
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.loginViewCell.isEditing ;
}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.loginViewCell endEditing:YES] ;
}

#pragma mark-
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isInitOk){
        return [RH_LoginViewCell heightForCellWithInfo:nil tableView:tableView context:@(self.isNeedVerCode)] ;
    }else{
        return MainScreenH - StatusBarHeight - NavigationBarHeight  ;
    }
//     return [RH_LoginViewCell heightForCellWithInfo:nil tableView:tableView context:@(self.isNeedVerCode)] ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isInitOk){
        [self.loginViewCell updateCellWithInfo:nil context:@(self.isNeedVerCode)] ;
        return self.loginViewCell ;
    }else{
        return self.loadingIndicateTableViewCell  ;
    }
//    [self.loginViewCell updateCellWithInfo:nil context:@(self.isNeedVerCode)] ;
//    return self.loginViewCell ;
}

#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    if ( type == ServiceRequestTypeUserLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            NSDictionary *result = ConvertToClassPointer(NSDictionary, data) ;
            if ([result boolValueForKey:@"success"]){
                showMessage(self.view, @"登录成功", nil);
                //登录成功后，记录用户名，密码，以便自动登录
                self.isLogin = YES;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.loginViewCell.userName forKey:@"account"];
                [defaults setObject:self.loginViewCell.userPassword forKey:@"password"];
                [defaults setObject:@(self.loginViewCell.isRemberPassword) forKey:@"loginIsRemberPassword"] ;
                [defaults synchronize];
                [appDelegate updateLoginStatus:YES] ;
                
                [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:self.loginViewCell.userName
                                                                         LoginTime:dateStringWithFormatter([NSDate date], @"yyyy-MM-dd HH:mm:ss")] ;
                ifRespondsSelector(self.delegate, @selector(loginViewViewControllerExLoginSuccessful:)){
                    [self.delegate loginViewViewControllerExLoginSuccessful:self];
                }
            }else{
                self.isNeedVerCode = [result boolValueForKey:@"isOpenCaptcha"] ;
                if (![[result objectForKey:@"message"] isEqual:[NSNull null]]) {
                    if ([[result objectForKey:@"message"] isEqualToString:@"账号被冻结"]) {
                        showMessage(self.view, @"您的账号已被冻结，请联系客服", nil);
                    }else if([[result objectForKey:@"message"] isEqualToString:@"账号被停用"]){
                        showMessage(self.view, @"您账户已被停用,暂不支持登录", nil) ;
                    }else
                    {
                         showMessage(self.view, @"用户名或密码错误", nil);
                    }
                }else if(![[result objectForKey:@"propMessages"] isEqual:[NSNull null]])
                {
                    if ([[result objectForKey:@"propMessages"] objectForKey:@"captcha"]) {
                        showMessage(self.view, [[result objectForKey:@"propMessages"] objectForKey:@"captcha"], nil);
                    }
                }
                [appDelegate updateLoginStatus:NO] ;
                [self.contentTableView reloadData] ;
            }
        }] ;
    }else if (type == ServiceRequestTypeV3VerifyRealNameForApp){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            NSDictionary *result = ConvertToClassPointer(NSDictionary, data) ;
            if ([result boolValueForKey:@"nameSame"]){
                showMessage(self.view, @"登录成功", nil);
                //登录成功后，记录用户名，密码，以便自动登录
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.loginViewCell.userName forKey:@"account"];
                [defaults setObject:self.loginViewCell.userPassword forKey:@"password"];
                [defaults setObject:@(self.loginViewCell.isRemberPassword) forKey:@"loginIsRemberPassword"] ;
                [defaults synchronize];
                [appDelegate updateLoginStatus:YES] ;
                [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:self.loginViewCell.userName
                                                                         LoginTime:dateStringWithFormatter([NSDate date], @"yyyy-MM-dd HH:mm:ss")] ;
                ifRespondsSelector(self.delegate, @selector(loginViewViewControllerExLoginSuccessful:)){
                    [self.delegate loginViewViewControllerExLoginSuccessful:self];
                }
            }else{
                showMessage(self.view, @"姓名验证失败", nil);
                self.isNeedVerCode = true ;
                [self.contentTableView reloadData] ;
            }
        }] ;
    } else if (type == ServiceRequestTypeV3RequetLoginWithGetLoadSid){
        RH_UserInfoManager *manager = [RH_UserInfoManager shareUserManager] ;
        if (manager.sidString.length >0) {
            self.isInitOk = YES;
            [self.contentLoadingIndicateView hiddenView] ;
            [self setNeedUpdateView];
        }
    }
   
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeUserLogin){
        if (error.code == 302) {
            self.token = [[error.userInfo objectForKey:@"propMessages"] objectForKey:@"gb.token"] ;
            [self showVerifyView];
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                [self.contentTableView reloadData] ;
            }] ;
        }else
        {
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                self.isNeedVerCode = true ;
                showErrorMessage(self.view, error, nil) ;
                [self.contentTableView reloadData] ;
            }] ;
        }
    }else if (type == ServiceRequestTypeV3VerifyRealNameForApp){
    
    }
    else if (type == ServiceRequestTypeV3RequetLoginWithGetLoadSid){
//        [self.contentLoadingIndicateView hiddenView] ;
        [self.contentLoadingIndicateView showInfoInInvalidWithTitle:@"提示" detailText:@"初始化登录信息失败"];
         [self setNeedUpdateView];
    }

}

#pragma mark-
-(void)backBarButtonItemHandle
{
    [self.loginViewCell endEditing:YES] ;
    if (self.isLogin) {
        ifRespondsSelector(self.delegate, @selector(loginViewViewControllerExTouchBack:BackToFirstPage:)){
            [self.delegate loginViewViewControllerExTouchBack:self BackToFirstPage:_backToFirstPage];
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.myTabBarController.selectedIndex = 0 ;
    }
    
}

#pragma mark-
- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark 点击textfield的代理
-(void)loginViewCellSelectedEachTextfield:(CGRect)frame
{
    _frame = frame;
    [self keyboardFrameWillChange];
}
#pragma mark 键盘高度
  
-(void)keyboardFrameWillChange
{
    [UIView animateWithDuration:self.keyboardAnimationDuration animations:^{
        if (self.keyboardEndFrame.size.height>0) {
            CGRect originalFrame = self.contentView.frame;
            originalFrame.origin.y =0;
            self.contentView.frame = originalFrame;
            CGRect frame = self.contentView.frame;
            frame.origin.y -=self.frame.origin.y-100;
            self.contentView.frame = frame;
        }
        else if (self.keyboardEndFrame.size.height<=0){
            CGRect frame = self.contentView.frame;
            frame.origin.y =self.view.frameY;
            self.contentView.frame = frame;
        }
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RHNT_SignOKNotification object:nil] ;
}
@end
