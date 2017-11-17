//
//  SplashViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "SplashViewController.h"
#import "coreLib.h"
#import "RH_ServiceRequest.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"
#import "MacroDef.h"
#import "RH_UpdatedVersionModel.h"

#define aiScreenWidth [UIScreen mainScreen].bounds.size.width
#define aiScreenHeight [UIScreen mainScreen].bounds.size.height
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_BAR_HEIGHT self.tabBarController.tabBar.frame.size.height

#define  kUpdateAPPDatePrompt                           @"kUpdateAPPDatePrompt"
#define  OneDayTotalInterval                             (24*60*60)

@interface SplashViewController ()
@property(nonatomic,strong) UIWindow * window;
@property (weak, nonatomic) IBOutlet UIImageView *splashLogo;
@property (weak, nonatomic) IBOutlet UILabel *bottomText;
@property (weak, nonatomic) IBOutlet UILabel *bottomText2;

@end

@implementation SplashViewController
{
    NSInteger _urlArrayLastIndex ;
    NSArray *_urlArray ;
    NSString *_talk ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _urlArrayLastIndex = 0 ;
    _talk = @"/__check" ;
    self.hiddenNavigationBar = YES ;
    self.hiddenStatusBar = YES ;
    self.hiddenTabBar = YES ;
    
    self.needObserveNetStatusChanged = NO ;
    [self netStatusChangedHandle] ;
    
    [self initView] ;
}

- (void)initView{
    //设置启动页logo
    NSString *logoName = [NSString stringWithFormat:@"app_logo_%@",SID] ;
    [self.splashLogo setImage:ImageWithName(logoName)];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.bottomText setText:[NSString stringWithFormat:@"Copyrihgt © %@ Reserved.",app_Name]];
    [self.bottomText2 setText:[NSString stringWithFormat:@"v%@",app_Version]];
}

-(void)startReqSiteInfo
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"正在检查线路,请稍候"] ;
    [self.serviceRequest cancleServiceWithType:ServiceRequestTypeDomainList] ;
    [self.serviceRequest startReqDomainList] ;
}

#pragma mark-
-(void)netStatusChangedHandle
{
    NSString *network = @"网络不可用";
    NSString *wifiing = @"正在使用Wifi";
    NSString *wifi = @"Wifi已开启";
    NSString *flow = @"你现在使用的流量";
    NSString *unknown = @"你现在使用的未知网络";

    //    if ([@"185" isEqualToString:SID]) {
//        network = @"ネット使用不可";
//        wifiing = @"WiFi使用中";
//        wifi = @"WiFiオープン";
//        flow = @"パケット使用中";
//        unknown = @"不明のネット使用中";
//    }

    switch (CurrentNetStatus()) {
        case NotReachable:
        {
            [self addToastWithString:network inView:self.view];
        }
            break;

        case ReachableViaWiFi:
        {
            [self addToastWithString:wifiing inView:self.view];
            if (_urlArray.count<1){
                [self startReqSiteInfo];
            }
        }
            break ;

        case ReachableViaWWAN:
        {
            [self addToastWithString:flow inView:self.view];
             if (_urlArray.count<1){
                 [self startReqSiteInfo];
             }
        }
            break ;

        default:
        {
            [self addToastWithString:unknown inView:self.view];
             if (_urlArray.count<1){
                 [self startReqSiteInfo];
             }
        }
            break;
    }

}

//showToast
- (void) addToastWithString:(NSString *)string inView:(UIView *)view {

    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 0);
    CGRect rect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 22);
    UILabel* label = [[UILabel alloc] initWithFrame:initRect];
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:0.9 alpha:0.6];

    [view addSubview:label];

    //弹出label
    [UIView animateWithDuration:0.5 animations:^{

        label.frame = rect;

    } completion:^ (BOOL finished){
        //弹出后持续1s
        [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(removeToastWithView:) userInfo:label repeats:NO];
    }];
}

//closeToast
- (void) removeToastWithView:(NSTimer *)timer {

    UILabel* label = [timer userInfo];

    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 0);
    //    label消失
    [UIView animateWithDuration:0.5 animations:^{

        label.frame = initRect;
    } completion:^(BOOL finished){

        [label removeFromSuperview];
    }];
}

