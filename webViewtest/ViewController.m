//
//  ViewController.m
//  webViewtest
//
//  Created by 牛奶哈哈的小屋 on 2017/3/6.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "ViewController.h"
#import "BViewVC.h"
#import "CustomVC.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "iKYLoadingHubView.h"
#import "PayVC.h"
#import "GameVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate,UITabBarDelegate>//设置代理

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property NSString *domain;
@property BOOL isLogin;
@property AppDelegate *appDelegate;
@property NSString *getServicePath;
@property iKYLoadingHubView *loadingHubView;
@property int loginId;
@property BOOL isLofinAfter;

- (void) gotoCustom;
- (void) getService;
- (void) login;
- (NSString *)stringFromHexString:(NSString *)hexString;
- (void) autoLogin;
- (void) stopLoadWV;
@end

@implementation ViewController

//每次进入界面只执行一次
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginId = 0;
    self.appDelegate = [[UIApplication sharedApplication] delegate];
//    self.appDelegate.domain = @"http://192.168.0.150:8089/";
    self.domain = _appDelegate.domain;
    self.isLofinAfter = false;
    _mainWebView.scrollView.bounces=NO;
    
    NSLog(@"----url:%@",_appDelegate.domain);
    
    _isLogin = _appDelegate.isLogin;
    
    //初始化动画
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
    [self.view addSubview:_loadingHubView];
    
    [_loadingHubView showHub];
    
    //2调用系统方法直接访问
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_domain]]];

    //3设置网页自适应
    self.mainWebView.scalesPageToFit = YES;
    
    //4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.mainWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //5. 代理方法  不遵守代理  就无法调用他的方法
    self.mainWebView.delegate=self;
    
    
    [self.mainWebView reload];
    self.getService;

    self.autoLogin;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    NSLog(@"main");
    
}

//开始加载网页，不仅监听我们指定的请求，还会监听内部发送的请求
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:NO];
    
    NSLog(@"开始加载");
}
//
//网页加载完毕之后会调用该方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if(_isLofinAfter){
        self.isLofinAfter = false;
        [self.mainWebView stringByEvaluatingJavaScriptFromString:@"sessionStorage.is_login=true;"];
    }
    //    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
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
            //[self presentViewController:customVC animated:YES completion:nil];
        });
        //[self presentViewController:customVC animated:YES completion:nil];
        NSLog(@"-------gotoPay-------");
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
    
    context[@"goBack"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        GameVC *GVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GameVC"];
        [self.navigationController pushViewController:GVC animated:YES];
    };
    
    context[@"gotoIndex"] = ^(){
        NSArray *args = [JSContext currentArguments];
        JSValue *indexJV = args[0];
        if([_mainWebView.request.URL.absoluteString containsString:@"/game.html"] && [indexJV.toString intValue] == 0){
            [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_domain]]];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tabBarController.selectedIndex = [indexJV.toString intValue];
            });
        }
        NSLog(@"gotoIndex:%@",indexJV.toString);
    };

    context[@"loginOut"] = ^(){
        //清空缓存
//        NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
//        [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
        //清空单个
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"++++++loginOut++++++");
        self.appDelegate.isLogin = false;
        _appDelegate.loginId ++;
        _isLogin = false;
    };

    context[@"loginState"] = ^(){
        
        NSLog(@"-----------loginState-----------");
        
                NSArray *args = [JSContext currentArguments];
                NSString *isLogin = [args[0] toString];
        
                NSLog(@"isLogin:%@",isLogin);
        
                if([isLogin isEqualToString:@"true"]){
                    _appDelegate.isLogin = YES;
                }else{
                    self.appDelegate.loginId ++;
                    _appDelegate.isLogin = NO;
                    // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号异常退出" preferredStyle:UIAlertControllerStyleAlert];
        
                    // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
        
                    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        
                    }];
        
                    // 3.将“取消”和“确定”按钮加入到弹框控制器中
        
                    [alertVc addAction:cancle];
        
                    [self presentViewController:alertVc animated:YES completion:^{nil;}];
                    return;
                }
        
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

    context[@"reload"] = ^() {
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_domain]]];
    };
//    if(_appDelegate.isLogin){
//        [webView stringByEvaluatingJavaScriptFromString:@"loginState(isLogin);"];
//    }
    [_loadingHubView setHidden:YES];
    NSLog(@"加载成功");
    
}


//网页加载失败调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_loadingHubView setHidden:YES];
    [self setErrorHtml:webView];
    
    NSLog(@"加载失败");
}

