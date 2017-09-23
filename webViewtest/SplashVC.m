//
//  SplashVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/4/3.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "SplashVC.h"
#import "NSString+MEJSON.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "MainTabBarVC.h"
#import "AppDelegate.h"
#import "UIKit+AFNetworking.h"


@interface SplashVC ()<NSURLConnectionDelegate>

@property(nonatomic,strong)NSMutableData * mData;
@property int urlArrayIndex;

@property AppDelegate *appDelegate;
@property NSArray *urlArray;
@property NSString *talk;
@property NSTimer *timer;
@property NSString *httpsPath;

@property (weak, nonatomic) IBOutlet UIImageView *splashLogo;
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@property (weak, nonatomic) IBOutlet UILabel *bottomText;
@property (weak, nonatomic) IBOutlet UILabel *bottomText2;

- (void) checkUrl;
- (void) judgeNet;
- (void) checkUpdate;
- (void) gotoTabView;
- (void) initBottomText;

@end

@implementation SplashVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.judgeNet;
    self.initBottomText;
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.urlArrayIndex = 0;
    self.talk = @"/__check";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //网络情况检查
    self.timer = [NSTimer timerWithTimeInterval:5
                                             target:self
                                           selector:@selector(judgeNet)
                                           userInfo:nil
                                            repeats:YES];
    
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //设置启动页logo
    [self.splashLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"app_logo_%@",SID]]];
}

- (void) initBottomText{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.bottomText setText:[NSString stringWithFormat:@"Copyrihgt © %@ Reserved.",app_Name]];
    [self.bottomText2 setText:[NSString stringWithFormat:@"v%@",app_Version]];
}

#pragma mark  -－－－－－－－－－－－－－－－－－－－－－－－－－-

- (void)getDataWithURLRequest {
    
    //停止首页首页面网络监控
    _timer.invalidate;
    
    //connect
    _httpsPath = [NSString stringWithFormat:@"%@app/line.html?code=%@&s=%@",_appDelegate.bossUrl,_appDelegate.code,_appDelegate.s];
    
    NSLog(@"%@",_httpsPath);
    
    NSURL *url = [NSURL URLWithString:_httpsPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {

    //直接验证服务器是否被认证（serverTrust），这种方式直接忽略证书验证，信任该connect
    SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
    return [[challenge sender] useCredential: [NSURLCredential credentialForTrust: serverTrust]
                  forAuthenticationChallenge: challenge];
    
    
    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust]) {
        do
        {
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            NSCAssert(serverTrust != nil, @"serverTrust is nil");
            if(nil == serverTrust)
                break; /* failed */
            /**
             *  导入多张CA证书（Certification Authority，支持SSL证书以及自签名的CA），请替换掉你的证书名称
             */
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"caname1" ofType:@"cer"];//自签名证书
            NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
            
            NSString *cerPath2 = [[NSBundle mainBundle] pathForResource:@"caname2" ofType:@"cer"];//SSL证书
            NSData * caCert2 = [NSData dataWithContentsOfFile:cerPath2];
            
            NSCAssert(caCert != nil, @"caCert is nil");
            if(nil == caCert)
                break; /* failed */
            
            NSCAssert(caCert2 != nil, @"caCert2 is nil");
            if (nil == caCert2) {
                break;
            }
            
            SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert);
            NSCAssert(caRef != nil, @"caRef is nil");
            if(nil == caRef)
                break; /* failed */
            
            SecCertificateRef caRef2 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert2);
            NSCAssert(caRef2 != nil, @"caRef2 is nil");
            if(nil == caRef2)
                break; /* failed */
            
            NSArray *caArray = @[(__bridge id)(caRef),(__bridge id)(caRef2)];
            
            NSCAssert(caArray != nil, @"caArray is nil");
            if(nil == caArray)
                break; /* failed */
            
            OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
            NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
            if(!(errSecSuccess == status))
                break; /* failed */
            
            SecTrustResultType result = -1;
            status = SecTrustEvaluate(serverTrust, &result);
            if(!(errSecSuccess == status))
                break; /* failed */
            NSLog(@"stutas:%d",(int)status);
            NSLog(@"Result: %d", result);
            
            BOOL allowConnect = (result == kSecTrustResultUnspecified) || (result == kSecTrustResultProceed);
            if (allowConnect) {
                NSLog(@"success");
            }else {
                NSLog(@"error");
            }
            /* https://developer.apple.com/library/ios/technotes/tn2232/_index.html */
            /* https://developer.apple.com/library/mac/qa/qa1360/_index.html */
            /* kSecTrustResultUnspecified and kSecTrustResultProceed are success */
            if(! allowConnect)
            {
                break; /* failed */
            }
            
#if 0
            /* Treat kSecTrustResultConfirm and kSecTrustResultRecoverableTrustFailure as success */
            /*   since the user will likely tap-through to see the dancing bunnies */
            if(result == kSecTrustResultDeny || result == kSecTrustResultFatalTrustFailure || result == kSecTrustResultOtherError)
                break; /* failed to trust cert (good in this case) */
