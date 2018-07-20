//
//  RH_MineMoreDetailWebViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/20.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineMoreDetailWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"

@interface RH_MineMoreDetailWebViewController ()

@end

@implementation RH_MineMoreDetailWebViewController
{
    NSString *_urlStr ;
}

-(void)setupViewContext:(id)context
{
    _urlStr = ConvertToClassPointer(NSString, context) ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.autoShowWebTitle = YES ;
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.appDelegate.domain,_urlStr]] ;
}

//-(BOOL)closeWebBarButtonItemHidden
//{
//    return YES ;
//}

//-(BOOL)navigationBarHidden
//{
//    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] || [SITE_TYPE isEqualToString:@"integratedv3"]) {
//        return NO ;
//    }else
//    {
//        return YES ;
//    }
//}

-(BOOL)tabBarHidden
{
    return YES ;
}

-(BOOL)backButtonHidden
{
    return NO ;
}

#pragma mark-

-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;
}



@end