//每次执行
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
//    if(self.appDelegate.isLogin){
//        if(_isLogin){
//            return;
//        }else{
//            [self.mainWebView reload];
//            _isLogin = true;
//        }
//        NSLog(@"~~~~~我是一个华丽丽的分割线 啊嘞~~~~");
//    }else{
//        if(_isLogin){
//            [self.mainWebView reload];
//            _isLogin = false;
//        }
//    }
    
    if(_appDelegate.goLogin){
        self.autoLogin;
        _appDelegate.goLogin = NO;
    }
    
    if(_loginId != _appDelegate.loginId){
        [self.mainWebView stringByEvaluatingJavaScriptFromString:@"sessionStorage.is_login=true;"];
        _loginId = _appDelegate.loginId;
        [self.mainWebView reload];
    }
    
    if(![_appDelegate.gotoIndexUrl isEqualToString:@""]){
        NSLog(@"gotoIndexURL%@",[NSString stringWithFormat:@"%@%@",_domain,_appDelegate.gotoIndexUrl]);
        
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_domain,_appDelegate.gotoIndexUrl]]]];
        _appDelegate.gotoIndexUrl = @"";
    }
    
    if(![_appDelegate.goBackURL isEqualToString:@""]){
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_domain,_appDelegate.goBackURL]]]];
        _appDelegate.goBackURL = @"";
    }
    
    NSLog(@"~~~~~我是一个华丽丽的分割线 啊嘞~~~~%i%d",self.loginId,_appDelegate.loginId);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[[NSScanner alloc] initWithString:hexCharStr] autoContentAccessingProxy];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
}

- (IBAction)ClickBtn:(UIButton *)sender {
    CustomVC *BVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomVC"];
    //BViewVC *BVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BViewVC"];
    [self.navigationController pushViewController:BVC animated:YES];
}

- (void) gotoCustom{
    CustomVC *BVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomVC"];
    [self.navigationController pushViewController:BVC animated:YES];
}


void alertView(){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"你的操作是非法的，你要继续吗" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}

- (void)login{
    //    //接口网站
    NSString *path = [NSString stringWithFormat:@"%@%@",_domain,@"/passport/login.html"];
    NSHTTPCookieStorage *cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSDictionary *cd = @{@"User-Agent":@"app_ios"};
    NSHTTPCookie *cookies = [[NSHTTPCookie alloc]initWithProperties:cd];
    NSDictionary *headers=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //创建网络请求管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[headers objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    //请求参数和get请求类同 但是第二个参数：参数列表根据接口文档而定
    [manager POST:path parameters:@{@"username":@"qwer1234",@"password":@"12341234"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"login---%@",responseString);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求登录接口失败：%@",error);
    }];
    
}

- (void) autoLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [defaults objectForKey:@"account"];
    NSString *password = [defaults objectForKey:@"password"];
    
    if([self isBlankString:password]){
        NSLog(@"密码为空");
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@%@",_domain,@"/passport/login.html"];
    NSURL * URL = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //NSDictionary *paraDict = @{@"username":@"qwer1234",@"password":@"12341234"};
    
    NSString * postString = [NSString stringWithFormat:@"username=%@&password=%@",account,password];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];//将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    
//    NSMutableString *cookieString = [[NSMutableString alloc] init];
//    [cookieString appendFormat:@"X-Requested-With", @"XMLHttpRequest"];
//    [cookieString appendFormat:@"User-Agent", @"app_ios"];
    
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setValue:@"app_ios" forHTTPHeaderField:@"User-Agent"];
    
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:postData];//设置请求的参数
    
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
        _appDelegate.isLogin = false;
    }else{
        //NSLog(@"response : %@",response);
        NSString *data = [[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding];
        NSLog(@"backData : %@",data);
        
        if ([data containsString:@"\"success\":true"]) {
            NSLog(@"登录成功");
            _appDelegate.isLogin = true;
            self.isLofinAfter = true;
            //[self.mainWebView reload];
        } else {
            NSLog(@"登录失败");
            CustomVC *customVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomVC"];
            _appDelegate.customUrl = @"/login/commonLogin.html";
            _appDelegate.isLogin = false;
            [self.navigationController pushViewController:customVC animated:YES];
        }
        
    }
};

- (void)getService {
    
    NSLog(@"----getService-----");
    //1.拿到网站
    NSString *path = [NSString stringWithFormat:@"%@%@",_domain,@"/index/getCustomerService.html"];
    
    NSHTTPCookieStorage *cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSDictionary *cd = @{@"User-Agent":@"IOS"};
    NSHTTPCookie *cookies = [[NSHTTPCookie alloc]initWithProperties:cd];
    NSDictionary *headers=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //2.创建字一个网络请求管理者对象 （http会话管理者）  此对象不是单例对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //3.设置网络传输的类型：这里一般都是二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //4.设置content-type请求头 （可选）这里表示可以接受的数据类型（text/html）MIME
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[headers objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    //5.get请求
    /*
     AF的get请求方式
     第一个参数：path网址路径 字符串类型
     第二个参数：参数列表，这里放入nil 一般get方法都是nil
     第三个参数：进度代码块 进度一般在调试的时候用到，通常状况也是nil
     第四个参数：成功代码块 请求数据成功后会调用到成功代码块
     第五个参数：失败代码块 请求数据失败后回调用到失败代码块
     */
    
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"成功");
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---%@",responseString);
        self.appDelegate.servicePath = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        //解析
        //                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //                NSLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败：%@",error);
        
    }];
    
}


- (void) showLog{
    NSLog(@"sl");
}


@end
