//
//  RH_LoginViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LoginViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"

@interface RH_LoginViewController ()
@property (nonatomic,assign) BOOL isLofinAfter ;
@end

@implementation RH_LoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.hiddenNavigationBar = YES ;

    RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/login/commonLogin.html",appDelegate.domain.trim]] ;

    self.navigationItem.titleView = nil ;
}

-(BOOL)tabBarHidden
{
    return YES ;
}

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [self.contentLoadingIndicateView hiddenView] ;

    if (error){
        self.hiddenNavigationBar = NO ;
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus] ;
    }else{
        NSString *url = self.webView.request.URL.absoluteString;

        [self.webView stringByEvaluatingJavaScriptFromString:@"$('.mui-inner-wrap').height();"];
        //账号密码自动填充
        if([url containsString:@"/login/commonLogin.html"] || [url containsString:@"/passport/login.html"]){

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *account = [defaults objectForKey:@"account"];
            NSString *password = [defaults objectForKey:@"password"];

            NSLog(@"%@%@",account,password);

            if(account != NULL && ![account isEqualToString: @""]){
                account = [NSString stringWithFormat:@"document.getElementById('username').value='%@'",account];
                [self.webView stringByEvaluatingJavaScriptFromString:account];

                if(password != NULL && ![password isEqualToString: @""]){
                    password = [NSString stringWithFormat:@"document.getElementById('password').value='%@'",password];
                    [self.webView stringByEvaluatingJavaScriptFromString:password];
                }
            }
        }
    }
}

#pragma mark-
-(void)backBarButtonItemHandle
{
    ifRespondsSelector(self.delegate, @selector(loginViewViewControllerTouchBack:)){
        [self.delegate loginViewViewControllerTouchBack:self];
    }
}
@end
