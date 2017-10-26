//
//  CLDeclineMenuContainerView.h

//  TaskTracking
//
//  Created by apple pro on 2017/2/21.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

//----------------------------------------------------------

#import <UIKit/UIKit.h>
#import "CLBlurredView.h"


//----------------------------------------------------------

@class CLDeclineMenuContainerView;
@class CLBasicDeclineMenuContentView ;


//----------------------------------------------------------

@protocol CLDeclineMenuContainerViewDelegate <NSObject>

@optional

//将要点击隐藏
- (BOOL)declineMenuContainerViewShouldTapHidden:(CLDeclineMenuContainerView *)declineMenuContainerView;
//将要开始滑动隐藏
- (BOOL)declineMenuContainerViewShouldBeginSwipeHidden:(CLDeclineMenuContainerView *)declineMenuContainerView;
//将要滑动隐藏
- (BOOL)declineMenuContainerViewShouldSwipeHidden:(CLDeclineMenuContainerView *)declineMenuContainerView;

//已经滑动隐藏
- (void)declineMenuContainerViewDidTapHidden:(CLDeclineMenuContainerView *)declineMenuContainerView;
//已经点击隐藏
- (void)declineMenuContainerViewDidSwipeHidden:(CLDeclineMenuContainerView *)declineMenuContainerView;
//已经隐藏，点击和滑动都会调用该方法
- (void)declineMenuContainerViewDidHidden:(CLDeclineMenuContainerView *)declineMenuContainerView;

@end

//----------------------------------------------------------

@interface CLDeclineMenuContainerView : CLBlurredView

- (void)showWithView:(CLBasicDeclineMenuContentView *)declineMenuContentView
            animated:(BOOL)animated;
- (void)showWithView:(CLBasicDeclineMenuContentView *)declineMenuContentView
            animated:(BOOL)animated
      completedBlock:(void(^)())completedBlock;

- (void)hideWithAnimated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated completedBlock:(void(^)())completedBlock;

@property(nonatomic,readonly,getter = isAnimating) BOOL animating;
@property(nonatomic,readonly,getter=isShowing) BOOL showing;
@property(nonatomic,strong,readonly) CLBasicDeclineMenuContentView * declineMenuContentView;

//显示下端的滑动视图
@property(nonatomic) BOOL showBottomSwipeView;
@property(nonatomic,strong) UIColor * bottomSwipeViewColor;

//代理
@property(nonatomic,weak) id<CLDeclineMenuContainerViewDelegate> delegate;

//动画时长
@property(nonatomic) NSTimeInterval animatedDuration;

@end

//----------------------------------------------------------

@interface UIView (CLDeclineMenuContainerView)

@property(nonatomic,strong,readonly) CLDeclineMenuContainerView * declineMenuContainerView;

@end



