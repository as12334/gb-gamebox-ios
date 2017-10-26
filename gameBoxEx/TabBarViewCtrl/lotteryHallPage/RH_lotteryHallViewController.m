//
//  RH_lotteryHallViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_lotteryHallViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_lotteryHallViewController.h"

@interface RH_lotteryHallViewController ()
@property (nonatomic,assign) BOOL isLofinAfter ;
@end

@implementation RH_lotteryHallViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    //请求链接 ==彩票大厅
    self.webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.domain,@"/lottery/mainIndex.html"]] ;
    self.navigationItem.titleView = nil ;
}

-(BOOL)tabBarHidden
{
    return NO ;
}

-(BOOL)needLogin
{
   //此为购彩大厅，不需登入
    return NO ;
}

#pragma mark-
-(void)webViewDidEndLoad:(NSError *)error
{
    [super webViewDidEndLoad:error] ;
}

#pragma mark-

@end
