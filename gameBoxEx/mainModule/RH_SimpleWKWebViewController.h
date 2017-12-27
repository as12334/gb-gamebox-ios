//
//  RH_SimpleWKWebViewController.h
//  TaskTracking
//
//  Created by apple pro on 2017/3/5.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicViewController.h"
#import "RH_BasicSubViewController.h"
#import "RH_APPDelegate.h"
#import "RH_LoginViewControllerEx.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>


//----------------------------------------------------------

typedef NS_ENUM(NSInteger, RH_WKWebViewContentShowState) {
    RH_WKWebViewContentShowStateNone = 0,     //没有显示
    RH_WKWebViewContentShowStateShowing,  //正在显示
    RH_WKWebViewContentShowStateShowed    //显示完成
};

//----------------------------------------------------------

@interface RH_SimpleWKWebViewController : RH_BasicViewController<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,LoginViewControllerExDelegate >
@property(nonatomic,strong,readonly) WKWebView *webView ;
@property(nonatomic,copy) NSURL *webURL ;
@property(nonatomic,assign) BOOL autoShowWebTitle ;
@property(nonatomic,readonly,getter=isLoading) BOOL loading ;
@property(nonatomic,strong,readonly) UIBarButtonItem * backBarButtonItem ;

@property(nonatomic,strong) NSString *domain ;

-(BOOL)backButtonHidden ;
-(BOOL)navigationBarHidden ;
-(BOOL)tabBarHidden ;
-(BOOL)needLogin ;

//加载指示
@property(nonatomic,strong,readonly) UIBarButtonItem * loadingBarButtonItem;
//内容显示状态
@property(nonatomic,readonly) RH_WKWebViewContentShowState contentShowState;

-(void)reloadWebView ;

//加载状态改变
- (void)wedViewContentLoadStateDidChange;

- (void)wedViewContentShowStateDidChange;

//开始加载
-(void)webViewBeginLoad;
//结束加载
-(void)webViewDidEndLoad:(NSError *)error;

//定义js callback oc 方法 。
-(void)setupJSCallBackOC:(JSContext*)jsContext ;

@end



@interface WKWebView (UIViewView)
-(void)stringByEvaluatingJavaScriptFromString:(NSString*)jsString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler ;
-(void)stringByEvaluatingJavaScriptFromString:(NSString*)jsString ;
@end

