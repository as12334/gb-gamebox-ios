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
@property(nonatomic,strong,readonly) UIImageView *gameBgImage ;
@property(nonatomic,strong,readonly) UIImageView *imageFirstPage ;
@property(nonatomic,strong)CLButton * homeBack;
@property(nonatomic,strong)CLButton * backBack;
@end

@implementation RH_LoginViewController
@synthesize gameBgImage = _gameBgImage              ;
@synthesize imageFirstPage = _imageFirstPage    ;
-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.hiddenNavigationBar = YES ;

    RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/login/commonLogin.html",appDelegate.domain.trim]] ;

    self.navigationItem.titleView = nil ;
    
    [self.contentView addSubview:self.gameBgImage];
    [self.contentView bringSubviewToFront:self.gameBgImage] ;
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.gameBgImage setUserInteractionEnabled:YES];//开启图片控件的用户交互
    [self.gameBgImage addGestureRecognizer:pan];
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeTrailing, self.contentView, -0.0f) ;
    setEdgeConstraint(self.gameBgImage, NSLayoutAttributeBottom, self.contentView, -60.0f) ;
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
    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
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
-(void)backBarButtonItemHandle
{
    ifRespondsSelector(self.delegate, @selector(loginViewViewControllerTouchBack:)){
        [self.delegate loginViewViewControllerTouchBack:self];
    }
}
@end
