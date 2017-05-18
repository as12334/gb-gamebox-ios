//
//  GameVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/3/29.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "GameVC.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "iKYLoadingHubView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface GameVC ()<NSURLConnectionDataDelegate>
/**
 -  访问url链接
 */
@property(nonatomic,strong)NSURL *url;
@property(nonatomic,weak)IBOutlet UIWebView *webView;
@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *gameWV;
@property NSString *domain;
@property iKYLoadingHubView *loadingHubView;
- (void)ocjs;

@end

@implementation GameVC

//每次进入界面只执行一次
- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.domain = _appDelegate.domain;
    
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(rx.size.width/2-100, rx.size.height/2-75, 200, 150)];
    [self.view addSubview:_loadingHubView];
    [_loadingHubView showHub];
    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy=NSHTTPCookieAcceptPolicyAlways;
    _gameWV.scrollView.bounces=NO;
    
    //1.创建一个字符创
    NSString *Request = [NSString stringWithFormat:@"%@",_appDelegate.customUrl];
    
    //2.调用系统方法直接访问
//    if([_appDelegate.customUrl containsString:@"https://"]){
//        NSURL *url = [NSURL URLWithString:_appDelegate.customUrl];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//        [connection start];
//    }else{
        [self.gameWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Request]]];
//    }
    
    //3设置网页自适应
    self.gameWV.scalesPageToFit = YES;
    
    //4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.gameWV.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //代理方法  不遵守代理  就无法调用他的方法
    self.gameWV.delegate=self;
    
    self.ocjs;
    
    NSLog(@"main");
}


//开始加载网页，不仅监听我们指定的请求，还会监听内部发送的请求
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:NO];
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"开始加载%@", url);
    
    if([url containsString:_domain]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}
//
//网页加载完毕之后会调用该方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:YES];
    NSLog(@"加载成功");
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)ocjs{
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[_gameWV valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"goBack"] = ^() {
        NSLog(@"+++++++GoBack Log+++++++");
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    context[@"reload"] = ^() {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_appDelegate.customUrl]]];
    };
}

- (IBAction)backWV:(UIButton *)sender {
    if(_gameWV.canGoBack){
        _gameWV.goBack;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
