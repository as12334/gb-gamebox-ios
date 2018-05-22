//
//  CLViewController.h
//  CoreLib
//
//  Created by jinguihua on 2017/2/6.
//  Copyright © 2017年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLNetReachability.h"
#import "MBProgressHUD.h"

@interface CLViewController : UIViewController
{
    //UpdateView
    BOOL             _needUpdateViewWhenViewAppear;
}
//视图是否显示
@property(nonatomic,readonly,getter=isViewShowing) BOOL viewShowing ;
//tabbar hidden
@property(nonatomic,getter=isHiddenTabBar) BOOL hiddenTabBar  ;
@end

//======================================
/**
 * statusBar 更新
 */
//======================================
@interface CLViewController (StatusBar)
@property(nonatomic,getter=isHiddenStatusBar) BOOL hiddenStatusBar ;

-(UIStatusBarStyle)preferredStatusBarStyle;
-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation ;
-(void)statusBarAppearanceUpdate ;

@end

//======================================
/**
 * 视图更新
 */
//======================================

@interface CLViewController (UpdateView)
-(void)setNeedUpdateView ;
-(void)updateView ;
-(void)tryRefreshData ;
@end


#define CurrentNetworkAvailable(showMSgWhenNoNetwork) \
([self currentNetStatus:showMSgWhenNoNetwork] != NotReachable)
//======================================
/**
 * NET STATUS 监控。
 */
//======================================
@interface CLViewController (NetStatus)
@property (nonatomic,getter=isNeedObserveNetStatusChanged) BOOL needObserveNetStatusChanged ;
-(NetworkStatus)currentNetStatus:(BOOL)showNoNetMsg ;
-(void)netStatusChangedHandle ;
@end

//======================================
/**
 * Message 接口定义
 */
//======================================
@interface CLViewController(MBMessage)
@property(nonatomic,strong,readonly) MBProgressHUD *progressIndicatorView ; //进度提示view
-(void)showProgressIndicatorViewWithAnimated:(BOOL)animated title:(NSString*)title ;
-(void)hideProgressIndicatorViewWithAnimated:(BOOL)animated completedBlock:(void(^)(void))completeBlock;
@end


