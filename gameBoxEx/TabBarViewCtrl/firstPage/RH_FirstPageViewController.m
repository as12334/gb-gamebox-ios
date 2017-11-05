//
//  RH_FirstPageViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_FirstPageViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_CustomViewController.h"

@interface RH_FirstPageViewController ()
@end

@implementation RH_FirstPageViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.webURL = [NSURL URLWithString:self.domain] ;
    self.navigationItem.titleView = nil ;
    [self autoLogin] ;
    [self getService] ;
    [self setHiddenTabBar:NO];
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    
}

-(BOOL)tabBarHidden
{
    return NO ;
}

-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        NSLog(@"received loginstatus changed:%d",self.appDelegate.isLogin) ;
        [self setNeedUpdateView] ;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(void)updateView
{
    [self reloadWebView] ;
}

#pragma mark-
- (void) autoLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [defaults objectForKey:@"account"];
    NSString *password = [defaults objectForKey:@"password"];

    if(account.length==0 || password.length ==0){
        return;
    }

    NSString *path = [NSString stringWithFormat:@"%@%@",self.domain,@"/passport/login.html"];
    NSURL * URL = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSString * postString = [NSString stringWithFormat:@"username=%@&password=%@",account,password];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];//将请求参数字符串转成NSData类型

    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]  init];

    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setValue:@"app_ios, iPhone" forHTTPHeaderField:@"User-Agent"];

    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:postData];//设置请求的参数

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if (connectionError) {
                                   [self.appDelegate updateLoginStatus:false] ;
                               }else{
                                   NSString *rtnStr = [[NSString alloc]initWithData:data
                                                                         encoding:NSUTF8StringEncoding];

                                   if ([rtnStr containsString:@"\"success\":true"]) {
                                       [self.appDelegate updateLoginStatus:true] ;
                                       [self performSelectorOnMainThread:@selector(reloadWebView) withObject:nil waitUntilDone:YES] ;
                                   }
                               }
                           }] ;

};


- (void)getService {
    //1.拿到网站
    NSString *path = [NSString stringWithFormat:@"%@%@",self.domain,@"/index/getCustomerService.html"];
    //2.创建字一个网络请求管理者对象 （http会话管理者）  此对象不是单例对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //3.设置网络传输的类型：这里一般都是二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---%@",responseString);
        [self.appDelegate updateServicePath:[responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""]] ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败：%@",error);
    }];
}

- (void)demoEnter{
    NSString *path = [NSString stringWithFormat:@"%@%@",self.domain,@"/demo/lottery.html"];
    NSURL * URL = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];

    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setValue:@"app_ios, iPhone" forHTTPHeaderField:@"User-Agent"];

    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
        [self.appDelegate updateLoginStatus:false] ;
    }else{
        NSLog(@"response : %@",response);
        NSString *data = [[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding];
        NSLog(@"backData : %@",data);

        if ([data containsString:@"true"]) {
            NSLog(@"试玩登录成功");
            [self.appDelegate updateLoginStatus:true] ;
            [self.webView stringByEvaluatingJavaScriptFromString:@"window.page.getHeadInfo()"];
        } else {
            NSLog(@"试玩登录失败");
            self.appDelegate.customUrl = @"/login/commonLogin.html";
            [self.appDelegate updateLoginStatus:false] ;
            [self showViewController:[RH_CustomViewController viewController] sender:self];
        }
    }
}

#pragma mark-
-(void)setupJSCallBackOC:(JSContext *)jsContext
{
    [super setupJSCallBackOC:jsContext] ;

    jsContext[@"demoEnter"] = ^() {
        [self demoEnter];
    };
}

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;
    if (!error){
        if (self.appDelegate.isLogin)
        {
            [self.webView stringByEvaluatingJavaScriptFromString:@"sessionStorage.is_login=true;"];
            [self.webView stringByEvaluatingJavaScriptFromString:@"window.page.getHeadInfo()"] ;//刷新webview 信息
        }
    }
}
#pragma mark-
@end
