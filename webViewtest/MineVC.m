//
//  MineVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/3/29.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "MineVC.h"
#import "CustomVC.h"
#import "GameVC.h"
#import "AppDelegate.h"
#import "iKYLoadingHubView.h"
#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface MineVC ()

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *mineWV;
@property NSString *domain;
@property BOOL selfIsLogin;
@property NSString *loadUrl;
@property iKYLoadingHubView *loadingHubView;
@property JSContext *context;
@property int loginId;

- (void)ocjs;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginId = 0;
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.domain = _appDelegate.domain;
    self.selfIsLogin = _appDelegate.isLogin;
    self.context=[_mineWV valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _mineWV.scrollView.bounces=NO;
    
    //加载动画
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(rx.size.width/2-100, rx.size.height/2-75, 200, 150)];
    [self.view addSubview:_loadingHubView];
    [_loadingHubView showHub];
    [_loadingHubView setHidden:YES];
    
    //请求链接
    _loadUrl = [NSString stringWithFormat:@"%@%@",_domain,@"/mine/index.html"];
    
    //2 调用系统方法直接访问
    if(self.appDelegate.isLogin){
        [self.mineWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
    }
    
    //3 设置网页自适应
    self.mineWV.scalesPageToFit = YES;
    
    
    //4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.mineWV.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //代理方法  不遵守代理  就无法调用他的方法
    self.mineWV.delegate=self;
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
        self.tabBarController.selectedIndex = _appDelegate.gotoIndex;
        _appDelegate.gotoIndex = -1;
    }
    
    //判断是否登录
    if(self.appDelegate.isLogin){
        [_mineWV setHidden:NO];
        if(_loginId != _appDelegate.loginId){
            _loginId = _appDelegate.loginId;
            [self.mineWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
        }
    }else{
        [_mineWV setHidden:YES];
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
    
    [_mineWV stringByEvaluatingJavaScriptFromString:@"window.page.getUserInfo()"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//开始加载网页，不仅监听我们指定的请求，还会监听内部发送的请求
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:NO];
    [_mineWV setHidden:YES];
    NSLog(@"开始加载");
}

//网页加载完毕之后会调用该方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:YES];
    [_mineWV setHidden:NO];
    NSLog(@"加载成功");
    self.ocjs;
//    [webView stringByEvaluatingJavaScriptFromString:@"loginState(isLogin);"];
}

//网页加载失败调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_loadingHubView setHidden:YES];
    [_mineWV setHidden:NO];
    [self setErrorHtml:webView];
    NSLog(@"加载失败");
}

- (void)ocjs{
    //    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    _context=[_mineWV valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //
    //    //第二种情况，js是通过对象调用的，我们假设js里面有一个对象 testobject 在调用方法
    //    //首先创建我们新建类的对象，将他赋值给js的对象
    //
    //    TestJSObject *testJO=[TestJSObject new];
    //    context[@"testobject"]=testJO;
    //
    //    //同样我们也用刚才的方式模拟一下js调用方法
    //    NSString *jsStr1=@"testobject.TestNOParameter()";
    //    [context evaluateScript:jsStr1];
    _context[@"share"] = ^() {
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
    
    _context[@"gotoCustom"] = ^() {
        NSLog(@"+++++++gotoCustom+++++++");
        NSArray *args = [JSContext currentArguments];
        
        JSValue *jsV;
        for (JSValue *jsVal in args) {
            jsV = jsVal;
            NSLog(@"%@", jsVal.toString);
        }
        
        CustomVC *customVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomVC"];
        
        if (args[0] != NULL) {
            _appDelegate.customUrl = jsV.toString;
        }
        NSLog(@"----------------------------:%@", jsV.toString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:customVC animated:NO];
        });
    };
    
    _context[@"gotoIndex"] = ^(){
        NSLog(@"+++++++gotoIndex+++++++");
        NSArray *args = [JSContext currentArguments];
        JSValue *indexJV = args[0];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tabBarController.selectedIndex = [indexJV.toString intValue];
        });
    };
    
    _context[@"loginOut"] = ^(){
        NSLog(@"++++++loginOut++++++");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.appDelegate.isLogin = false;
        self.appDelegate.loginId ++;
        _selfIsLogin = false;
    };
    
    _context[@"loginState"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        NSString *isLogin = [args[0] toString];
        
        NSLog(@"isLogin:%@",isLogin);
        
        if([isLogin isEqualToString:@"true"]){
            _appDelegate.isLogin = YES;
            self.selfIsLogin = YES;
        }else{
            self.appDelegate.loginId ++;
            _appDelegate.isLogin = NO;
            self.selfIsLogin = NO;
            [self.mineWV stopLoading];
            NSString *prompt = @"提示";
            NSString *message = @"请先登录[104]";
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
            return;
        }
        
    };
    
    _context[@"goBack"] = ^() {
        NSLog(@"+++++++Mine GoBack+++++++");
        [self.navigationController popViewControllerAnimated:NO];
    };
    _context[@"loginSucc"] = ^() {
        NSLog(@"+++++++loginSucc Log+++++++");
        _appDelegate.isLogin = true;
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    _context[@"gotoIndexUrl"] = ^(){
        NSLog(@"+++++++gotoIndexUrl Log+++++++");
        NSArray *args = [JSContext currentArguments];
        _appDelegate.gotoIndexUrl = [args[1] toString];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tabBarController.selectedIndex = [[args[0] toString] intValue];
        });
    };
    
    _context[@"reload"] = ^() {
        [self.mineWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
    };
    
    _context[@"gotoTab"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSString *target;
        for (JSValue *jsVal in args) {
            target = jsVal.toString;
            NSLog(@"%@", jsVal.toString);
        }
        if (args[0] != nil) {
            self.tabBarController.selectedIndex = [target intValue];
        }
    };
    
    _context[@"gotoGame"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        JSValue *gameJsVal;
        for (JSValue *jsVal in args) {
            gameJsVal = jsVal;
            NSLog(@"%@", jsVal.toString);
        }
        
        GameVC *GVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GameVC"];
        
        if (args[0] != NULL) {
            _appDelegate.customUrl = gameJsVal.toString;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:GVC animated:YES];
        });
    };
}

@end