#endif
            
            // The only good exit point
            NSLog(@"信任该证书");
            return [[challenge sender] useCredential: [NSURLCredential credentialForTrust: serverTrust]
                          forAuthenticationChallenge: challenge];
            
        }
        while(0);
    }
    
    // Bad dog
    return [[challenge sender] cancelAuthenticationChallenge: challenge];
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

#pragma mark -- connect的异步代理方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"请求被响应");
    _mData = [[NSMutableData alloc]init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data {
    NSLog(@"开始返回数据片段");
    [_mData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"链接完成");
    NSString *responseString = [[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding];
    
    if([_httpsPath containsString:@"line.html?code"]){
        //域名解析
        NSLog(@"received info:\n%@",responseString);
        
        NSError *err;
        self.urlArray = [NSJSONSerialization JSONObjectWithData:_mData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&err];
        self.checkUrl;
    }else{
        NSString *receiveInfo = [NSJSONSerialization JSONObjectWithData:self.mData options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.mData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"receiveInfo:%@",receiveInfo);
        NSLog(@"checkUpdate:%@",[dic objectForKey:@"versionCode"]);
        
        if([self isBlankString:receiveInfo]){
            self.gotoTabView;
            return;
        }
        
        if([[dic objectForKey:@"versionCode"] intValue] > [_appDelegate.versionCode intValue]){
            NSString *downLoadIpaUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&amp;url=https://%@%@/app_%@_%@.plist",[dic objectForKey:@"appUrl"],_appDelegate.code,_appDelegate.code,[dic objectForKey:@"versionName"]];
            NSLog(@"%@",downLoadIpaUrl);
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:downLoadIpaUrl]];
        }else{
            self.gotoTabView;
        }
        
    }
}

-(void) gotoTabView{
    MainTabBarVC *scanVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:scanVC animated:YES completion:nil];
}

//链接出错
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"error - %@",error);
}

- (void) checkUrl{
    
//    NSString *path = [NSString stringWithFormat:@"%@%@",_domain,@"/index/getCustomerService.html"];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",@"https://",_urlArray[_urlArrayIndex],_talk];
    if(IS_DEBUG) {
        path = [NSString stringWithFormat:@"%@%@%@",@"http://",_urlArray[_urlArrayIndex],_talk];
    }
   
    NSLog(@"检测线路：%@", path);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(IS_DEBUG) {
             self.appDelegate.domain = [NSString stringWithFormat:@"%@%@",@"http://",_urlArray[_urlArrayIndex]];
        } else {
             self.appDelegate.domain = [NSString stringWithFormat:@"%@%@",@"https://",_urlArray[_urlArrayIndex]];
        }
        NSLog(@"线路%@可用", path);
        //检测成功后检查更新
        self.checkUpdate;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _urlArrayIndex ++;
        NSLog(@"线路%@不可用", path);
        NSLog(@"线路错误信息返回:%@", [error localizedDescription]);
        int size = [self.urlArray count];
        if(_urlArrayIndex < size) {
            self.checkUrl;
        }
    }];
    
}


// 判断网络
- (void)judgeNet{
    NSString *network = @"网络不可用";
    NSString *wifiing = @"正在使用Wifi";
    NSString *wifi = @"Wifi已开启";
    NSString *flow = @"你现在使用的流量";
    NSString *unknown = @"你现在使用的未知网络";
    if ([@"185" isEqualToString:SID]) {
        network = @"ネット使用不可";
        wifiing = @"WiFi使用中";
        wifi = @"WiFiオープン";
        flow = @"パケット使用中";
        unknown = @"不明のネット使用中";
    }

    self.manager = [AFNetworkReachabilityManager manager];
    __weak typeof(self) weakSelf = self;
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                //                [weakSelf loadMessage:@"网络不可用"];
                NSLog(network);
                self.appDelegate.netStatus = @"noNetwork";
                NSLog(@"netStatus:%@", _appDelegate.netStatus);
                [self addToastWithString:network inView:self.view];
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                [self addToastWithString:wifiing inView:self.view];
                self.appDelegate.netStatus = @"wifi";
                NSLog(@"netStatus:%@", _appDelegate.netStatus);
                [self getDataWithURLRequest];
                NSLog(wifi);
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //                [weakSelf loadMessage:@"你现在使用的流量"];
                NSLog(flow);
                self.appDelegate.netStatus = @"gprs";
                [self addToastWithString:flow inView:self.view];
                [self getDataWithURLRequest];
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown: {
                //                [weakSelf loadMessage:@"你现在使用的未知网络"];
                NSLog(unknown);
                self.appDelegate.netStatus = @"unknown";
                [self addToastWithString:unknown inView:self.view];
                [self getDataWithURLRequest];
                break;
            }
                
            default:
                break;
        }
    }];
    [self.manager startMonitoring];
}


- (void)checkUpdate {
    //地址
    _httpsPath = [NSString stringWithFormat:@"https://apiplay.info:1344/boss/app/update.html?type=ios&key=%@&code=%@",_appDelegate.md5,_appDelegate.versionCode];
    
    //_httpsPath = [NSString stringWithFormat:@"%@app/update.html?type=ios&key=%@&code=%@",_appDelegate.bossUrl,_appDelegate.md5,_appDelegate.versionCode];
    
    NSURL *url = [NSURL URLWithString:_httpsPath];
    NSLog(@"update url = %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}

@end
