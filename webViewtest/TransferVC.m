//
//  TransferVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/3/29.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "TransferVC.h"
#import "CustomVC.h"
#import "GameVC.h"
#import "AppDelegate.h"
#import "iKYLoadingHubView.h"
#import "ViewController.h"
#import "NSString+Tool.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface TransferVC ()

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *transferWV;
@property NSString *domain;
@property BOOL selfIsLogin;
@property BOOL isLogin;
@property NSString *loadUrl;
@property iKYLoadingHubView *loadingHubView;
@property int loginId;

@end

@implementation TransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.domain = _appDelegate.domain;
    self.selfIsLogin = _appDelegate.isLogin;
    self.loginId = 0;
    
    _isLogin = _appDelegate.isLogin;
    
    //加载动画
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(rx.size.width/2-100, rx.size.height/2-75, 200, 150)];
    [self.view addSubview:_loadingHubView];
    [_loadingHubView showHub];
    [_loadingHubView setHidden:YES];
    
    _transferWV.scrollView.bounces=NO;
    
    //请求链接
    if ([@"integrated" isEqualToString:SITE_TYPE]) {
        _loadUrl = [NSString stringWithFormat:@"%@%@",_domain,@"/transfer/index.html"];
    } else if ([@"lottery" isEqualToString:SITE_TYPE]) {
        _loadUrl = [NSString stringWithFormat:@"%@%@",_domain,@"/lottery/mainIndex.html"];
    }
    
    //2 调用系统方法直接访问
    if(self.appDelegate.isLogin){
        [self.transferWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
    }
    
    //3 设置网页自适应
    self.transferWV.scalesPageToFit = YES;
    
    
    //4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.transferWV.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //代理方法  不遵守代理  就无法调用他的方法
    self.transferWV.delegate=self;
    NSLog(@"viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//即将进入这个界面加载该方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_appDelegate.gotoIndex != -1){
        self.tabBarController.selectedIndex = _appDelegate.gotoIndex;
        _appDelegate.gotoIndex = -1;
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //判断是否登录
    if(self.appDelegate.isLogin || [@"lottery" isEqualToString:SITE_TYPE]){
        [_transferWV setHidden:NO];
        if(_loginId == 0){
            _loginId = 1;
            [self.transferWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
        }
    } else {
        [_transferWV setHidden:YES];
        if(_selfIsLogin){
            [self.transferWV reload];
            _selfIsLogin = false;
        }
        NSString *prompt = @"提示";
        NSString *message = @"您尚未登录";
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
    
    if ([@"lottery" isEqualToString:SITE_TYPE]) {
        [_transferWV stringByEvaluatingJavaScriptFromString:@"window.page.menu.getHeadInfo()"];
    }
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
    [_loadingHubView setHidden:YES];
    [_loadingHubView dismissHub];
    JSContext *context=[_transferWV valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"gotoIndex"] = ^(){
        NSArray *args = [JSContext currentArguments];
        JSValue *indexJV = args[0];
        if([webView.request.URL.absoluteString containsString:@"/game.html"] && [indexJV.toString intValue] == 0){
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_domain]]];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tabBarController.selectedIndex = [indexJV.toString intValue];
            });
        }
        NSLog(@"gotoIndex:%@",indexJV.toString);
    };
    
    context[@"getLoginState"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        NSString *isLogin = [args[0] toString];
        
        NSLog(@"isLogin:%@",isLogin);
        
        if([isLogin isEqualToString:@"true"]){
            _appDelegate.isLogin = YES;
            self.selfIsLogin = YES;
        } else  {
            _appDelegate.isLogin = NO;
            self.selfIsLogin = NO;
            _appDelegate.loginId ++;
            [self.transferWV stopLoading];
            NSString *prompt = @"提示";
            NSString *message = @"请先登录[102]";
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
    
    context[@"reload"] = ^() {
        [self.transferWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
    };
    
    context[@"gotoGame"] = ^() {
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
            if (![_appDelegate.customUrl startsWith:@"http"]) {
                self.appDelegate.customUrl = [NSString stringWithFormat:@"%@%@", _domain, _appDelegate.customUrl];
                NSLog(@"game url = %@", _appDelegate.customUrl);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:GVC animated:YES];
        });
    };
    
    context[@"gotoTab"] = ^() {
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
    
    context[@"loginOut"] = ^(){
        //清空单个
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"++++++loginOut++++++");
        self.appDelegate.isLogin = false;
        _appDelegate.loginId ++;
        _isLogin = false;
    };
    
    context[@"gotoCustom"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        JSValue *customUrl;
        
        for (JSValue *jsVal in args) {
            customUrl = jsVal;
            NSLog(@"%@", jsVal.toString);
        }
        
        CustomVC *customVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomVC"];
        
        if (args[0] != NULL) {
            _appDelegate.customUrl = customUrl.toString;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:customVC animated:YES];
            //[self presentViewController:customVC animated:YES completion:nil];
        });
        
        NSLog(@"-------End Log-------");
    };
    
    if (![@"lottery" isEqualToString:SITE_TYPE]) {
        [webView stringByEvaluatingJavaScriptFromString:@"getLoginState(isLogin);"];
    }
    NSLog(@"加载成功");
}

//网页加载失败调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_loadingHubView setHidden:YES];
    [self setErrorHtml:webView];
    NSLog(@"加载失败");
}

@end
