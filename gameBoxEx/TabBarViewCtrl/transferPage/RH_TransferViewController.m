//
//  RH_TransferViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_TransferViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_TransferViewController.h"

@interface RH_TransferViewController ()
@property (nonatomic,assign) BOOL isLofinAfter ;
@end

@implementation RH_TransferViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;

    //请求链接
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.domain,@"/transfer/index.html"]] ;
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
    //此为综合站 转帐界面
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

#pragma mark-

@end
