//
//  RH_PromoDetailViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/4/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PromoDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_UserInfoManager.h"


@interface RH_PromoDetailViewController ()
@property(nonatomic,strong) id context ;
@end

@implementation RH_PromoDetailViewController

-(void)setupViewContext:(id)context
{
    self.context = context ;
}

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.navigationItem.titleView = nil ;
    [self setupURL] ;
    
    
}

-(void)setupURL
{
//    if([self.appDelegate.customUrl containsString:@"http"]){
//        self.webURL = [NSURL URLWithString:self.appDelegate.customUrl.trim] ;
//    }else{
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",@"https://",self.appDelegate.headerDomain.trim,@":8989",self.appDelegate.customUrl.trim]] ;
    if (!([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
        [self reloadWebView] ;//预防两次url 一样，不加载情况
    }
}

-(BOOL)tabBarHidden
{
    return YES ;
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
            NSLog(@"jsVal==%@", jsVal.toString);
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
    //优惠详情加入成功之后跳转到申请优惠界面
    jsContext[@"nativeGoToApplyPromoPage"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            //跳转原生申请优惠界面
         
        }) ;
    };
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

// 允许自动旋转
-(BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

//3.返回进入界面默认显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}




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
