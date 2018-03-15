//
//  RH_HasNavCustomViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_HasNavCustomViewController.h"
#import "RH_UserInfoManager.h"

@interface RH_HasNavCustomViewController ()
@property(nonatomic,strong) id context ;
@end

@implementation RH_HasNavCustomViewController
-(void)setupViewContext:(id)context
{
    self.context = context ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.titleView = nil ;
     [self setupURL] ;
    self.title = @"123";
}
-(void)setupURL
{
    if([self.appDelegate.customUrl containsString:@"http"]){
        self.webURL = [NSURL URLWithString:self.appDelegate.customUrl.trim] ;
    }else{
        self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.appDelegate.domain.trim,self.appDelegate.customUrl.trim]] ;
    }
    if ([self.appDelegate.customUrl containsString:@"transfer"]) {
        self.title = @"额度转换112" ;
        self.navigationItem.titleView.backgroundColor = [UIColor redColor] ;
    }
    if (!([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
        [self reloadWebView] ;//预防两次url 一样，不加载情况
    }
}

-(BOOL)tabBarHidden
{
    return YES ;
}

-(BOOL)navigationBarHidden
{
    return NO ;
}

-(BOOL)needLogin
{
    if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
        if ([self.appDelegate.customUrl containsString:@"/transfer/index.html"]) {
            return YES ;
        }
    }
    
    return NO ;
}

#pragma mark -
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView {
    if (self.webURL.absoluteString.length){
        [self reloadWebView];
    }
}

#pragma mark-
-(void)setupJSCallBackOC:(JSContext *)jsContext
{
    [super setupJSCallBackOC:jsContext] ;
    jsContext[@"gotoCustom"] = ^(){
        NSLog(@"JSToOc :%@------ gotoCustom",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        JSValue *customUrl;
        for (JSValue *jsVal in args) {
            customUrl = jsVal;
            NSLog(@"%@", jsVal.toString);
        }
        
        if (args[0] != NULL) {
            self.appDelegate.customUrl = customUrl.toString;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]) &&
                [self.appDelegate.customUrl containsString:@"/login/commonLogin.html"]){
                //跳转原生
                RH_LoginViewControllerEx *loginViewCtrlEx = [RH_LoginViewControllerEx viewController] ;
                loginViewCtrlEx.delegate = self ;
                [self showViewController:loginViewCtrlEx sender:self] ;
            }else
            {
                self.webURL = nil ;
                [self setupURL] ;
            }
        }) ;
    } ;
    
    jsContext[@"loginOut"] = ^(){
        NSLog(@"JSToOc :%@------ loginOut",NSStringFromClass([self class])) ;
        //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.appDelegate updateLoginStatus:false] ;
        
        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
            [self reloadWebView] ;
        }
    };
    
    jsContext[@"loginSucc"] = ^() {
        NSLog(@"JSToOc :%@------ loginSucc",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        
        JSValue *jsAccount = args[0];
        JSValue *jsPassword = args[1];
        JSValue *jsStatus = args[2] ;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:jsAccount.toString forKey:@"account"];
        [defaults setObject:jsPassword.toString forKey:@"password"];
        [defaults synchronize];
        
        [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:jsAccount.toString
                                                                 LoginTime:dateStringWithFormatter([NSDate date], @"yyyy-MM-dd HH:mm:ss")] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.appDelegate updateLoginStatus:jsStatus.toBool] ;
            
            RH_LoginViewControllerEx *loginViewCtrlEx = ConvertToClassPointer(RH_LoginViewControllerEx, self.context) ;
            if (loginViewCtrlEx){
                ifRespondsSelector(loginViewCtrlEx.delegate, @selector(loginViewViewControllerExSignSuccessful:SignFlag:)){
                    [loginViewCtrlEx.delegate loginViewViewControllerExSignSuccessful:loginViewCtrlEx SignFlag:jsStatus.toBool] ;
                }
            }else
            {
                if (jsStatus.toBool==false){
                    if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
                        [self.serviceRequest startAutoLoginWithUserName:jsAccount.toString Password:jsPassword.toString] ;
                    }else{
                        [self.serviceRequest startLoginWithUserName:jsAccount.toString Password:jsPassword.toString VerifyCode:nil] ;
                    }
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES] ;
        }) ;
        
    };
}

#pragma mark- service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        NSDictionary *dict = ConvertToClassPointer(NSDictionary, data) ;
        if ([dict boolValueForKey:@"success" defaultValue:FALSE]){
            [self.appDelegate updateLoginStatus:true] ;
            [self performSelectorOnMainThread:@selector(reloadWebView) withObject:nil waitUntilDone:YES] ;
        }else{
            [self.appDelegate updateLoginStatus:false] ;
        }
    }else if (type==ServiceRequestTypeDemoLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            if ([data boolValue]){
                showSuccessMessage(self.view, @"试玩登录成功", nil) ;
                [self.appDelegate updateLoginStatus:true] ;
                [self backBarButtonItemHandle] ;
            }else{
                showAlertView(@"试玩登录失败", @"提示信息");
                [self.appDelegate updateLoginStatus:false] ;
            }
        }] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest  serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        [self.appDelegate updateLoginStatus:false] ;
    }else if (type==ServiceRequestTypeDemoLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"提示信息");
            [self.appDelegate updateLoginStatus:false] ;
        }] ;
    }else if (type==ServiceRequestTypeV3GameLink ||
              type==ServiceRequestTypeV3GameLinkForCheery){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;
    if (error){
        [self.webView stringByEvaluatingJavaScriptFromString:@"$('.mui-inner-wrap').height();"];//防止白屏
        
        //账号退出
        if([self.appDelegate.customUrl isEqualToString:@"/passport/logout.html"]){
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        NSArray* filterUrls = [[NSArray alloc] initWithObjects:@"/login/commonLogin.",@"/signUp/index.",@"/passport/logout.",@"/help/",@"/promoDetail.",@"/lottery/mainIndex.",@"/lottery/",@"/index.",@"/lotteryResultHistory/",nil];
        //判断是否需要登录判断
        
        if([filterUrls containsObject: self.webURL.absoluteString] == 1){
            [self.webView stringByEvaluatingJavaScriptFromString:@"loginState(isLogin);"];
        }
    }
}

#pragma mark-

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
