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

@interface RH_CustomServicePageViewController ()
@property (nonatomic,assign) BOOL isLofinAfter ;
@end

@implementation RH_CustomServicePageViewController
{
    NSInteger _loadingCount ;
}

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    _loadingCount = 0 ;
    self.navigationItem.titleView = nil ;
    self.webURL = [NSURL URLWithString:self.appDelegate.servicePath.trim];

    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
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
        [self.webView stringByEvaluatingJavaScriptFromString:@"window.page.getHeadInfo()"] ;//刷新webview 信息
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

@end
