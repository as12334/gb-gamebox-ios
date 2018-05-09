//
//  RH_SimpleWebViewController.m
//  TaskTracking
//
//  Created by apple pro on 2017/3/5.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_SimpleWebViewController.h"
#import "coreLib.h"
#import "RH_CustomViewController.h"
#import "RH_PayViewController.h"
#import "RH_APPDelegate.h"
#import "MacroDef.h"
#import "RH_LoginViewController.h"
#import "RH_MainTabBarController.h"
#import "RH_GamesViewController.h"
#import "RH_TestViewController.h"
#import "CLTabBarController.h"
#import "MacroDef.h"
#import "RH_API.h"
#import "RH_UserInfoManager.h"
#import "RH_CapitalRecordViewController.h"
#import "RH_PromoListController.h"
#import "RH_LoginViewControllerEx.h"
#import "RH_MePageViewController.h"
#import "RH_RegistrationViewController.h"
#import "RH_CustomServiceSubViewController.h"

//原生登录代理和H5代理。方便切换打包用
@interface RH_SimpleWebViewController ()<LoginViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LoginViewControllerExDelegate>
//关闭网页按钮
@property(nonatomic,strong) UIBarButtonItem * closeWebBarButtonItem;
@end

@implementation RH_SimpleWebViewController
@synthesize contentShowState = _contentShowState;
@synthesize loadingBarButtonItem = _loadingBarButtonItem;
@synthesize closeWebBarButtonItem = _closeWebBarButtonItem;
@synthesize backBarButtonItem = _backBarButtonItem ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _domain = self.appDelegate.domain.trim ;
    
    if (self.appDelegate.servicePath.length<1){
        [self.serviceRequest startGetCustomService] ;
    }
    
    [self setHiddenStatusBar:NO];
    
    self.hiddenTabBar = [self tabBarHidden] ;
    self.hiddenNavigationBar = [self navigationBarHidden] ;
    self.navigationBarItem.rightBarButtonItems = nil ;
    //webView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.backgroundColor  = [UIColor clearColor];
    _webView.opaque           = NO;
    _webView.delegate         = self;
    _webView.scalesPageToFit  = YES;//
    //_webView.dataDetectorTypes= UIDataDetectorTypeLink;
    _webView.dataDetectorTypes = UIDataDetectorTypeAll ;//4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    _webView.hidden           = YES;
    _webView.scrollView.delegate = self;
    
#if 0
    _webView.scrollView.contentInset = [self contentScrollViewEdgeInsetsWithFullScreenModel:NO];
//    _webView.scrollView.scrollIndicatorInsets = [self contentScrollViewIndicatorContentEdgeInsetsWithFullScreenModel:NO];
#else

    if (@available(iOS 11.0, *))
    {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _webView.scrollView.contentInset = [self contentScrollViewEdgeInsetsWithFullScreenModel:NO];
    }else{
        UIEdgeInsets edgeInsets = [self contentScrollViewEdgeInsetsWithFullScreenModel:NO] ;
        _webView.frame = CGRectMake(0, edgeInsets.top, self.contentView.frameWidth,
                                    self.contentView.frameHeigh-edgeInsets.top - edgeInsets.bottom) ;
    }
#endif

    [self.contentView addSubview:_webView];
//    self.contentScrollView = _webView.scrollView;
    
}

