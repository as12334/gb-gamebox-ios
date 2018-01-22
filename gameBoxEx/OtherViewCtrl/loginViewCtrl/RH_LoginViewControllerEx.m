//
//  RH_LoginViewControllerEx.m
//  gameBoxEx
//
//  Created by luis on 2017/12/5.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LoginViewControllerEx.h"
#import "RH_LoginViewCell.h"
#import "RH_APPDelegate.h"
#import "RH_CustomViewController.h"
#import "RH_API.h"
#import "RH_ForgetPasswordController.h"
@interface RH_LoginViewControllerEx ()<LoginViewCellDelegate>
@property (nonatomic,strong,readonly) RH_LoginViewCell *loginViewCell ;
@property (nonatomic,assign) BOOL isNeedVerCode ;
@property (nonatomic,assign)CGRect frame;
@end

@implementation RH_LoginViewControllerEx

@synthesize loginViewCell = _loginViewCell ;

+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            navigationBar.barTintColor = RH_NavigationBar_BackgroundColor;
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.backButtonItem ;
    self.title = @"登录" ;
    self.needObserverTapGesture = YES ;
    self.needObserverKeyboard = YES ;
    [self setupUI] ;
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

-(void)loginViewCellTouchLoginButton:(RH_LoginViewCell*)loginViewCell
{
    [self showProgressIndicatorViewWithAnimated:YES title:@"正在登入..."];
    [self.serviceRequest startLoginWithUserName:self.loginViewCell.userName
                                  Password:self.loginViewCell.userPassword
                                VerifyCode:self.loginViewCell.verifyCode] ;
    
}

-(void)loginViewCellTouchCreateButton:(RH_LoginViewCell*)loginViewCell
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    appDelegate.customUrl = RH_API_PAGE_SIGNUP ;

    [self showViewController:[RH_CustomViewController viewControllerWithContext:self] sender:self] ;
}
-(void)loginViewCellTouchForgetPasswordButton:(RH_LoginViewCell *)loginViewCell
{
    RH_ForgetPasswordController *passwordVC = [[RH_ForgetPasswordController alloc]init];
    [self.navigationController pushViewController:passwordVC animated:YES];
//    [self showViewController:[RH_ForgetPasswordController viewControllerWithContext:self] sender:self];
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
    return [RH_LoginViewCell heightForCellWithInfo:nil tableView:tableView context:@(self.isNeedVerCode)] ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.loginViewCell updateCellWithInfo:nil context:@(self.isNeedVerCode)] ;
    return self.loginViewCell ;
}

#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    if (type == ServiceRequestTypeUserLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            NSDictionary *result = ConvertToClassPointer(NSDictionary, data) ;
            if ([result boolValueForKey:@"success"]){
                showMessage(self.view, @"登入成功", nil);

                //登入成功后，记录用户名，密码，以便自动登入
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.loginViewCell.userName forKey:@"account"];
                [defaults setObject:self.loginViewCell.userPassword forKey:@"password"];
                [defaults synchronize];
                [appDelegate updateLoginStatus:YES] ;

                ifRespondsSelector(self.delegate, @selector(loginViewViewControllerExLoginSuccessful:)){
                    [self.delegate loginViewViewControllerExLoginSuccessful:self];
                }
            }else{
                self.isNeedVerCode = [result boolValueForKey:@"isOpenCaptcha"] ;
                showMessage(self.view, @"登入失败", nil);
                [appDelegate updateLoginStatus:NO] ;
                [self.contentTableView reloadData] ;
            }
        }] ;
    }
}

- (void)     serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeUserLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            self.isNeedVerCode = true ;
            showErrorMessage(self.view, error, nil) ;
            [self.contentTableView reloadData] ;
        }] ;
    }
}

#pragma mark-
-(void)backBarButtonItemHandle
{
    [self.loginViewCell endEditing:YES] ;

    ifRespondsSelector(self.delegate, @selector(loginViewViewControllerExTouchBack:)){
        [self.delegate loginViewViewControllerExTouchBack:self];
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
@end
