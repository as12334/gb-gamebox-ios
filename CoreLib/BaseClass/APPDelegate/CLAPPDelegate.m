//
//  CLAPPDelegate.m
//  TaskTracking
//
//  Created by jinguihua on 2017/4/14.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLAPPDelegate.h"
#import "NSDictionary+CLCategory.h"
#import "help.h"
#import "MacroDef.h"
#import "NSDate+CLCategory.h"
#import "UIAlertView+Block.h"
#import "CLNetReachability.h"

#import "RH_MyUncaughtExceptionHandler.h"
#import "RH_ServiceRequest.h"
#import "RH_Crash.h"

//----------------------------------------------------------

#define MyKAppID                        @"AppID"                      //app的ID
#define MyKAppBuild                     @"AppBuild"                   //app的构建版本（完成版本）
#define MyKUserGuideViewVersion         @"UserGuideViewVersion"       //用户引导页版本
#define MyKAppLaunchTimes               @"AppLaunchTimes"             //当前版本app加载的次数
#define MyKAppEnterForegroundTimes      @"AppEnterForegroundTimes"    //当前版本app进入前台的次数，即点击次数
#define MyKAppLastLaunchDate            @"AppLastLaunchDate"          //app上一次加载的时间
#define MyKAppLastEnterForegroundDate   @"AppLastEnterForegroundDate" //app上一次进入前台的时间
#define MyKAppContinuousClickDays       @"AppContinuousClickDays"     //app连续点击的天数
#define MyKHadSorceApp                  @"HadSorceApp"                //是否评价了当前版本的app
#define MyKAppIgnoreSorceTimes          @"AppIgnoreSorceTimes"        //忽略评价的次数


@interface CLAPPDelegate()

//当主窗口完成显示执行的action
@property(nonatomic,strong,readonly) NSMutableArray * mainWindowDidShowActions;

//网络状态改变的观察者
@property(nonatomic,strong) id networkStatusChangeNotificationObsever;

@property(nonatomic,strong)RH_ServiceRequest *serviceRequest ;


@end

//----------------------------------------------------------

@implementation CLAPPDelegate

@synthesize window     = _window;
@synthesize appVersion = _appVersion;
@synthesize appBuild   = _appBuild;
@synthesize appID      = _appID;
@synthesize mainWindowDidShowActions = _mainWindowDidShowActions;

#pragma mark - life circle

+ (instancetype)appDelegate {
    return (id)[UIApplication sharedApplication].delegate;
}

- (id)init
{
    self = [super init];

    if (self) {

        NSDictionary * appVersionInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppVersionConfig" ofType:@"plist"]];

        //获取key及版本数据
        _appID = [appVersionInfo stringValueForKey:MyKAppID];
        _userGuideViewVersion = [appVersionInfo stringValueForKey:MyKUserGuideViewVersion];


        NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _appBuild   = [infoDictionary objectForKey:@"CFBundleVersion"];
        _appBundleIdentifier = [infoDictionary objectForKey:@"CFBundleName"];
    }

    return self;
}

#pragma mark -

- (NSString *)appIdentifier {
    return [NSString stringWithFormat:@"%@.%@",_appID,_appBundleIdentifier];
}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DefaultDebugLog(@"应用状态变为完成加载");

    _applicationState = CLApplicationStateDidFinishLaunching;
    _launchOptions = launchOptions;

    //计数
    [self _launchApp];


    //第一次启动当前版本APP
//    if ([[self class] isFirstLaunchApp]) {
        [self doSomethingWhenAppFirstLaunch];
//    }

    //开始显示视图
    [self startShowView];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}
#pragma mark -- 发送崩溃日志
- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path {
    
    NSLog(@"123") ;
    
    //    [self.serviceRequest startTestUrl:path];
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer.timeoutInterval = 5.0f;
    //    //告诉AFN，支持接受 text/xml 的数据
    //    [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //    NSString *urlString = @"后台地址";
    //
    //    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    //        [formData appendPartWithFileData:data name:@"file" fileName:@"Exception.txt" mimeType:@"txt"];
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //        // 删除文件
    //        NSFileManager *fileManger = [NSFileManager defaultManager];
    //        [fileManger removeItemAtPath:path error:nil];
    //
    //    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    //
    //
    //    }];
    
}

-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc] init];
    }
    return _serviceRequest ;
}

//进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DefaultDebugLog(@"应用状态变为将要进入前台");
    _applicationState = CLApplicationStateWillEnterForeground;

    [self _clickApp];
}

//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _applicationState = CLApplicationStateBackground;
    DefaultDebugLog(@"应用状态变为已进入后台");
}

//未激活
- (void)applicationWillResignActive:(UIApplication *)application
{
    _applicationState = CLApplicationStateInactive;
    DefaultDebugLog(@"应用状态变为未激活");
}