//重载父类方法
-(UIEdgeInsets)contentScrollViewEdgeInsetsWithFullScreenModel:(BOOL)fullScreen
{
    UIEdgeInsets contentInsets =UIEdgeInsetsZero ;
    if (fullScreen){
        contentInsets = UIEdgeInsetsMake(0,
                                         0,
                                         [self isHiddenTabBar]?0:69,
                                         0) ;
    }else{
        contentInsets = UIEdgeInsetsMake((self.isHiddenStatusBar?0:heighStatusBar)+
                                         ([self navigationBarHidden]?0:NavigationBarHeight),
                                         0,
                                         [self tabBarHidden]?0:heighTabBar,
                                         0) ;
        
//        NSLog(@"contentinset top %f,bottom:%f",contentInsets.top,contentInsets.bottom) ;
    }
    
    return contentInsets ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    if ([self needLogin]){
        //check whether login
        if (!self.appDelegate.isLogin){
            //暂停loading
            _loading = NO ;
            [self.webView stopLoading] ;
            [self _setContentShowState:RH_WebViewContentShowStateNone] ;

            if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                //push login viewController
                RH_LoginViewControllerEx *loginViewCtrlEx = [RH_LoginViewControllerEx viewControllerWithContext:@(YES)];
                loginViewCtrlEx.delegate = self ;
                [self presentViewController:loginViewCtrlEx animated:YES completion:nil] ;
            }else{
                UIAlertView *alertView = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex==alertView.cancelButtonIndex){//返回首页
                        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                            [self.navigationController popToRootViewControllerAnimated:NO];
                            self.myTabBarController.selectedIndex = 2 ;
                        }else{
                            self.myTabBarController.selectedIndex = 0 ;
                        }
                    }else{
                        //push login viewController
                        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){//显示原生登录界面
                            RH_LoginViewControllerEx *loginViewCtrlEx = [RH_LoginViewControllerEx viewController];
                            loginViewCtrlEx.delegate = self ;
                            [self showViewController:loginViewCtrlEx sender:self] ;
                        }else{
                            //H5登录接口
                            RH_LoginViewController *loginViewCtrl = [RH_LoginViewController viewController];
                            loginViewCtrl.delegate = self ;
                            [self showViewController:loginViewCtrl sender:self] ;
                        }
                    }
                } title:NSLocalizedString(@"ALERT_LOGIN_PROMPT_TITLE", nil)
                                                                     message:NSLocalizedString(@"ALERT_LOGIN_PROMPT_DESC", nil)
                                                            cancelButtonName:NSLocalizedString(@"ALERT_LOGIN_BTN_BACKFIRST", nil)
                                                           otherButtonTitles:NSLocalizedString(@"ALERT_LOGIN_BTN_CONFIRMLOGIN", nil), nil] ;

                [alertView show] ;
            }
        }
    }
}

