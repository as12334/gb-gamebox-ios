//
//  RH_LotteryRecPageViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LotteryRecPageViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_LoginViewController.h"

@interface RH_LotteryRecPageViewController ()
@end

@implementation RH_LotteryRecPageViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.navigationItem.titleView = nil ;
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.domain,@"/lottery/bet/betOrders.html"]] ;

    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
}

-(BOOL)tabBarHidden
{
    return NO ;
}

-(BOOL)needLogin
{
    return YES ;
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

-(void)updateView{
    if (self.appDelegate.isLogin){
        [self reloadWebView] ;
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
-(void)setupJSCallBackOC:(JSContext *)jsContext
{
    [super setupJSCallBackOC:jsContext] ;

}

-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;

    if (self.appDelegate.isLogin){
        [self.webView stringByEvaluatingJavaScriptFromString:@"window.page.refreshBetOrder()"] ;
    }
}

@end
