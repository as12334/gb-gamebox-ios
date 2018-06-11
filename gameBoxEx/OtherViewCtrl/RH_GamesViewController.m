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
#import "RH_LotteryAPIInfoModel.h"
#import "RH_LotteryInfoModel.h"
#import <WebKit/WebKit.h>
#import "coreLib.h"
@interface RH_GamesViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong,readonly) UIImageView *gameBgImage ;
@property(nonatomic,strong,readonly) UIImageView *imageFirstPage ;
@property(nonatomic,strong)CLButton * homeBack;
@property(nonatomic,strong)CLButton * backBack;
@property(nonatomic,strong)NSURL *subUrl;
@property(nonatomic,strong)WKWebView *gameWebView;
@property(nonatomic,strong)WKUserContentController *userContentController;
@end

@implementation RH_GamesViewController{
    NSInteger _apiID  ;
    RH_LotteryAPIInfoModel *_apiInfoModel  ;
    RH_LotteryInfoModel *_lotteryInfoModel ;
}
@synthesize gameBgImage = _gameBgImage              ;
@synthesize imageFirstPage = _imageFirstPage        ;

-(void)setupViewContext:(id)context
{
   
    if ([context isKindOfClass:[RH_LotteryAPIInfoModel class]]){
        _apiInfoModel = ConvertToClassPointer(RH_LotteryAPIInfoModel, context) ;
    }else if ([context isKindOfClass:[RH_LotteryInfoModel class]]){
        _lotteryInfoModel = ConvertToClassPointer(RH_LotteryInfoModel, context) ;
    }else{
        _apiID = [context integerValue] ;
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.autoShowWebTitle = NO ;
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    self.userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = self.userContentController;
    self.gameWebView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
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
    [self showProgressIndicatorViewWithAnimated:YES title:@"加载中"];
    if (_apiInfoModel){//需请求加载的link
        [self.serviceRequest startv3GetGamesLinkForCheeryLink:_apiInfoModel.mGameLink] ;

    }else if (_lotteryInfoModel){//
        if (_lotteryInfoModel.showGameLink.length>0){ //已获取的请求链接
            self.appDelegate.customUrl = _lotteryInfoModel.showGameLink ;
            [self setupInfo] ;
        }else{
            [self.serviceRequest startv3GetGamesLinkForCheeryLink:_lotteryInfoModel.mGameLink] ;
        }
    }
}

-(void)setupInfo
{
    if([self.appDelegate.customUrl containsString:@"http"]){
        self.subUrl = [NSURL URLWithString:self.appDelegate.customUrl] ;
    }
    else{
        if ([self.appDelegate.checkType isEqualToString:@"https+8989"]) {
            self.subUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@:8989%@",self.appDelegate.headerDomain,self.appDelegate.customUrl]] ;
        }
        else if ([self.appDelegate.checkType isEqualToString:@"http+8787"]) {
            self.subUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8787%@",self.appDelegate.headerDomain,self.appDelegate.customUrl]] ;
        }
        else if ([self.appDelegate.checkType isEqualToString:@"https"]) {
            self.subUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@%@",self.appDelegate.headerDomain,self.appDelegate.customUrl]] ;
            
        }
       else if ([self.appDelegate.checkType isEqualToString:@"http"]) {
            self.subUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",self.appDelegate.headerDomain,self.appDelegate.customUrl]] ;
        }
        
    }
    [self.gameWebView loadRequest:[NSURLRequest requestWithURL:self.subUrl]];

}

-(BOOL)isHiddenStatusBar
{
    return YES ;
}

-(void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint point=[pan translationInView:self.view];
//    NSLog(@"%f,%f",point.x,point.y);
    pan.view.center=CGPointMake(pan.view.center.x+point.x, pan.view.center.y+point.y);
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
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
    if (_apiID>0){
        [self.serviceRequest startAPIRetrive:_apiID] ;
    }
    
    //clear 音效
    self.webURL = [NSURL URLWithString:@""] ;
    [self reloadWebView] ;
    
    [self.navigationController popToRootViewControllerAnimated:YES] ;
    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
        self.myTabBarController.selectedIndex = 0 ;
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

#pragma mark -
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView {
    
    if (self.subUrl.absoluteString.length){
        [self reloadWebView];
    }
}

#pragma mark-
-(void)backBarButtonItemHandle
{
    if (_apiID>0){
        [self.serviceRequest startAPIRetrive:_apiID] ;
    }
    
    //clear 音效
    self.webURL = [NSURL URLWithString:@""] ;
    [self reloadWebView] ;
    
    [super backBarButtonItemHandle] ;
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
    }
    else{
        [super webView:webView didFailLoadWithError:error] ;
    }
}

#pragma mark- service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
  
    if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        NSDictionary *dict = ConvertToClassPointer(NSDictionary, data) ;
        if ([dict boolValueForKey:@"success" defaultValue:FALSE]){
            [self.appDelegate updateLoginStatus:true] ;
            [self performSelectorOnMainThread:@selector(reloadWebView) withObject:nil waitUntilDone:YES] ;
        }else{
            [self.appDelegate updateLoginStatus:false] ;
        }
    }else if (type==ServiceRequestTypeDemoLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            if ([data boolValue]){
                showSuccessMessage(self.view, @"试玩登录成功", nil) ;
                [self.appDelegate updateLoginStatus:true] ;
                [self backBarButtonItemHandle] ;
            }else{
                showAlertView(@"试玩登录失败", @"提示信息");
                [self.appDelegate updateLoginStatus:false] ;
            }
        }] ;
    }else if (type==ServiceRequestTypeV3GameLink ||
              type==ServiceRequestTypeV3GameLinkForCheery){
        [self.contentLoadingIndicateView hiddenView] ;
        NSDictionary *gameLinkDict = ConvertToClassPointer(NSDictionary, data) ;
        if (_apiInfoModel){//需请求加载的link
            [_apiInfoModel updateShowGameLink:gameLinkDict] ;
        }else {
            [_lotteryInfoModel updateShowGameLink:gameLinkDict] ;
        }
        NSString *gameLink = _apiInfoModel.showGameLink?:_lotteryInfoModel.showGameLink ;
        NSString *gameMessage = _apiInfoModel.mGameMsg?:_lotteryInfoModel.mGameMsg ;
        if (gameLink.length){
            self.appDelegate.customUrl = gameLink ;
            [self setupInfo] ;
        }else{
            showAlertView(@"温馨提示", gameMessage);
            [self.contentLoadingIndicateView showInfoInInvalidWithTitle:gameMessage detailText:@"温馨提示"] ;
        }
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest  serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    
    if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        [self.appDelegate updateLoginStatus:false] ;
    }else if (type==ServiceRequestTypeDemoLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"提示信息");
            [self.appDelegate updateLoginStatus:false] ;
        }] ;
    }else if (type==ServiceRequestTypeV3GameLink ||
              type==ServiceRequestTypeV3GameLinkForCheery){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"webView.URL===%@",[NSString stringWithFormat:@"%@",webView.URL]);
    
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
        showMessage(self.view, @"即将进入...", nil);
    }];
    if ([[NSString stringWithFormat:@"%@",webView.URL] containsString:@"test01.ccenter.test.so"]||[[NSString stringWithFormat:@"%@",webView.URL] containsString:@"mainIndex.html"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        self.myTabBarController.selectedIndex = 0 ;
    }

}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
   
    [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
        showErrorMessage(self.view,error,@"加载失败");
    }];
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
