//
//  TransferVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/3/29.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "TransferVC.h"
#import "CustomVC.h"
#import "AppDelegate.h"
#import "iKYLoadingHubView.h"
#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface TransferVC ()

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *transferWV;
@property NSString *domain;
@property BOOL selfIsLogin;
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
    
    //加载动画
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(rx.size.width/2-100, rx.size.height/2-75, 200, 150)];
    [self.view addSubview:_loadingHubView];
    [_loadingHubView showHub];
    [_loadingHubView setHidden:YES];
    
    _transferWV.scrollView.bounces=NO;
    
    //请求链接
    _loadUrl = [NSString stringWithFormat:@"%@%@",_domain,@"/transfer/index.html"];
    
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
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //判断是否登录
    if(self.appDelegate.isLogin){
        //判断当前页面是否登录
//        if(_selfIsLogin){
//            return;
//        }
//        
//        _selfIsLogin = true;
//        [self.transferWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
        [_transferWV setHidden:NO];
        if(_loginId != _appDelegate.loginId){
            _loginId = _appDelegate.loginId;
            [self.transferWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
        }
    }else{
        
        [_transferWV setHidden:YES];
        if(_selfIsLogin){
            [self.transferWV reload];
            _selfIsLogin = false;
        }
        // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        
        // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"返回首页");
            self.tabBarController.selectedIndex = 0;
            
        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"立即登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
    [_loadingHubView setHidden:YES];
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
        }else{
            _appDelegate.isLogin = NO;
            self.selfIsLogin = NO;
            _appDelegate.loginId ++;
            [self.transferWV stopLoading];
            // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号异常退出" preferredStyle:UIAlertControllerStyleAlert];
            
            // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"返回首页");
                self.tabBarController.selectedIndex = 0;
                
            }];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"立即登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
    [webView stringByEvaluatingJavaScriptFromString:@"getLoginState(isLogin);"];
    NSLog(@"加载成功");
}

//网页加载失败调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_loadingHubView setHidden:YES];
    
    NSLog(@"加载失败");
}


@end
