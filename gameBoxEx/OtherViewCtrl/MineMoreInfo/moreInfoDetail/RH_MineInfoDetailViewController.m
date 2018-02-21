//
//  RH_MineInfoDetailViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/20.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineInfoDetailViewController.h"
#import <WebKit/WKWebView.h>

@interface RH_MineInfoDetailViewController ()<UIWebViewDelegate>

@end

@implementation RH_MineInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
//    [wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test01.ampinplayopt0matrix.com"]]];
//    // http://test01.ampinplayopt0matrix.com/help/firstType.html
//    [self.view addSubview:wkWebView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self ;
    /*
     关于我们:/about.html?path=about
     注册条款:/getRegisterRules.html?path=terms
     常见问题:/help/firstType.html
     */
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test01.ampinplayopt0matrix.com/help/firstType.html"]]];
    //  http://test01.ampinplayopt0matrix.com/getRegisterRules.html?path=terms

    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES ;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"") ;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"") ;
}
@end
