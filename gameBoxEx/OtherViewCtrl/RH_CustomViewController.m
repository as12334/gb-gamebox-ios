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

@interface RH_CustomViewController ()
@property(nonatomic,strong,readonly) UIImageView *gameBgImage ;
@property(nonatomic,strong,readonly) UIImageView *imageFirstPage ;
@end

@implementation RH_CustomViewController
@synthesize gameBgImage = _gameBgImage              ;
@synthesize imageFirstPage = _imageFirstPage    ;

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.hiddenNavigationBar = YES ;
    self.navigationItem.titleView = nil ;
    [self setupURL] ;

    //
    [self.contentView addSubview:self.gameBgImage];
    [self.contentView bringSubviewToFront:self.gameBgImage] ;
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeTrailing, self.contentView, -0.0f) ;
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeBottom, self.contentView, -60.0f) ;
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

        CLButton * homeBack = [[CLButton alloc] initWithFrame:CGRectMake(0, 0, _gameBgImage.boundWidth, floor(_gameBgImage.boundHeigh/2.0))];
        homeBack.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [homeBack setBackgroundColor:BlackColorWithAlpha(0.2f)
                                  forState:UIControlStateHighlighted];
        [homeBack setBackgroundImage:ImageWithName(@"icon_home") forState:UIControlStateNormal] ;
        [homeBack addTarget:self
                           action:@selector(_homeBackHandle)
                 forControlEvents:UIControlEventTouchUpInside];
        [_gameBgImage addSubview:homeBack];


        CLButton * backBack = [[CLButton alloc] initWithFrame:CGRectMake(0, floor(_gameBgImage.boundHeigh/2.0)+1, _gameBgImage.boundWidth, floor(_gameBgImage.boundHeigh/2.0))];
        backBack.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [backBack setBackgroundColor:BlackColorWithAlpha(0.2f)
                            forState:UIControlStateHighlighted];
        [backBack setBackgroundImage:ImageWithName(@"title_back") forState:UIControlStateNormal] ;
        [backBack addTarget:self
                     action:@selector(_backBackHandle)
           forControlEvents:UIControlEventTouchUpInside];
        [_gameBgImage addSubview:backBack];

    }

    return _gameBgImage;
}


-(void)_homeBackHandle
{
    [self.navigationController popToRootViewControllerAnimated:YES] ;
//    self.myTabBarController.selectedIndex = 0 ;// jump to first page .
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

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:jsAccount.toString forKey:@"account"];
        [defaults setObject:jsPassword.toString forKey:@"password"];
        [defaults synchronize];
        [self.appDelegate updateLoginStatus:true] ;


        dispatch_async(dispatch_get_main_queue(), ^{
             [self.navigationController popViewControllerAnimated:YES] ;
        });
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