- (void)dealloc
{
    if (self.isLoading) {
        _loading = NO;
        showNetworkActivityIndicator(NO);
    }
    self.webView.delegate = nil;
//    [WebView stopLoading];
    [self.webView stopLoading];
    _webURL = nil;
    
    if (!([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
    // 每次退出 都清除一下缓存被
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
      
}

#pragma mark--
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


-(BOOL)backButtonHidden
{
    return NO ;
}

-(BOOL)navigationBarHidden
{
    return YES ;
}

-(BOOL)tabBarHidden
{
    return YES ;
}

-(BOOL)closeWebBarButtonItemHidden
{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault ;
}

-(BOOL)needLogin
{
    //子类重定义来指定该界面是否login .
    return NO ;
}

#pragma mark-
-(void)loginViewViewControllerTouchBack:(RH_LoginViewController *)loginViewContrller
{
    [loginViewContrller hideWithDesignatedWay:YES completedBlock:nil] ;
}

-(void)loginViewViewControllerLoginSuccessful:(RH_LoginViewController *)loginViewContrller
{
    [self.navigationController popViewControllerAnimated:YES] ;
    [self reloadWebView] ;
}

#pragma mark-
-(void)loginViewViewControllerExTouchBack:(RH_LoginViewControllerEx *)loginViewContrller BackToFirstPage:(BOOL)bFirstPage
{
    if (loginViewContrller.presentingViewController){
        [loginViewContrller dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    
    if (bFirstPage){
        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            self.myTabBarController.selectedIndex = 2 ;
        }else{
            self.myTabBarController.selectedIndex = 0 ;
        }
    }
}

-(void)loginViewViewControllerExLoginSuccessful:(RH_LoginViewControllerEx *)loginViewContrller
{
    if (loginViewContrller.presentingViewController){
        [loginViewContrller dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    
    [self reloadWebView] ;
}

-(void)loginViewViewControllerExSignSuccessful:(RH_LoginViewControllerEx *)loginViewContrller SignFlag:(BOOL)bFlag
{
    if (loginViewContrller.presentingViewController){
        [loginViewContrller dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    
    [self reloadWebView] ;
    
    if (bFlag==false){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *account = [defaults stringForKey:@"account"] ;
        NSString *password = [defaults stringForKey:@"password"] ;
        
        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
            [self.serviceRequest startAutoLoginWithUserName:account Password:password] ;
        }else{
            [self.serviceRequest startLoginWithUserName:account Password:password VerifyCode:nil] ;
        }
    }
}


#pragma mark -
- (void)setWebURL:(NSURL *)webURL
{
    
    if (_webURL != webURL && ![_webURL isEqual:webURL]) {
        if (webURL) {
            NSString * URL = webURL.absoluteString;
//            _webURL = [NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            _webURL = [NSURL URLWithString:URL] ; //解决 按NSUTF8StringEncoding转换会多出一些其它字符的情况
            NSLog(@"URL===%@",URL);
        }else {
            _webURL = nil;
        }
        
        [self reloadWebView];
    }
}

- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView {
    [self reloadWebView];
}

- (void)reloadWebView
{
    if (self.webView) {
        //停止上一次的加载
        [self.webView stopLoading];
        [self _setLoading:NO];

        if (self.webURL) {
            if(CurrentNetworkAvailable(NO)) {

                [self.contentLoadingIndicateView hiddenView];
                [self _startLoadWebView];

            }else {

                [self _setContentShowState:RH_WebViewContentShowStateNone];
                [self.contentLoadingIndicateView showNoNetworkStatus];
            }
        }else {

            [self _setContentShowState:RH_WebViewContentShowStateNone];
            [self.contentLoadingIndicateView showInfoInInvalidWithTitle:@"无效的地址"
                                                             detailText:nil];
        }
    }
}

- (void)_startLoadWebView
{
    //开始加载网页内容
    NSMutableURLRequest * urlRequest = [[NSMutableURLRequest alloc] initWithURL:self.webURL];
//    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
////        [dictionnary setValue:@"v3.0" forKey:@"app_version"] ;//用于后台切换 v3 环境
//        [urlRequest setValue:@"3.0" forHTTPHeaderField:@"app_version 3.0"] ;
//    }
    [urlRequest setValue:@"application/javascript; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.webView loadRequest:urlRequest];
}

- (UIBarButtonItem *)loadingBarButtonItem
{
    if (!_loadingBarButtonItem) {
        UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

        if ([self hasNavigationBar]) {
            activityIndicatorView.color = self.navigationBar.tintColor;
        }

        [activityIndicatorView startAnimating];

        _loadingBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
    }

    return _loadingBarButtonItem;
}

- (void)_setLoading:(BOOL)loading
{
    if (_loading != loading) {
        _loading = loading;
        showNetworkActivityIndicator(loading);

        //设置标题
        if (!self.title.length && [self hasNavigationBar]) {
            self.navigationBarItem.title = loading ? NSLocalizedString(@"NAVIGATIONBAR_LOADING_STATUS", nil) : nil;
        }

        //显示加载指示
        if ([self hasNavigationBar]) {
            if (loading) {
                if (self.navigationBarItem.rightBarButtonItem == nil ) {
                    self.navigationBarItem.rightBarButtonItem = self.loadingBarButtonItem;
                }

            }else {

                if (self.navigationBarItem.rightBarButtonItem == self.loadingBarButtonItem &&
                    self.contentShowState == RH_WebViewContentShowStateShowed) {
                    self.navigationBarItem.rightBarButtonItem =  nil;
                }
            }

            if (self.webView.canGoBack) {
                if ([self backButtonHidden]){
                    self.navigationBarItem.leftBarButtonItems = @[self.closeWebBarButtonItem];
                }else{
                    self.navigationBarItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeWebBarButtonItem];
                }
            }else {
                if ([self backButtonHidden]){
                    self.navigationBarItem.leftBarButtonItems = nil;
                }else{
                    self.navigationBarItem.leftBarButtonItems = @[self.backBarButtonItem];
                }
            }
            if ([self closeWebBarButtonItemHidden]) {
                self.navigationBarItem.leftBarButtonItems = @[self.backBarButtonItem];
            }else
            {
                self.navigationBarItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeWebBarButtonItem];
            }
        }

        //加载状态改变
        [self wedViewContentLoadStateDidChange];
    }
}

- (void)_setContentShowState:(RH_WebViewContentShowState)contentShowState
{
    if (_contentShowState != contentShowState) {
        _contentShowState = contentShowState;

        if (_contentShowState == RH_WebViewContentShowStateNone) {
            self.webView.hidden = YES;
        }else {
            self.webView.hidden = NO;
        }

        [self wedViewContentShowStateDidChange];
    }
}

#pragma mark-webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //设置状态
    [self _setLoading:YES];
    if (!self.webView.suppressesIncrementalRendering) {
        [self _setContentShowState:RH_WebViewContentShowStateShowing];
    }

    [self.contentLoadingIndicateView hiddenView];
    [self webViewBeginLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"-webView finish ---:");
//    CGFloat rightSpace = 0.0;
//    if (self.view.frame.size.width == 320.0) {
//        rightSpace = self.view.frame.size.width/6.5;
//    } else if (self.view.frame.size.width == 375.0){
//        rightSpace = self.view.frame.size.width/7.2;
//    } else {
//        rightSpace = self.view.frame.size.width/8.0;
//    }
//    NSString *script = [NSString stringWithFormat:
//                        @"var script = document.createElement('script');"
//                        "script.type = 'text/javascript';"
//                        "script.text = \"function ResizeImages() { "
//                        "var img;"
//                        "var maxwidth=%f;"
//                        "for(i=0;i <document.images.length;i++){"
//                        "img = document.images[i];"
//                        "if(img.width > maxwidth){"
//                        "img.width = maxwidth;"
//                        "}"
//                        "}"
//                        "}\";"
//                        "document.getElementsByTagName('head')[0].appendChild(script);", self.view.frame.size.width - rightSpace];
//    [webView stringByEvaluatingJavaScriptFromString: script];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    [self _setContentShowState:RH_WebViewContentShowStateShowed];
    [self _setLoading:NO];
    NSString *url = webView.request.URL.absoluteString;
    ////账号密码自动填充
    if([url containsString:@"/login/commonLogin.html"] || [url containsString:@"/passport/login.html"]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *account = [defaults objectForKey:@"account"];
        NSString *password = [defaults objectForKey:@"password"];

        NSLog(@"%@%@",account,password);

        if(account != NULL && ![account isEqualToString: @""]){
            account = [NSString stringWithFormat:@"document.getElementById('username').value='%@'",account];
            [self.webView stringByEvaluatingJavaScriptFromString:account];

            if(password != NULL && ![password isEqualToString: @""]){
                password = [NSString stringWithFormat:@"document.getElementById('password').value='%@'",password];
                [self.webView stringByEvaluatingJavaScriptFromString:password];
            }
        }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    }
    
    //增加通用 js 处理
    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]  ;
    
    [self setupJSCallBackOC:jsContext] ;
    [self webViewDidEndLoad:nil];
    
    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
//        [self.webView stringByEvaluatingJavaScriptFromString:@"headInfo()"] ;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"-webView finish with error---:%@",error);
    [self _setContentShowState:RH_WebViewContentShowStateNone];
    [self _setLoading:NO];
    [self.contentLoadingIndicateView showNothingWithTitle:@"点击页面刷新" detailText:nil];
    

    [self webViewDidEndLoad:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* reqUrl = request.URL.absoluteString;
   
//    if ([reqUrl isEqualToString:@"https://777.ampinplayopt0matrix.com/m/new/#/game"]) {
//        reqUrl = @"http://777.ampinplayopt0matrix.com/m/new/#/game";
//    }
    
    if ([reqUrl hasPrefix:@"weixin://"]||[reqUrl hasPrefix:@"alipay://"]) {
        [[UIApplication sharedApplication]openURL:request.URL];
        return NO ;
        //bSucc是否成功调起支付宝
    }else if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])
              && ([reqUrl containsString:@"/login/commonLogin.html"] || [reqUrl containsString:@"/passport/login.html"] )){
//        //跳转原生
//        if (![self.navigationController.topViewController isKindOfClass:[RH_LoginViewControllerEx class]] &&
//            ![self.navigationController.presentedViewController isKindOfClass:[RH_LoginViewControllerEx class]]){
//            RH_LoginViewControllerEx *loginViewCtrlEx = [RH_LoginViewControllerEx viewController] ;
//            loginViewCtrlEx.delegate = self ;
//            [self showViewController:loginViewCtrlEx sender:self] ;
//        }

        return NO ;
    }else if ([reqUrl.lowercaseString isEqualToString:self.domain.lowercaseString] ||
              [reqUrl.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@/",self.domain.lowercaseString]]){
        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
            return YES ;
//            if (self.myTabBarController.selectedIndex!=2){
//                self.myTabBarController.selectedIndex = 2 ;
//                return YES ;
//            }
        }else{
            if (self.myTabBarController.selectedIndex!=0){
                self.myTabBarController.selectedIndex = 0 ;
                return NO ;
            }
        }
    }
    NSLog(@"-start Request---:%@",reqUrl);
    return YES;
}

#pragma mark-
-(void)setupJSCallBackOC:(JSContext*)jsContext
{
    jsContext[@"nativeGoToRegisterPage"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showViewController:[RH_RegistrationViewController viewController]
                              sender:self];
        });
    };
    
    jsContext[@"nativeCloseCurrentPage"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            self.myTabBarController.selectedIndex = 0 ;
        });
    };
    
    jsContext[@"share"] = ^() {
        NSLog(@"JSToOc :%@------ share",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];

        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"方式二" message:@"这是OC原生的弹出窗" delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
            [alertView show];
        });

        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
        }
    };

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
        
        if ([self.appDelegate.customUrl containsString:@"/passport/logout.html"]){
            self.appDelegate.logoutUrl = self.appDelegate.customUrl ;
            if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.myTabBarController.selectedIndex = 2 ;
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                     self.myTabBarController.selectedIndex = 0 ;
                });
               
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]) &&
                    [self.appDelegate.customUrl containsString:@"/login/commonLogin.html"]){
                    //跳转原生
                    RH_LoginViewControllerEx *loginViewCtrlEx = [RH_LoginViewControllerEx viewController] ;
                    loginViewCtrlEx.delegate = self ;
                    [self showViewController:loginViewCtrlEx sender:self] ;
                }else
                {
                    [self showViewController:[RH_CustomViewController viewController] sender:self];
                }
            }) ;
        }
        NSLog(@"-------End Log-------");
    } ;


    jsContext[@"goBack"] = ^() {
        NSLog(@"JSToOc :%@------ goBack",NSStringFromClass([self class])) ;
        NSUInteger index = [self.navigationController.viewControllers indexOfObject:self] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index>=1 && index !=NSNotFound){
                [self backBarButtonItemHandle] ;
            }else{
                if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
                    self.myTabBarController.selectedIndex = 2 ;
                }else{
                    self.myTabBarController.selectedIndex = 0 ;
                }
            }
        }) ;
    };

    jsContext[@"reload"] = ^() {
        NSLog(@"JSToOc :%@------ reload",NSStringFromClass([self class])) ;
        [self reloadWebView] ;
    };

    jsContext[@"gotoTab"] = ^() {
        NSLog(@"JSToOc :%@------ gotoTab",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        NSString *target;
        for (JSValue *jsVal in args) {
            target = jsVal.toString;
            NSLog(@"%@", jsVal.toString);
        }
        if (args[0] != nil) {

            NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
            if (index >= 1 && index != NSNotFound) {
                [self hideWithDesignatedWay:YES completedBlock:^{
                    self.myTabBarController.selectedIndex = [target intValue] ;
                }] ;
            }else{
                self.myTabBarController.selectedIndex = [target intValue] ;
            }
        }
    };

    jsContext[@"gotoIndex"] = ^(){
        NSLog(@"JSToOc :%@------ gotoIndex",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        JSValue *indexJV = args[0];
        if([self.webView.request.URL.absoluteString containsString:@"/game.html"] && [indexJV.toString intValue] == 0){
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_domain]]];
        }else{

            NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
            if (index >= 1 && index != NSNotFound) {
                [self hideWithDesignatedWay:YES completedBlock:^{
                    self.myTabBarController.selectedIndex = [indexJV.toString intValue] ;
                }] ;
            }else{
                self.myTabBarController.selectedIndex = [indexJV.toString intValue] ;
            }
        }
    };

    jsContext[@"gotoGame"] = ^() {
        NSLog(@"JSToOc :%@------ gotoGame",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];

//        JSValue *gameJsVal;
//        for (JSValue *jsVal in args) {
//            gameJsVal = jsVal;
////            NSLog(@"%@", jsVal.toString);
//        }

        if (args[0] != NULL) {
            JSValue *jsval = args[0] ;
            self.appDelegate.customUrl = jsval.toString;
        }
        
        NSInteger apiTypeID  = -1 ;
        if (args.count>1){
            JSValue *jsval = args[1] ;
            apiTypeID = jsval.toInt32 ;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            //add 197 lottery 客服跳到浏览器
            if ([SID isEqualToString:@"197"] && [self.appDelegate.servicePath.trim hasPrefix:self.appDelegate.customUrl.trim]){
                openURL(self.appDelegate.servicePath.trim) ;
            }else{
                [self showViewController:[RH_GamesViewController viewControllerWithContext:@(apiTypeID)]
                                  sender:self] ;
            }
        });
    };

    jsContext[@"gotoPay"] = ^() {
        NSLog(@"JSToOc :%@------ gotoPay",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        JSValue *jsCustom;

        for (JSValue *jsVal in args) {
            jsCustom = jsVal;
            NSLog(@"%@", jsVal.toString);
        }
        
        if ([jsCustom.toString containsString:RH_API_NAME_APPDOWNLOADURL]){
            NSString *downloadURL = nil ;
            if([jsCustom.toString containsString:@"http"]){
                downloadURL = jsCustom.toString.trim ;
            }else{
               
                downloadURL = [NSString stringWithFormat:@"%@%@",self.appDelegate.domain.trim,jsCustom.toString.trim] ;
            }
            
            openURL(downloadURL) ;
            return  ;
        }

        if (args[0] != NULL) {
            self.appDelegate.customUrl = jsCustom.toString;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showViewController:[RH_PayViewController viewController]
                              sender:self];
        });
    };

    jsContext[@"loginOut"] = ^(){
        NSLog(@"JSToOc :%@------ loginOut",NSStringFromClass([self class])) ;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.appDelegate updateLoginStatus:false] ;
    };
    
   

    jsContext[@"loginState"] = ^(){
        NSLog(@"JSToOc :%@------ loginState",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        NSString *isLogin = [args[0] toString];

        NSLog(@"isLogin:%@",isLogin);
        if([isLogin isEqualToString:@"true"]){
            [self.appDelegate updateLoginStatus:true] ;
        }else{
//            self.appDelegate.loginId ++;
            [self.appDelegate updateLoginStatus:false] ;

            NSString *prompt = @"提示";
            NSString *message = @"请先登录[100]";
            NSString *title = @"返回首页";
            if ([@"185" isEqualToString:SID]) {
                prompt = @"メッセージ";
                message = @"ログイン情報エラー";
                title = @"トップページへ戻る";
            }

            // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];

            // 3.将“取消”和“确定”按钮加入到弹框控制器中

            [alertVc addAction:cancle];

            [self presentViewController:alertVc animated:YES completion:^{nil;}];
            return;
        }
    };

#pragma mark--depositViewController
    jsContext[@"getLoginState"] = ^(){
        NSLog(@"JSToOc :%@------ getLoginState",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        NSString *isLogin = [args[0] toString];

        if([isLogin isEqualToString:@"true"]){
            [self.appDelegate updateLoginStatus:true] ;
        }else{
            [self.appDelegate updateLoginStatus:false] ;
//            self.appDelegate.loginId ++;
            self.tabBarController.selectedIndex = 0;
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
        
        [self.appDelegate updateLoginStatus:jsStatus.toBool] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            RH_LoginViewController *loginViewCtrl = ConvertToClassPointer(RH_LoginViewController, self) ;
            
            if (loginViewCtrl){
                ifRespondsSelector(loginViewCtrl.delegate, @selector(loginViewViewControllerLoginSuccessful:)){
                    [loginViewCtrl.delegate loginViewViewControllerLoginSuccessful:loginViewCtrl];
                }
            }else{
                if (jsStatus.toBool==false){
                    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                        [self.serviceRequest startAutoLoginWithUserName:jsAccount.toString Password:jsPassword.toString] ;
                    }else{
                        [self.serviceRequest startLoginWithUserName:jsAccount.toString Password:jsPassword.toString VerifyCode:nil] ;
                    }
                }
                
                [self reloadWebView] ;
            }
        }) ;
    };

