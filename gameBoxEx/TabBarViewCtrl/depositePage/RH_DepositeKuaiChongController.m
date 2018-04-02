//
//  RH_DepositeKuaiChongController.m
//  gameBoxEx
//
//  Created by lewis on 2018/4/1.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeKuaiChongController.h"
#import "coreLib.h"
@interface RH_DepositeKuaiChongController ()
@property(nonatomic,strong)NSURL *url;
@end

@implementation RH_DepositeKuaiChongController
-(BOOL)isSubViewController
{
    return YES;
}
-(void)setupViewContext:(id)context
{
    NSString *urlStr =ConvertToClassPointer(NSString, context);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]] ;
    self.url = url;
}

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.contentView.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    webView.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    [self.contentView addSubview:webView];
}



@end
