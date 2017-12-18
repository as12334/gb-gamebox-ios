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
    [self setupURL] ;
    [self.contentView addSubview:self.gameBgImage];
    [self.contentView bringSubviewToFront:self.gameBgImage] ;
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.gameBgImage setUserInteractionEnabled:YES];//开启图片控件的用户交互
    [self.gameBgImage addGestureRecognizer:pan];
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeTrailing, self.contentView, -0.0f) ;
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeBottom, self.contentView, -60.0f) ;
}
-(void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint point=[pan translationInView:self.view];
    NSLog(@"%f,%f",point.x,point.y);
    pan.view.center=CGPointMake(pan.view.center.x+point.x, pan.view.center.y+point.y);
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [pan setTranslation:CGPointMake(0, 0) inView:self.contentView];
}

-(void)setupURL
{
    if([self.appDelegate.customUrl containsString:@"http"]){
        self.webURL = [NSURL URLWithString:self.appDelegate.customUrl.trim] ;
    }else{
        self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.appDelegate.domain.trim,self.appDelegate.customUrl.trim]] ;
    }
    
    [self reloadWebView] ;//预防两次url 一样，不加载情况
}

-(BOOL)tabBarHidden
{
    return YES ;
}

-(BOOL)navigationBarHidden
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
    if ([SITE_TYPE isEqualToString:@"integratedv3"]){
        self.myTabBarController.selectedIndex = 2 ;
    }else{
        self.myTabBarController.selectedIndex = 0 ;
    }
}

-(void)_backBackHandle
{
    [self backBarButtonItemHandle] ;
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
            NSLog(@"%@", jsVal.toString);
        }

        if (args[0] != NULL) {
            self.appDelegate.customUrl = customUrl.toString;
        }
        
        [self setupURL] ;
    } ;

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
                    if ([SITE_TYPE isEqualToString:@"integratedv3"]){
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

@end
