//
//  RH_CustomViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_CustomViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_MainNavigationController.h"
#import "RH_FirstPageViewController.h"
#import "RH_MainTabBarController.h"
#import "RH_LotteryInfoModel.h"
#import "RH_UserInfoManager.h"
#import "RH_LotteryAPIInfoModel.h"

@interface RH_CustomViewController ()
@property(nonatomic,strong,readonly) UIImageView *gameBgImage ;
@property(nonatomic,strong,readonly) UIImageView *imageFirstPage ;
@property(nonatomic,strong)CLButton * homeBack;
@property(nonatomic,strong)CLButton * backBack;

@property(nonatomic,strong) id context ;
@end

@implementation RH_CustomViewController
@synthesize gameBgImage = _gameBgImage              ;
@synthesize imageFirstPage = _imageFirstPage    ;

-(void)setupViewContext:(id)context
{
    self.context = context ;
}

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.navigationItem.titleView = nil ;
    [self.view addSubview:self.gameBgImage];
    [self.view bringSubviewToFront:self.gameBgImage] ;
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.gameBgImage setUserInteractionEnabled:YES];//开启图片控件的用户交互
    [self.gameBgImage addGestureRecognizer:pan];
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeTrailing, self.view, -0.0f) ;
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeBottom, self.view, -60.0f) ;
    
    if ([self.context isKindOfClass:[RH_LotteryInfoModel class]]){ //需要请求 link
        RH_LotteryInfoModel *lotteryInfoModel = ConvertToClassPointer(RH_LotteryInfoModel, self.context) ;
        if (lotteryInfoModel.showGameLink.length){ //已获取的请求链接
            self.appDelegate.customUrl = [NSString stringWithFormat:@"%@",lotteryInfoModel.showGameLink] ;
//            self.appDelegate.customUrl = [NSString stringWithFormat:@"%@%@",self.appDelegate.domain,lotteryInfoModel.showGameLink] ;
            [self setupURL] ;
        }else{
            [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"正在请求信息" detailText:@"请稍等"] ;
            [self.serviceRequest startv3GetGamesLinkForCheeryLink:lotteryInfoModel.mGameLink] ;
        }
    }else if ([self.context isKindOfClass:[RH_LotteryAPIInfoModel class]]){ //需要请求 link
        RH_LotteryAPIInfoModel *lotteryApiInfoModel = ConvertToClassPointer(RH_LotteryAPIInfoModel, self.context) ;
        if (lotteryApiInfoModel.showGameLink.length){ //已获取的请求链接
            self.appDelegate.customUrl = lotteryApiInfoModel.showGameLink ;
            [self setupURL] ;
        }else{
            [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"正在请求信息" detailText:@"请稍等"] ;
            [self.serviceRequest startv3GetGamesLinkForCheeryLink:lotteryApiInfoModel.mGameLink] ;
        }
    }else{
        [self setupURL] ;
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

-(void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint point=[pan translationInView:self.view];
//    NSLog(@"%f,%f",point.x,point.y);
    pan.view.center=CGPointMake(pan.view.center.x+point.x, pan.view.center.y+point.y);
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
}

-(void)setupURL
{
    if([self.appDelegate.customUrl containsString:@"http"]){
        self.webURL = [NSURL URLWithString:self.appDelegate.customUrl.trim] ;
        
    }else{
        self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.appDelegate.domain,self.appDelegate.customUrl.trim]] ;
    }
    
    if (!([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
        [self reloadWebView] ;//预防两次url 一样，不加载情况
    }
    //隐藏按钮
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]) {
        if ([self.appDelegate.customUrl containsString:@"signUp/index.html"]  ||
            [self.appDelegate.customUrl containsString:@"promo/promoDetail.html"] ||
            [self.appDelegate.customUrl containsString:@"transfer/index.html"] ||
            [self.appDelegate.customUrl containsString:@"company/index"] ||
            [self.appDelegate.customUrl containsString:@"electronic/index"] ||
            [self.appDelegate.customUrl containsString:@"company/bitcoin/index"]) {
            _gameBgImage.hidden = YES ;
        }
    }
}

-(BOOL)tabBarHidden
{
    return YES ;
}

//-(BOOL)navigationBarHidden
//{
//    if ([self.appDelegate.customUrl containsString:@"promo/promoDetail"] ) {
//        return NO;
//    }else
//    {
//        return YES ;
//    }
//    return YES;
//}
//
//-(BOOL)closeWebBarButtonItemHidden
//{
//    return YES;
//}

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
        self.myTabBarController.selectedIndex = 0 ;
    }else{
        self.myTabBarController.selectedIndex = 0 ;
    }
}

