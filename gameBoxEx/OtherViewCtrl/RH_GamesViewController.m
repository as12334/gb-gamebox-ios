//
//  RH_GamesViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_GamesViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"

@interface RH_GamesViewController ()
@property (nonatomic,assign) BOOL isLofinAfter ;
@end

@implementation RH_GamesViewController
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
        NSString *weixin = @"weixin";

        if ([url.lowercaseString containsString:qqWallet] || [url.lowercaseString containsString:alipay] || [url.lowercaseString containsString:weixin]) {
            NSLog(@"浏览器加载支付地址：%@", url);
            NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", url]];
            [[UIApplication sharedApplication] openURL:cleanURL];
        }
    }
}

#pragma mark-

#pragma mark  强制横屏代码
- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskLandscape;
}

////进入界面直接旋转的方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}
// 是否隐藏状态栏
//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}


@end
