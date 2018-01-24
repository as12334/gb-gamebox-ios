//
//  CLViewController.m
//  CoreLib
//
//  Created by jinguihua on 2017/2/6.
//  Copyright © 2017年 GIGA. All rights reserved.
//

#import "CLViewController.h"
#import "UIViewController+CLTabBarController.h"
#import "CLTabBarController.h"
#import <objc/runtime.h>
#import "MacroDef.h"

@interface CLViewController ()

@end

@implementation CLViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    _viewShowing = YES ;

    [self statusBarAppearanceUpdate] ;
    [self.myTabBarController setTabBarHidden:self.hiddenTabBar
                                    animated:animated
                                  animations:nil
                                  completion:^{
                                      if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
                                          if (self.isHiddenTabBar && GreaterThanIOS10System){
                                              //fix ios 10以上 tabbar 隐藏时,view 不能全屏大小
                                              self.view.frame = MainScreenBounds ;
                                          }
                                      }
                                  }] ;

    //更新视图
    if (_needUpdateViewWhenViewAppear) {
        _needUpdateViewWhenViewAppear = NO;
        [self updateView];
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    _viewShowing = NO ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHiddenTabBar:(BOOL)hiddenTabBar
{
    if (_hiddenTabBar!=hiddenTabBar){
        _hiddenTabBar = hiddenTabBar ;

        [self.myTabBarController setTabBarHidden:self.hiddenTabBar
                                        animated:YES
                                      animations:nil
                                      completion:^{
                                          if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
                                              if (self.isHiddenTabBar && GreaterThanIOS10System){
                                                  //fix ios 10以上 tabbar 隐藏时,view 不能全屏大小
                                                  self.view.frame = MainScreenBounds ;
                                              }
                                          }
                                      }] ;

    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews] ;
    
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        if (self.isHiddenTabBar && GreaterThanIOS10System){
            //fix ios 10以上 tabbar 隐藏时,view 不能全屏大小
            if (CGRectEqualToRect(self.view.frame, MainScreenBounds)==false){
                self.view.frame = MainScreenBounds ;
            }
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}
@end


@implementation CLViewController (StatusBar)
static char  HIDDENSTATUSBAR ;

-(BOOL)isHiddenStatusBar
{
    return  [objc_getAssociatedObject(self, &HIDDENSTATUSBAR) boolValue] ;
}

-(void)setHiddenStatusBar:(BOOL)hiddenStatusBar
{
    BOOL tmpHiddenStatusBar = self.isHiddenStatusBar ;
    if (tmpHiddenStatusBar !=hiddenStatusBar){
        objc_setAssociatedObject(self, &HIDDENSTATUSBAR, hiddenStatusBar?@(YES):nil, OBJC_ASSOCIATION_RETAIN) ;

        [self setNeedsStatusBarAppearanceUpdate] ;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault ;
}

-(BOOL)prefersStatusBarHidden
{
    return self.isHiddenStatusBar ;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade ;
}

-(void)statusBarAppearanceUpdate
{
    if (!self.isViewShowing) return ;

    UIApplication *application = [UIApplication sharedApplication] ;

    if (application.isStatusBarHidden != self.prefersStatusBarHidden){
        [application setStatusBarHidden:self.prefersStatusBarHidden withAnimation:self.preferredStatusBarUpdateAnimation] ;
    }

    if (application.statusBarStyle != self.preferredStatusBarStyle){
        [application setStatusBarStyle:self.preferredStatusBarStyle animated:YES] ;
    }
}

@end

@implementation CLViewController (UpdateView)
- (void)setNeedUpdateView
{
    if (![self isViewShowing]) {
        _needUpdateViewWhenViewAppear = YES;
    }else{
        [self performSelectorOnMainThread:@selector(updateView) withObject:self waitUntilDone:NO] ;
    }
}

- (void)updateView {
    //do nothing
}

- (void)tryRefreshData {
    //do noting
}

@end


@implementation CLViewController (NetStatus)
static char NEEDOBSERVENETSTATUSCHANGED ;
-(BOOL)isNeedObserveNetStatusChanged
{
    return [objc_getAssociatedObject(self, &NEEDOBSERVENETSTATUSCHANGED) boolValue] ;
}

-(void)setNeedObserveNetStatusChanged:(BOOL)needObserveNetStatusChanged
{
    if (self.isNeedObserveNetStatusChanged!=needObserveNetStatusChanged){
        if (self.isNeedObserveNetStatusChanged){
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:NT_NetReachabilityChangedNotification
                                                          object:nil] ;
        }

        objc_setAssociatedObject(self, &NEEDOBSERVENETSTATUSCHANGED, needObserveNetStatusChanged?@(YES):nil, OBJC_ASSOCIATION_RETAIN) ;

        if (self.isNeedObserveNetStatusChanged){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_netStatusChangedNotification:) name:NT_NetReachabilityChangedNotification object:nil] ;
        }

    }
}

-(void)_netStatusChangedNotification:(NSNotification*)notification
{
    if ([NSThread mainThread]){
        [self netStatusChangedHandle] ;
    }else
    {
        [self performSelectorOnMainThread:@selector(netStatusChangedHandle) withObject:self waitUntilDone:NO] ;
    }
}

-(void)netStatusChangedHandle
{
    //do nothing ;
}

-(NetworkStatus)currentNetStatus:(BOOL)showNoNetMsg
{
    NetworkStatus status = [CLNetReachability currentNetReachabilityStatus] ;
    if (showNoNetMsg && status==NotReachable){
        //显示没有网络的通过界面
        showErrorMessage(nil, nil, @"网络已断开") ;
    }

    return status ;
}

@end


@implementation CLViewController (MBMessage)
static char PROGRESSINDICATORVIEW ;
-(MBProgressHUD *)progressIndicatorView
{
    MBProgressHUD *progressHud = objc_getAssociatedObject(self, &PROGRESSINDICATORVIEW) ;
    if (progressHud==nil){
        CLActivityIndicatorView *activityIndicatorView = [[CLActivityIndicatorView alloc] initWithStyle:CLActivityIndicatorViewStyleIndeterminate] ;
        activityIndicatorView.bounds = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f) ;
        [activityIndicatorView startAnimating];

        progressHud = [[MBProgressHUD alloc] initWithView:self.view] ;
        progressHud.mode = MBProgressHUDModeCustomView ;
        progressHud.customView = activityIndicatorView ;
        progressHud.removeFromSuperViewOnHide = YES ;

        objc_setAssociatedObject(self, &PROGRESSINDICATORVIEW, progressHud, OBJC_ASSOCIATION_RETAIN) ;
    }

    return progressHud ;
}

-(void)showProgressIndicatorViewWithAnimated:(BOOL)animated title:(NSString*)title
{
    [self hideProgressIndicatorViewWithAnimated:NO completedBlock:nil] ;

    self.progressIndicatorView.labelText = title ;
    self.progressIndicatorView.transform = CGAffineTransformIdentity ;
    self.progressIndicatorView.animationType = MBProgressHUDAnimationFade ;
    [self.view addSubview:self.progressIndicatorView] ;
    [self.progressIndicatorView show:animated] ;
}

-(void)hideProgressIndicatorViewWithAnimated:(BOOL)animated completedBlock:(void(^)(void))completeBlock
{
    if (self.progressIndicatorView.superview){
        self.progressIndicatorView.animationType = MBProgressHUDAnimationZoom ;
        self.progressIndicatorView.completionBlock = completeBlock ;
        [self.progressIndicatorView hide:animated] ;
    }
}

@end


