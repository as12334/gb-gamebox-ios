//
//  RH_PayViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_PayViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"

@interface RH_PayViewController ()
@end

@implementation RH_PayViewController
-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.autoShowWebTitle = YES ;

    if([self.appDelegate.customUrl containsString:@"http"]){
        self.webURL = [NSURL URLWithString:self.appDelegate.customUrl.trim] ;
    }else{
        self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.appDelegate.domain.trim,self.appDelegate.customUrl.trim]] ;
    }

    [self reloadWebView] ;
}

+(void)configureNavigationBar:(UINavigationBar*)navigationBar
{
    if (navigationBar){
        navigationBar.tintColor = [UIColor whiteColor] ;
        navigationBar.barTintColor = [UIColor redColor] ;
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]};
    }

    return ;
}

-(BOOL)navigationBarHidden
{
    return NO ;
}

-(BOOL)tabBarHidden
{
    return YES ;
}

-(BOOL)backButtonHidden
{
    return NO ;
}

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;

    if (!error){
        NSString *url = self.webView.request.URL.absoluteString;
        NSString *qqWallet = @"https://myun.tenpay.com/";
        NSString *alipay = @"https://ds.alipay.com/";

        if ([url.lowercaseString containsString:qqWallet] || [url.lowercaseString containsString:alipay]) {
            NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", url]];
            [[UIApplication sharedApplication] openURL:cleanURL];
        }
    }

}

#pragma mark-

@end
