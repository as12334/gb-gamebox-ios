//
//  RH_FirstPageViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_FirstPageViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_CustomViewController.h"
#import "RH_API.h"
#import "JPUSHService.h"

@interface RH_FirstPageViewController ()
@end

@implementation RH_FirstPageViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    if (![SITE_TYPE isEqualToString:@"lottery"]){ //非彩票 站
        self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.domain]] ;
    }else{
        self.webURL = [NSURL URLWithString:self.domain] ;
    }
    self.navigationItem.titleView = nil ;
    [self autoLogin] ;
   
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    
}

-(BOOL)tabBarHidden
{
    return NO ;
}

-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        NSLog(@"received loginstatus changed:%d",self.appDelegate.isLogin) ;
        [self setNeedUpdateView] ;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(void)updateView
{
    if (self.appDelegate.logoutUrl){
        if([self.appDelegate.logoutUrl containsString:@"http"]){
            self.webURL = [NSURL URLWithString:self.appDelegate.logoutUrl.trim] ;
        }else{
            self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.appDelegate.domain.trim,self.appDelegate.logoutUrl.trim]] ;
        }
        
        self.appDelegate.logoutUrl = nil ;
    }else{
        if (![SITE_TYPE isEqualToString:@"lottery"]){ //非彩票 站
            self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mainIndex.html",self.domain]] ;
        }else{
            self.webURL = [NSURL URLWithString:self.domain] ;
        }
        
        [self reloadWebView] ;
    }
}

#pragma mark-
- (void) autoLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [defaults objectForKey:@"account"];
    NSString *password = [defaults objectForKey:@"password"];

    if(account.length==0 || password.length ==0){
        return;
    }
   
    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
        [self.serviceRequest startAutoLoginWithUserName:account Password:password] ;
    }else{
        [self.serviceRequest startLoginWithUserName:account Password:password VerifyCode:nil] ;
    }

    return ;
};


- (void)demoEnter{
    [self showProgressIndicatorViewWithAnimated:YES title:@"试玩登录中"];
    [self.serviceRequest startDemoLogin] ;
    return ;
}

#pragma mark-
-(void)setupJSCallBackOC:(JSContext *)jsContext
{
    [super setupJSCallBackOC:jsContext] ;

    jsContext[@"demoEnter"] = ^() {
        [self demoEnter];
    };
}

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;
    if (!error){
        if (self.appDelegate.isLogin)
        {
            [self.webView stringByEvaluatingJavaScriptFromString:@"sessionStorage.is_login=true;"];
            if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                [self.webView stringByEvaluatingJavaScriptFromString:@"headInfo()"] ;
            }else{
                [self.webView stringByEvaluatingJavaScriptFromString:@"window.page.getHeadInfo()"] ;//刷新webview 信息 ;
            }
        }
    }
}
#pragma mark-

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        NSDictionary *dict = ConvertToClassPointer(NSDictionary, data) ;
        if ([dict boolValueForKey:@"success" defaultValue:FALSE]){
            [self.appDelegate updateLoginStatus:true] ;
            [self performSelectorOnMainThread:@selector(reloadWebView) withObject:nil waitUntilDone:YES] ;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *account = [defaults stringForKey:@"account"] ;
            //设置jpush别名
            [JPUSHService setAlias:account completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                if (iResCode == 0) {
                    NSLog(@"别名设置成功");
                }else{
                    NSLog(@"别名设置失败");
                }
            } seq:1];
        }else{
            [self.appDelegate updateLoginStatus:false] ;
        }
    }else if (type == ServiceRequestTypeDemoLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            if ([data boolValue]){
                showSuccessMessage(self.view, @"试玩登录成功", nil) ;
                [self.appDelegate updateLoginStatus:true] ;
                
                if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                    [self.webView stringByEvaluatingJavaScriptFromString:@"headInfo()"] ;
                }else{
                    [self.webView stringByEvaluatingJavaScriptFromString:@"window.page.getHeadInfo()"] ;//刷新webview 信息 ;
                }
            }else{
                showAlertView(@"试玩登录失败", @"提示信息");
                self.appDelegate.customUrl = @"/login/commonLogin.html";
                [self.appDelegate updateLoginStatus:false] ;
                [self showViewController:[RH_CustomViewController viewController] sender:self];
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
    }
}

-(void)tryRefreshData
{
    if ([self.webView canGoBack]){
        [self.webView goBack] ;
    }
}

@end
