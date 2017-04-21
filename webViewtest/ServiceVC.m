//
//  ServiceVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/3/25.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "ServiceVC.h"
#import "CustomVC.h"
#import "AppDelegate.h"
#import "iKYLoadingHubView.h"
#import "ViewController.h"

@interface ServiceVC ()

@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *serviceWV;
@property NSString *domain;
@property BOOL isLoad;
@property iKYLoadingHubView *loadingHubView;

- (void)showPage;

@end

@implementation ServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    _isLoad = false;
    
    _serviceWV.scrollView.bounces=NO;
    
    //加载动画
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.loadingHubView = [[iKYLoadingHubView alloc] initWithFrame:CGRectMake(rx.size.width/2-100, rx.size.height/2-75, 200, 150)];
    [self.view addSubview:_loadingHubView];
    [_loadingHubView showHub];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//即将进入这个界面加载该方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"ServiceVC");
    self.showPage;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)showPage{
    if(_isLoad){
        return;
    }
    NSLog(@"%@",_appDelegate.servicePath);
    if([_appDelegate.servicePath containsString: @"http"]){
        _isLoad = true;
        self.serviceWV.scalesPageToFit = YES;
        self.serviceWV.dataDetectorTypes = UIDataDetectorTypeAll;
        self.serviceWV.delegate=self;
        [self.serviceWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.appDelegate.servicePath]]];
    }else{
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"客服正忙请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
        
        // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"返回首页");
            self.tabBarController.selectedIndex = 0;
            
        }];
        
        // 3.将“取消”和“确定”按钮加入到弹框控制器中
        
        [alertVc addAction:cancle];
        
        [self presentViewController:alertVc animated:YES completion:^{nil;}];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//开始加载网页，不仅监听我们指定的请求，还会监听内部发送的请求
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:NO];
    NSLog(@"开始加载");
}

//网页加载完毕之后会调用该方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadingHubView setHidden:YES];
    NSLog(@"加载成功");
}

//网页加载失败调用该方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_loadingHubView setHidden:YES];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"客服正忙请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"返回首页");
        self.tabBarController.selectedIndex = 0;
    }];
    
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    
    [alertVc addAction:cancle];
    
    [self presentViewController:alertVc animated:YES completion:^{nil;}];
    NSLog(@"加载失败");
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
