//
//  BViewVC.m
//  webViewtest
//
//  Created by jim on 2017/3/24.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "BViewVC.h"
#import "ViewController.h"
#import "AppDelegate.h"
@interface BViewVC ()

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *bwv;
@property NSString *domain;

@end

@implementation BViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.domain = _appDelegate.domain;
    
    //2调用系统方法直接访问
    [self.bwv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.158/login/commonLogin.html"]]];
    
    //3设置网页自适应
    self.bwv.scalesPageToFit = YES;
    
    //4 设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.bwv.dataDetectorTypes = UIDataDetectorTypeAll;
    
    //代理方法  不遵守代理  就无法调用他的方法
    self.bwv.delegate=self;
    
}

@end
