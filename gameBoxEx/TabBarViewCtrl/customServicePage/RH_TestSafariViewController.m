//
//  RH_TestSafariViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/4/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_TestSafariViewController.h"
#import "RH_APPDelegate.h"
#import "RH_LoginViewController.h"
#import "coreLib.h"
@interface RH_TestSafariViewController ()<UINavigationControllerDelegate,UIWebViewDelegate>
@property(nonatomic,strong,readonly)UIWebView *webView;
@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,strong)NSNumber *statusMark;
@property(nonatomic,strong)NSNumber *urlMark;
@end

@implementation RH_TestSafariViewController
@synthesize  webView = _webView;
//-(BOOL)isSubViewController
//{
//    return YES;
//}
//-(BOOL)isHiddenNavigationBar
//{
//    return YES;
//}
-(void)viewWillAppear:(BOOL)animated
{
    self.hiddenNavigationBar = YES;
    self.hiddenTabBar = NO;
    if ([_urlMark isEqual:@1]) {
        [self.serviceRequest startV3GetCustomService];
    }
    
}
-(BOOL)tabBarHidden
{
    return NO ;
}
+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            if ([THEMEV3 isEqualToString:@"green"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            if ([THEMEV3 isEqualToString:@"green"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else{
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
            }
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
                                              NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
    }else{
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            navigationBar.barTintColor = [UIColor blackColor];
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = [UIColor blackColor] ;
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    }
}
-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
        _webView.delegate = self;
        [_webView setScalesPageToFit:NO];
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服";
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    [self.webView setScalesPageToFit:NO];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(MainScreenH==812?20.0:0.0, 0, self.isHiddenTabBar?0:49+heighStatusBar, 0);
//    if ([SID isEqualToString:@"119"] || [SID isEqualToString:@"270"]|| [SID isEqualToString:@"511"]) {
//        self.webView.scrollView.contentInset = UIEdgeInsetsMake(MainScreenH==812?20.0:0.0, 0, self.isHiddenTabBar?0:49+heighStatusBar, 0);
//    }else if ([SID isEqualToString:@"500"]||[SID isEqualToString:@"501"]){
//        self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0);
//    }else{
//        self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, self.isHiddenTabBar?0:49, 0);
//    }
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, self.isHiddenTabBar?0:49, 0);
    self.webView.frame = self.view.frame;
    [self.serviceRequest startV3GetCustomService];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissFirstVC) name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void)dismissFirstVC
{
    if ([_urlMark isEqual:@1]) {
        [self.tabBarController setSelectedIndex:0];
    }
}
-(BOOL)needLogin
{
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self setNeedUpdateView] ;
    }
}

-(void)updateView
{
    if (self.appDelegate.isLogin)
    {
        [self.webView stringByEvaluatingJavaScriptFromString:@"sessionStorage.is_login=true;"];
        
        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
            [self.webView stringByEvaluatingJavaScriptFromString:@"headInfo()"] ;
        }else{
            [self.webView stringByEvaluatingJavaScriptFromString:@"window.page.getHeadInfo()"] ;//刷新webview 信息 ;
        }
    }
}
-(void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeV3CustomService) {
        self.urlString = [[data objectForKey:@"data"]objectForKey:@"customerUrl"];
        self.statusMark = [[data objectForKey:@"data"]objectForKey:@"isInlay"];
        if ([self.statusMark isEqual:@0]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString]];
            self.urlMark=@1;
        }
        else if([self.statusMark isEqual:@1])
        {
           NSURL *webURL = [NSURL URLWithString:self.urlString];
            [self.webView loadRequest:[NSURLRequest requestWithURL:webURL]];
            [self.contentView addSubview:self.webView];
            self.urlMark=@0;
        }
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showProgressIndicatorViewWithAnimated:YES title:@"加载中"] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
        showErrorMessage(self.view, error, nil) ;
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    
}

@end
