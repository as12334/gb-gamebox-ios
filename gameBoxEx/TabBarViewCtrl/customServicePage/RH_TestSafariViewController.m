//
//  RH_TestSafariViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/4/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_TestSafariViewController.h"
#import "RH_APPDelegate.h"
#import "RH_LoginViewController.h"
#import "coreLib.h"
@interface RH_TestSafariViewController ()<UINavigationControllerDelegate,UIWebViewDelegate>
@property(nonatomic,strong,readonly)UIWebView *webView;
@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,strong)NSNumber *statusMark;
@end

@implementation RH_TestSafariViewController
@synthesize  webView = _webView;
-(BOOL)hasTopView
{
    return YES;
}
-(CGFloat)topViewHeight
{
    return 50;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.serviceRequest startV3GetCustomService];
}
-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
        _webView.delegate = self;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
}
-(void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeV3CustomService) {
        self.urlString = [[data objectForKey:@"data"]objectForKey:@"customerUrl"];
        self.statusMark = [[data objectForKey:@"data"]objectForKey:@"isInlay"];
        if ([self.statusMark isEqual:@0]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString]];
        }
        else if([self.statusMark isEqual:@1])
        {
           NSURL *webURL = [NSURL URLWithString:self.urlString];
            [self.webView loadRequest:[NSURLRequest requestWithURL:webURL]];
            [self.contentView addSubview:self.webView];
        }
        
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.tabBarController.selectedIndex = 0 ;
}

@end
