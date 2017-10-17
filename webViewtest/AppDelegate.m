//
//  AppDelegate.m
//  webViewtest
//
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarVC.h"
#import "TransferVC.h"

#define aiScreenWidth [UIScreen mainScreen].bounds.size.width
#define aiScreenHeight [UIScreen mainScreen].bounds.size.height
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_BAR_HEIGHT self.tabBarController.tabBar.frame.size.height

@interface AppDelegate ()
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize domain = _domain;
@synthesize bossUrl = _bossUrl;
@synthesize isLogin = _isLogin;
@synthesize customUrl = _customUrl;
@synthesize servicePath = _servicePath;
@synthesize loginId = _loginId;

@synthesize goLogin = _goLogin;
@synthesize gotoIndex = _gotoIndex;
@synthesize goBackURL = _goBackURL;

@synthesize versionCode = _versionCode;
@synthesize md5 = _md5;
@synthesize code = _code;
@synthesize s = _s;
@synthesize siteType = _siteType;
@synthesize theme = _theme;
@synthesize netStatus = _netStatus;

@synthesize gotoIndexUrl = _gotoIndexUrl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _versionCode = @"2";
    _md5 = @"3f990aa1e870c0065a2e98e16683e9e9";
    _code = CODE;
    _s = S;
    _siteType = SITE_TYPE;
    _theme = THEME;
    
    _bossUrl = BASE_URL;
    
    _isLogin = false;
    _servicePath = @"null";
    _loginId = 0;
    _goLogin = NO;
    _gotoIndex = -1;
    _gotoIndexUrl = @"";
    _goBackURL = @"";
    _netStatus = @"";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:@"app_ios, iPhone"];
    NSLog(@"new agent :%@", newAgent);

    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
