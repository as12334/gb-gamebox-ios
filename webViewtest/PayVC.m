//
//  PayVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/4/7.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "PayVC.h"
#import "AppDelegate.h"
#import "iKYLoadingHubView.h"
#import "CustomVC.h"
#import "GameVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSString+Tool.h"

@interface PayVC ()<UIWebViewDelegate>

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *customWebView;
@property NSString *domain;
@property iKYLoadingHubView *loadingHubView;
@property NSString *request;
- (void)ocjs;

@end

@implementation PayVC

//每次进入界面只执行一次
- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.domain = _appDelegate.domain;
    
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(rx.size.width/2-100, rx.size.height/2-75, 200, 150)];
    [self.view addSubview:_loadingHubView];
    [_loadingHubView showHub];
    
    _customWebView.scrollView.bounces=NO;
    
    
    if([_appDelegate.customUrl containsString:@"http"]){
        self.request = _appDelegate.customUrl;
    }else{
        self.request = [NSString stringWithFormat:@"%@%@",_domain,_appDelegate.customUrl];
    }
    
    NSLog(@"%@", _request);
    //2.调用系统方法直接访问
    [self.customWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_request]]];
    
    //3设置网页自适应
    self.customWebView.scalesPageToFit = YES;
    
    //4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.customWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //代理方法  不遵守代理  就无法调用他的方法
    self.customWebView.delegate=self;
    
    //tite颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSLog(@"----PayVC----");
}


//开始加载网页，不仅监听我们指定的请求，还会监听内部发送的请求
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:NO];
    [self setErrorHtml:webView];
    NSLog(@"开始加载");
}

//网页加载完毕之后会调用该方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:YES];
    
    [self.navigationItem setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    
    NSString *url = webView.request.URL.absoluteString;
   
    NSString *qqWallet = @"https://myun.tenpay.com/";
    NSString *alipay = @"https://ds.alipay.com/";
    NSString *weixin = @"weixin";
    
    if ([url startsWith:qqWallet] || [url startsWith:alipay] || [[url toLowerCase] containsString:weixin]) {
        NSLog(@"浏览器加载支付地址：%@", url);
        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", url]];
        [[UIApplication sharedApplication] openURL:cleanURL];
    }
    
    self.ocjs;
    
    NSLog(@"加载成功%@",url);
}

//网页加载失败调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_loadingHubView setHidden:YES];
    [self setErrorHtml:webView];
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"加载失败%@", url);
}

- (void)ocjs{
    //    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[_customWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
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
            [self.navigationController pushViewController:customVC animated:YES];
            //[self presentViewController:customVC animated:YES completion:nil];
        });
        //[self presentViewController:customVC animated:YES completion:nil];
        NSLog(@"-------goto-------");
    };
    
    context[@"goBack"] = ^() {
        NSLog(@"+++++++GoBack Log+++++++");
        if(_customWebView.canGoBack){
            _customWebView.goBack;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
    context[@"loginSucc"] = ^() {
        NSLog(@"+++++++loginSucc Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
        }
        
        JSValue *jsAccount = args[0];
        JSValue *jsPassword = args[1];
        
        if(args.count >2){
            JSValue *jsIsLogin = args[2];
            if([jsIsLogin.toString isEqualToString:@"0"]){
                _appDelegate.goLogin = YES;
            }
        }
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        [defaults removeObjectForKey:@"account"];
        //        [defaults removeObjectForKey:@"password"];
        
        [defaults setObject:jsAccount.toString forKey:@"account"];
        [defaults setObject:jsPassword.toString forKey:@"password"];
        _appDelegate.isLogin = true;
        _appDelegate.loginId ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
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
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:GVC animated:YES];
        });
    };
    
    context[@"gotoIndex"] = ^() {
        NSArray *args = [JSContext currentArguments];
        JSValue *indexJV = args[0];
        NSLog(@"+++++++custom gotoIndex+++++++%@",indexJV.toString);
        _appDelegate.gotoIndex = [indexJV.toString intValue];
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    context[@"goBackUrl"] = ^(){
        NSLog(@"-------goBackUrl-------");
        NSArray *args = [JSContext currentArguments];
        _appDelegate.goBackURL = [args[0] toString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    };
    
    context[@"reload"] = ^() {
        [self.customWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_request]]];
    };
}


@end
