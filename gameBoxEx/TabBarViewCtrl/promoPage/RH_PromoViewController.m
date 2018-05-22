//
//  RH_PromoViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_PromoViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_PromoViewController.h"

@interface RH_PromoViewController ()
@end

@implementation RH_PromoViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;

    //请求链接
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.domain,@"/discounts/index.html"]] ;
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
    return NO ;
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
    [self reloadWebView] ;
}

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;
}

#pragma mark-

@end
