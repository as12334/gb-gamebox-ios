//
//  CustomVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/3/25.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "CustomVC.h"
#import "AppDelegate.h"
#import "iKYLoadingHubView.h"
#import "GameVC.h"
#import "PayVC.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface CustomVC ()<UIWebViewDelegate>

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *customWebView;
@property NSString *domain;
@property iKYLoadingHubView *loadingHubView;
@property NSString *request;

@property bool isLogin;

- (void)ocjs;

@end

@implementation CustomVC

//每次进入界面只执行一次
- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.domain = _appDelegate.domain;
    
    _isLogin = _appDelegate.isLogin;
    
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(rx.size.width/2-100, rx.size.height/2-75, 200, 150)];
    
    [self.view addSubview:_loadingHubView];
    [_loadingHubView showHub];
    
    _customWebView.scrollView.bounces=NO;
    
    
    
    if([_appDelegate.customUrl containsString:@"http:"]){
        self.request = _appDelegate.customUrl;
    }else{
        self.request = [NSString stringWithFormat:@"%@%@",_domain,_appDelegate.customUrl];
    }
    
    NSLog(@"%@",_request);
    //2.调用系统方法直接访问
    [self.customWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_request]]];
    
    //3设置网页自适应
    self.customWebView.scalesPageToFit = YES;
    
    //4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.customWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //代理方法  不遵守代理  就无法调用他的方法
    self.customWebView.delegate=self;
    
    NSLog(@"----CustomVC----");
}


//开始加载网页，不仅监听我们指定的请求，还会监听内部发送的请求
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:NO];
    NSLog(@"开始加载");
}
//
//网页加载完毕之后会调用该方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:YES];
    
    NSString *url = webView.request.URL.absoluteString;
    if([_domain containsString: url]){
        
    }
    NSLog(@"加载成功%@",url);
    [webView stringByEvaluatingJavaScriptFromString:@"$('.mui-inner-wrap').height();"];
    //js方法绑定
    self.ocjs;
    
    //账号密码自动填充
    if([url containsString:@"/login/commonLogin.html"] || [url containsString:@"/passport/login.html"]){
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *account = [defaults objectForKey:@"account"];
        NSString *password = [defaults objectForKey:@"password"];
        
        NSLog(@"%@%@",account,password);
        
        if(account != NULL && ![account isEqualToString: @""]){
            account = [NSString stringWithFormat:@"document.getElementById('username').value='%@'",account];
            [_customWebView stringByEvaluatingJavaScriptFromString:account];
            
            if(password != NULL && ![password isEqualToString: @""]){
                password = [NSString stringWithFormat:@"document.getElementById('password').value='%@'",password];
                [_customWebView stringByEvaluatingJavaScriptFromString:password];
            }
        }
    }
    
    //账号退出
    if([_appDelegate.customUrl isEqualToString:@"/passport/logout.html"]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //判断是否需要登录判断
    if(![_request containsString:@"/login/commonLogin.html"] && ![_request containsString:@"/signUp/index.html"] && ![_request containsString:@"/passport/logout.html"] && ![_request containsString:@"/help/"] && ![_request containsString:@"/promoDetail.html"]){
        [webView stringByEvaluatingJavaScriptFromString:@"loginState(isLogin);"];
    }
}

//网页加载失败调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_loadingHubView setHidden:YES];
    [self setErrorHtml:webView];
    NSLog(@"加载失败");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if(_appDelegate.isLogin != _isLogin){
//        [self.customWebView reload];
//        _isLogin = _appDelegate.isLogin;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
    if(![_appDelegate.goBackURL isEqualToString:@""]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
        
        NSString *gotoUrl = [args[0] toString];
        
        if([gotoUrl containsString:@"api/detail.html"]){
            NSLog(@"%@%@",_domain,gotoUrl);
            dispatch_async(dispatch_get_main_queue(), ^{
                if([gotoUrl containsString:@"http"]){
                    [self.customWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:gotoUrl]]];
                }else{
                    [self.customWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_domain,gotoUrl]]]];
                }
            });
            return;
        }
        
        if(![_domain containsString:@"/login/commonLogin.html"] && ![_domain containsString:@"/passport/login.html"] && ![_domain containsString:@"/passport/logout.html"]){
            CustomVC *customVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomVC"];
            
            if (args[0] != NULL) {
                _appDelegate.customUrl = gotoUrl;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:customVC animated:YES];
                
            });
            NSLog(@"-------goto-------%@",_domain);
        }
        
    };
    
    context[@"goBack"] = ^() {
        NSLog(@"+++++++GoBack Log+++++++");
//        if(_customWebView.canGoBack){
//            _customWebView.goBack;
//        }else{
//            
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
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
        [self.customWebView stringByEvaluatingJavaScriptFromString:@"sessionStorage.is_login=true;"];
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
    
    context[@"gotoPay"] = ^() {
        NSArray *args = [JSContext currentArguments];
        
        JSValue *jsCustom;
        
        for (JSValue *jsVal in args) {
            jsCustom = jsVal;
        }
        NSLog(@"+++++++custom gotoPay+++++++%@",args[0]);
        
        PayVC *customVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PayVC"];
        
        if (args[0] != NULL) {
            _appDelegate.customUrl = jsCustom.toString;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:customVC animated:YES];
            //[self presentViewController:customVC animated:YES completion:nil];
        });
        //[self presentViewController:customVC animated:YES completion:nil];
        NSLog(@"-------gotoPay-------");
    };
    
    context[@"goBackUrl"] = ^(){
        NSLog(@"-------goBackUrl-------");
        NSArray *args = [JSContext currentArguments];
        _appDelegate.goBackURL = [args[0] toString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    };
    
    context[@"loginState"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        NSString *isLogin = [args[0] toString];
        
        NSLog(@"isLogin:%@",isLogin);
        
        if([isLogin isEqualToString:@"true"]){
            _appDelegate.isLogin = YES;
        }else{
            self.appDelegate.loginId ++;
            _appDelegate.isLogin = NO;
            [self.customWebView stopLoading];
            // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号异常退出" preferredStyle:UIAlertControllerStyleAlert];
            
            // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                _appDelegate.gotoIndex = 0;
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            // 3.将“取消”和“确定”按钮加入到弹框控制器中
            
            [alertVc addAction:cancle];
            
            [self presentViewController:alertVc animated:YES completion:^{nil;}];
            return;
        }
    };
    
    context[@"reload"] = ^() {
        [self.customWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_request]]];
    };
}


@end
