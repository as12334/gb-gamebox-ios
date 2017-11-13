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
//#import
//原生的OC登录控制器
#import "RH_LoginViewControllerEx.h"
//原生登录代理和H5代理。方便切换打包用
@interface RH_SimpleWebViewController ()<RH_LoginViewControllerExDelegate,LoginViewControllerDelegate>
//关闭网页按钮
@property(nonatomic,strong,readonly) UIBarButtonItem * closeWebBarButtonItem;
@end

@implementation RH_SimpleWebViewController
@synthesize contentShowState = _contentShowState;
@synthesize loadingBarButtonItem = _loadingBarButtonItem;
@synthesize closeWebBarButtonItem = _closeWebBarButtonItem;
@synthesize backBarButtonItem = _backBarButtonItem ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    _domain = self.appDelegate.domain ;
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
    UIEdgeInsets edgeInsets = [self contentScrollViewEdgeInsetsWithFullScreenModel:NO] ;
    _webView.frame = CGRectMake(0, edgeInsets.top, self.contentView.frameWidth,
                                self.contentView.frameHeigh-edgeInsets.top - edgeInsets.bottom) ;
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
        
        NSLog(@"contentinset top %f,bottom:%f",contentInsets.top,contentInsets.bottom) ;
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

            UIAlertView *alertView = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==alertView.cancelButtonIndex){//返回首页
                    self.myTabBarController.selectedIndex = 0 ;
                }else{
                    //push login viewController
                    //H5登录接口
                    RH_LoginViewController *loginViewCtrl = [RH_LoginViewController viewController];
                    //oc原生登录接口
//                    RH_LoginViewControllerEx *loginViewCtrl = [RH_LoginViewControllerEx viewController] ;
                    loginViewCtrl.delegate = self ;
                    [self showViewController:loginViewCtrl sender:self] ;
                }
            } title:NSLocalizedString(@"ALERT_LOGIN_PROMPT_TITLE", nil)
                                                                 message:NSLocalizedString(@"ALERT_LOGIN_PROMPT_DESC", nil)
                                                        cancelButtonName:NSLocalizedString(@"ALERT_LOGIN_BTN_BACKFIRST", nil)
                                                       otherButtonTitles:NSLocalizedString(@"ALERT_LOGIN_BTN_CONFIRMLOGIN", nil), nil] ;

            [alertView show] ;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    NSLog(@"....webView : (%f,%f),(%f,%f)",self.webView.frameX,self.webView.frameY,self.webView.frameWidth,self.webView.frameHeigh) ;
}

- (void)dealloc
{
    if (self.isLoading) {
        _loading = NO;
        showNetworkActivityIndicator(NO);
    }

    [self.webView stopLoading];
    // 每次退出 都清除一下缓存被
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

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

#pragma mark -
- (void)setWebURL:(NSURL *)webURL
{
    if (_webURL != webURL && ![_webURL isEqual:webURL]) {
        if (webURL) {
            NSString * URL = webURL.absoluteString;
            _webURL = [NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

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
    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] ;
    [self setupJSCallBackOC:jsContext] ;
    [self webViewDidEndLoad:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self _setContentShowState:RH_WebViewContentShowStateNone];
    [self _setLoading:NO];
    [self.contentLoadingIndicateView showNothingWithTitle:@"点击页面刷新" detailText:nil];

    [self webViewDidEndLoad:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* reqUrl = request.URL.absoluteString;
    if ([reqUrl hasPrefix:@"weixin://"]||[reqUrl hasPrefix:@"alipay://"]) {
        BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
        //bSucc是否成功调起支付宝
    }
    return YES;
}

#pragma mark-
-(void)setupJSCallBackOC:(JSContext*)jsContext
{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showViewController:[RH_CustomViewController viewController] sender:self];
        });

        NSLog(@"-------End Log-------");
    } ;


    jsContext[@"goBack"] = ^() {
        NSLog(@"JSToOc :%@------ goBack",NSStringFromClass([self class])) ;
        NSUInteger index = [self.navigationController.viewControllers indexOfObject:self] ;
        if (index>=1 && index !=NSNotFound){
            [self backBarButtonItemHandle] ;
        }else{
            self.myTabBarController.selectedIndex = 0 ;// jump to first page .
        }
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

        JSValue *gameJsVal;
        for (JSValue *jsVal in args) {
            gameJsVal = jsVal;
            NSLog(@"%@", jsVal.toString);
        }

        if (args[0] != NULL) {
            self.appDelegate.customUrl = gameJsVal.toString;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self showViewController:[RH_GamesViewController viewController]
                              sender:self] ;
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

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:jsAccount.toString forKey:@"account"];
        [defaults setObject:jsPassword.toString forKey:@"password"];
        [defaults synchronize];
        [self.appDelegate updateLoginStatus:true] ;

        RH_LoginViewController *loginViewCtrl = ConvertToClassPointer(RH_LoginViewController, self) ;
        if (loginViewCtrl){
            ifRespondsSelector(loginViewCtrl.delegate, @selector(loginViewViewControllerLoginSuccessful:)){
                [loginViewCtrl.delegate loginViewViewControllerLoginSuccessful:loginViewCtrl];
            }
        }else{
            [self reloadWebView] ;
        }
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
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus] ;
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
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageWithName(@"title_back") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonItemHandle:)];
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


@end
