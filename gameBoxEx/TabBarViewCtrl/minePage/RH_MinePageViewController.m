//
//  RH_MinePageViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MinePageViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_LoginViewController.h"

@interface RH_MinePageViewController ()
@property (nonatomic,assign) BOOL isLofinAfter ;
@end

@implementation RH_MinePageViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.appDelegate.domain,@"/mine/index.html"]] ;

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
        [self performSelectorOnMainThread:@selector(reloadWebView) withObject:nil waitUntilDone:NO] ;
    }
}

#pragma mark-

@end
