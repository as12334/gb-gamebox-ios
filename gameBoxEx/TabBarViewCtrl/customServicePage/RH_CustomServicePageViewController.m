//
//  RH_CustomServicePageViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_CustomServicePageViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_LoginViewController.h"
#import "RH_API.h"
@interface RH_CustomServicePageViewController ()<RH_ServiceRequestDelegate>
@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,assign)BOOL statusMark;
@end

@implementation RH_CustomServicePageViewController
{
    NSInteger _loadingCount ;
//    RH_APPDelegate *_appDelegate;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.serviceRequest startV3GetCustomService];
}
-(void)viewDidLoad
{
    [super viewDidLoad] ;
    
    _loadingCount = 0 ;
    self.navigationItem.titleView = nil ;
  
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    [self.webView setScalesPageToFit:NO];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.webView.frame = self.view.frame;
}

-(BOOL)tabBarHidden
{
    return NO ;
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

#pragma mark-
-(void)loginViewViewControllerLoginSuccessful:(RH_LoginViewController*)loginViewContrller
{
    [loginViewContrller hideWithDesignatedWay:YES completedBlock:^{
        
        [self reloadWebView] ;
    }] ;
}

-(void)loginViewViewControllerTouchBack:(RH_LoginViewController *)loginViewContrller
{
    [loginViewContrller hideWithDesignatedWay:YES completedBlock:^{
        self.tabBarController.selectedIndex = 0 ;
    }] ;
}

#pragma mark-
//开始加载

-(void)webViewBeginLoad
{
    if (!_loadingCount){
        [super webViewBeginLoad] ;
        _loadingCount++ ;
    }
}

-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;
    if (!error){
        if (self.appDelegate.isLogin){
            [self.webView stringByEvaluatingJavaScriptFromString:@"window.page.refreshBetOrder()"] ;
        }
    }
    
}
-(void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeV3CustomService) {
        self.urlString = [[data objectForKey:@"data"]objectForKey:@"customerUrl"];
        self.statusMark = [[data objectForKey:@"data"]objectForKey:@"isInlay"];
//        self.statusMark=false;
        if (self.statusMark==true ) {
            self.webURL = [NSURL URLWithString:self.urlString];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString]];
        }
        
    }
}
@end