#pragma mark- Mine ViewControl
    jsContext[@"gotoIndexUrl"] = ^(){
        NSLog(@"JSToOc :%@------ gotoIndexUrl",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        self.appDelegate.gotoIndexUrl = [args[1] toString];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tabBarController.selectedIndex = [[args[0] toString] intValue];
        });
    };

#pragma mark- sub-Custom
    jsContext[@"goBackUrl"] = ^(){
        NSLog(@"JSToOc :%@------ goBackUrl",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        self.appDelegate.goBackURL = [args[0] toString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    };
    
#pragma mark - demo Enter
    jsContext[@"demoEnter"] = ^() {
        [self performSelectorOnMainThread:@selector(demoEnter) withObject:self waitUntilDone:NO] ;
    };
    
#pragma mark -  V3 JS Function
    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
        jsContext[@"nativeAccountChange"] = ^(){/*** 通知账户已经变动(用户额度转换)*/
            NSLog(@"JSToOc :%@------ notifyAccountChange",NSStringFromClass([self class])) ;
            [self.serviceRequest startV3UserInfo];
        };
        
        jsContext[@"nativeRefreshPage"] = ^(){/*** 刷新当前页面*/
            NSLog(@"JSToOc :%@------ refreshPage",NSStringFromClass([self class])) ;
            [self performSelectorOnMainThread:@selector(reloadWebView) withObject:self waitUntilDone:YES] ;
        };
      
        jsContext[@"nativeGoBackPage"] = ^(){/*** 如果有上一级页面，就返回上一级 如果没有上一级页面，就不返回，而是提示用户*/
             NSLog(@"JSToOc :%@------ goBackPage",NSStringFromClass([self class])) ;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self backButtonItemHandle:self] ;
            });
           
        };
        
        jsContext[@"nativeGotoDepositPage"] = ^(){/*** 跳入存款页面*/
            NSLog(@"JSToOc :%@------ gotoDepositPage",NSStringFromClass([self class])) ;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
                self.myTabBarController.selectedIndex = 1 ;
//                [self reloadWebView];
            });
        };
        
        jsContext[@"nativeGotoTransactionRecordPage"] = ^(){/*** 跳到资金记录页面*/
            NSLog(@"JSToOc :%@------ gotoCapitalRecordPage",NSStringFromClass([self class])) ;
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self showViewController:[RH_CapitalRecordViewController viewController] sender:self] ;
            });
        };
        
        jsContext[@"nativeOpenWindow"] = ^(){/*** 打开新的webview（打开一个新的弹窗，并且根据传入的url进行加载）*/
            NSLog(@"JSToOc :%@------ nativeOpenWindow",NSStringFromClass([self class])) ;
            NSArray *args = [JSContext currentArguments];
            JSValue *customUrl;
            if (args.count==0) {
                return  ;
            }
            customUrl = args[0] ;
            if ([customUrl.toString containsString:@"http:"] ||[customUrl.toString containsString:@"https:"] ) {
                
                 self.appDelegate.customUrl =[NSString stringWithFormat:@"%@",customUrl.toString];
            }else
            {
               
                self.appDelegate.customUrl =[NSString stringWithFormat:@"%@"@"%@",self.appDelegate.domain,customUrl.toString];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showViewController:[RH_CustomViewController viewController] sender:self];
            }) ;
        };
        
        jsContext[@"nativeGotoPromoRecordPage"] = ^(){/*** 跳到我的优惠记录界面 ）*/
            NSLog(@"JSToOc :%@------ gotoPromoRecordPage",NSStringFromClass([self class])) ;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.appDelegate.isLogin) {
                     [self showViewController:[RH_PromoListController viewController] sender:self] ;
                }else
                {
                    [self loginButtonItemHandle] ;
                }
             
            }) ;
        };
        
        
        // nativeLogin  gotoLoginPage
        jsContext[@"nativeLogin"] = ^(){/*** 跳到login界面 ）*/
            NSLog(@"JSToOc :%@------ nativeLogin",NSStringFromClass([self class])) ;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loginButtonItemHandle] ;
            });
        };
        
        //nativeAutoLogin
        jsContext[@"nativeAutoLogin"] = ^(){/*** 注册成功后 回调 原生自动login ）*/
            NSLog(@"JSToOc :%@------ nativeAutoLogin",NSStringFromClass([self class])) ;
            NSArray *args = [JSContext currentArguments];
            
            JSValue *jsAccount = args[0];
            JSValue *jsPassword = args[1];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:jsAccount.toString forKey:@"account"];
            [defaults setObject:jsPassword.toString forKey:@"password"];
            [defaults synchronize];
            [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:jsAccount.toString
                                                                     LoginTime:dateStringWithFormatter([NSDate date], @"yyyy-MM-dd HH:mm:ss")] ;
           
             RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
            [appDelegate updateLoginStatus:YES] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                RH_LoginViewControllerEx *loginViewCtrl = [[RH_LoginViewControllerEx alloc] init];
                loginViewCtrl.delegate = self ;
                if (loginViewCtrl){
                    ifRespondsSelector(loginViewCtrl.delegate, @selector(loginViewViewControllerExSignSuccessful:SignFlag:)){
                        [loginViewCtrl.delegate loginViewViewControllerExSignSuccessful:loginViewCtrl SignFlag:NO];
                        [self.navigationController popViewControllerAnimated:YES ] ;
                    }
                }
            }) ;
        };
        //分享图片保存
        jsContext[@"nativeSaveImage"] = ^(){/*** 拿到图片的url 将图片保存至本地相册 ）*/
            NSLog(@"JSToOc :%@------ nativeSaveImage",NSStringFromClass([self class])) ;
            NSArray *args = [JSContext currentArguments];
            JSValue *customUrl;
            if (args.count==0) {
                return  ;
            } 
            customUrl = args[0] ;
            self.appDelegate.customUrl = customUrl.toString;
            NSString *urlStr;
            if ([self.appDelegate.customUrl containsString:@"http"] || [self.appDelegate.customUrl containsString:@"https:"]) {
                
                urlStr = [NSString stringWithFormat:@"%@", self.appDelegate.customUrl];
            }else
            {
                
                urlStr = [NSString stringWithFormat:@"%@%@",self.appDelegate.domain, self.appDelegate.customUrl];
            }
          
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]]];
            UIImage *myImage = [UIImage imageWithData:data];
            [self saveImageToPhotos:myImage];
          
        };
        //存款完成后返回首页
        jsContext[@"gotoHomePage"] = ^(){/*** 注册成功后 回调 原生自动login ）*/
            NSLog(@"JSToOc :%@------ gotoHomePage",NSStringFromClass([self class])) ;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
                self.myTabBarController.selectedIndex = 2 ;
            });
