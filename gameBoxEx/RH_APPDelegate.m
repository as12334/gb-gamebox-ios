//
//  AppDelegate.m
//  gameBoxEx
//
//  Created by luis on 2017/10/6.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_APPDelegate.h"
#import "RH_ServiceRequest.h"
#import "SplashViewController.h"
#import "SplashViewControllerEX.h"
#import "RH_MainTabBarController.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_GesturelLockController.h"
#import "RH_MainNavigationController.h"
#import "RH_GestureOpenLockView.h"
#import "RH_API.h"
#import "StartPageViewController.h"

NSString  *NT_LoginStatusChangedNotification  = @"LoginStatusChangedNotification" ;
//----------------------------------------------------------

#define AppDelegateDebugLog(_format,...) DebugLog(ED_AppDelegate, _format,##__VA_ARGS__)

//----------------------------------------------------------

@interface RH_APPDelegate ()<SplashViewControllerDelegate, StartPageViewControllerDelegate>

@end

@implementation RH_APPDelegate

- (void)doSomethingWhenAppFirstLaunch
{
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

- (BOOL)splashViewControllerWillHidden:(SplashViewController *)viewController
{
    [self showMainWindow] ;
    return YES;
}

- (void)showMainWindow
{
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //显示主界面
    if (self.window==nil){
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] ;
    }

#if 1
    self.window.rootViewController = [RH_MainTabBarController viewController] ;
#else
    self.window.rootViewController = [RH_MainTabBarControllerEx createInstanceEmbedInNavigationControllerWithContext:nil] ;
#endif
    
    [self.window makeKeyAndVisible] ;

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
            NSLog(@"updateLoginStatus :%d",loginStatus) ;
            _isLogin = loginStatus ;
            
            if (!_isLogin){
                [[RH_UserInfoManager shareUserManager] setUserSafetyInfo:nil] ;
                [[RH_UserInfoManager shareUserManager] setMineSettingInfo:nil] ;
                [[RH_UserInfoManager shareUserManager] setUserWithDrawInfo:nil] ;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NT_LoginStatusChangedNotification object:nil] ;
        }
    }else{
        NSLog(@"updateLoginStatus :%d",loginStatus) ;
        _isLogin = loginStatus ;

        [[NSNotificationCenter defaultCenter] postNotificationName:NT_LoginStatusChangedNotification object:nil] ;
    }
}

-(void)updateApiDomain:(NSString*)apiDomain
{
    if (_apiDomain.length==0){
        _apiDomain = apiDomain ;
    }
}
-(void)updateHeaderDomain:(NSString *)headerDomain
{
    if (_headerDomain.length==0) {
        _headerDomain = headerDomain;
    }
}
-(void)updateDomain:(NSString*)domain ;
{
    NSString *tmpStr = domain.trim ;
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""] ;
    
    NSLog(@".....domain:%@",tmpStr) ;
    _domain = tmpStr ;
}

-(void)updateServicePath:(NSString*)servicePath
{
    if (servicePath !=_servicePath){
        NSString *tmpStr = servicePath.trim ;
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""] ;

        _servicePath = tmpStr ;
    }
}

-(void)setCustomUrl:(NSString *)customUrl
{
    if (customUrl !=_customUrl){
        NSString *tmpStr = customUrl.trim ;
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""] ;
        
        _customUrl = tmpStr ;
    }
}
-(void)setWhetherNewSystemNotice:(NSString *)whetherNewSystemNotice
{
    _whetherNewSystemNotice = whetherNewSystemNotice;
}
#pragma mark- For MeiQia---overload function
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [super applicationWillEnterForeground:application] ;

    
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        #define RH_GuseterLock            @"RH_GuseterLock"
        NSString * currentGuseterLockStr = [SAMKeychain passwordForService:@" "account:RH_GuseterLock];
        // [RH_UserInfoManager shareUserManager].screenLockPassword.length
        if ([RH_UserInfoManager shareUserManager].isScreenLock && currentGuseterLockStr.length){
            RH_MainTabBarController *tabBarController =  ConvertToClassPointer(RH_MainTabBarController, self.window.rootViewController) ;
            if (tabBarController){
                [tabBarController.selectedViewController presentViewController:[RH_GesturelLockController viewController]
                                                                      animated:YES
                                                                    completion:nil] ;
//                [tabBarController.selectedViewController showViewController:[RH_GesturelLockController viewController] sender:self] ;
            }
//            RH_GestureOpenLockView *openLockView = [[RH_GestureOpenLockView alloc] initWithFrame:self.window.bounds] ;
//            [openLockView show] ;
        }
    }
}

//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application] ;
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

@end