//激活
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    _applicationState = CLApplicationStateActive;
    DefaultDebugLog(@"应用状态变为激活");
}

#pragma mark -

- (void)_launchApp
{
    //记录加载次数及时间
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@([[NSDate date] timeIntervalSince1970]) forKey:MyKAppLastLaunchDate];
    [userDefaults setObject:@([[self class] appLaunchTimes] + 1) forKey:MyKAppLaunchTimes];


    [self appDidLaunch];

    //点击app
    [self _clickApp];
}

- (void)appDidLaunch {
    // do nothing
}

- (void)_clickApp
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];

    //点击次数+1
    NSUInteger appEnterForegroundTimes = [[self class] appClickTimes] + 1;
    [userDefaults setObject:@(appEnterForegroundTimes) forKey:MyKAppEnterForegroundTimes];

    //上一次点击的日期
    NSDate * lastClickDate = [[self class] appLastClickDate];

    NSDate * now = [NSDate date]; //上一次点击的日期和昨天是同一天，则连续点击次数+1
    if (lastClickDate && [lastClickDate isSameDay:[now dateWithMoveDay:-1]]) {
        [userDefaults setObject:@([[self class] appContinuousClickDays] + 1) forKey:MyKAppContinuousClickDays];
    }else if(!lastClickDate || ![lastClickDate isSameDay:now]) { //无上一次点击时间或者上一次点击时间不是今天则将次数置为1
        [userDefaults setObject:@1 forKey:MyKAppContinuousClickDays];
    }

    //记录点击时间
    [userDefaults setObject:@([now timeIntervalSince1970]) forKey:MyKAppLastEnterForegroundDate];

    //click回调
    [self appDidClick];

    //显示去评价app
    if ([[self class] canShowScoreAlertView] && self.showScoreAlertViewPerClickTimes &&
        appEnterForegroundTimes % self.showScoreAlertViewPerClickTimes == 0) {
        [self showScoreAlertView];
    }
}

- (void)appDidClick {
    //do nothing
}

+ (NSUInteger)appLaunchTimes;
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];

    //获取版本信息
    NSString * appBuild = [[userDefaults objectForKey:MyKAppBuild] description];
    NSString * currentAppBuild = [(CLAPPDelegate *)[self appDelegate] appBuild];

    //版本号改变，重置值
    if (![appBuild isEqualToString:currentAppBuild]) {
        [userDefaults setObject:currentAppBuild forKey:MyKAppBuild];

        [userDefaults removeObjectForKey:MyKAppLaunchTimes];
        [userDefaults removeObjectForKey:MyKAppEnterForegroundTimes];
        [userDefaults removeObjectForKey:MyKAppContinuousClickDays];
        [userDefaults removeObjectForKey:MyKAppLastLaunchDate];
        [userDefaults removeObjectForKey:MyKAppLastEnterForegroundDate];
        [userDefaults removeObjectForKey:MyKHadSorceApp];
        [userDefaults removeObjectForKey:MyKAppIgnoreSorceTimes];
    }

    return [[userDefaults objectForKey:MyKAppLaunchTimes] unsignedIntegerValue];
}

+ (NSUInteger)appClickTimes {
    return [[[NSUserDefaults standardUserDefaults]  objectForKey:MyKAppEnterForegroundTimes] unsignedIntegerValue];
}

+ (BOOL)isFirstLaunchApp {
    return [self appLaunchTimes] == 1;
}

+ (NSDate *)appLastLauchDate
{
    NSTimeInterval timeInterval = [[NSUserDefaults standardUserDefaults] integerForKey:MyKAppLastLaunchDate];
    return timeInterval ? [NSDate dateWithTimeIntervalSince1970:timeInterval] : nil;
}

+ (NSDate *)appLastClickDate
{
    NSTimeInterval timeInterval = [[NSUserDefaults standardUserDefaults] integerForKey:MyKAppLastEnterForegroundDate];
    return timeInterval ? [NSDate dateWithTimeIntervalSince1970:timeInterval] : nil;
}

+ (NSUInteger)appContinuousClickDays {
    return [[[NSUserDefaults standardUserDefaults]  objectForKey:MyKAppContinuousClickDays] unsignedIntegerValue];
}

#pragma mark -

- (void)doSomethingWhenAppFirstLaunch {
    //do nothing
}

- (void)startShowView
{
    //判断是否需要显示引导视图
    if ([self needShowUserGuideView]) {
        [self showUserGuideView];
    }else{
        [self showMainWindow];
    }
}