//            [self.serviceRequest startV3UserInfo];
            [self.serviceRequest startV3GetUserAssertInfo] ;
            [self reloadWebView];
        };
        //存款点击在线客服页面跳转
        jsContext[@"nativeGoToCustomerPage"] = ^(){/*** 存款点击在线客服页面跳转）*/
            NSLog(@"JSToOc :%@------ nativeGoToCustomerPage",NSStringFromClass([self class])) ;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showViewController:[RH_CustomServiceSubViewController viewController] sender:nil];
            });
        };
        
        jsContext[@"gotoTab"] = ^() {
            NSLog(@"JSToOc :%@------ gotoTab",NSStringFromClass([self class])) ;
            NSArray *args = [JSContext currentArguments];
            NSString *target;
            for (JSValue *jsVal in args) {
                target = jsVal.toString;
                NSLog(@"%@", jsVal.toString);
            }
            if (args[0] != nil) {
                NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
                if (index >= 0 && index != NSNotFound) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        self.myTabBarController.selectedIndex = [target intValue] ;
                    });
                }
            }
        };
    }
}
- (void)saveImageToPhotos:(UIImage*)savedImage

{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel  =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }else{
        msg = @"保存图片成功!请到相册里查看" ;
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        /* 照片是否可以编辑 */
        picker.allowsEditing = YES;
        picker.delegate = self;
        /* 根据照片来源确定AlertAction */
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        /* 判断相册是否可以访问 */
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                [[self topMostController] presentViewController:picker animated:YES completion:^{
//
//                }];
//            }];
//
//            [alert addAction:action1];
//        }
//        UIAlertAction *cancel  =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//
//
//        }];
//        [alert addAction:cancel];
//
//        [self presentViewController:alert animated:YES completion:^{
//
//        }];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片保存成功,请前往相册进行查看！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
       
    }
}

- (UIViewController*) topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

#pragma mark- demoEnter -
- (void)demoEnter{
    [self showProgressIndicatorViewWithAnimated:YES title:@"试玩登录中"];
    [self.serviceRequest startDemoLogin] ;
    return ;
}

#pragma mark-

- (void)webViewBeginLoad {
    //do nothing
    
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:NSLocalizedString(@"WEBVIEW_LOADING_STATUS", nil) detailText:nil] ;
}

