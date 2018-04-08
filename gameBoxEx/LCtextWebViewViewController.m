//
//  LCtextWebViewViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/4/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "LCtextWebViewViewController.h"

@interface LCtextWebViewViewController ()
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation LCtextWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString *urlStr = @"https://777.ampinplayopt0matrix.com/m/new/#/game&ad=10";
    NSURL *url  = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    NSLog(@"--%@",self.webView.subviews);
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
