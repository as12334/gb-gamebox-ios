//
//  CLViewControllerTransitioningDelegate.h
//  CoreLib
//
//  Created by jinguihua on 2016/12/2.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBasicViewControllerAnimatedTransitioning.h"

@interface CLViewControllerTransitioningDelegate : NSObject<UIViewControllerTransitioningDelegate,
                                                            UIGestureRecognizerDelegate,
                                                            CLBasicViewControllerAnimatedTransitioningDelegate>

- (void)presentViewController:(UIViewController *)viewControllerToPresent;

//是否正在交互dimsmissing
@property(nonatomic,readonly,getter = isInteractiveDismissing) BOOL interactiveDismissing;
//是否正在过渡
@property(nonatomic,readonly,getter = isTransitioning) BOOL transitioning;

@property(nonatomic,weak,readonly) UIViewController * presentedViewController;

@end


//----------------------------------------------------------

NS_AVAILABLE_IOS(7_0) @protocol CLViewControllerTransitioningProtocol

//返回Present动画,返回nil则为默认动画
- (CLBasicViewControllerAnimatedTransitioning *)viewControllerAnimatedTransitioningForPresented;
//返回Dismiss动画,返回nil则为默认动画
- (CLBasicViewControllerAnimatedTransitioning *)viewControllerAnimatedTransitioningForDismissed;

//是否允许交互
@property(nonatomic,getter = isInteractiveDismissEnabled) BOOL interactiveDismissEnable;
//是否正在交互
@property(nonatomic,readonly,getter = isInteractiveDismissing) BOOL interactiveDismissing;
@property(nonatomic,readonly,getter = isPresentTransitioning) BOOL presentTransitioning;


//开始收到touch,返回NO取消
- (BOOL)interactiveDismissGestureShouldReceiveTouch:(UITouch *)touch;

//开始移动，返回NO取消
- (BOOL)interactiveDismissGestureShouldBeginWithTranslation:(CGPoint)translation;

//位移和开始点返回进度
- (float)interactiveDismissCompletePercentForTranslation:(CGPoint)translation
                                          withStartPoint:(CGPoint)startPoint;

//开始
- (void)startInteractiveDismiss;
//完成
- (void)finishInteractiveDismiss;
//取消
- (void)cancelInteractiveDismiss;

//用于NavigationControllerTransitioning的子视图控制器，默认为nil
- (UIViewController *)childViewControllerForViewControllerTransitioning;

@end

//----------------------------------------------------------

@interface UIViewController (CLViewControllerTransitioning)<CLViewControllerTransitioningProtocol>

//动画代理
@property(nonatomic,readonly) CLViewControllerTransitioningDelegate * viewControllerTransitioningDelegate NS_AVAILABLE_IOS(7_0);

@end
