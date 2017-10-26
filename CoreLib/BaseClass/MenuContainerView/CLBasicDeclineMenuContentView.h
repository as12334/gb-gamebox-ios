//
//  CLBasicDeclineMenuContentView.H
//  TaskTracking
//
//  Created by apple pro on 2017/2/21.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

//----------------------------------------------------------

#import <UIKit/UIKit.h>
#import "help.h"

//----------------------------------------------------------

UIKIT_EXTERN NSString * const MyDeclineMenuContentViewSizeInvalidateNotification;

//----------------------------------------------------------

@class CLDeclineMenuContainerView;

//----------------------------------------------------------

@interface CLBasicDeclineMenuContentView : UIView

//返回显示高度
- (CGFloat)heightForViewWithContainerSize:(CGSize)containerSize;
//大小无效
- (void)sizeInvalidate;


//将要点击隐藏，默认返回YES，返回NO阻止
- (BOOL)shouldTapHiddenInContainerView:(CLDeclineMenuContainerView *)containerView;
//将要开始滑动隐藏，默认返回YES，返回NO阻止
- (BOOL)shouldBeginSwipeHiddenInContainerView:(CLDeclineMenuContainerView *)containerView;
//将要滑动隐藏，默认返回YES，返回NO阻止
- (BOOL)shouldSwipeHiddenInContainerView:(CLDeclineMenuContainerView *)containerView;


//视图的显示过程，子类重载进行自定义动作
- (void)viewWillShow:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)viewDidShow:(BOOL)animated;
- (void)viewWillHide:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)viewDidHide:(BOOL)animated;

//显示时是否需要动画默认为YES
@property(nonatomic) BOOL needAnimatedWhenShow;
//显示动画的方向
@property(nonatomic) CLMoveAnimtedDirection showAnimtedMoveDirection;
//开始显示动画
- (void)startShowAnimatedWithDelay:(NSTimeInterval)delay;


@end
