//
//  DepositVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/3/27.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "DepositVC.h"
#import "CustomVC.h"
#import "AppDelegate.h"
#import "iKYLoadingHubView.h"
#import "ViewController.h"
#import "PayVC.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface DepositVC ()

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *depositWV;
@property NSString *domain;
@property BOOL selfIsLogin;
@property NSString *loadUrl;
@property iKYLoadingHubView *loadingHubView;
@property int loginId;

- (void)ocjs;

- (void)goBackMainToast;

@end

@implementation DepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.domain = _appDelegate.domain;
    self.selfIsLogin = _appDelegate.isLogin;
    self.loginId = 0;
    //加载动画
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(rx.size.width/2-100, rx.size.height/2-75, 200, 150)];
    [self.view addSubview:_loadingHubView];
    [_loadingHubView showHub];
    [_loadingHubView setHidden:YES];
    
    _depositWV.scrollView.bounces=NO;
    
    //请求链接
    _loadUrl = [NSString stringWithFormat:@"%@%@",_domain,@"/wallet/deposit/index.html"];
//    if ([@"integrated" isEqualToString:SITE_TYPE]) {
//        _loadUrl = [NSString stringWithFormat:@"%@%@",_domain,@"/wallet/deposit/index.html"];
//    } else if ([@"lottery" isEqualToString:SITE_TYPE]) {
//        _loadUrl = [NSString stringWithFormat:@"%@%@",_domain,@"/lottery/lotteryResultHistory/index.html"];
//    }
    
    //2 调用系统方法直接访问
    if(self.appDelegate.isLogin){
        [self.depositWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
    }
    
    //3 设置网页自适应
    self.depositWV.scalesPageToFit = YES;
    
    
    //4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.depositWV.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //代理方法  不遵守代理  就无法调用他的方法
    self.depositWV.delegate = self;
    
    NSLog(@"viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//即将进入这个界面加载该方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if(_appDelegate.gotoIndex != -1){
        if(_appDelegate.gotoIndex == self.tabBarController.selectedIndex){
            [_depositWV reload];
        }else{
            self.tabBarController.selectedIndex = _appDelegate.gotoIndex;
        }
        _appDelegate.gotoIndex = -1;
    }
    
    //判断是否登录
    if(self.appDelegate.isLogin){
        [_depositWV setHidden:NO];
        if(_loginId != _appDelegate.loginId){
            _loginId = _appDelegate.loginId;
            [self.depositWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
        }

    }else{
        
        [_depositWV setHidden:YES];
        
        if(_selfIsLogin){
            [self.depositWV reload];
            _selfIsLogin = false;
        }
        
        NSString *prompt = @"提示";
        NSString *message = @"您尚未登录，请先登录";
        NSString *title = @"返回首页";
        NSString *loginTitle = @"立即登录";
        if ([@"185" isEqualToString:SID]) {
            prompt = @"メッセージ";
            message = @"ログイン情報エラー";
            title = @"トップページへ戻る";
            loginTitle = @"今すぐログイン";
        }
        
        // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:prompt message:message preferredStyle:UIAlertControllerStyleAlert];
        
        // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"返回首页");
            self.tabBarController.selectedIndex = 0;
        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:loginTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            _appDelegate.customUrl = @"/login/commonLogin.html";
            CustomVC *BVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomVC"];
            [self.navigationController pushViewController:BVC animated:YES];
            NSLog(@"立即登录");
        }];
        
        // 3.将“取消”和“确定”按钮加入到弹框控制器中
        [alertVc addAction:cancle];
        [alertVc addAction:confirm];
        [self presentViewController:alertVc animated:YES completion:^{nil;}];
    }
    NSLog(@"viewWillAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//开始加载网页，不仅监听我们指定的请求，还会监听内部发送的请求
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:NO];
    NSLog(@"开始加载");
}

//网页加载完毕之后会调用该方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载成功");
    [_loadingHubView setHidden:YES];
    [_loadingHubView dismissHub];
    self.ocjs;
    
    [webView stringByEvaluatingJavaScriptFromString:@"getLoginState(isLogin);"];
}
- (void)ocjs{
    //    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[_depositWV valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"share"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"方式二" message:@"这是OC原生的弹出窗" delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
            [alertView show];
        });
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
        }
        
        NSLog(@"-------End Log-------");
    };
    
    context[@"getLoginState"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        NSString *isLogin = [args[0] toString];
        
        NSLog(@"isLogin:%@",isLogin);
        
        if([isLogin isEqualToString:@"true"]){
            _appDelegate.isLogin = YES;
            self.selfIsLogin = YES;
        }else{
            _appDelegate.isLogin = NO;
            self.selfIsLogin = NO;
            _appDelegate.loginId ++;
            
            self.tabBarController.selectedIndex = 0;
        }
        
    };
    
    context[@"gotoCustom"] = ^() {
        NSArray *args = [JSContext currentArguments];
        
        JSValue *jsCustom;
        
        for (JSValue *jsVal in args) {
            jsCustom = jsVal;
            NSLog(@"%@", jsVal.toString);
        }
        
        CustomVC *customVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomVC"];
        
        if (args[0] != NULL) {
            _appDelegate.customUrl = jsCustom.toString;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:customVC animated:NO];
        });
        NSLog(@"-------goto-------");
    };
    
    context[@"gotoPay"] = ^() {
        NSArray *args = [JSContext currentArguments];
        
        JSValue *jsCustom;
        
        for (JSValue *jsVal in args) {
            jsCustom = jsVal;
            NSLog(@"%@", jsVal.toString);
        }
        
        PayVC *customVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PayVC"];
        
        if (args[0] != NULL) {
            _appDelegate.customUrl = jsCustom.toString;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:customVC animated:YES];
        });
        NSLog(@"-------gotoPay-------");
    };
    
    context[@"goBack"] = ^() {
        NSLog(@"+++++++DepositVC GoBack+++++++");
        [self.navigationController popViewControllerAnimated:NO];
    };
    context[@"loginSucc"] = ^() {
        NSLog(@"+++++++loginSucc Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        //        for (JSValue *jsVal in args) {
        //            NSLog(@"%@", jsVal.toString);
        //        }
        
        JSValue *jsAccount = args[0];
        JSValue *jsPassword = args[1];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        [defaults removeObjectForKey:@"account"];
        //        [defaults removeObjectForKey:@"password"];
        
        [defaults setObject:jsAccount.toString forKey:@"account"];
        [defaults setObject:jsPassword.toString forKey:@"password"];
        [defaults synchronize];
        _appDelegate.isLogin = true;
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    context[@"reload"] = ^() {
        [self.depositWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
    };
}

//网页加载失败调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_loadingHubView setHidden:YES];
    [self setErrorHtml:webView];
    NSLog(@"加载失败");
}

- (void)goBackMainToast{
    [self.depositWV stopLoading];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"警告⚠️" message:@"您的账号已经被强制踢出" preferredStyle:UIAlertControllerStyleAlert];
    
            // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
    
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"返回首页");
                self.tabBarController.selectedIndex = 0;
    
            }];
    
            // 3.将“取消”和“确定”按钮加入到弹框控制器中
    
            [alertVc addAction:cancle];
    
            [self presentViewController:alertVc animated:YES completion:^{nil;}];
}

@end
