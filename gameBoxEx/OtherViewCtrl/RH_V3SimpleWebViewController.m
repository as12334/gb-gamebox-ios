//
//  RH_V3SimpleWebViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_V3SimpleWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"

@interface RH_V3SimpleWebViewController ()
@end

@implementation RH_V3SimpleWebViewController
{
    NSString * _urlString ;
}
- (void)setupViewContext:(id)context
{
    _urlString = ConvertToClassPointer(NSString, context) ;
}

#pragma mark-configure navigation bar
+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    navigationBar.barStyle = UIBarStyleDefault ;
    if (GreaterThanIOS11System){
        navigationBar.barTintColor = RH_NavigationBar_BackgroundColor;
    }else
    {
        UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
        [navigationBar insertSubview:backgroundView atIndex:0] ;
        backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
    }
    
    navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
                                          NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
    
}

-(BOOL)backButtonHidden
{
    return NO ;
}

-(BOOL)navigationBarHidden
{
    return NO ;
}

-(BOOL)tabBarHidden
{
    return YES ;
}

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.navigationBarItem.leftBarButtonItem = self.backButtonItem ;
    self.webURL = [NSURL URLWithString:_urlString] ;
}

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [self.contentLoadingIndicateView hiddenView] ;

    if (error){
        self.hiddenNavigationBar = NO ;
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus] ;
    }
}

@end
