//
//  GameWebViewController.m
//  GameBox
//
//  Created by shin on 2018/6/27.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "GameWebViewController.h"
#import "SH_DragableMenuView.h"
#import "NJKWebViewProgress.h"
#import "MacroDef.h"
#import "WHC_AutoLayout.h"
#import "RH_UserInfoManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_PromoListController.h"
#import "RH_CustomServiceSubViewController.h"
#import "RH_RegistrationViewController.h"

//忽略证书访问
@interface NSURLRequest (IgnoreSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
@end
@implementation NSURLRequest (IgnoreSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host {return YES;}
@end

@interface GameWebViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) SH_DragableMenuView *dragableMenuView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, copy) GameWebViewControllerClose closeBlock;
@property (nonatomic, copy) GameWebViewControllerCloseAndShowLogin closeAndShowLoginBlock;

@end

@implementation GameWebViewController

- (void)dealloc
{
    [self.webview stopLoading];
    [self.webview removeFromSuperview];
    self.webview = nil;
    self.webview.delegate = nil;
}

-(BOOL)isSubViewController
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"url===%@",self.url);
    // Do any additional setup after loading the view from its nib.
    //开始加载网页内容
    //我们自己的游戏需要传入SID
    //第三方游戏不需要传入SID
    __weak typeof(self) weakSelf = self;
    if (iPhoneX) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    
    [self setHiddenStatusBar:YES];

    _webview = [[UIWebView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_webview];
    _webview.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0) ;

    [self loadWithUrl:self.url];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressTintColor = colorWithRGB(39, 61, 157);
    [_progressView setProgress:0.05 animated:YES];
    [self.view addSubview:_progressView];
    _progressView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(4) ;

    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;

    _progressProxy.progressBlock = ^(float progress) {
        weakSelf.progressView.hidden = progress == 1.0;
        [weakSelf.progressView setProgress:progress animated:NO];
    };

    _dragableMenuView = [[[NSBundle mainBundle] loadNibNamed:@"SH_DragableMenuView" owner:nil options:nil] lastObject];
    _dragableMenuView.hidden = self.hideMenuView;
    [self.view addSubview:_dragableMenuView];
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    _dragableMenuView.whc_TopSpace(470).whc_RightSpace(iPhoneX && oriention == UIInterfaceOrientationLandscapeLeft ? 30 :  0).whc_Height(67).whc_Width(32);
    [_dragableMenuView closeAction:^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
    }];
    
    [_dragableMenuView gobackAction:^{
        if ([weakSelf.webview canGoBack]) {
            [weakSelf.webview goBack];
        }
        else
        {
            [weakSelf.navigationController popViewControllerAnimated:NO];
            if (weakSelf.closeBlock) {
                weakSelf.closeBlock();
            }
        }
    }];
}

- (void)close:(GameWebViewControllerClose)closeBlock
{
    self.closeBlock = closeBlock;
}

- (void)closeAndShowLogin:(GameWebViewControllerClose)closeAndShowLoginBlock
{
    self.closeAndShowLoginBlock = closeAndShowLoginBlock;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    if (oriention == UIInterfaceOrientationLandscapeLeft) {
        self.dragableMenuView.whc_TopSpace(60).whc_RightSpace(iPhoneX && oriention == UIInterfaceOrientationLandscapeLeft ? 30 :  0).whc_Height(67).whc_Width(32);
    }
    else
    {
        self.dragableMenuView.whc_TopSpace(60).whc_RightSpace(0).whc_Height(67).whc_Width(32);
    }
}

- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    JSContext *jsContext = [_webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self setupJSCallBackOC:jsContext] ;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

