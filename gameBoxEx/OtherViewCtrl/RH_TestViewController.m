//
//  RH_TestViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_TestViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"

@interface RH_TestViewController ()
@property(nonatomic,strong,readonly) UIImageView *gameBgImage ;
@property(nonatomic,strong,readonly) UIImageView *imageFirstPage ;
@property(nonatomic,strong)CLButton * homeBack;
@property(nonatomic,strong)CLButton * backBack;
@end

@implementation RH_TestViewController
@synthesize gameBgImage = _gameBgImage              ;
@synthesize imageFirstPage = _imageFirstPage    ;
-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.autoShowWebTitle = NO ;
    
    if([self.appDelegate.customUrl containsString:@"http"]){
        self.webURL = [NSURL URLWithString:self.appDelegate.customUrl] ;
    }else{
        self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.appDelegate.domain.trim,self.appDelegate.customUrl]] ;
    }
    
//    [self reloadWebView] ;
    [self.contentView addSubview:self.gameBgImage];
    [self.contentView bringSubviewToFront:self.gameBgImage] ;
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.gameBgImage setUserInteractionEnabled:YES];//开启图片控件的用户交互
    [self.gameBgImage addGestureRecognizer:pan];
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeTrailing, self.contentView, -0.0f) ;
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeBottom, self.contentView, -60.0f) ;

}

-(BOOL)isHiddenStatusBar
{
    return YES ;
}

-(void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint point=[pan translationInView:self.view];
    NSLog(@"%f,%f",point.x,point.y);
    pan.view.center=CGPointMake(pan.view.center.x+point.x, pan.view.center.y+point.y);
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [pan setTranslation:CGPointMake(0, 0) inView:self.contentView];
}

- (UIImageView *)gameBgImage
{
    if (!_gameBgImage) {
        _gameBgImage = [[UIImageView alloc] initWithImage:ImageWithName(@"game_btn_bg")];
        _gameBgImage.translatesAutoresizingMaskIntoConstraints = NO ;
        _gameBgImage.backgroundColor = [UIColor clearColor];
        _gameBgImage.alpha = 0.3f ;
        _gameBgImage.contentMode = UIViewContentModeScaleAspectFill;
        _gameBgImage.clipsToBounds = YES;
        _gameBgImage.userInteractionEnabled = YES;
        
        _homeBack = [[CLButton alloc] initWithFrame:CGRectMake(0, 0, _gameBgImage.boundWidth, floor(_gameBgImage.boundHeigh/2.0))];
        _homeBack.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [_homeBack setBackgroundColor:BlackColorWithAlpha(0.2f)
                             forState:UIControlStateHighlighted];
        [_homeBack setBackgroundImage:ImageWithName(@"icon_home") forState:UIControlStateNormal] ;
        [_homeBack addTarget:self
                      action:@selector(_homeBackHandle)
            forControlEvents:UIControlEventTouchUpInside];
        [_gameBgImage addSubview:_homeBack];
        
        
        _backBack = [[CLButton alloc] initWithFrame:CGRectMake(0, floor(_gameBgImage.boundHeigh/2.0)+1, _gameBgImage.boundWidth, floor(_gameBgImage.boundHeigh/2.0))];
        _backBack.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [_backBack setBackgroundColor:BlackColorWithAlpha(0.2f)
                             forState:UIControlStateHighlighted];
        [_backBack setBackgroundImage:ImageWithName(@"title_back") forState:UIControlStateNormal] ;
        [_backBack addTarget:self
                      action:@selector(_backBackHandle)
            forControlEvents:UIControlEventTouchUpInside];
        [_gameBgImage addSubview:_backBack];
        
    }
    
    return _gameBgImage;
}
-(void)_homeBackHandle
{
    [self.navigationController popToRootViewControllerAnimated:YES] ;
    if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
        self.myTabBarController.selectedIndex = 2 ;
    }else{
        self.myTabBarController.selectedIndex = 0 ;
    }
}

-(void)_backBackHandle
{
    [self backBarButtonItemHandle] ;
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
    return YES ;
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
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"-webView finish ---:",webView);
//    [self _setContentShowState:RH_WebViewContentShowStateShowed];
//    [self _setLoading:NO];
//    NSString *url = webView.request.URL.absoluteString;
//    ////账号密码自动填充
//    if([url containsString:@"/login/commonLogin.html"] || [url containsString:@"/passport/login.html"]){
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *account = [defaults objectForKey:@"account"];
//        NSString *password = [defaults objectForKey:@"password"];
//
//        NSLog(@"%@%@",account,password);
//
//        if(account != NULL && ![account isEqualToString: @""]){
//            account = [NSString stringWithFormat:@"document.getElementById('username').value='%@'",account];
//            [self.webView stringByEvaluatingJavaScriptFromString:account];
//
//            if(password != NULL && ![password isEqualToString: @""]){
//                password = [NSString stringWithFormat:@"document.getElementById('password').value='%@'",password];
//                [self.webView stringByEvaluatingJavaScriptFromString:password];
//            }
//        }
//    }
//
//    //增加通用 js 处理
//    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"] ;
//    [self setupJSCallBackOC:jsContext] ;
    [self webViewDidEndLoad:nil];
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

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if  (error.code==101){//忽略不处理 。
    }else{
        [super webView:webView didFailLoadWithError:error] ;
    }
}

#pragma mark-
- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
}

@end
