//
//  ServiceVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/3/25.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "ServiceVC.h"
#import "CustomVC.h"
#import "AppDelegate.h"
#import "iKYLoadingHubView.h"
#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ServiceVC ()

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *serviceWV;
@property NSString *domain;
@property BOOL isLoad;
@property iKYLoadingHubView *loadingHubView;
@property NSString *loadUrl;
@property BOOL selfIsLogin;
@property int loginId;

- (void)showPage;

@end

@implementation ServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.domain = _appDelegate.domain;
    self.selfIsLogin = _appDelegate.isLogin;
    self.loginId = 0;
    _isLoad = false;
    
    //加载动画
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(rx.size.width/2-100, rx.size.height/2-75, 200, 150)];
    [self.view addSubview:_loadingHubView];
    [_loadingHubView showHub];
    
    _serviceWV.scrollView.bounces=NO;
    //2调用系统方法直接访问
    if([@"lottery" isEqualToString:SITE_TYPE]){
        _loadUrl = [NSString stringWithFormat:@"%@%@",_domain,@"/lottery/bet/betOrders.html"];
        if (self.appDelegate.isLogin) {
            [self.serviceWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
        }
    }
    
    //3设置网页自适应
    self.serviceWV.scalesPageToFit = YES;
    
    //4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.serviceWV.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //5. 代理方法  不遵守代理  就无法调用他的方法
    self.serviceWV.delegate=self;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//即将进入这个界面加载该方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.showPage;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if ([@"lottery" isEqualToString:SITE_TYPE]) {
        if(_appDelegate.gotoIndex != -1){
            if(_appDelegate.gotoIndex == self.tabBarController.selectedIndex){
                [_serviceWV reload];
            }else{
                self.tabBarController.selectedIndex = _appDelegate.gotoIndex;
            }
            _appDelegate.gotoIndex = -1;
        }
        
        //判断是否登录
        if(self.appDelegate.isLogin) {
            NSLog(@"refresh data...");
            [_serviceWV setHidden:NO];
            [_serviceWV stringByEvaluatingJavaScriptFromString:@"window.page.refreshBetOrder()"];
            if(_loginId != _appDelegate.loginId){
                _loginId = _appDelegate.loginId;
                [self.serviceWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
            }
        } else {
            [_loadingHubView dismissHub];
            [_serviceWV setHidden:YES];
            
            if(_selfIsLogin){
                [self.serviceWV reload];
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
    }
}

- (void)showPage{
    if(_isLoad){
        return;
    }
    
    if(![@"lottery" isEqualToString:SITE_TYPE] && [_appDelegate.servicePath containsString: @"http"]){
        NSLog(@"%@",_appDelegate.servicePath);
        _isLoad = true;
        self.serviceWV.scalesPageToFit = YES;
        self.serviceWV.dataDetectorTypes = UIDataDetectorTypeAll;
        self.serviceWV.delegate=self;
        [self.serviceWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_appDelegate.servicePath]]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _appDelegate.loginId = 1;
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
    NSLog(@"加载成功");
    
    [_loadingHubView setHidden:YES];
    JSContext *context=[_serviceWV valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
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
        });
        
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
    
    if ([@"lottery" isEqualToString:SITE_TYPE]) {
        [webView stringByEvaluatingJavaScriptFromString:@"getLoginState(isLogin);"];
    }
}

//网页加载失败调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_loadingHubView setHidden:YES];
    [_loadingHubView dismissHub];
    [self setErrorHtml:webView];
    NSLog(@"ServiceVC 加载失败");
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
