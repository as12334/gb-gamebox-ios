//
//  RH_TestViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_ElecGameViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_LotteryInfoModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
@interface RH_ElecGameViewController ()<RH_ServiceRequestDelegate,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong,readonly) UIImageView *gameBgImage ;
@property(nonatomic,strong,readonly) UIImageView *imageFirstPage ;
@property(nonatomic,strong)CLButton * homeBack;
@property(nonatomic,strong)CLButton * backBack;
@property(nonatomic,strong)WKWebView *gameWebView;
@property(nonatomic,strong)WKUserContentController *userContentController;
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property(nonatomic,strong)RH_LotteryInfoModel *lotteryInfoModel;
//游戏地址
@property(nonatomic,strong)NSString *urlStr;
@end

@implementation RH_ElecGameViewController
@synthesize gameBgImage = _gameBgImage              ;
@synthesize imageFirstPage = _imageFirstPage    ;
@synthesize serviceRequest = _serviceRequest ;
-(void)viewDidLoad
{
    [super viewDidLoad] ;
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    self.userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = self.userContentController;
    self.gameWebView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    //注册方法
//    [self.userContentController addScriptMessageHandler:self  name:@"sayhello"];//注册一个name为sayhello的js方法
    
    [self.view addSubview:self.gameWebView];
    self.gameWebView.UIDelegate = self;
    self.gameWebView.navigationDelegate = self;
    
    self.gameWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.gameWebView];
    
    [self.view addSubview:self.gameBgImage];
    [self.view bringSubviewToFront:self.gameBgImage] ;
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.gameBgImage setUserInteractionEnabled:YES];//开启图片控件的用户交互
    [self.gameBgImage addGestureRecognizer:pan];
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeTrailing, self.view, -0.0f) ;
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeBottom, self.view, -60.0f) ;
    if (self.lotteryInfoModel.showGameLink.length){ //已获取的请求链接
        self.urlStr = self.lotteryInfoModel.showGameLink ;
        
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.serviceRequest startv3GetGamesLinkForCheeryLink:self.lotteryInfoModel.mGameLink] ;
    }
}
-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc]init];
        _serviceRequest.delegate = self;
    }
    return _serviceRequest;
}
-(void)setupViewContext:(id)context
{
    RH_LotteryInfoModel *lotteryInfoModel = ConvertToClassPointer(RH_LotteryInfoModel, context);
    self.lotteryInfoModel = lotteryInfoModel;
    
}

-(void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint point=[pan translationInView:self.view];
    NSLog(@"%f,%f",point.x,point.y);
    pan.view.center=CGPointMake(pan.view.center.x+point.x, pan.view.center.y+point.y);
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
}
-(BOOL)isHiddenStatusBar
{
    return YES ;
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
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}
//+(void)configureNavigationBar:(UINavigationBar*)navigationBar
//{
//    if (navigationBar){
//        navigationBar.tintColor = [UIColor whiteColor] ;
//        navigationBar.barTintColor = [UIColor redColor] ;
//        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:19],
//                                              NSForegroundColorAttributeName:[UIColor whiteColor]};
//    }
//
//    return ;
//}

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
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3GameLinkForCheery) {
        if (IS_DEV_SERVER_ENV||IS_TEST_SERVER_ENV) {
            [self.gameWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[data objectForKey:@"gameMsg"]]]];
        }
        else{
            [self.gameWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[data objectForKey:@"gameLink"]]]];
        }
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