- (BOOL)needShowUserGuideView
{
    //用户引导页的版本改变,则需要显示用户引导页面
    NSString * userGuideViewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:MyKUserGuideViewVersion];
    if (self.userGuideViewVersion.length && ![userGuideViewVersion isEqualToString:self.userGuideViewVersion]) {
        return YES;
    }else {
        return NO;
    }
}

- (void)showUserGuideView {
    // do nothing
}

- (void)completedShowUserGuideView
{
    //设置引导页面版本
    if ([self userGuideViewVersion].length) {
        [[NSUserDefaults standardUserDefaults] setObject:[self userGuideViewVersion] forKey:MyKUserGuideViewVersion];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:MyKUserGuideViewVersion];
    }
}

- (void)showMainWindow {
}

- (void)completedShowMainWindow
{
    if (!self.appDidShowMainWindow) {
        _appDidShowMainWindow = YES;

        //尝试注册通知
        [self _tryRegisterRemoteNotification];

        //尝试注册3D Touch快捷项目
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
        [self _tryRegister3DTouchShortcutItems];
#endif

        //ios7系统以下或者没有实现application:didReceiveRemoteNotification:fetchCompletionHandler:方法
        if (!GreaterThanIOS7System || ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {

            //处理远程通知
            NSDictionary * remoteNotificationInfo = self.launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
            if (remoteNotificationInfo) {
                [self applicationDidReceiveRemoteNotification:remoteNotificationInfo
                                                        state:CLApplicationReceiveNotificationStateLaunchApp];
            }
        }

        //执行action并移除
        for (void(^action)() in _mainWindowDidShowActions) {
            action();
        }
        [_mainWindowDidShowActions removeAllObjects];

        _launchOptions = nil;
    }
}

- (NSMutableArray *)mainWindowDidShowActions
{
    if (!_mainWindowDidShowActions) {
        _mainWindowDidShowActions = [NSMutableArray array];
    }

    return _mainWindowDidShowActions;
}

- (void)performActionWhenDidShowMainWindow:(void (^)())action
{
    if (action) {
        if (self.appDidShowMainWindow) {
            action();
        }else {
            [self.mainWindowDidShowActions addObject:[action copy]];
        }
    }
}

#pragma mark - check update and app store

+ (void)openInAppStore
{
    NSString * appID = [[self appDelegate] appID];
    if (appID.length) {
        gotoAppStore(appID);
    }
}

+ (BOOL)canShowScoreAlertView {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:MyKHadSorceApp];
}

- (NSString *)scoreAlertViewContentText {
    return _scoreAlertViewContentText ? : @"亲，你觉得怎么样？去评价一下吧。\n我们不完美，但我们会一直努力。\n你的肯定是我们最大的动力。";
}

- (void)showScoreAlertView
{
    UIAlertView * alertView = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {

        CLAppScoreAlertViewResult result = CLAppScoreAlertViewResultIgnore;
        if (alertView.cancelButtonIndex == buttonIndex) {
            result = CLAppScoreAlertViewResultDeny;
        }else if(alertView.firstOtherButtonIndex == buttonIndex){
            result = CLAppScoreAlertViewResultGoto;
        }
        
        [self scoreAlertViewCompletedShowWithResult:result];
        
    }
                                                            title:@"给我们评价"
                                                          message:[self scoreAlertViewContentText]
                                                 cancelButtonName:@"残忍拒绝"
                                                otherButtonTitles:@"立即评价",@"稍后提醒", nil];

    [alertView show];
}

+ (NSUInteger)appScoreIgnoreTimes {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:MyKAppIgnoreSorceTimes] unsignedIntegerValue];
}

- (void)scoreAlertViewCompletedShowWithResult:(CLAppScoreAlertViewResult)result
{
    if (result != CLAppScoreAlertViewResultIgnore) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MyKHadSorceApp];
        if (result == CLAppScoreAlertViewResultGoto) {
            [[self class] openInAppStore];
        }
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@([[self class] appScoreIgnoreTimes] + 1)
                                                  forKey:MyKAppIgnoreSorceTimes];
    }
}

#pragma mark -

- (void)setShowNetworkStatusChange:(BOOL)showNetworkStatusChange
{
    if (_showNetworkStatusChange != showNetworkStatusChange) {

        if (_showNetworkStatusChange && self.networkStatusChangeNotificationObsever) {
            [[NSNotificationCenter defaultCenter] removeObserver:self.networkStatusChangeNotificationObsever];
            self.networkStatusChangeNotificationObsever = nil;
        }

        _showNetworkStatusChange = showNetworkStatusChange;

        if (_showNetworkStatusChange) {

            self.networkStatusChangeNotificationObsever =
            [[NSNotificationCenter defaultCenter] addObserverForName:NT_NetReachabilityChangedNotification
                                                              object:nil
                                                               queue:[NSOperationQueue mainQueue]
                                                          usingBlock:^(NSNotification *note) {
                                                              //显示网络状态
                                                              [self showNetworkStatus];
                                                          }];
        }
    }
}