- (void)webViewDidEndLoad:(NSError *)error {
    //设置标题
    if ([self hasNavigationBar]) {
        if (self.autoShowWebTitle) {
            NSString *  webTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            self.navigationBarItem.title = webTitle.length ? webTitle : self.title;

        }else {
            self.navigationBarItem.title = self.title;
        }
    }

    if (error){
        if ([self needLogin]){
            if (!self.appDelegate.isLogin){
                [self.contentLoadingIndicateView showDefaultNeedLoginStatus] ;
            }else{
//                [self.contentLoadingIndicateView showDefaultLoadingErrorStatus] ;
            }
        }else{
//            [self.contentLoadingIndicateView showDefaultLoadingErrorStatus] ;
        }
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
    }
}

- (void)wedViewContentShowStateDidChange {
    //do nothing
}

- (void)wedViewContentLoadStateDidChange {
    //do nothing
}

#pragma mark -

- (UIBarButtonItem *)closeWebBarButtonItem
{
    if (!_closeWebBarButtonItem) {
        _closeWebBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonItemHandle:)];
        _closeWebBarButtonItem.tintColor = [UIColor whiteColor] ;
    }

    return _closeWebBarButtonItem;
}

- (UIBarButtonItem *)backBarButtonItem
{
    if (!_backBarButtonItem) {
        NSString *imageName;
        if ([SITE_TYPE isEqualToString:@"integratedv3oc"]||[SITE_TYPE isEqualToString:@"integratedv3"]) {
            imageName = @"ic_back" ;
        }else
        {
              imageName = @"title_back" ;
        }
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageWithName(imageName) style:UIBarButtonItemStylePlain target:self action:@selector(backButtonItemHandle:)];
        _backBarButtonItem.tintColor = [UIColor whiteColor] ;
    }

    return _backBarButtonItem;
}

-(void)backButtonItemHandle:(id)sender
{
    if(sender == self.backBarButtonItem &&
       self.webView.canGoBack &&
       self.navigationBarItem.leftBarButtonItems.count > 1)
    {
        [self.webView goBack];
    }else {
        [self backBarButtonItemHandle] ;
    }
}

-(void)backBarButtonItemHandle
{
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}

#pragma mark -

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if (scrollView == self.webView.scrollView) {
        [self.webView endEditing:YES];
    }

    return YES;
}


#pragma mark-
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
    }
}


@end
