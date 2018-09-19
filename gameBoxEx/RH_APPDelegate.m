//
//  AppDelegate.m
//  gameBoxEx
//
//  Created by luis on 2017/10/6.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_APPDelegate.h"
#import "RH_ServiceRequest.h"
#import "RH_MainTabBarController.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_GesturelLockController.h"
#import "RH_MainNavigationController.h"
#import "RH_GestureOpenLockView.h"
#import "RH_API.h"
#import "StartPageViewController.h"
#import "RH_GestureLockMainView.h"
#import "RH_CheckAndCrashHelper.h"
#import "AvoidCrash.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
NSString  *NT_LoginStatusChangedNotification  = @"LoginStatusChangedNotification" ;
//----------------------------------------------------------

#define AppDelegateDebugLog(_format,...) DebugLog(ED_AppDelegate, _format,##__VA_ARGS__)

//----------------------------------------------------------

@interface RH_APPDelegate ()<StartPageViewControllerDelegate,RH_GestureLockMainViewDelegate,JPUSHRegisterDelegate>
@property(nonatomic,strong)RH_GestureLockMainView *gestureView;
@end

@implementation RH_APPDelegate

- (void)doSomethingWhenAppFirstLaunch
{
    //崩溃日志
     [self avoidCrash];
    //jpush
    [self jpushInit];
    //清理缓存的临时和缓存数据数据
    [CLDocumentCachePool clearCacheFilesWithPathType:CLPathTypeTemp cacheFileFloderName:nil];
    [CLDocumentCachePool clearCacheFilesWithPathType:CLPathTypeCaches cacheFileFloderName:nil];

    //初始值
    _isLogin = false;

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    //add my info to the new agent
    NSLog(@"........%@",getDeviceModel()) ;//app_ios app_android
    NSString *newAgent = nil ;
    
    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
        ////用于后台切换 v3 环境
        newAgent = [oldAgent stringByAppendingString:[NSString stringWithFormat:@"app_ios,is_native True, %@",getDeviceModel()]];
    }else{
        newAgent = [oldAgent stringByAppendingString:[NSString stringWithFormat:@"app_ios, %@",getDeviceModel()]];
    }
    
    NSLog(@"new agent :%@", newAgent);
    //regist the new agent
    NSMutableDictionary *dictionnary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil] ;
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    self.dictUserAgent = dictionnary ;
}
-(void)avoidCrash{
    [AvoidCrash makeAllEffective];
    NSArray *noneSelClassStrings = @[
                                     @"NSNull",
                                     @"NSNumber",
                                     @"NSString",
                                     @"NSDictionary",
                                     @"NSArray"
                                     ];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    
}
- (void)dealwithCrashMessage:(NSNotification *)note {
    NSDictionary *dic = ConvertToClassPointer(NSDictionary, note.userInfo);
    //收集错误信息
    [[RH_CheckAndCrashHelper shared]uploadJournalWithMessages:@[@{RH_SP_COLLECTAPPERROR_DOMAIN:self.domain,RH_SP_COLLECTAPPERROR_CODE:CODE,RH_SP_COLLECTAPPERROR_ERRORMESSAGE:[NSString stringWithFormat:@"crashReason:%@;crashPlace:%@",dic[@"errorReason"],dic[@"errorPlace"]],RH_SP_COLLECTAPPERROR_TYPE:@"2"}]];
}
//jpush初始化
-(void)jpushInit{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:self.launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}
-(BOOL)needShowUserGuideView
{
    return YES ;
}

- (void)startShowView
{
    if ([self needShowUserGuideView]) {
        [self showUserGuideView];
    }else{
        [self tryShowMainWindow] ;
    }

}

-(void)tryShowMainWindow
{
    [self showMainWindow] ;
}

- (void)showUserGuideView
{
    //显示界面，用于获取DOMAIN.
//    SplashViewController * splashViewController = [SplashViewController viewController];
//    splashViewController.delegate = self ;
//    self.window.alpha = 0.f;
//    [splashViewController show:YES completedBlock:^{
//        self.window.alpha = 1.f;
//    }];

    StartPageViewController *startPageVC = [[StartPageViewController alloc] initWithNibName:@"StartPageViewController" bundle:nil];
    startPageVC.delegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = [[UIApplication sharedApplication] keyWindow].windowLevel;
    
    //建立的循环保留
    [self.window setRootViewController:startPageVC];
    [self.window makeKeyAndVisible];
}

- (void)showMainWindow
{
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //显示主界面
    if (self.window==nil){
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }

#if 1
    self.window.rootViewController = [RH_MainTabBarController viewController];
#else
    self.window.rootViewController = [RH_MainTabBarControllerEx createInstanceEmbedInNavigationControllerWithContext:nil];
#endif
    
    [self.window makeKeyAndVisible];

    [self completedShowMainWindow];
    if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV)
    {
        showAlertView( @"提示", @"您正在使用的是测试环境");
    }
    
}

