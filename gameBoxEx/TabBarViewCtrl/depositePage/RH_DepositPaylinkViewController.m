//
//  RH_DepositPaylinkViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/4/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositPaylinkViewController.h"
#import <WebKit/WebKit.h>
@interface RH_DepositPaylinkViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)WKWebView *MyWebView;
@end

@implementation RH_DepositPaylinkViewController
-(BOOL)isSubViewController
{
    return YES;
}
-(void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.MyWebView = [[WKWebView alloc]initWithFrame:self.contentView.frame];
    NSURL * url = [NSURL URLWithString:self.urlStr];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
//    [request addValue:[Global Datatoken]forHTTPHeaderField:@"token"];
    [self.MyWebView loadRequest:request];
    
    self.MyWebView.UIDelegate=self;
    self.MyWebView.navigationDelegate=self;
    [self.contentView addSubview:self.MyWebView];
}
// 在收到响应开始加载后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //返回支付宝的信息字符串，alipays:// 以后的为支付信息，这个信息后台是经过 URLEncode 后的，前端需要进行解码后才能跳转支付宝支付（坑点）
    
    //https://ds.alipay.com/?from=mobilecodec&scheme=alipays://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=https%253A%252F%252Fqr.alipay.com%252Fbax041244dd0qf8n6ras805b%253F_s%253Dweb-other
    
    NSString *urlStr = [navigationResponse.response.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([urlStr containsString:@"alipays://"]) {
        
        NSRange range = [urlStr rangeOfString:@"alipays://"]; //截取的字符串起始位置
        NSString * resultStr = [urlStr substringFromIndex:range.location]; //截取字符串
        
        NSURL *alipayURL = [NSURL URLWithString:resultStr];
        
        [[UIApplication sharedApplication] openURL:alipayURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
            
        }];
    }
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}
@end