- (void)showNetworkStatus {
    showNetworkStatusMessage(nil);
}

#pragma mark -

- (BOOL)    application:(UIApplication *)application
                openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation
{
    MyAssert(self.applicationState != CLApplicationStateBackground);

    //状态
    CLApplicationOpenURLState state;

    switch (self.applicationState) {

        case CLApplicationStateDidFinishLaunching:
            state = CLApplicationOpenURLStateLaunchApp;
            break;

        case CLApplicationStateWillEnterForeground:
            state = CLApplicationOpenURLStateEnterForeground;
            break;

        default:
            state = CLApplicationOpenURLStateActive;
            break;
    }


    [self performActionWhenDidShowMainWindow:^{
        [self applicationDidOpenURL:url sourceApplication:sourceApplication annotation:annotation state:state];
    }];

    return YES;
}

- (void)applicationDidOpenURL:(NSURL *)url
            sourceApplication:(NSString *)sourceApplication
                   annotation:(id)annotation
                        state:(CLApplicationOpenURLState)state
{
    //do nothing
}

#pragma mark -

- (BOOL)needRegisterRemoteNotification {
    return NO;
}

- (void)_tryRegisterRemoteNotification
{
    if ([self needRegisterRemoteNotification]) {
        [self registerRemoteNotification];
    }
}

- (void)registerRemoteNotification
{
    //推送注册的默认实现
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

    if (GreaterThanIOS8System) {

        //通知设置
        UIUserNotificationSettings * userNotificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
        //注册设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
        //注册通知
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
        //                                                                               UIRemoteNotificationTypeBadge |
        //                                                                               UIRemoteNotificationTypeSound )];
    }

#else

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                                           UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound )];
#endif

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (NetNotReachability()) { //网络不可用，则网络恢复后重试
        __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NT_NetReachabilityChangedNotification
                                                                                object:nil
                                                                                 queue:[NSOperationQueue mainQueue]
                                                                            usingBlock:^(NSNotification *note) {

                                                                                //删除观察
                                                                                [[NSNotificationCenter defaultCenter] removeObserver:observer];

                                                                                //重新注册
                                                                                [self _tryRegisterRemoteNotification];

                                                                            }];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self _applicationDidNotificationWithData:userInfo];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [self _applicationDidNotificationWithData:userInfo];

    //完成回调
    completionHandler(UIBackgroundFetchResultNewData);
}

#endif

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self _applicationDidNotificationWithData:notification];
}

- (void)_applicationDidNotificationWithData:(id)data
{
    MyAssert(self.applicationState != CLApplicationStateBackground);

    //状态
    CLApplicationReceiveNotificationState state;

    switch (self.applicationState) {
        case CLApplicationStateDidFinishLaunching:
            state = CLApplicationReceiveNotificationStateLaunchApp;
            break;

        case CLApplicationStateWillEnterForeground:
            state = CLApplicationReceiveNotificationStateEnterForeground;
            break;

        case CLApplicationStateActive:
            state = CLApplicationReceiveNotificationStateActive;
            break;

        default:
            state = CLApplicationReceiveNotificationStateInactive;
            break;
    }

    NSDictionary * userInfo = ConvertToClassPointer(NSDictionary, data);
    UILocalNotification * localNotification = ConvertToClassPointer(UILocalNotification, data);

    MyAssert(userInfo || localNotification);

    //发送通知
    [self performActionWhenDidShowMainWindow:^{
        if (userInfo) {
            [self applicationDidReceiveRemoteNotification:userInfo state:state];
        }else {
            [self applicationDidReceiveLocalNotification:localNotification state:state];
        }
    }];
}

- (void)applicationDidReceiveLocalNotification:(UILocalNotification *)notification
                                         state:(CLApplicationReceiveNotificationState)state
{
    //do nothing
}

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo state:(CLApplicationReceiveNotificationState)state {
    //do nothing
}

#pragma mark -

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0

- (void)_tryRegister3DTouchShortcutItems
{
    if ([self isSupported3DTouch] && [self needRegister3DTouchShortcutItems]) {
        [self register3DTouchShortcutItems];
    }
}

- (BOOL)needRegister3DTouchShortcutItems {
    return NO;
}

- (BOOL)isSupported3DTouch {
    return systemVersion() >= 9.0;
}

- (void)register3DTouchShortcutItems {
    //do nothing
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    //发送通知
    [self performActionWhenDidShowMainWindow:^{
        [self applicationPerformActionForShortcutItem:shortcutItem];
    }];

    completionHandler(YES);
}

- (void)applicationPerformActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem {
    //do nothing
}

#endif


@end