-(void)setupJSCallBackOC:(JSContext*)jsContext
{
    __weak typeof(self) weakSelf = self;

    jsContext[@"nativeGoBackPage"] = ^(){
        //返回按钮
        if ([weakSelf.webview canGoBack]) {
            [weakSelf.webview goBack];
        }
        else
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };

    jsContext[@"nativeGotoPromoRecordPage"] = ^(){
        //跳到我的优惠记录界面
        if (weakSelf.appDelegate.isLogin) {
            [weakSelf.navigationController pushViewController:[RH_PromoListController viewController] animated:YES];
        }else
        {
            [weakSelf loginButtonItemHandle] ;
        }
    };

    jsContext[@"nativeGotoDepositPage"] = ^(){
        //跳入存款页面
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        weakSelf.myTabBarController.selectedIndex = 1 ;
    };

    jsContext[@"nativeGoToCustomerPage"] = ^(){
        //跳转客服页面
        [weakSelf.navigationController pushViewController:[RH_CustomServiceSubViewController viewController] animated:YES];
    };

    jsContext[@"nativeGoToRegisterPage"] = ^(){
        //注册页面
        [weakSelf.navigationController pushViewController:[RH_RegistrationViewController viewController] animated:YES];
    };

    jsContext[@"gotoHomePage"] = ^(){
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        weakSelf.myTabBarController.selectedIndex = 0 ;
    };

    jsContext[@"nativeLogin"] = ^(){
        //跳到login界面
        [weakSelf loginButtonItemHandle] ;
    };
    
    jsContext[@"gotoCustom"] = ^(){
        NSArray *args = [JSContext currentArguments];
        JSValue *customUrl;
        for (JSValue *jsVal in args) {
            customUrl = jsVal;
            NSLog(@"%@", jsVal.toString);
        }

        if (args[0] != NULL) {
            NSString *url = customUrl.toString;
            if ([url containsString:@"/login/commonLogin.html"]) {
                //回到首页并展示登录界面
                [weakSelf.navigationController popViewControllerAnimated:NO];
                if (weakSelf.closeAndShowLoginBlock) {
                    weakSelf.closeAndShowLoginBlock();
                }
            }
            else if ([url containsString:@"/mainIndex.html"])
            {
                //回到首页
                [weakSelf.navigationController popViewControllerAnimated:NO];
                if (weakSelf.closeBlock) {
                    weakSelf.closeBlock();
                }
            }
            else
            {
                NSString *checkType = [[weakSelf.appDelegate.checkType componentsSeparatedByString:@"+"] firstObject];
                NSString *urlStr;
                if (self.appDelegate.demainName.length > 0) {
                    urlStr = [NSString stringWithFormat:@"%@://%@%@",checkType,weakSelf.appDelegate.demainName,url];
                } else {
                    urlStr = [NSString stringWithFormat:@"%@://%@%@",checkType,weakSelf.appDelegate.headerDomain,url];
                }
                
                [weakSelf loadWithUrl:urlStr];
            }
        }
    } ;
}

- (void)loadWithUrl:(NSString *)url
{
    NSString *domain;
    //如果有新的域名检测过了就是用新的域名
    if (self.appDelegate.demainName) {
        if ([url  containsString:self.appDelegate.demainName]) {
            domain = self.appDelegate.demainName;
        }
    } else {
        domain = self.appDelegate.headerDomain;
    }
    
    NSArray *checkTypeComponents = [self.appDelegate.checkType componentsSeparatedByString:@"+"];
    NSString *preUrl = [NSString stringWithFormat:@"%@://%@",checkTypeComponents[0],domain];
    NSLog(@"url == %@",url);
    if ([url hasPrefix:@"http"] && ([RH_UserInfoManager shareUserManager].sidString != nil && ![[RH_UserInfoManager shareUserManager].sidString isEqualToString:@""])) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"SID" forKey:NSHTTPCookieName];
        NSArray *sidStringCompArr = [[RH_UserInfoManager shareUserManager].sidString componentsSeparatedByString:@";"];
        NSString *sid = [[sidStringCompArr firstObject] stringByReplacingOccurrencesOfString:@"SID=" withString:@""];
        [cookieProperties setObject:sid forKey:NSHTTPCookieValue];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [request setValue:domain forHTTPHeaderField:@"Host"];
        
        [self.webview loadRequest:request];
    }
    else
    {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:self.appDelegate.headerDomain forKey:NSHTTPCookieDomain];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        
        [self.webview loadRequest:request];
    }
}
@end