-(void)_backBackHandle
{
    [self backBarButtonItemHandle] ;
}

-(BOOL)needLogin
{
    if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
        if ([self.appDelegate.customUrl containsString:@"/transfer/index.html"]) {
            return YES ;
        }
    }
    
    return NO ;
}

#pragma mark -
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView {
    if (self.webURL.absoluteString.length){
        [self reloadWebView];
    }
}

#pragma mark-
-(void)setupJSCallBackOC:(JSContext *)jsContext
{
    [super setupJSCallBackOC:jsContext] ;
    jsContext[@"gotoCustom"] = ^(){
        NSLog(@"JSToOc :%@------ gotoCustom",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        JSValue *customUrl;
        for (JSValue *jsVal in args) {
            customUrl = jsVal;
            NSLog(@"jsVal==%@", jsVal.toString);
        }

        if (args[0] != NULL) {
            self.appDelegate.customUrl = customUrl.toString;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]) &&
                [self.appDelegate.customUrl containsString:@"/login/commonLogin.html"]){
//                //跳转原生
//                RH_LoginViewControllerEx *loginViewCtrlEx = [RH_LoginViewControllerEx viewController] ;
//                loginViewCtrlEx.delegate = self ;
//                [self showViewController:loginViewCtrlEx sender:self] ;
            }else
            {
                self.webURL = nil ;
                [self setupURL] ;
            }
        }) ;
    } ;

    jsContext[@"loginOut"] = ^(){
        NSLog(@"JSToOc :%@------ loginOut",NSStringFromClass([self class])) ;
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.appDelegate updateLoginStatus:false] ;
        
        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
            [self reloadWebView] ;
        }
    };
    
    jsContext[@"loginSucc"] = ^() {
        NSLog(@"JSToOc :%@------ loginSucc",NSStringFromClass([self class])) ;
        NSArray *args = [JSContext currentArguments];
        
        JSValue *jsAccount = args[0];
        JSValue *jsPassword = args[1];
        JSValue *jsStatus = args[2] ;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:jsAccount.toString forKey:@"account"];
        [defaults setObject:jsPassword.toString forKey:@"password"];
        [defaults synchronize];
        
        [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:jsAccount.toString
                                                                 LoginTime:dateStringWithFormatter([NSDate date], @"yyyy-MM-dd HH:mm:ss")] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.appDelegate updateLoginStatus:jsStatus.toBool] ;
            
            RH_LoginViewControllerEx *loginViewCtrlEx = ConvertToClassPointer(RH_LoginViewControllerEx, self.context) ;
            if (loginViewCtrlEx){
                ifRespondsSelector(loginViewCtrlEx.delegate, @selector(loginViewViewControllerExSignSuccessful:SignFlag:)){
                    [loginViewCtrlEx.delegate loginViewViewControllerExSignSuccessful:loginViewCtrlEx SignFlag:jsStatus.toBool] ;
                }
            }else
            {
                if (jsStatus.toBool==false){
                    if (([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"])){
                        [self.serviceRequest startAutoLoginWithUserName:jsAccount.toString Password:jsPassword.toString] ;
                    }else{
                        [self.serviceRequest startLoginWithUserName:jsAccount.toString Password:jsPassword.toString VerifyCode:nil] ;
                    }
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES] ;
        }) ;
        
    };
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
        RH_LotteryInfoModel *lotteryInfoModel = ConvertToClassPointer(RH_LotteryInfoModel, self.context) ;
        [lotteryInfoModel updateShowGameLink:gameLinkDict] ;
        NSString *gameLink = lotteryInfoModel.showGameLink ;
        NSString *gameMessage = lotteryInfoModel.mGameMsg ;
        if (gameLink.length){
            self.appDelegate.customUrl =[NSString stringWithFormat:@"%@",gameLink]  ;
            [self setupURL] ;
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

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;
    if (error){
        [self.webView stringByEvaluatingJavaScriptFromString:@"$('.mui-inner-wrap').height();"];//防止白屏

        //账号退出
        if([self.appDelegate.customUrl isEqualToString:@"/passport/logout.html"]){
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }

        NSArray* filterUrls = [[NSArray alloc] initWithObjects:@"/login/commonLogin.",@"/signUp/index.",@"/passport/logout.",@"/help/",@"/promoDetail.",@"/lottery/mainIndex.",@"/lottery/",@"/index.",@"/lotteryResultHistory/",nil];
        //判断是否需要登录判断

        if([filterUrls containsObject: self.webURL.absoluteString] == 1){
            [self.webView stringByEvaluatingJavaScriptFromString:@"loginState(isLogin);"];
        }
    }
}

#pragma mark-

// 允许自动旋转
-(BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

//3.返回进入界面默认显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}




@end
