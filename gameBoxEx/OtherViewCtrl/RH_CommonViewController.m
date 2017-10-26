//
//  RH_CommonViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_CommonViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"

@interface RH_CommonViewController ()
@property (nonatomic,assign) BOOL isLofinAfter ;
@end

@implementation RH_CommonViewController
{
    NSString * _urlString ;
}
- (void)setupViewContext:(id)context
{
    _urlString = ConvertToClassPointer(NSString, context) ;
}

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.hiddenNavigationBar = YES ;

    if([_urlString containsString:@"http"]){
        self.webURL = [NSURL URLWithString:_urlString] ;
    }else{
        self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.domain,_urlString]] ;
    }

    self.navigationItem.titleView = nil ;
}

-(BOOL)tabBarHidden
{
    return YES ;
}

#pragma mark-
-(void)webViewBeginLoad
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:NSLocalizedString(@"WEBVIEW_LOADING_STATUS", nil) detailText:nil] ;
}

-(void)webViewDidEndLoad:(NSError *)error
{
    [self.contentLoadingIndicateView hiddenView] ;

    if (error){
        self.hiddenNavigationBar = NO ;
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus] ;
    }
}

#pragma mark-

@end