#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest  serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeDomainList){
        _urlArray = ConvertToClassPointer(NSArray, data) ;
        
        if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV){
#ifdef TEST_DOMAIN
            _urlArray = @[TEST_DOMAIN] ;
#endif
        }
        
        [self checkUrl] ;
    }else if (type == ServiceRequestTypeDomainCheck01 || type == ServiceRequestTypeDomainCheck02 ||
              type == ServiceRequestTypeDomainCheck03 || type == ServiceRequestTypeDomainCheck04 ||
              type == ServiceRequestTypeDomainCheck05 || type == ServiceRequestTypeDomainCheck06 ||
              type == ServiceRequestTypeDomainCheck07 || type == ServiceRequestTypeDomainCheck08 ||
              type == ServiceRequestTypeDomainCheck09 || type == ServiceRequestTypeDomainCheck10 ||
              type == ServiceRequestTypeDomainCheck11 || type == ServiceRequestTypeDomainCheck12 ||
              type == ServiceRequestTypeDomainCheck13 || type == ServiceRequestTypeDomainCheck14 ||
              type == ServiceRequestTypeDomainCheck15 || type == ServiceRequestTypeDomainCheck16 ||
              type == ServiceRequestTypeDomainCheck17 || type == ServiceRequestTypeDomainCheck18 ||
              type == ServiceRequestTypeDomainCheck19 || type == ServiceRequestTypeDomainCheck20
              )
    {
        [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"检查完成,即将进入"];
        static dispatch_once_t onceToken ;
        dispatch_once(&onceToken, ^{
            NSString *strTmp = [ConvertToClassPointer(NSString, _urlArray[type-1]) copy] ;
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
            
//            if ((isIgnoreHTTPS(strTmp) || IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV))
            if (![data boolValue])//http protocol
            {
                [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@",@"http://",strTmp]] ;
            }else{
                [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@",@"https://",strTmp]] ;
            }
            
            [self.serviceRequest cancleAllServices] ;//结束所有域名检测
            [self.serviceRequest startUpdateCheck] ;
        }) ;
        
    }else if (type == ServiceRequestTypeUpdateCheck){
        RH_UpdatedVersionModel *checkVersion = ConvertToClassPointer(RH_UpdatedVersionModel, data) ;
        
        if(checkVersion.mVersionCode<=[RH_APP_VERCODE integerValue]){
            [self splashViewComplete] ;
            return;
        }
        
        //检查今天是否已提醒
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSDate *dateTmp = ConvertToClassPointer(NSDate, [userDefaults objectForKey:kUpdateAPPDatePrompt]) ;
        NSDate *dateCurr = [NSDate date] ;
        
        
        if (dateTmp==nil ||
            [dateCurr timeIntervalSinceDate:dateTmp]>OneDayTotalInterval){
            UIAlertView * alertView = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if(alertView.firstOtherButtonIndex == buttonIndex){
                    RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
                    //itms-services://?action=download-manifest&amp;url=%@/%@/%@/app_%@_%@.plist
                    NSString *downLoadIpaUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://%@%@/%@/app_%@_%@.plist",checkVersion.mAppUrl,checkVersion.mVersionName,CODE,CODE,checkVersion.mVersionName];
                    NSLog(@"%@",downLoadIpaUrl);
                    if (openURL(downLoadIpaUrl)==false){
                        [userDefaults setObject:[NSDate date] forKey:kUpdateAPPDatePrompt] ;
                        [self splashViewComplete] ;
                    }else{
                        exit(0) ;
                    }
                }else{
                    [userDefaults setObject:[NSDate date] forKey:kUpdateAPPDatePrompt] ;
                    [self splashViewComplete] ;
                }
                
            }
                                                                    title:@"检测到新版本"
                                                                  message:checkVersion.mMemo
                                                         cancelButtonName:@"暂不更新"
                                                        otherButtonTitles:@"立即更新", nil];
            
            [alertView show];
        }else{
            [self splashViewComplete] ;
        }
    }
}

- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeDomainList){
        showErrorMessage(self.view, error, nil) ;
    }else if (type == ServiceRequestTypeDomainCheck01 || type == ServiceRequestTypeDomainCheck02 ||
              type == ServiceRequestTypeDomainCheck03 || type == ServiceRequestTypeDomainCheck04 ||
              type == ServiceRequestTypeDomainCheck05 || type == ServiceRequestTypeDomainCheck06 ||
              type == ServiceRequestTypeDomainCheck07 || type == ServiceRequestTypeDomainCheck08 ||
              type == ServiceRequestTypeDomainCheck09 || type == ServiceRequestTypeDomainCheck10 ||
              type == ServiceRequestTypeDomainCheck11 || type == ServiceRequestTypeDomainCheck12 ||
              type == ServiceRequestTypeDomainCheck13 || type == ServiceRequestTypeDomainCheck14 ||
              type == ServiceRequestTypeDomainCheck15 || type == ServiceRequestTypeDomainCheck16 ||
              type == ServiceRequestTypeDomainCheck17 || type == ServiceRequestTypeDomainCheck18 ||
              type == ServiceRequestTypeDomainCheck19 || type == ServiceRequestTypeDomainCheck20
              )
    {
        static int totalFail = 0 ;
        dispatch_async(dispatch_get_main_queue(), ^{
            totalFail ++ ;
            if (totalFail>=20){
                [self checkUrl] ;
            }
        });
        
        if (totalFail>=_urlArray.count){
            [self.contentLoadingIndicateView hiddenView] ;
            showAlertView(@"系统提示", @"没有检测到可用的域名!");
        }
        
    }else if (type == ServiceRequestTypeUpdateCheck){
        [self splashViewComplete] ;
    }
}


- (void)checkUrl{
    if (_urlArrayLastIndex<_urlArray.count){
        if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV){
            [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil
                                                             detailText:[NSString stringWithFormat:@"checking domain:%@",_urlArray[_urlArrayLastIndex]]] ;
        }
        
        int minIndex = _urlArrayLastIndex ;
        int maxIndex = MIN(_urlArray.count, _urlArrayLastIndex+20) ;
        for (; minIndex < maxIndex ; minIndex++) {
            [self.serviceRequest startCheckDomain:_urlArray[minIndex] ServiceRequestTypeDomainCheckIndex:(minIndex+1)%21] ;
        }
        _urlArrayLastIndex = minIndex + 1 ;
    }else{
        showMessage(self.view, NSLocalizedString(@"ALERT_LOGIN_PROMPT_TITLE", nil),
                    _urlArray.count?NSLocalizedString(@"SPLASHVIEWCTRL_INVALID_DOMAIN", nil):
                    NSLocalizedString(@"SPLASHVIEWCTRL_EMPTY_DOMAINLIST", nil)) ;
    }
}

#pragma mark-
- (void)show:(BOOL)animated completedBlock:(void(^)(void))completedBlock
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = [[UIApplication sharedApplication] keyWindow].windowLevel;

    //建立的循环保留
    [self.window setRootViewController:self];
    [self.window makeKeyAndVisible];

    if (animated) {
        self.window.alpha = 0.f;
        [UIView animateWithDuration:0.8f
                         animations:^{
                             self.window.alpha = 1.f;
                         } completion:^(BOOL finished) {

                             [self statusBarAppearanceUpdate];

                             if (completedBlock) {
                                 completedBlock();
                             }
                         }];
    }else {
        [self statusBarAppearanceUpdate];

        if (completedBlock) {
            completedBlock();
        }
    }
}

- (void)hide:(BOOL)animated completedBlock:(void (^)(void))completedBlock
{
    if (!self.window) {
        return;
    }

    if (animated) {

        [UIView animateWithDuration:1.5f animations:^{

            //放大并消失
            self.window.alpha = 0.f;
            self.window.transform = CGAffineTransformMakeScale(2.f, 2.f);

        } completion:^(BOOL finished){

            [self.window setHidden:YES];
            [self.window setRootViewController:nil];
            self.window = nil;

            if (completedBlock) {
                completedBlock();
            }
        }];

    }else{

        [self.window setHidden:YES];
        [self.window setRootViewController:nil];
        self.window = nil;

        if (completedBlock) {
            completedBlock();
        }
    }

}

#pragma mark -
- (void)splashViewComplete
{
    [self.contentLoadingIndicateView hiddenView] ;
    BOOL bRet = YES;
    ifRespondsSelector(self.delegate, @selector(splashViewControllerWillHidden:)) {
        bRet = [self.delegate splashViewControllerWillHidden:self];
    }

    if (bRet) {
        [self hide:YES completedBlock:nil];
    }
}

#pragma mark -
- (BOOL)shouldAutorotate {
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