- (void)completedShowMainWindow
{
    [super completedShowMainWindow];

    //监听网络改变
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showNetworkStatusChange = YES;
    });

}

#pragma mark----
-(void)updateLoginStatus:(BOOL)loginStatus
{
    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
        if (_isLogin !=loginStatus){
            NSLog(@"updateLoginStatus :%d",loginStatus);
            _isLogin = loginStatus;
            
            if (!_isLogin){
                [[RH_UserInfoManager shareUserManager] setUserSafetyInfo:nil];
                [[RH_UserInfoManager shareUserManager] setMineSettingInfo:nil];
                [[RH_UserInfoManager shareUserManager] setUserWithDrawInfo:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NT_LoginStatusChangedNotification object:nil];
        }
    }else{
        NSLog(@"updateLoginStatus :%d",loginStatus);
        _isLogin = loginStatus;

        [[NSNotificationCenter defaultCenter] postNotificationName:NT_LoginStatusChangedNotification object:nil];
    }
}

-(void)updateApiDomain:(NSString*)apiDomain
{
    if (_apiDomain.length==0){
        _apiDomain = apiDomain;
    }
}
-(void)updateHeaderDomain:(NSString *)headerDomain
{
    if (_headerDomain.length==0) {
        _headerDomain = headerDomain;
    }
}
-(void)updateDomain:(NSString*)domain;
{
    NSString *tmpStr = domain.trim;
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""] ;
    
    NSLog(@".....domain:%@",tmpStr);
    _domain = tmpStr;
}

-(void)updateDomainName:(NSString *)domainName {
    _demainName = domainName;
}

-(void)updateServicePath:(NSString*)servicePath
{
    if (servicePath !=_servicePath){
        NSString *tmpStr = servicePath.trim;
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];

        _servicePath = tmpStr;
    }
}

-(void)setCustomUrl:(NSString *)customUrl
{
    if (customUrl !=_customUrl){
        NSString *tmpStr = customUrl.trim;
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
        _customUrl = tmpStr;
    }
}

-(void)setWhetherNewSystemNotice:(NSString *)whetherNewSystemNotice
{
    _whetherNewSystemNotice = whetherNewSystemNotice;
}

#pragma mark- For MeiQia---overload function
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [super applicationWillEnterForeground:application];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]) {
        #define RH_GuseterLock            @"RH_GuseterLock"
        NSString * currentGuseterLockStr = [SAMKeychain passwordForService:@" " account:RH_GuseterLock];
        if (currentGuseterLockStr.length > 0) {
            if (self.isLogin) {
                 RH_MainTabBarController *tabBarController = ConvertToClassPointer(RH_MainTabBarController, self.window.rootViewController);
                 UINavigationController *nvc = ConvertToClassPointer(UINavigationController, tabBarController.selectedViewController);
                 [self.gestureView gestureViewShowWithController:nvc.childViewControllers.lastObject];
            }
            }
        }
}
#pragma mark--
#pragma mark--lazy
- (RH_GestureLockMainView *)gestureView{
    if (!_gestureView) {
        _gestureView = [[RH_GestureLockMainView alloc]initWithFrame:CGRectMake(0, screenSize().height, screenSize().width, screenSize().height)];
        _gestureView.delegate = self;
        [self.window addSubview:_gestureView];
    }
    return _gestureView;
}
- (void)RH_GestureLockMainViewSeccussful{
    [self.gestureView removeFromSuperview];
    self.gestureView = nil;
}
//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application] ;
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


#pragma mark -

//- (void)applicationDidOpenURL:(NSURL *)url
//            sourceApplication:(NSString *)sourceApplication
//                   annotation:(id)annotation
//                        state:(CLApplicationOpenURLState)state
//{
//    //处理URL
//    if (![self _tryHandleURL:url context:nil]) {
//    }
//}
//
//- (BOOL)_tryHandleURL:(NSURL *)url context:(id)context
//{
//    return NO;
//}

#pragma mark -

- (BOOL)needRegisterRemoteNotification {
    return NO;
}

#pragma mark -

- (BOOL)needRegister3DTouchShortcutItems {
    return NO;
}
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

#pragma mark - StartPageViewControllerDelegate M

- (void)startPageViewControllerShowMainPage:(id)controller
{
    [self showMainWindow];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"loginIsRemberPassword"]) {
        [defaults removeObjectForKey:@"password"];
        [defaults removeObjectForKey:@"account"];
        [defaults removeObjectForKey:@"loginIsRemberPassword"];
    }
}

#pragma mark--
#pragma mark--Jpush
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    [super application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
// iOS 10 Support
#ifdef NSFoundationVersionNumber_iOS_10_x_Max
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
