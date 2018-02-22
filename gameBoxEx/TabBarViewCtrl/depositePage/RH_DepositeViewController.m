//
//  RH_DepositeViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_DepositeViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"

@interface RH_DepositeViewController ()
@end

@implementation RH_DepositeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self.webView reload];
}

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/wallet/deposit/index.html",self.domain]] ;
    self.navigationItem.titleView = nil ;

    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
}

-(BOOL)tabBarHidden
{
    return NO ;
}

-(BOOL)needLogin
{
    return YES  ;
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
        [self reloadWebView] ;
    }
}

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;
}



@end
